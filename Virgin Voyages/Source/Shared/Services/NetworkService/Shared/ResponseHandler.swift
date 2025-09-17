//
//  ResponseHandler.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 4/30/25.
//


import Foundation

final class ResponseHandler {
    func handle<T: Decodable>(data: Data, response: HTTPURLResponse, responseModel: T.Type) throws -> T {
        switch response.statusCode {
        case 200...299:
            return try decode(data, as: responseModel)
        case 400:
            throw parseApiError(from: data) ?? .badRequest
        case 401:
            throw NetworkServiceError.unauthorized
		case 404:
			throw NetworkServiceError.resourceNotFound
        default:
            throw parseApiError(from: data) ?? .genericError
        }
    }

    func decode<T: Decodable>(_ data: Data, as model: T.Type) throws -> T {
        
        if data.isEmpty, T.self == EmptyResponse.self {
            return EmptyResponse() as! T
        } else {
			return try JSONDecoder().decode(model, from: data)
        }
    }

    func parseApiError(from data: Data) -> NetworkServiceError? {
        return (try? JSONDecoder().decode(APIError.self, from: data)).map {
            NetworkServiceError.APIError(error: $0)
        }
    }
}
