//
//  AddOnHeaderViewModelTests.swift
//  Virgin VoyagesTests
//
//  Created by Abel on 9/10/25.
//

import XCTest
@testable import Virgin_Voyages

final class AddOnHeaderViewModelTests: XCTestCase {

    func testPrice_perSailor_showsBasePriceOnly() {
        // Given
        let addon = AddOn(
            shortDescription: nil,
            name: "Test",
            subtitle: nil,
            amount: 100.0,
            bonusAmount: nil,
            addonCategory: nil,
            code: "CODE",
            bonusDescription: nil,
            longDescription: nil,
            imageURL: nil,
            detailReceiptDescription: nil,
            currencyCode: "USD",
            isCancellable: false,
            isPurchased: false,
            sellType: .perSailor,
            isPerSailorPurchase: true,
            isBookingEnabled: true,
            isActionButtonsDisplay: true,
            isSoldOut: false
        )
        let vm = AddOnHeaderViewModel(addOn: addon)

        // When
        // Then
        XCTAssertEqual(vm.price, "$ 100.00" as String?)
    }

    func testPrice_perCabin_appendsPerSailorSuffix() {
        // Given
        let addon = AddOn(
            shortDescription: nil,
            name: "Test",
            subtitle: nil,
            amount: 100.0,
            bonusAmount: nil,
            addonCategory: nil,
            code: "CODE",
            bonusDescription: nil,
            longDescription: nil,
            imageURL: nil,
            detailReceiptDescription: nil,
            currencyCode: "USD",
            isCancellable: false,
            isPurchased: false,
            sellType: .perCabin,
            isPerSailorPurchase: false,
            isBookingEnabled: true,
            isActionButtonsDisplay: true,
            isSoldOut: false
        )
        let vm = AddOnHeaderViewModel(addOn: addon)

        // When
        // Then
        XCTAssertEqual(vm.price, "$ 100.00 per Sailor" as String?)
    }
}
