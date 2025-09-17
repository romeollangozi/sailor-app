//
//  RequestPasswordService.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 13.9.24.
//

import Foundation

extension NetworkServiceProtocol {
    // MARK: - Reset password
    func resetPassword(email: String, clientToken: String, reCaptcha: String) async throws -> ResetPasswordDTO {

        let result = await request(RequestPasswordEndPoint.resetPassword(clientToken: clientToken, email: email, reCaptcha: reCaptcha), responseModel: ResetPasswordDTO.self)
        guard let response: ResetPasswordDTO = result.response else { throw NetworkServiceError.genericError }
        return response
    }
    
}
