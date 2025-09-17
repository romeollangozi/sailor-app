//
//  FolioShipboardViewModelTests.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 18.6.25.
//

import XCTest
@testable import Virgin_Voyages

final class FolioShipboardViewModelTests: XCTestCase {
    
    func testInitialState() async {
        let viewModel = await FolioShipboardViewModel(shipboard: Folio.sampleWithShipboard().shipboard!)
        
        let shouldShow = await MainActor.run { viewModel.shouldShowFolioDrawerInfoSheet }
        let content = await MainActor.run { viewModel.folioInfoContent }
        
        XCTAssertFalse(shouldShow)
        XCTAssertNil(content)
    }
    
    func testInfoBarTabClick_SetsCorrectContentAndOpensSheet() async {
        let viewModel = await FolioShipboardViewModel(shipboard: Folio.sampleWithShipboard().shipboard!)
        await MainActor.run {
            viewModel.onInfoBarTabClick()
        }
        
        let shouldShow = await MainActor.run { viewModel.shouldShowFolioDrawerInfoSheet }
        let content = await MainActor.run { viewModel.folioInfoContent }
        
        XCTAssertTrue(shouldShow)
        XCTAssertNotNil(content)
    }
    
    func testInfoAccountClick_SetsCorrectContentAndOpensSheet() async {
        let viewModel = await FolioShipboardViewModel(shipboard: Folio.sampleWithShipboard().shipboard!)
        await MainActor.run {
            viewModel.onInfoAccountClick()
        }
        
        let shouldShow = await MainActor.run { viewModel.shouldShowFolioDrawerInfoSheet }
        let content = await MainActor.run { viewModel.folioInfoContent }
        
        XCTAssertTrue(shouldShow)
        XCTAssertNotNil(content)
    }
    
    func testOnCloseFolioInfoSheet_ClosesSheetAndClearsContent() async {
        let viewModel = await FolioShipboardViewModel(shipboard: Folio.sampleWithShipboard().shipboard!)
        
        await MainActor.run {
            viewModel.onInfoAccountClick()
            viewModel.onCloseFolioInfoSheet()
        }
        
        let shouldShow = await MainActor.run { viewModel.shouldShowFolioDrawerInfoSheet }
        let content = await MainActor.run { viewModel.folioInfoContent }
        
        XCTAssertFalse(shouldShow)
        XCTAssertNil(content)
    }
    
    func testOnDownloadClick() async {
        let mockUseCase = MockDownloadFolioInvoiceUseCase()
        let viewModel = await MainActor.run {
            FolioShipboardViewModel(
                shipboard: Folio.sampleWithShipboard().shipboard!,
                downloadFolioInvoiceUseCase: mockUseCase
            )
        }
        
        let expectation = expectation(description: "Invoice download completed")
        await MainActor.run {
            viewModel.onDownloadClick()
            
            Task {
                while viewModel.isDownloadingInvoice {
                    try? await Task.sleep(nanoseconds: 10_000_000) // 10ms
                }
                expectation.fulfill()
            }
        }
        
        await fulfillment(of: [expectation], timeout: 1.0)
        
        let isDownloading = await MainActor.run { viewModel.isDownloadingInvoice }
        let pdfShown = await MainActor.run { viewModel.isShowPdfViewer }
        let data = await MainActor.run { viewModel.invoiceData }
        
        XCTAssertFalse(isDownloading)
        XCTAssertTrue(pdfShown)
        XCTAssertEqual(data, mockUseCase.expectedData)
    }
    
    func testLoadSailorProfile_SetsSailorName() async {
        let sailorProfileRepositoryMock = SailorProfileV2RepositoryMock()
        let mockSailorProfile = SailorProfileV2.sample()
        sailorProfileRepositoryMock.mockSailorProfile = mockSailorProfile
        
        let mockUseCase = GetSailorProfileV2UseCase(sailorsProfileRepository: sailorProfileRepositoryMock)
        
        let viewModel = await MainActor.run {
            FolioShipboardViewModel(
                shipboard: Folio.sampleWithShipboard().shipboard!,
                sailorProfileUseCase: mockUseCase
            )
        }
        
        try? await Task.sleep(nanoseconds: 10_000_000)
        
        let sailorName = await MainActor.run { viewModel.sailorName }
        let fullName = "\(mockSailorProfile.firstName) \(mockSailorProfile.lastName)"
        XCTAssertEqual(sailorName, fullName)
    }
    

    func testSortTransactionsByDate_groupsAndSortsCorrectly() async {
        let transactions: [Folio.Shipboard.Wallet.Transaction] = [
            .init(
                iconUrl: "",
                name: "Transaction1",
                date: ISO8601DateFormatter().date(from: "2025-05-29T18:15:00Z") ?? Date(),
                itemDescription: "Item 1",
                itemQuantity: 1,
                type: .cash,
                amount: "$10.00",
                subTotal: "$10.00",
                tax: "$0.00",
                total: "$10.00",
                receiptNr: 1111,
                receiptImageUrl: nil,
                dependentSailor: nil
            ),
            .init(
                iconUrl: "",
                name: "Transaction2",
                date: ISO8601DateFormatter().date(from: "2025-05-30T18:15:00Z") ?? Date(),
                itemDescription: "Item 2",
                itemQuantity: 1,
                type: .pos,
                amount: "$20.00",
                subTotal: "$20.00",
                tax: "$0.00",
                total: "$20.00",
                receiptNr: 2222,
                receiptImageUrl: nil,
                dependentSailor: nil
            ),
            .init(
                iconUrl: "",
                name: "Transaction3",
                date: ISO8601DateFormatter().date(from: "2025-05-29T18:15:00Z") ?? Date(),
                itemDescription: "Item 3",
                itemQuantity: 1,
                type: .pos,
                amount: "$30.00",
                subTotal: "$30.00",
                tax: "$0.00",
                total: "$30.00",
                receiptNr: 3333,
                receiptImageUrl: nil,
                dependentSailor: nil
            )
        ]
        
        let wallet = Folio.Shipboard.Wallet(header: nil, sailorLoot: nil, transactions: transactions)
        let shipboard = Folio.Shipboard(dependent: nil, wallet: wallet)
        
        let viewModel = await MainActor.run {
            FolioShipboardViewModel(shipboard: shipboard)
        }
        
        await MainActor.run {
            viewModel.selectedTab = .date
        }
        
        let grouped = await MainActor.run { viewModel.transactionItems }
        
        XCTAssertEqual(grouped.count, 2, "Expected 2 date groups (one for May 30 and one for May 29)")
        
        XCTAssertEqual(grouped[0].0, "May 30 2025", "Expected first group to be for the most recent date: May 30 2025")
        XCTAssertEqual(grouped[1].0, "May 29 2025", "Expected second group to be for the older date: May 29 2025")
        
        XCTAssertEqual(grouped[0].1.count, 1, "Expected May 30 group to contain 1 transaction")
        XCTAssertEqual(grouped[1].1.count, 2, "Expected May 29 group to contain 2 transactions")
        
        let firstGroupNames = grouped[0].1.map(\.name)
        XCTAssertTrue(firstGroupNames.contains("Transaction2"), "Expected May 30 group to include Transaction2")
        
        let secondGroupNames = grouped[1].1.map(\.name)
        XCTAssertTrue(secondGroupNames.contains("Transaction1"), "Expected May 29 group to include Transaction1")
        XCTAssertTrue(secondGroupNames.contains("Transaction3"), "Expected May 29 group to include Transaction3")
        
        let sortedSecondGroup = secondGroupNames.sorted { $0.localizedCaseInsensitiveCompare($1) == .orderedAscending }
        XCTAssertEqual(secondGroupNames.sorted { $0.localizedCaseInsensitiveCompare($1) == .orderedAscending },
                       sortedSecondGroup,
                       "Expected transactions in May 29 group to be sorted by name")
    }

    func testSortTransactionsBySailorName_groupsAndSortsCorrectly() async {
        let transactions: [Folio.Shipboard.Wallet.Transaction] = [
            .init(
                iconUrl: "",
                name: "Transaction1",
                date: Date(),
                itemDescription: "Item 1",
                itemQuantity: 1,
                type: .pos,
                amount: "$10.00",
                subTotal: "$10.00",
                tax: "$0.00",
                total: "$10.00",
                receiptNr: 1111,
                receiptImageUrl: nil,
                dependentSailor: .init(reservationGuestId: "RG001", name: "Alice", profileImageUrl: "")
            ),
            .init(
                iconUrl: "",
                name: "Transaction2",
                date: Date(),
                itemDescription: "Item 2",
                itemQuantity: 1,
                type: .pos,
                amount: "$20.00",
                subTotal: "$20.00",
                tax: "$0.00",
                total: "$20.00",
                receiptNr: 2222,
                receiptImageUrl: nil,
                dependentSailor: .init(reservationGuestId: "RG002", name: "Bob", profileImageUrl: "")
            ),
            .init(
                iconUrl: "",
                name: "Transaction3",
                date: Date(),
                itemDescription: "Item 3",
                itemQuantity: 1,
                type: .pos,
                amount: "$30.00",
                subTotal: "$30.00",
                tax: "$0.00",
                total: "$30.00",
                receiptNr: 3333,
                receiptImageUrl: nil,
                dependentSailor: .init(reservationGuestId: "RG001", name: "Alice", profileImageUrl: "")
            )
        ]
        
        let wallet = Folio.Shipboard.Wallet(header: nil, sailorLoot: nil, transactions: transactions)
        let shipboard = Folio.Shipboard(dependent: nil, wallet: wallet)
        
        let viewModel = await MainActor.run {
            FolioShipboardViewModel(shipboard: shipboard)
        }
        
        await MainActor.run {
            viewModel.selectedTab = .sailor
        }
        
        let grouped = await MainActor.run { viewModel.transactionItems }
        
        XCTAssertEqual(grouped.count, 2, "Expected 2 groups (one for Alice and one for Bob)")
        
        XCTAssertEqual(grouped[0].0, "Alice", "Expected first group to be for Alice (alphabetical order)")
        XCTAssertEqual(grouped[1].0, "Bob", "Expected second group to be for Bob (alphabetical order)")
        
        XCTAssertEqual(grouped[0].1.count, 2, "Expected Alice group to contain 2 transactions")
        let aliceNames = grouped[0].1.map(\.name)
        XCTAssertTrue(aliceNames.contains("Transaction1"), "Expected Alice group to include Transaction1")
        XCTAssertTrue(aliceNames.contains("Transaction3"), "Expected Alice group to include Transaction3")
        
        XCTAssertEqual(grouped[1].1.count, 1, "Expected Bob group to contain 1 transaction")
        let bobNames = grouped[1].1.map(\.name)
        XCTAssertTrue(bobNames.contains("Transaction2"), "Expected Bob group to include Transaction2")
        
        let sortedAlice = aliceNames.sorted { $0.localizedCaseInsensitiveCompare($1) == .orderedAscending }
        XCTAssertEqual(aliceNames, sortedAlice, "Expected transactions in Alice group to be sorted by name")
    }
    
    func testItems_ParsesBarTabRemainingFolioPrice() async {
        let barTab = Folio.Shipboard.Wallet.Header.BarTabRemaining(
            totalAmount: "$50.00",
            items: [
                .init(
                    name: "$50 Bar Tab Bonus",
                    amount: "$30.00",
                    dependentSailor: nil
                ),
                .init(
                    name: "$300 Bar Tab",
                    amount: "$-20.00",
                    dependentSailor: nil
                )
            ]
        )
        
        let header = Folio.Shipboard.Wallet.Header(account: nil, barTabRemaining: barTab)
        let wallet = Folio.Shipboard.Wallet(header: header, sailorLoot: nil, transactions: [])
        let shipboard = Folio.Shipboard(dependent: nil, wallet: wallet)
        
        let viewModel = await MainActor.run {
            FolioShipboardViewModel(shipboard: shipboard)
        }
        
        let items = await MainActor.run { viewModel.items }
        
        XCTAssertEqual(items.count, 2, "Expected 2 items from barTabRemaining sample")
        
        XCTAssertEqual(items[0].name, "$300 Bar Tab", "Expected first item name to match")
        XCTAssertEqual(items[0].price.integerPart, "20", "Expected integer part 20 for first item")
        XCTAssertEqual(items[0].price.decimalPart, "00", "Expected decimal part 00 for first item")
        XCTAssertTrue(items[0].price.isNegative, "Expected first item to be negative")
        
        XCTAssertEqual(items[1].name, "$50 Bar Tab Bonus", "Expected second item name to match")
        XCTAssertEqual(items[1].price.integerPart, "30", "Expected integer part 30 for second item")
        XCTAssertEqual(items[1].price.decimalPart, "00", "Expected decimal part 00 for second item")
        XCTAssertFalse(items[1].price.isNegative, "Expected second item to be non-negative")
    }
}
