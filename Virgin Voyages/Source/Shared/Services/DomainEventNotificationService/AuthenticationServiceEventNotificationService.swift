//
//  AuthenticationServiceEventNotificationService.swift
//  Virgin Voyages
//
//  Created by TX on 24.7.25.
//

enum AuthenticationEventNotification: Hashable {
    case userDidLogIn
    case userDidLogOut
    case userDidRegister
    case shouldRecalculateApplicationScreenFlow
}

class AuthenticationEventNotificationService: DomainNotificationService<AuthenticationEventNotification> {
    static let shared = AuthenticationEventNotificationService()
}
