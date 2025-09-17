//
//  HomeActionsSection.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 25.3.25.
//

import Foundation

struct HomeActionsSection: HomeSection {
    var id: String
    var key: SectionKey = .actions
    let items: [Action]
    
    struct Action: Identifiable {
        let id = UUID()
        let type: ActionType
        let imageUrl: String
        let title: String
        let description: String
    }
}

enum ActionType: String {
    case wallet = "Wallet"
    case homeGuide = "HomeGuide"
    case wiFi = "WiFi"
}

extension HomeActionsSection {
    static func empty() -> Self {
        return HomeActionsSection(
            id: UUID().uuidString,
            key: .actions,
            items: []
        )
    }
    
    static func sample() -> Self {
        return HomeActionsSection(
            id: UUID().uuidString,
            key: .actions,
            items: [
                Action(
                    type: .wallet,
                    imageUrl: "https://example.com/wallet.jpg",
                    title: "Your Wallet",
                    description: "View your onboard spending and balances."
                ),
                Action(
                    type: .homeGuide,
                    imageUrl: "https://example.com/guide.jpg",
                    title: "Home Guide",
                    description: "Learn more about your voyage."
                )
            ]
        )
    }
}

