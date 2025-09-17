//
//  MessengerLandingScreenCMSContent.swift
//  Virgin Voyages
//
//  Created by Timur Xhabiri on 24.10.24.
//

import Foundation

struct MessengerLandingScreenContentModel {
    let screenTitle: String
    let welcomingText: String
    let addFriendText: String
    
    init(screenTitle: String, welcomingText: String, addFriendText: String) {
        self.screenTitle = screenTitle
        self.welcomingText = welcomingText
        self.addFriendText = addFriendText
    }
    
    init() {
        self.screenTitle = ""
        self.welcomingText = ""
        self.addFriendText = ""
    }
}

extension MessengerLandingScreenContentModel {
    static func mock(
        screenTitle: String = "Mock Screen Title",
        welcomingText: String = "Welcome to the mock screen",
        addFriendText: String = "Mock Add Friend Text"
    ) -> MessengerLandingScreenContentModel {
        return .init(
            screenTitle: screenTitle,
            welcomingText: welcomingText,
            addFriendText: addFriendText
        )
    }
}
