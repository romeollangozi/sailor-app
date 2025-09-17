//
//  FolioShipboardViewModel.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 17.6.25.
//

import Observation
import SwiftUI
import VVUIKit

@Observable
class FolioShipboardViewModel: BaseViewModelV2, FolioShipboardViewModelProtocol {

    private let shipboard: Folio.Shipboard
    private let folioImageUseCase: FolioImageUseCaseProtocol
    private let localizationManager: LocalizationManagerProtocol
    private var folioResources: FolioResources = .sample()
    private let downloadFolioInvoiceUseCase: DownloadFolioInvoiceUseCaseProtocol
    private let sailorProfileUseCase: GetSailorProfileV2UseCasePotocol

    var invoiceData: Data?
    var isDownloadingInvoice: Bool = false
    var isShowPdfViewer: Bool = false
    var sailorName: String = ""
    
    init(
        shipboard: Folio.Shipboard = Folio.emptyShipboard(),
        folioImageUseCase: FolioImageUseCaseProtocol = FolioImageUseCase(),
        localizationManager: LocalizationManagerProtocol = LocalizationManager.shared,
        downloadFolioInvoiceUseCase: DownloadFolioInvoiceUseCaseProtocol = DownloadFolioInvoiceUseCase(),
        sailorProfileUseCase: GetSailorProfileV2UseCasePotocol = GetSailorProfileV2UseCase()
    ) {
        self.shipboard = shipboard
        self.folioImageUseCase = folioImageUseCase
        self.localizationManager = localizationManager
        self.downloadFolioInvoiceUseCase = downloadFolioInvoiceUseCase
        self.sailorProfileUseCase = sailorProfileUseCase

        super.init()
        loadFolioLocalizedResources()
        loadSailorProfile()
        sortTransactionsByDate()
    }

    var cardHeader: String? { shipboard.wallet?.header?.account?.isAmountCredit == true ? "Account" : "Amount" }
    var cardSubHeader: String? { shipboard.wallet?.header?.account?.isAmountCredit == true ? "In Credit" : "Due" }
    var cardOnFileText: String { folioResources.cardOnFileText }
    var cardExplainerText: String { folioResources.cardExplainerText }
    var barCardExplainerText: String { folioResources.barTabExplainerText }
    var cardNumber: String { shipboard.wallet?.header?.account?.cardNumber ?? "" }
    var cardIconURL: String { shipboard.wallet?.header?.account?.cardIconURL ?? "" }
    var accountBalance: String { shipboard.wallet?.header?.account?.amount ?? "0.00" }
    var barTabBalance: String? { shipboard.wallet?.header?.barTabRemaining?.totalAmount }
    var items: [FolioCardItem] {
        shipboard.wallet?.header?.barTabRemaining?.sortedItems.map {
            FolioCardItem(
                name: $0.name,
                price: folioPrice(from: $0.amount),
                imageURL: folioImageUseCase.authenticatedImageURL(from: $0.dependentSailor?.profileImageUrl)
            )
        } ?? []
    }
    var shouldShowFolioDrawerInfoSheet: Bool = false
    var folioInfoContent: FolioInfoContent? = nil
    var sailorLootTitle: String? { shipboard.wallet?.sailorLoot?.title }
    var sailorLootDescription: String? { shipboard.wallet?.sailorLoot?.description }
    var transactionItems: [(String, [FolioTransaction])] = []
    var selectedTab: FolioSortType = .date {
        didSet {
            selectedTab == .date ? sortTransactionsByDate() : sortTransactionsBySailorName()
        }
    }
    var shouldShowTransactionSortTabs: Bool {
        shipboard.wallet?.transactions.contains { $0.dependentSailor != nil } ?? false
    }
    var selectedTransaction: FolioTransaction? = nil
        
    func onDownloadClick() {
        isDownloadingInvoice = true
        Task {
            let data = try await downloadFolioInvoiceUseCase.execute()
            self.invoiceData = data
            isDownloadingInvoice = false
            isShowPdfViewer = true
        }
    }

    func onCloseFolioInfoSheet() {
        shouldShowFolioDrawerInfoSheet = false
        folioInfoContent = nil
    }
    
    func onInfoAccountClick() {
        folioInfoContent = FolioInfoContent(
            title: "End of voyage payment and refund",
            description: shipboard.accountDescriptionText
        )
        shouldShowFolioDrawerInfoSheet = true
    }
    
    func onInfoBarTabClick() {
        folioInfoContent = FolioInfoContent(
            title: folioResources.barTabInfoDrawerHeadline ,
            description: folioResources.barTabInfoDrawerBody
        )
        shouldShowFolioDrawerInfoSheet = true
    }
    
    func onTransactionClick(transaction: FolioTransaction) {
        selectedTransaction = transaction
    }
    
    func onCloseTransaction() {
        selectedTransaction = nil
    }
    
    private func sortTransactionsByDate() {
        transactionItems = shipboard.wallet?.groupedByDate.map { date, transactions in
            (date, transactions.map(mapToFolioTransaction))
        } ?? []
    }

    private func sortTransactionsBySailorName() {
        transactionItems = {
            let grouped = Dictionary(
                grouping: shipboard.wallet?.transactions ?? [],
                by: { $0.dependentSailor?.name ?? sailorName }
            )

            let sortedGroups = grouped.sorted {
                $0.key.localizedCaseInsensitiveCompare($1.key) == .orderedAscending
            }

            return sortedGroups.map { name, transactions in
                let sortedTransactions = transactions.sorted {
                    $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
                }
                return (name, sortedTransactions.map(mapToFolioTransaction))
            }
        }()
    }
    
    private func mapToFolioTransaction(_ transaction: Folio.Shipboard.Wallet.Transaction) -> FolioTransaction {
        let folioPriceValue = folioPrice(from: transaction.total)
        let price = FolioPrice(
            integerPart: folioPriceValue.integerPart,
            decimalPart: folioPriceValue.decimalPart,
            isNegative: transaction.type == .refund
        )
        return FolioTransaction(
            iconUrl: transaction.iconUrl,
            name: transaction.name,
            dateTime: transaction.date.toMonthDayTime(),
            itemDescription: transaction.itemDescription,
            itemQuantity: transaction.itemQuantity,
            type: TransactionType(rawValue: transaction.type.rawValue) ?? .pos,
            amount: transaction.amount,
            subTotal: transaction.subTotal,
            tax: transaction.tax,
            total: transaction.total,
            receiptNr: transaction.receiptNr,
            price: price,
            profileImageUrl: folioImageUseCase.authenticatedImageURL(from: transaction.dependentSailor?.profileImageUrl),
            folioResources: FolioStringResources(walletFolioTotalText: folioResources.walletFolioTotalText, shipEatsTaxText: folioResources.shipEatsTaxText, globalGlobalShortStringsSubtotal: folioResources.globalGlobalShortStringsSubtotal),
            receiptImageUrl: folioImageUseCase.authenticatedImageURL(from: transaction.receiptImageUrl)
        )
    }

    
    private func folioPrice(from amount: String) -> FolioPrice {
        let trimmed = amount.trimmingCharacters(in: .whitespaces)
        let isNegative = trimmed.contains("-")

        let cleaned = trimmed
            .replacingOccurrences(of: "$", with: "")
            .replacingOccurrences(of: "-", with: "")

        let components = cleaned.split(separator: ".")
        let integerPart = String(components.first ?? "0")
        let decimalPart = String(components.dropFirst().first ?? "00")
        
        return FolioPrice(integerPart: integerPart, decimalPart: decimalPart, isNegative: isNegative)
    }
    
    private func loadFolioLocalizedResources() {
        folioResources = FolioResources(
            cardOnFileText: localizationManager.getString(for: .folioCardOnFileText),
            cardExplainerText: localizationManager.getString(for: .folioCardExplainerText),
            barTabExplainerText: localizationManager.getString(for: .folioBarTabExplainerText),
            barTabInfoDrawerHeadline: localizationManager.getString(for: .folioBarTabInfoDrawerHeadline),
            barTabInfoDrawerBody: localizationManager.getString(for: .folioBarTabInfoDrawerBody),
            walletFolioTotalText: localizationManager.getString(for: .walletFolioTotalText),
            shipEatsTaxText: localizationManager.getString(for: .shipEatsTaxText),
            globalGlobalShortStringsSubtotal: localizationManager.getString(for: .globalGlobalShortStringsSubtotal)
        )
    }
    
    private func loadSailorProfile() {
        Task {
            guard let sailorProfile = await sailorProfileUseCase.execute(reservationNumber: nil) else { return }
            sailorName = "\(sailorProfile.firstName) \(sailorProfile.lastName)"
        }
    }
}
