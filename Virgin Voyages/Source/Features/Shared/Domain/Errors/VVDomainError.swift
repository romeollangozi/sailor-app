//
//  DomainError.swift
//  Virgin Voyages
//
//  Created by Timur Xhabiri on 17.10.24.
//

import Foundation

struct FieldError: Equatable, Hashable {
	let field: String
	let errorMessage: String
    
    // Optional RTS specifics
    let isMultiCitizenshipError: Bool?
    let multiCitizenErrorDetails: MultiCitizenErrorDetails?
    
    init(field: String, errorMessage: String, isMultiCitizenshipError: Bool? = nil, multiCitizenErrorDetails: MultiCitizenErrorDetails? = nil) {
        self.field = field
        self.errorMessage = errorMessage
        self.isMultiCitizenshipError = isMultiCitizenshipError
        self.multiCitizenErrorDetails = multiCitizenErrorDetails
    }
}

struct MultiCitizenErrorDetails: Equatable, Hashable {
    let options: [String: String]
}

struct ValidationError: Equatable, Hashable {
	let fieldErrors: [FieldError]
	let errors: [String]
}

protocol VVError: Error {
}

enum VVDomainError: VVError, Equatable, Hashable {
	case error(title: String?, message: String?)
	case validationError(error: ValidationError)
    case genericError
    case notFound
	case unknownError
	case unauthorized
}

class NetworkToVVDomainErrorMapper  {
    static func map(from networkError: NetworkServiceError) -> VVDomainError {
        switch networkError {
        case .customError(let error):
			return .error(title: "#Awkward", message: error)
		case .APIError(let error):
			return mapAPIError(error)
		case .unauthorized:
			return .unauthorized
        case .badRequest:
			return .validationError(error: .init(fieldErrors: [], errors: ["An error occurred"]))
        default: return .unknownError
        }
    }

	static func mapAPIError(_ error: APIError) -> VVDomainError {
		switch error {
		case .statusTitle(let statusTitleError):
			return .error(title: "#Awkward", message: statusTitleError.title)
		case .unknownError(_):
            return .unknownError
		case .validationError(let validationError):
			return .validationError(error: validationError.toDomain())
		}
	}
}

extension APIError.ValidationError {
	func toDomain() -> ValidationError {
		return ValidationError(fieldErrors: fieldErrors.toDomain(), errors: errors)
	}
}

extension Array where Element == APIError.FieldError {
	func toDomain() -> [FieldError] {
		return map({ $0.toDomain() })
	}
}

extension APIError.FieldError {
    func toDomain() -> FieldError {
        return FieldError(
            field: field,
            errorMessage: errorMessage,
            isMultiCitizenshipError: isMultiCitizenshipError,
            multiCitizenErrorDetails: multiCitizenErrorDetails?.toDomain()
        )
    }
}

extension APIError.MultiCitizenErrorDetails {
    func toDomain() -> MultiCitizenErrorDetails {
        return MultiCitizenErrorDetails(options: options)
    }
}
