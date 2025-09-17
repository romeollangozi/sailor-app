//
//  SignUpService.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 6.9.24.
//

import Foundation

extension NetworkServiceProtocol {
    
    // MARK: - SignUp
    func signUp(email: String,
                firstName: String,
                lastName: String,
                password: String,
                preferredName: String,
                birthDate: String,
                userType: String,
                enableEmailNewsOffer: Bool,
                isVerificationRequired: Bool) async -> SignUpCredentialsDetails? {
        let result = await request(SignUpEndPoint.signUp(email: email,
                                                         firstName: firstName,
                                                         lastName: lastName,
                                                         password: password,
                                                         preferredName: preferredName,
                                                         birthDate: birthDate,
                                                         userType: userType,
                                                         enableEmailNewsOffer: enableEmailNewsOffer,
                                                         isVerificationRequired: isVerificationRequired),
                                   responseModel: SignUpCredentialsDetails.self)
        
        // Errors are not managed for this request. Returning nil in case of any error
        if let response = result.response {
            return response
        } else {
            return nil
        }
    }
    
    // MARK: - SignUp with social networks
    func signUpWithSocial(type: String,
                          socialMediaId: String,
                          email: String,
                          firstName: String,
                          lastName: String,
                          password: String,
                          preferredName: String,
                          birthDate: String,
                          userType: String,
                          enableEmailNewsOffer: Bool,
                          isVerificationRequired: Bool) async -> TokenDTO? {
        let result = await request(SignUpEndPoint.signUpWithSocial(socialNetwork: type,
                                                                   socialMediaId: socialMediaId,
                                                                   email: email,
                                                                   firstName: firstName,
                                                                   lastName: lastName,
                                                                   password: password,
                                                                   preferredName: preferredName,
                                                                   birthDate: birthDate,
                                                                   userType: userType,
                                                                   enableEmailNewsOffer: enableEmailNewsOffer,
                                                                   isVerificationRequired: isVerificationRequired),
                                   responseModel: TokenDTO.self)
        
        // Errors are not managed for this request. Returning nil in case of any error
        if let response = result.response {
            return response
        } else {
            return nil
        }
    }
    
    // MARK: - Upload user profile image
    func uploadPhoto(imageData: Data, token: String) async -> String? {
        return try? await mediaUploadRequest(SignUpEndPoint.updateUserPhoto(photoData: imageData, token: token), responseModel: String.self)
    }
    
    // MARK: - Validate Email
    func signUpEmailValidation(email: String, clientToken: String) async throws -> ValidateEmailResponse? {
        
        let result = try await requestV2(SignUpEndPoint.signupEmailValidation(email: email, clientToken: clientToken), responseModel: ValidateEmailResponse.self)
        
        return result
    }
    
}
