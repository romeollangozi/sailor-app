//
//  DeepLinkNotificationHandlerProtocol.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 5/7/25.
//

protocol DeepLinkNotificationHandlerProtocol {
    func handle(userStatus: UserApplicationStatus, type: String, payload: String)
}
