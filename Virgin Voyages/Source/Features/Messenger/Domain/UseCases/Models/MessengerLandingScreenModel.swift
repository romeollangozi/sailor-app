//
//  MessengerLandingModel.swift
//  Virgin Voyages
//
//  Created by Timur Xhabiri on 24.10.24.
//

import Foundation

struct MessengerLandingScreenModel {
    
    var content: MessengerLandingScreenContentModel
    
    init(content: MessengerLandingScreenContentModel) {
        self.content = content
    }
    // Empty state init
    init() {
        self.content = .init()
    }
}

extension MessengerLandingScreenModel {
    static func mock(
        content: MessengerLandingScreenContentModel = .mock()
    ) -> MessengerLandingScreenModel {
        return .init(
            content: content
        )
    }
}


