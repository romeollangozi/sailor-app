//
//  NotificationJSONDecoderProtocol.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 5/8/25.
//

import Foundation

protocol NotificationJSONDecoderProtocol {
    func decodeNotificationData<T: Decodable>(_ json: String, as type: T.Type) -> T? where T: Decodable
}
