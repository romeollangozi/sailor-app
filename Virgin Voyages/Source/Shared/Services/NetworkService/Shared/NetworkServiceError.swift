//
//  NetworkServiceError.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 7.8.24.
//

import Foundation

enum NetworkServiceError: Error {
	case noInternetConnection
	case invalidURL
	case emptyResponse
	case requestFailed(Error)
	case invalidResponse
	case invalidData
	case decodeError
	case customError(String)
	case badURL
	case badParameters
	case genericError
	case badRequest
	case unauthorized
	case resourceNotFound
	case APIError(error: APIError)
	case timedOut
}

extension NetworkServiceError: Equatable {
	public static func == (lhs: NetworkServiceError, rhs: NetworkServiceError) -> Bool {
		switch (lhs, rhs) {
		case (.noInternetConnection, .noInternetConnection),
			 (.invalidURL, .invalidURL),
			 (.emptyResponse, .emptyResponse),
			 (.invalidResponse, .invalidResponse),
			 (.invalidData, .invalidData),
			 (.decodeError, .decodeError),
			 (.badURL, .badURL),
			 (.badParameters, .badParameters),
			 (.genericError, .genericError),
			 (.badRequest, .badRequest),
			 (.unauthorized, .unauthorized),
			 (.timedOut, .timedOut):
			return true

		case let (.customError(lhsMessage), .customError(rhsMessage)):
			return lhsMessage == rhsMessage

		case let (.requestFailed(lhsError), .requestFailed(rhsError)):
			// Basic check on error descriptions (errors rarely conform to Equatable)
			return lhsError.localizedDescription == rhsError.localizedDescription

		case let (.APIError(lhsApiError), .APIError(rhsApiError)):
			return lhsApiError == rhsApiError

		default:
			return false
		}
	}
}

struct StatusTitleError: Codable {
	let status: Int
	let title: String
}

enum APIError: Decodable {

	struct FieldError: Codable {
		let field: String
		let errorMessage: String
    // RTS-specific fields
       let isMultiCitizenshipError: Bool?
       let multiCitizenErrorDetails: MultiCitizenErrorDetails?
   }

    struct MultiCitizenErrorDetails: Codable, Equatable, Hashable {
       let options: [String: String]
   }

	struct ValidationError: Codable {
		let fieldErrors: [FieldError]
		let errors: [String]
	}

	case statusTitle(StatusTitleError)
	case unknownError(String)
	case validationError(ValidationError)

	private enum CodingKeys: String, CodingKey {
		case message, status, title, fieldErrors, errors
	}

	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)

		if let message = try? container.decode(StatusTitleError.self, forKey: .message) {
			self = .statusTitle(message)
		} else if let fieldErrors = try? container.decode([FieldError].self, forKey: .fieldErrors),
				  let errors = try? container.decode([String].self, forKey: .errors) {
			self = .validationError(ValidationError(fieldErrors: fieldErrors, errors: errors))
		}
		else {
			self = .unknownError("Unknown error format")
		}
	}
}

extension APIError: Equatable {
	static func == (lhs: APIError, rhs: APIError) -> Bool {
		switch (lhs, rhs) {
		case let (.statusTitle(lhsError), .statusTitle(rhsError)):
			return lhsError.status == rhsError.status &&
				   lhsError.title == rhsError.title

		case let (.unknownError(lhsMessage), .unknownError(rhsMessage)):
			return lhsMessage == rhsMessage

		case let (.validationError(lhsVal), .validationError(rhsVal)):
			return lhsVal == rhsVal

		default:
			return false
		}
	}
}

extension APIError.FieldError: Equatable {}
extension APIError.ValidationError: Equatable {}
extension StatusTitleError: Equatable {}

