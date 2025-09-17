//
//  URLRequestBuilder.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 4/30/25.
//


import Foundation

final class URLRequestBuilder {

	func build(for request: HTTPRequestProtocol, using environment: NetworkServiceEnvironmentProtocol) throws -> URLRequest {
		let url = try buildURL(for: request, using: environment)
		var urlRequest = URLRequest(url: url)
		urlRequest.httpMethod = request.method.rawValue
		urlRequest.timeoutInterval = request.timeoutInterval

		addHeaders(to: &urlRequest, from: request)
		addAuthentication(to: &urlRequest, for: request, using: environment)
		setRequestBody(for: &urlRequest, from: request)

		return urlRequest
	}

	// MARK: - URL Building

	private func buildURL(for request: HTTPRequestProtocol, using environment: NetworkServiceEnvironmentProtocol) throws -> URL {
		var components = URLComponents()

		if let fullURL = URL(string: request.path),
		   let urlComponents = URLComponents(url: fullURL, resolvingAgainstBaseURL: false),
		   let scheme = urlComponents.scheme,
		   let host = urlComponents.host {
			components.scheme = scheme
			components.host = host
			components.path = urlComponents.path
		} else {
			components.scheme = environment.scheme
			components.host = environment.host
			components.path = request.path
		}

		components.queryItems = request.queryItems

		guard let url = components.url else {
			throw NetworkServiceError.invalidURL
		}

		return url
	}

	// MARK: - Header Configuration

	private func addHeaders(to urlRequest: inout URLRequest, from request: HTTPRequestProtocol) {
		request.headers?.headers.forEach {
			urlRequest.setValue($0.value, forHTTPHeaderField: $0.key)
		}
	}

	// MARK: - Authentication

	private func addAuthentication(to urlRequest: inout URLRequest, for request: HTTPRequestProtocol, using environment: NetworkServiceEnvironmentProtocol) {
		if let authenticatedRequest = request as? AuthenticatedHTTPRequestProtocol,
		   let token = authenticatedRequest.tokenManager.token?.accessToken {
			urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
		} else if let _ = request as? BasicAuthenticatedHTTPRequestProtocol {
			urlRequest.setValue("Basic \(environment.basicToken)", forHTTPHeaderField: "Authorization")
		}
	}

	// MARK: - Body Configuration

	private func setRequestBody(for urlRequest: inout URLRequest, from request: HTTPRequestProtocol) {
		if let formRequest = request as? FormDataHTTPRequestProtocol {
			let boundary = "Boundary-\(UUID().uuidString)"
			urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
			urlRequest.httpBody = MultipartBuilder().createFormData(
				parameters: formRequest.parameters,
				files: formRequest.files,
				boundary: boundary
			)
            
		} else if let urlEncodedRequest = request as? URLEncodedRequestProtocol {
            urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            let encodedBody = urlEncodedRequest.parameters.percentEncoded()
            urlRequest.httpBody = encodedBody
            
        } else if let body = request.bodyData {
            urlRequest.httpBody = body
        } 
	}
}
