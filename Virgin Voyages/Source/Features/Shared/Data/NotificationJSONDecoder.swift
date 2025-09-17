//
//  NotificationJSONDecoder.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 5/8/25.
//

import Foundation

class NotificationJSONDecoder: NotificationJSONDecoderProtocol {
    
    func decodeNotificationData<T: Decodable>(_ json: String, as type: T.Type) -> T? where T: Decodable {
        guard let data = json.data(using: .utf8) else {
            return nil
        }
        
        do {
            let decoded = try JSONDecoder().decode(T.self, from: data)
            return decoded
        } catch {
            return nil
        }
    }
    
}
