//
//  QRBoardingPass.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 4/4/25.
//

import Foundation

struct QRBoardingPass: Codable {
    
    let firstName: String
    let lastName: String
    let reservationGuestId: String
    let reservationNumber: String
    
    func toJSONString() -> String? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
}
