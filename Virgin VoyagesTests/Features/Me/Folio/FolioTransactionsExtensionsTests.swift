//
//  FolioTransactionsExtensionsTests.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 25.6.25.
//

import XCTest
@testable import Virgin_Voyages

final class FolioTransactionsExtensionsTests: XCTestCase {
    
    func testGroupedByDate_sortsAndGroupsCorrectly() {
        
        let transactions: [Folio.Shipboard.Wallet.Transaction] = [
            .init(
                iconUrl: "",
                name: "Transaction1",
                date: ISO8601DateFormatter().date(from: "2025-05-29T18:15:00Z") ?? Date(),
                itemDescription: "60 min deep tissue massage",
                itemQuantity: 1,
                type: .cash,
                amount: "$25.00",
                subTotal: "$25.00",
                tax: "$0.00",
                total: "$25.00",
                receiptNr: 1234,
                receiptImageUrl: "...",
                dependentSailor: nil
            ),
            .init(
                iconUrl: "",
                name: "Transaction2",
                date: ISO8601DateFormatter().date(from: "2025-05-30T18:15:00Z") ?? Date(),
                itemDescription: "60 min deep tissue massage",
                itemQuantity: 1,
                type: .pos,
                amount: "$25.00",
                subTotal: "$25.00",
                tax: "$0.00",
                total: "$25.00",
                receiptNr: 1234,
                receiptImageUrl: "",
                dependentSailor: nil
            ),
            .init(
                iconUrl: "",
                name: "Transaction3",
                date: ISO8601DateFormatter().date(from: "2025-05-29T18:15:00Z") ?? Date(),
                itemDescription: "60 min deep tissue massage",
                itemQuantity: 1,
                type: .pos,
                amount: "$25.00",
                subTotal: "$25.00",
                tax: "$0.00",
                total: "$25.00",
                receiptNr: 1234,
                receiptImageUrl: "",
                dependentSailor: nil
            )
        ]
        
        let wallet = Folio.Shipboard.Wallet(header: nil, sailorLoot: nil, transactions: transactions)
        let grouped = wallet.groupedByDate
        
        XCTAssertEqual(grouped.count, 2)
        XCTAssertEqual(grouped[0].0, "May 30 2025")
        XCTAssertEqual(grouped[1].0, "May 29 2025")
        
        XCTAssertEqual(grouped[0].1.count, 1)
        XCTAssertEqual(grouped[1].1.count, 2)
        
        let firstGroup = grouped[0].1.map(\.name)
        XCTAssertTrue(firstGroup.contains("Transaction2"))
        
        let secondGroup = grouped[1].1.map(\.name)
        XCTAssertTrue(secondGroup.contains("Transaction1"))
        XCTAssertTrue(secondGroup.contains("Transaction3"))
    }
    
    func testGroupedByDate_returnsEmpty_whenNoTransactions() {
           let wallet = Folio.Shipboard.Wallet(header: nil, sailorLoot: nil, transactions: [])

           let grouped = wallet.groupedByDate

           XCTAssertTrue(grouped.isEmpty)
       }
}
