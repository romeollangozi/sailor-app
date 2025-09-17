//
//  NetworkService.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 7.8.24.
//

import Foundation

protocol ErrorTrackingService {
	func reportDecodingError(_ error: Error, data: Data?, modelName: String)
}

protocol NetworkServiceProtocol {
	func request<ResponseType: Decodable>(_ request: HTTPRequestProtocol, responseModel: ResponseType.Type) async -> ApiResponse<ResponseType>
	func requestV2<ResponseType: Decodable>(_ request: HTTPRequestProtocol, responseModel: ResponseType.Type, cacheOption: CacheOption) async throws -> ResponseType
	func mediaUploadRequest<T: Decodable>(_ request: HTTPRequestProtocol, responseModel: T.Type) async throws -> String
	func downloadFile(autheticatedFileRequest: AuthenticatedFileRequestProtocol) async -> ApiResponse<Data?>
	func getRawData(request: HTTPRequestProtocol) async throws -> Data?
	func generateCacheKey(for request: HTTPRequestProtocol) -> String
}

extension NetworkServiceProtocol {
	func requestV2<ResponseType: Decodable>(_ request: HTTPRequestProtocol,
											responseModel: ResponseType.Type) async throws -> ResponseType {
		return try await self.requestV2(request, responseModel: responseModel, cacheOption: .noCache())
	}
}

protocol NetworkCacheStoreProtocol {
	func getData(for key: String) -> Data?
	func writeData(for key: String, data: Data, cacheExpiration: TimeInterval) -> Bool
	func removeAllData()
}

protocol NetworkServiceEnvironmentProtocol {
	var scheme: String { get }
	var host: String { get }
	var basicToken: String { get }
}

protocol NetworkServiceEnvironmentProvider {
	func getEnvironment() -> NetworkServiceEnvironmentProtocol
}

final class NetworkService: NetworkServiceProtocol {
	private let environmentProvider: NetworkServiceEnvironmentProvider
	private let networkMonitor: NetworkMonitorProtocol
	private let networkCacheStore: NetworkCacheStoreProtocol
	private let requestBuilder: URLRequestBuilder
	private let responseHandler: ResponseHandler
	private let multipartBuilder: MultipartBuilder
	private let logger: NetworkLogger

	init(
		environmentProvider: NetworkServiceEnvironmentProvider,
		networkMonitor: NetworkMonitorProtocol = NetworkMonitor.shared,
		networkCacheStore: NetworkCacheStoreProtocol,
		requestBuilder: URLRequestBuilder = URLRequestBuilder(),
		responseHandler: ResponseHandler = ResponseHandler(),
		multipartBuilder: MultipartBuilder = MultipartBuilder(),
		logger: NetworkLogger = NetworkLogger()
	) {
		self.environmentProvider = environmentProvider
		self.networkMonitor = networkMonitor
		self.networkCacheStore = networkCacheStore
		self.requestBuilder = requestBuilder
		self.responseHandler = responseHandler
		self.multipartBuilder = multipartBuilder
		self.logger = logger
	}

	func request<ResponseType>(_ request: HTTPRequestProtocol, responseModel: ResponseType.Type) async -> ApiResponse<ResponseType> where ResponseType: Decodable {
		do {
			let environment = environmentProvider.getEnvironment()
			let urlRequest = try requestBuilder.build(for: request, using: environment)

			logger.logRequest(urlRequest)

			let (data, response) = try await URLSession.shared.data(for: urlRequest)
			guard let httpResponse = response as? HTTPURLResponse else {
				return ApiResponse(error: NetworkServiceError.invalidResponse)
			}

			logger.logResponse(httpResponse, data: data)

			// Decode with error reporting to errorTracker on failure
			do {
				let decoded = try responseHandler.decode(data, as: responseModel)
				return ApiResponse(response: decoded)
			} catch {
				if let decodingError = error as? DecodingError {
					reportDecodingError(decodingError, data: data, modelName: String(describing: ResponseType.self))
				}
				throw error
			}
		} catch let error as NetworkServiceError {
			return ApiResponse(error: error)
		} catch {
			if let decodingError = error as? DecodingError {
				reportDecodingError(decodingError, data: nil, modelName: String(describing: ResponseType.self))
			}
			return ApiResponse(error: NetworkServiceError.customError(error.localizedDescription))
		}
	}

	func requestV2<ResponseType: Decodable>(
		_ request: HTTPRequestProtocol,
		responseModel: ResponseType.Type,
		cacheOption: CacheOption
	) async throws -> ResponseType {
		if let cached = try await getCachedResponse(request, responseModel: responseModel, cacheOption: cacheOption) {
			return cached
		}

		return try await sendRequest(request, responseModel: responseModel, cacheOption: cacheOption)
	}

	private func getCachedResponse<ResponseType: Decodable>(
		_ request: HTTPRequestProtocol,
		responseModel: ResponseType.Type,
		cacheOption: CacheOption
	) async throws -> ResponseType? {
		if cacheOption.useCache && request.method == .GET && !cacheOption.forceReload {
			let cacheKey = generateCacheKey(for: request)
			let cachedData = networkCacheStore.getData(for: cacheKey)
			if let cachedData = cachedData {
				// Decode cached data with error reporting to errorTracker on failure
				do {
					let cachedResponse = try responseHandler.decode(cachedData, as: responseModel)
					if cacheOption.alwaysRefreshCache {
						Task {
							try? await self.sendRequest(request, responseModel: responseModel, cacheOption: cacheOption)
						}
					}
					return cachedResponse
				} catch {
					if let decodingError = error as? DecodingError {
						reportDecodingError(decodingError, data: cachedData, modelName: String(describing: ResponseType.self))
					}
					throw error
				}
			}
		}
		return nil
	}

	private func sendRequest<ResponseType: Decodable>(
		_ request: HTTPRequestProtocol,
		responseModel: ResponseType.Type,
		cacheOption: CacheOption
	) async throws -> ResponseType {
		try validateNetworkConnection()
		let environment = environmentProvider.getEnvironment()
		let urlRequest = try requestBuilder.build(for: request, using: environment)
		let session = URLSession(configuration: .default)
		let (data, response) = try await session.data(for: urlRequest)

		guard let httpResponse = response as? HTTPURLResponse else {
			throw NetworkServiceError.invalidResponse
		}

		logger.logRequest(urlRequest)
		logger.logResponse(httpResponse, data: data)

		// Decode response with error reporting to errorTracker on failure
		do {
			let result = try responseHandler.handle(data: data, response: httpResponse, responseModel: responseModel)

			if cacheOption.useCache && request.method == .GET {
				let cacheKey = generateCacheKey(for: request)
				_ = networkCacheStore.writeData(for: cacheKey, data: data, cacheExpiration: cacheOption.cacheExpiry)
			}

			return result
		} catch {
			if let decodingError = error as? DecodingError {
				reportDecodingError(decodingError, data: data, modelName: String(describing: ResponseType.self))
			}
			throw error
		}
	}

	func mediaUploadRequest<T: Decodable>(_ request: HTTPRequestProtocol, responseModel: T.Type) async throws -> String {
		let environment = environmentProvider.getEnvironment()
		let url = try requestBuilder.build(for: request, using: environment).url!
		var urlRequest = URLRequest(url: url)
		urlRequest.httpMethod = request.method.rawValue

		request.headers?.headers.forEach {
			urlRequest.setValue($0.value, forHTTPHeaderField: $0.key)
		}

		let boundary = UUID().uuidString
		urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

		guard let imageData = request.body?["imageData"] as? Data else {
			throw NetworkServiceError.badParameters
		}

		urlRequest.httpBody = multipartBuilder.createImageData(imageData: imageData, fileName: "image", mimeType: "image/jpeg", boundary: boundary)

		let (_, response) = try await URLSession.shared.data(for: urlRequest)
		guard let httpResponse = response as? HTTPURLResponse else {
			throw NetworkServiceError.invalidResponse
		}

        if case 200...299 = httpResponse.statusCode, let location = httpResponse.allHeaderFields["Location"] as? String {
			return location
		} else {
			throw NetworkServiceError.invalidResponse
		}
	}

	func downloadFile(autheticatedFileRequest: AuthenticatedFileRequestProtocol) async -> ApiResponse<Data?> {
		guard let url = URL(string: autheticatedFileRequest.fileURL) else { return ApiResponse(error: .badURL) }
		var request = URLRequest(url: url)
		guard let token = autheticatedFileRequest.tokenManager.token?.accessToken else { return ApiResponse(error: .unauthorized) }
		request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

		do {
			let (data, _) = try await URLSession.shared.data(for: request)
			return ApiResponse(response: data)
		} catch {
			return ApiResponse(error: .invalidData)
		}
	}

	func getRawData(request: HTTPRequestProtocol) async throws -> Data? {
		try validateNetworkConnection()
		let environment = environmentProvider.getEnvironment()
		let urlRequest = try requestBuilder.build(for: request, using: environment)
		logger.logRequest(urlRequest)

		let (data, response) = try await URLSession.shared.data(for: urlRequest)
		guard let httpResponse = response as? HTTPURLResponse else {
			throw NetworkServiceError.invalidResponse
		}

		switch httpResponse.statusCode {
		case 200...299:
			return data
		case 400:
			throw responseHandler.parseApiError(from: data) ?? .badRequest
		case 401:
			throw NetworkServiceError.unauthorized
		default:
			throw responseHandler.parseApiError(from: data) ?? .genericError
		}
	}

	func generateCacheKey(for request: HTTPRequestProtocol) -> String {
		let environment = environmentProvider.getEnvironment()
		return (try? requestBuilder.build(for: request, using: environment).url?.absoluteString) ?? ""
	}

	private func validateNetworkConnection() throws {
		guard networkMonitor.isConnected else {
			throw NetworkServiceError.noInternetConnection
		}
	}

	// MARK: - Error tracking abstraction for decoding issues

	private func reportDecodingError(_ error: Error, data: Data?, modelName: String) {
		logger.reportDecodingError(error, data: data, modelName: modelName)
	}
}
