//
//  SignUpEndPoint.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 6.9.24.
//

import Foundation

// MARK: - SignUp end point
enum SignUpEndPoint {
	case signUp(email: String, firstName: String, lastName: String, password: String, preferredName: String, birthDate: String, userType: String, enableEmailNewsOffer: Bool, isVerificationRequired: Bool)
	case signUpWithSocial(socialNetwork: String,socialMediaId: String, email: String, firstName: String, lastName: String, password: String, preferredName: String, birthDate: String, userType: String, enableEmailNewsOffer: Bool, isVerificationRequired: Bool)
	case updateUserPhoto(photoData: Data, token: String)
    case signupEmailValidation(email: String, clientToken: String)
}

extension SignUpEndPoint: HTTPRequestProtocol {

	// MARK: - Define path
	var path: String {
		switch self {
		case .signUp:
			return NetworkServiceEndpoint.signUpPath
		case .signUpWithSocial:
			return NetworkServiceEndpoint.signUpSocialPath
		case .updateUserPhoto:
			return NetworkServiceEndpoint.uploadImagePath
        case .signupEmailValidation:
            return NetworkServiceEndpoint.getSignupEmailValidation
		}
	}

	// MARK: - Request method
	var method: HTTPMethod {
		switch self {
		case .signUp:
			return .POST
		case .signUpWithSocial:
			return .POST
		case .updateUserPhoto:
			return .POST
        case .signupEmailValidation:
            return .GET
		}
	}

	var headers: HTTPHeadersProtocol? {
		switch self {
		case .signUp, .signUpWithSocial:
			let endpoint = Endpoint.BasicAuthentication(host: AuthenticationService.shared.host())
			return HTTPHeaders(["Content-Type": "application/json;charset=utf-8",
										 "Accept": "application/json",
										 "authorization" : endpoint.authorizationHeader,
										])
		case .updateUserPhoto(photoData: _, token: let token):
			return HTTPHeaders(["Content-Type": "multipart/form-data",
										 "Authorization" : "bearer \(token)",
										])
            
        case .signupEmailValidation(email: _, clientToken: let clientToken):
            return HTTPHeaders(["Authorization" : "bearer \(clientToken)"])
		}
	}

	// MARK: - Request body
	var body: [String : Any]? {
		switch self {
			//Sign up body parameters
		case .signUp(email: let email, firstName: let firstName, lastName: let lastName, password: let password, preferredName: let preferredName, birthDate: let birthDate, userType: let userType, enableEmailNewsOffer: let enableEmailNewsOffer, isVerificationRequired: let isVerificationRequired):
            return ["email" : email,
                    "firstName" : firstName,
                    "lastName" : lastName,
                    "password" : password,
                    "preferredName" : preferredName,
                    "birthDate": birthDate,
                    "userType": userType,
                    "enableEmailNewsOffer" : enableEmailNewsOffer,
                    "isVerificationRequired" : isVerificationRequired
            ]
        case .signUpWithSocial(socialNetwork: let network, socialMediaId: let socialMediaId, email: let email, firstName: let firstName, lastName: let lastName, password: let password, preferredName: let preferredName, birthDate: let birthDate, userType: let userType, enableEmailNewsOffer: let enableEmailNewsOffer, isVerificationRequired: let isVerificationRequired):
            return ["email": email,
                    "socialMediaId" : socialMediaId,
                    "firstName" : firstName,
                    "lastName" : lastName,
                    "preferredName" : preferredName,    
                    "birthDate": birthDate,
                    "userType": userType,
                    "enableEmailNewsOffer" : enableEmailNewsOffer,
                    "isVerificationRequired" : isVerificationRequired
            ]
        case .updateUserPhoto(let photoData, _):
            return ["imageData": photoData]
        case .signupEmailValidation(email: _):
            return nil
        }
    }
    
    // MARK: - Query parameters
    var queryItems: [URLQueryItem]? {
        switch self {
        case .signUp:
            return []
        case .signUpWithSocial(let network, _, _, _, _,  _,  _,  _,  _,  _,  _):
            return [URLQueryItem(name: "type", value: network)]
        case .updateUserPhoto:
            return [URLQueryItem(name: "mediagroupid", value: "f67c581d-4a9b-e611-80c2-00155df80332")]
        case .signupEmailValidation(email: let email, clientToken: _):
            return [URLQueryItem(name: "email", value: email)]
        }
    }
}
