//
//  SignUpInputModel.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 27.8.24.
//

import Foundation
import SwiftUI

enum SocialMediaType: String {
    case apple = "apple"
    case facebook = "facebook"
    case google = "google"
}

struct SignUpInputModel: Hashable {
    // MARK: - Properties
    var socialMediaId: String?
    var email: String
    var firstName: String
    var lastName: String
    var preferredName: String
    var receiveEmails: Bool
    var dateOfBirth: DateComponents = DateComponents(calendar: Calendar.current)
    var password: String
    var imageData: Data?
    var socialMediaType: SocialMediaType?
    
    // MARK: - Init
    init(socialMediaId: String? = nil, email: String = "", firstName: String = "", lastName: String = "", preferredName: String = "", dateOfBirth: DateComponents = DateComponents(calendar: Calendar.current), receiveEmails: Bool = false, password: String = "", imageData: Data? = nil, socialMediaType: SocialMediaType? = nil) {
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.preferredName = preferredName
        self.dateOfBirth = dateOfBirth
        self.receiveEmails = receiveEmails
        self.password = password
        self.imageData = imageData
        self.socialMediaId = socialMediaId
        self.socialMediaType = socialMediaType
    }

    var isSocialMediaUser: Bool {
        return !(socialMediaType == nil)
    }
}
