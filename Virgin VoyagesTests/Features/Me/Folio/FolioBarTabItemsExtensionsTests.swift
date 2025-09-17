//
//  FolioBarTabItemsExtensionsTests.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 20.6.25.
//

import XCTest
@testable import Virgin_Voyages

final class FolioBarTabItemsExtensionsTests: XCTestCase {
    
    func testSortedItems_ordersByDependentSailorCorrectly() {
        let sailorA = Folio.Shipboard.Wallet.Sailor(reservationGuestId: "1", name: "Bob", profileImageUrl: "")
        let sailorB = Folio.Shipboard.Wallet.Sailor(reservationGuestId: "2", name: "Tom", profileImageUrl: "")
        
        let item1 = Folio.Shipboard.Wallet.Header.BarTabRemaining.Item(name: "Bar Tab6", amount: "10", dependentSailor: nil)
        let item2 = Folio.Shipboard.Wallet.Header.BarTabRemaining.Item(name: "Bar Tab5", amount: "20", dependentSailor: nil)
        let item3 = Folio.Shipboard.Wallet.Header.BarTabRemaining.Item(name: "Bar Tab4", amount: "30", dependentSailor: sailorA)
        let item4 = Folio.Shipboard.Wallet.Header.BarTabRemaining.Item(name: "Bar Tab3", amount: "40", dependentSailor: sailorB)
        let item5 = Folio.Shipboard.Wallet.Header.BarTabRemaining.Item(name: "Bar Tab2", amount: "50", dependentSailor: sailorA)
        let item6 = Folio.Shipboard.Wallet.Header.BarTabRemaining.Item(name: "Bar Tab1", amount: "60", dependentSailor: sailorB)
        
        let barTab = Folio.Shipboard.Wallet.Header.BarTabRemaining(
            totalAmount: "100",
            items: [item1, item2, item3, item4, item5, item6]
        )
        
        XCTAssertEqual(barTab.sortedItems, [item2, item1, item5, item3, item6, item4])
    }
}
