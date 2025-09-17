//
//  Endpoint.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 4/14/23.
//

import Foundation

enum Endpoint {
	enum VPN: Equatable {
		case nonprod(VPNNonProdEnvironment)
		case prod(VPNProdEnvironment)

		enum VPNNonProdEnvironment {
			case dev
			case integration
			case cert
			case stage

			var hostName: String {
				switch self {
				case .dev:
					return "dev.gcpshore.virginvoyages.com"
				case .integration:
					return "int.gcpshore.virginvoyages.com"
				case .cert:
					return "cert.gcpshore.virginvoyages.com"
				case .stage:
					return "stage.gcp.virginvoyages.com"
				}
			}
		}

		enum VPNProdEnvironment {
			case prod

			var hostName: String {
				switch self {
				case .prod:
					return "mobile.shore.virginvoyages.com"
				}
			}
		}
	}
	
	enum Host: Equatable {
		case shoreside
		case ship(CruiseShip)
		case vpn(VPN)

		func url(path: String, scope: RequestScope, pathComponent: String?, query: Encodable?) throws -> URL? {
			var components = URLComponents()
			components.scheme = "https"

			switch (self, scope) {
				// Ship to Ship or Ship to Shoreside
			case (.ship(let ship), .shipOnly), (.ship(let ship), .any):
				components.host = ship.hostName
				components.path = "/svc" + path
				
				// Ship to Chat
			case (.ship(let ship), .chatOnly):
				components.host = ship.chatName
				components.path = path
				
				// Ship to Shoreside
			case (.ship, .shoresideOnly):
				components.host = APIEnvironmentProvider().getEnvironment().host
				components.path = path
				
				// Shoreside to Shoreside
			default:
				components.host = APIEnvironmentProvider().getEnvironment().host
				components.path = path
			}
			
			if let pathComponent = pathComponent {
				components.path.append("/")
				components.path.append(pathComponent)
			}
		
			components.queryItems = try? query?.queryItems()
			return components.url
		}
	}
		
	enum Method: Codable, CustomStringConvertible {
		case get
		case post
		case put
		case delete
		case form
		
		var description: String {
			switch self {
			case .get: return "GET"
			case .post, .form: return "POST"
			case .put: return "PUT"
			case .delete: return "DELETE"
			}
		}
		
		var contentType: String {
			self == .form ? "application/x-www-form-urlencoded" : "application/json"
		}
	}
	
	enum CachePolicy: String, Codable {
		case none
		case always // saveable
	}
	
	enum AuthenticationType: String, Codable {
		case basic
		case user
	}
	
	enum RequestScope {
		case shipOnly
		case shoresideOnly
		case chatOnly
		case vpnOnly
		case any
	}
	
	struct NoQuery: Encodable {
		
	}
	
	struct NoRequest: Encodable {
		
	}
	
	struct WebPage: Decodable {
		var url: URL
		var html: String
	}
	
	// MARK: Errors
	
	struct Error: LocalizedError {
        init(_ name: String, statusCode: Int? = nil) {
			description = name
            self.statusCode = statusCode
		}
		
		var description: String
        var statusCode: Int?
		var errorDescription: String? {
			return description
		}
	}

	// Sent for guest authentication
	struct MessageError: Decodable {
		var message: String
	}

	// Sent for user authentication
	struct StatusError: Decodable, LocalizedError {
		var message: Message
		
		struct Message: Decodable {
			var status: Int // 401
			var title: String // "401"
		}
	}

    struct FieldsValidationError: Decodable, LocalizedError {
        var fieldErrors: [FieldError]
        var errors: [String]

        struct FieldError: Decodable {
            var field: String
            var errorMessage: String
        }
    }

	struct MessageDescriptionError: Decodable, LocalizedError {
		var message: Message
		
		struct Message: Decodable {
			var error: String
			var errorDescription: String
			
			enum CodingKeys: String, CodingKey {
				case error
				case errorDescription = "error_description"
			}
		}
	}
	
	struct DescriptionError: Decodable {
		var error: String
		var errorDescription: String
		
		enum CodingKeys: String, CodingKey {
			case error
			case errorDescription = "error_description"
		}
	}
	
	struct CodeError: Decodable {
		var errors: [Item]
		
		struct Item: Decodable {
			let status: Int
			let id: String
			let code: String
			let detail: String
		}
	}	
}

extension Encodable {
	// Converts a value to a query string
	// {name: "value"} => name=value&name=value
	private func queryItemString(_ value: Any) -> String? {
		if let string = value as? String {
			return string
		}
		
		if let number = value as? NSNumber {
			return number.stringValue
		}
		
		if let array = value as? NSArray {
			var values: [String] = []
			for item in array {
				if let string = queryItemString(item) {
					values += [string]
				}
			}
			
			let isStringArray = array.reduce(true) { (result, element) -> Bool in
				result && element is NSString
			}
			
			let string = values.joined(separator: ",")
			return isStringArray ? string : "[\(string)]"
		}
		
		if let dictionary = value as? NSDictionary {
			guard let data = try? JSONSerialization.data(withJSONObject: dictionary) else {
				return nil
			}
			
			return String(data: data, encoding: .utf8)
		}
		
		return nil
	}
	
	func queryItems() throws -> [URLQueryItem]? {
		let queryData = try JSONEncoder().encode(self)
		guard let dictionary = try JSONSerialization.jsonObject(with: queryData) as? [String: Any] else {
			return nil
		}
		
		return dictionary.sorted {
			$0.key < $1.key
		}.compactMap { key, value in
			guard let string = queryItemString(value) else {
				return nil
			}
			
			return URLQueryItem(name: key, value: string)
		}
	}
	
	func formData() throws -> Data? {
		guard let queryItems = try queryItems() else {
			return nil
		}
		
		var components = URLComponents()
		components.queryItems = queryItems
		let body = components.percentEncodedQuery?.replacingOccurrences(of: "%20", with: "+")
		return body?.data(using: .utf8)
	}
}

extension Endpoint.Error {
    static func mapToVVDomainError(from error: Endpoint.Error) -> VVDomainError {
        if let statusCode = error.statusCode {
            switch statusCode {
            case 400:
				return .validationError(error: .init(fieldErrors: [], errors: [error.description]))
            case 401:
				return .unauthorized
            case 404:
                return .genericError
            case 500...599:
                return .genericError
            default:
				return .error(title: "#Awkward", message: error.description)
            }
        } else {
            return .genericError
        }
    }
    
    enum ErrorCode: Int {
        case notConnectedToInternet = -1009
        case requestTimedOut = -1001
        case cannotFindHost = -1003
        case cannotConnectToHost = -1004
        case networkConnectionLost = -1005
        
        static var retryableErrors: Set<Int> {
                return [
                    notConnectedToInternet.rawValue,
                    requestTimedOut.rawValue,
                    cannotFindHost.rawValue,
                    cannotConnectToHost.rawValue,
                    networkConnectionLost.rawValue
                ]
        }
    }
}

