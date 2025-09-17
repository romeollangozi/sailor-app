//
//  ResetPasswordDTO.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 13.9.24.
//

import Foundation

// MARK: - ResetPasswordDTO
struct ResetPasswordDTO: Codable {
    let isEmailExist, isEmailSent: Bool
}
