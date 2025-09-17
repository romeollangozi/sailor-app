//
//  Authenticatable.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 3/21/24.
//

import Foundation
import Dynatrace

protocol Authenticatable {
	var host: Endpoint.Host { get set }
	var userId: String { get }
	var authorizationHeader: String { get }
}

extension Authenticatable {
	fileprivate func cacheURL<T: Requestable>(_ endpoint: T) -> URL? {
		let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		guard let documentsDirectory = paths.first else {
			return nil
		}
		
		let name = endpoint.saveName(host: host)
		var path = documentsDirectory
		path = path.appending(path: userId.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? userId)
		try? FileManager().createDirectory(at: path, withIntermediateDirectories: false)
		path.append(component: name)
		return path
	}
	
	fileprivate func save<T: Requestable>(data: Data, endpoint: T) throws {
		// Save data
		if let path = cacheURL(endpoint) {
			do {
				try data.write(to: path)
			} catch {
				print(error)
			}
		}
	}

	func delete<T: Requestable>(_ endpoint: T) {
		guard let fileURL = cacheURL(endpoint) else {
			return
		}
		
		try? FileManager.default.removeItem(at: fileURL)
	}
	
	func load<T: Requestable>(_ endpoint: T) throws -> T.ResponseType? {
		guard let fileURL = cacheURL(endpoint), let fileData = try? Data(contentsOf: fileURL) else {
			return nil
		}
		
		return try JSONDecoder().decode(T.ResponseType.self, from: fileData)
	}
	
	func uploadData<T: Uploadable>(_ endpoint: T) async throws -> URL {
		let request = try endpoint.urlMultipartRequest(host: host, authorization: authorizationHeader)
		let (responseData, response) = try await URLSession.shared.data(for: request)
		
		// Check for created response
		if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 {
			guard let location = httpResponse.allHeaderFields["Location"] as? String else {
				throw Endpoint.Error("Failed to get location header")
			}
			
			guard let url = URL(string: location) else {
				throw Endpoint.Error("Failed to create URL")
			}
			
			return url
		}
		
		if let error = try? JSONDecoder().decode(Endpoint.CodeError.self, from: responseData), let message = error.errors.first?.detail {
			throw Endpoint.Error(message)
		}
		
		if let response = String(data: responseData, encoding: .utf8) {
			throw Endpoint.Error(response)
		}
		
		throw Endpoint.Error("Failed to parse upload response")
	}
	
	func fetchData<T: Requestable>(_ endpoint: T, debug: Bool = true, timeout: TimeInterval = 10.0) async throws -> Data {
		var request = try endpoint.urlRequest(host: host, authorization: authorizationHeader)
		request.timeoutInterval = timeout // Set the timeout for the request

		if debug {
			print(request.cURL)
		}

		do {
			let (responseData, response) = try await URLSession.shared.data(for: request)

			// Check for error
			if let httpResponse = response as? HTTPURLResponse, !(200..<300).contains(httpResponse.statusCode) {
				print(String(data: responseData, encoding: .utf8) ?? "")

				if let error = try? JSONDecoder().decode(Endpoint.MessageError.self, from: responseData) {
					throw Endpoint.Error(error.message, statusCode: httpResponse.statusCode)
				} else if let status = try? JSONDecoder().decode(Endpoint.StatusError.self, from: responseData) {
					throw Endpoint.Error(status.message.title, statusCode: httpResponse.statusCode)
				} else if let error = try? JSONDecoder().decode(Endpoint.MessageDescriptionError.self, from: responseData) {
					throw Endpoint.Error(error.message.errorDescription, statusCode: httpResponse.statusCode)
				} else if let error = try? JSONDecoder().decode(Endpoint.DescriptionError.self, from: responseData) {
					throw Endpoint.Error(error.errorDescription, statusCode: httpResponse.statusCode)
				} else if let error = try? JSONDecoder().decode(Endpoint.FieldsValidationError.self, from: responseData) {
					throw error
				} else {
					throw Endpoint.Error("\(httpResponse.statusCode) Error", statusCode: httpResponse.statusCode)
				}
			}

			return endpoint.sanitize(data: responseData)

		} catch let validationError as Endpoint.FieldsValidationError {
			throw validationError
		} catch let urlError as URLError {
			switch urlError.code {
			case .notConnectedToInternet:
				throw Endpoint.Error("No internet connection", statusCode: urlError.errorCode)
			case .timedOut:
				throw Endpoint.Error("The request timed out", statusCode: urlError.errorCode)
			case .cannotFindHost:
				throw Endpoint.Error("Cannot find the server", statusCode: urlError.errorCode)
			case .cannotConnectToHost:
				throw Endpoint.Error("Cannot connect to the server", statusCode: urlError.errorCode)
			case .networkConnectionLost:
				throw Endpoint.Error("Network connection was lost", statusCode: urlError.errorCode)
			default:
				throw Endpoint.Error(urlError.localizedDescription)
			}
		} catch let error as Endpoint.Error {
			throw Endpoint.Error(error.localizedDescription, statusCode: error.statusCode)
		} catch {
			throw Endpoint.Error(error.localizedDescription)
		}
	}

	func fetch<T: Requestable>(_ endpoint: T, debug: Bool = false, timeout: TimeInterval = 30.0) async throws -> T.ResponseType {
		let data = try await fetchData(endpoint, debug: debug, timeout: timeout)
		if T.ResponseType.self == Endpoint.WebPage.self, let html = String(data: data, encoding: .utf8), let response = Endpoint.WebPage(url: try endpoint.url(host: host), html: html) as? T.ResponseType {
			return response
		}
		
		let result = try decode(data: data, endpoint: endpoint)
		try save(data: data, endpoint: endpoint)
		return result
	}
	
	func decode<T: Requestable>(data: Data, endpoint: T) throws -> T.ResponseType {
		do {
			return try JSONDecoder().decode(T.ResponseType.self, from: data)
		} catch {
			print(String(data: data, encoding: .utf8) ?? "")
			print(error)
			switch error {
			case let error as DecodingError:

				if let action = DTXAction.enter(withName: "JSONDecodingError") {
					action.reportError(withName: "JSONDecodingError", error: error)
					action.reportValue(withName: "ModelName", stringValue: "\(String(describing: T.ResponseType.self))")
					action.reportValue(withName: "dataSample", stringValue: String(data: data.prefix(1024), encoding: .utf8) ?? "nil")
					action.leave()
				}

				if case let .keyNotFound(key, _) = error {
					throw Endpoint.Error("Error reading \"\(key.stringValue)\" from \"\(endpoint.path)\".")
					
				} else if case let .dataCorrupted(context) = error {
					let keys = context.codingPath.map { $0.stringValue }
					let keyString = keys.joined(separator: ", ")
					throw Endpoint.Error("Error reading \"\(keyString)\" from \"\(endpoint.path)\".")
					
				} else if case let .typeMismatch(_, context) = error {
					let keys = context.codingPath.map { $0.stringValue }
					let keyString = keys.joined(separator: ", ")
					throw Endpoint.Error("Error reading \"\(keyString)\" from \"\(endpoint.path)\".")
				}
				
			default:
				throw error
			}
			
			throw error
		}
	}
}

extension Endpoint {
	// Guest for login to get access
	struct BasicAuthentication: Authenticatable {
		var host: Host
		var userId: String = ""
		var authorizationHeader: String {
			return "Basic \(APIEnvironmentProvider().getEnvironment().basicToken)"
		}
		
		init(host: Host) {
            self.host = host
		}
		
		func fetch<T: Requestable>(_ endpoint: T, debug: Bool = false) async throws -> T.ResponseType {
			let data = try await fetchData(endpoint, debug: debug)
            print(endpoint)
			return try decode(data: data, endpoint: endpoint)
		}
	}

	// Basic user with or without an upcoming reservation
	struct UserAuthentication: Authenticatable {
		var host: Host
		var account: Token
		var userId: String = "User"
		var authorizationHeader: String { "bearer \(account.accessToken)" }
		
		func fetchPage(url: URL) async throws -> String? {
			var request = URLRequest(url: url)
			request.httpMethod = Endpoint.Method.get.description
			request.addValue(Endpoint.Method.get.contentType, forHTTPHeaderField: "Content-Type")
			request.addValue("bearer \(account.accessToken)", forHTTPHeaderField: "Authorization")
			let (data, _) = try await URLSession.shared.data(for: request)
			guard let html = String(data: data, encoding: .utf8) else { return nil }
			let header = "<header><meta name='viewport' content='width=device-width,initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0'></header>"
			let style = "<style>body { margin: 0; padding: 0; }</style>"
			return "<html>\(header)\(style)\(html)</html>"
		}
	}
	
	// Includes reservation for sailors
	struct SailorAuthentication: Authenticatable {
		var host: Host
		var account: Token
		var userProfile: Endpoint.GetUserProfile.Response
		var reservation: VoyageReservation
		var authorizationHeader: String { "bearer \(account.accessToken)" }
		
		var userId: String {
			userProfile.email
		}
		
		func imageUrl(path: String) -> URL? {
			var components = URLComponents()
			components.scheme = "https"
			components.host = APIEnvironmentProvider().getEnvironment().host
			components.path = path
			return components.url
		}
	}
}

// MARK: Sailor Authentication

extension Endpoint.SailorAuthentication {
	
	func fetch<T: Viewable>(_ content: T) async throws -> T.Content {
		try await content.fetch(authentication: self)
	}
	
	func load<T: Viewable>(_ content: T) throws -> T.Content? {
		try content.load(authentication: self)
	}
	
	func preload<T: Viewable>(_ content: T) async -> T.Content? {
		await content.preload(authentication: self)
	}
	
	func upload(image: Data, targetSize: CGSize = .init(width: 720, height: 720), compressionQuality: CGFloat = 0.8) async throws -> URL {
		let data = image.resize(targetSize: targetSize, compressionQuality: 0.8)
		return try await uploadData(Endpoint.UploadMediaItem(imageData: data, imageType: .jpeg))
	}
	
	func reload(task: any Sailable) async throws {
		try await task.reload(self)
	}
	
	func fetchPaymentUrl() async throws -> URL {
		let paymentURL = try await fetch(Endpoint.GetPaymentPage(reservation: reservation)).links.form.href

		return paymentURL
	}
}

