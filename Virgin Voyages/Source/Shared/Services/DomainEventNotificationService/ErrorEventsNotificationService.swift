//
//  ErrorEventsNotificationService.swift
//  Virgin Voyages
//
//  Created by TX on 11.6.25.
//


enum ErrorNotification: Hashable {
    case didReceiveError(VVDomainError)
}

class ErrorEventsNotificationService: DomainNotificationService<ErrorNotification> {
    static let shared = ErrorEventsNotificationService()
}
