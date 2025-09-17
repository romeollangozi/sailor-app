//
//  FolioShipboardView.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 12.6.25.
//

import SwiftUI

public protocol FolioShipboardViewModelProtocol {
    var cardHeader: String? { get }
    var cardSubHeader: String? { get }
    var cardOnFileText: String { get }
    var cardExplainerText: String { get }
    var barCardExplainerText: String { get }
    var cardNumber: String { get }
    var cardIconURL: String { get }
    var accountBalance: String { get }
    var barTabBalance: String? { get }
    var items: [FolioCardItem] { get }
    var shouldShowFolioDrawerInfoSheet: Bool { get set }
    var folioInfoContent: FolioInfoContent? { get set }
    var sailorLootTitle: String? { get }
    var sailorLootDescription: String? { get }
    var transactionItems: [(String, [FolioTransaction])] { get }
    var shouldShowTransactionSortTabs: Bool { get }
    var selectedTab: FolioSortType { get set}
    var selectedTransaction: FolioTransaction? { get set }
    var invoiceData: Data? { get }
    var isDownloadingInvoice: Bool { get set }
    var isShowPdfViewer: Bool { get set }
    var sailorName: String { get }

    func onDownloadClick()
    func onCloseFolioInfoSheet()
    func onInfoAccountClick()
    func onInfoBarTabClick()
    func onTransactionClick(transaction: FolioTransaction)
    func onCloseTransaction()
}

public struct FolioCardItem: Identifiable {
    public let id: UUID = UUID()
    public let name: String
    public let price: FolioPrice
    public let imageURL: URL?
    
    public init(name: String, price: FolioPrice, imageURL: URL? = nil) {
        self.name = name
        self.price = price
        self.imageURL = imageURL
    }
}

public struct FolioInfoContent {
    let title: String
    let description: String
    
    public init(title: String, description: String) {
        self.title = title
        self.description = description
    }
}

public enum TransactionType: String, Codable {
    case pos
    case refund
    case cash
    case sailorLoot
}

public struct FolioTransaction: Identifiable, Hashable {
    public let id: UUID = UUID()
    public let name: String
    let iconUrl: String
    let dateTime: String
    let itemDescription: String
    let itemQuantity: Int
    let type: TransactionType
    let amount: String
    let subTotal: String
    let tax: String
    let total: String
    let receiptNr: Int
    let price: FolioPrice
    let profileImageUrl: URL?
    let folioResources: FolioStringResources
    let receiptImageUrl: URL?

    public init(iconUrl: String, name: String, dateTime: String, itemDescription: String, itemQuantity: Int, type: TransactionType, amount: String, subTotal: String, tax: String, total: String, receiptNr: Int, price: FolioPrice, profileImageUrl: URL?, folioResources: FolioStringResources, receiptImageUrl: URL?) {
        self.iconUrl = iconUrl
        self.name = name
        self.dateTime = dateTime
        self.itemDescription = itemDescription
        self.itemQuantity = itemQuantity
        self.type = type
        self.amount = amount
        self.subTotal = subTotal
        self.tax = tax
        self.total = total
        self.receiptNr = receiptNr
        self.price = price
        self.profileImageUrl = profileImageUrl
        self.folioResources = folioResources
        self.receiptImageUrl = receiptImageUrl
    }
}

public struct FolioStringResources: Equatable, Hashable {
    let walletFolioTotalText: String?
    let shipEatsTaxText: String?
    let globalGlobalShortStringsSubtotal: String?

    public init(
        walletFolioTotalText: String,
        shipEatsTaxText: String,
        globalGlobalShortStringsSubtotal: String
    ) {
        self.walletFolioTotalText = walletFolioTotalText
        self.shipEatsTaxText = shipEatsTaxText
        self.globalGlobalShortStringsSubtotal = globalGlobalShortStringsSubtotal
    }
}

public enum FolioSortType {
    case date
    case sailor
}

public struct FolioShipboardView: View {
    @State private var viewModel: FolioShipboardViewModelProtocol
    
    public init(viewModel: FolioShipboardViewModelProtocol) {
        _viewModel = .init(wrappedValue: viewModel)
    }
    
    public var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                VStack(spacing: .zero) {
                    headerView()
                    if let title = viewModel.sailorLootTitle, let description = viewModel.sailorLootDescription {
                        sailorLootView(title: title, description: description)
                    }
                    if viewModel.transactionItems.isEmpty {
                        emptryTransactionView()
                    } else {
                        transactionView()
                    }
                    Spacer()
                }
            }
                                     
            toolbar()
                .zIndex(1)
        }
        .ignoresSafeArea(edges: [.top])
        .sheet(isPresented: $viewModel.shouldShowFolioDrawerInfoSheet) {
            infoSheet()
        }
        .fullScreenCover(item: $viewModel.selectedTransaction) { transaction in
                FolioTransactionSheet(
                    name: transaction.name,
                    dateTime: transaction.dateTime,
                    iconURL: transaction.iconUrl,
                    receiptURL: transaction.receiptImageUrl,
                    nonPosReceipt: NonPosReceipt(
                        itemDescription: transaction.itemDescription,
                        type: transaction.type,
                        amount: transaction.amount,
                        subTotal: transaction.subTotal,
                        tax: transaction.tax,
                        total: transaction.total,
                        folioResources: transaction.folioResources
                    ),
                    close: { viewModel.onCloseTransaction() }
                )
        }
        .sheet(isPresented: $viewModel.isShowPdfViewer) {
            if let pdfData = viewModel.invoiceData {
                PDFViewerWithShare(pdfData: pdfData)
            }
        }
    }
    
    private func headerView() -> some View {
        VStack(spacing: Spacing.space16) {
            Text("My Wallet")
                .font(.vvHeading1Bold)
                .foregroundColor(.white)
                .padding(.top, Spacing.space16)
                .padding(.bottom, Spacing.space8)
            
            if let header = viewModel.cardHeader, let subheader = viewModel.cardSubHeader {
                FolioExpandableRow(header: header, subheader: subheader, balance: viewModel.accountBalance) {
                    if viewModel.cardNumber.isEmpty {
                        emptyAccountCardView()
                    } else {
                        accountCardView()
                    }
                }
            }
            
            if let barTabBalance = viewModel.barTabBalance {
                FolioExpandableRow(header: "Bar tab", subheader: "Remaining", balance: barTabBalance) {
                    barTabCardView()
                }
            }
        }
        .padding(.horizontal, Spacing.space24)
        .padding(.bottom, Spacing.space24)
        .padding(.top, Spacing.space64)
        .background {
            GeometryReader { geo in
                Image("Pattern")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geo.size.width, height: geo.size.height)
                    .clipped()
            }
        }
    }
    
    private func emptyAccountCardView() -> some View {
        VStack(spacing: .zero) {
            headerCardInfo(title: "No card on file")
            
            Text("No card currently on file.\nSee Sailor Services if you wish to add a payment card to your folio.")
                .font(.vvCaption)
                .foregroundColor(.slateGray)
                .multilineTextAlignment(.center)
                .padding(.vertical, Spacing.space16)
                .padding(.horizontal, Spacing.space8)
            
            footerCardInfo(title: viewModel.cardExplainerText, onInfoClick: viewModel.onInfoAccountClick)
        }
    }
    
    private func accountCardView() -> some View {
        VStack(spacing: .zero) {
            headerCardInfo(title: viewModel.cardOnFileText)
            
            HStack(spacing: Spacing.space16) {
                if !viewModel.cardIconURL.isEmpty {
                    ImageViewer(url: viewModel.cardIconURL, width: 80, height: 60)
                }
                Text(viewModel.cardNumber)
                    .font(.vvHeading5Medium)
                    .foregroundColor(.darkGray)
                    .padding(.vertical, 20)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, Spacing.space24)
            
            footerCardInfo(title: viewModel.cardExplainerText, onInfoClick: viewModel.onInfoAccountClick)
        }
    }
    
    private func barTabCardView() -> some View {
        VStack(spacing: .zero) {
            headerCardInfo(title: "Your Purchased Bar Tab")
            
            ForEach(viewModel.items) { item in
                FolioBarTabRow(name: item.name, price: item.price, imageURL: item.imageURL)
                
                Divider()
                    .foregroundStyle(Color.borderGray)
                    .padding(.horizontal, Spacing.space24)
            }
            
            footerCardInfo(title: viewModel.barCardExplainerText, onInfoClick: viewModel.onInfoBarTabClick)
        }
    }
    
    private func headerCardInfo(title: String) -> some View {
        Text(title.uppercased())
            .font(.vvCaptionBold)
            .foregroundColor(.slateGray)
            .kerning(1.2)
            .padding(.top, Spacing.space24)
            .padding(.bottom, Spacing.space12)
            .padding(.horizontal, Spacing.space8)
    }
    
    private func footerCardInfo(title: String, onInfoClick: @escaping () -> Void) -> some View {
        VStack(spacing: .zero) {
            Divider()
                .foregroundStyle(Color.borderGray)
                .padding(.horizontal, Spacing.space24)
            
            HStack(spacing: 4) {
                Text(title)
                    .font(.vvCaption)
                    .foregroundColor(.slateGray)
                Button(action: onInfoClick) {
                    Image("Info")
                        .frame(width: Spacing.space24, height: Spacing.space24)
                }
              
            }
            .padding(.vertical, Spacing.space20)
            .padding(.horizontal, Spacing.space24)
        }
    }
    
    private func sailorLootView(title: String, description: String) -> some View {
        VStack(spacing: Spacing.space0) {
            VStack(alignment: .leading, spacing: Spacing.space12) {
                Text(title.uppercased())
                    .font(.vvCaptionBold)
                    .foregroundColor(.slateGray)
                    .kerning(1.2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(description)
                    .font(.vvCaption)
                    .foregroundColor(.slateGray)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxWidth: .infinity)
            .padding(Spacing.space24)
            .background(Color.softGray)
        }
        .padding(.horizontal, Spacing.space20)
        .padding(.top, Spacing.space20)
    }
    
    private func emptryTransactionView() -> some View {
        VStack(spacing: .zero) {
                Image("Folio")
                
                Text("Nothing to see yet.\nAs you start to make purchases onboard the ship they’ll show up here")
                    .font(.vvSmall)
                    .foregroundColor(.slateGray)
                    .multilineTextAlignment(.center)
                    .lineSpacing(Spacing.space8)
            }
            .frame(maxWidth: .infinity)
            .padding(60)
    }
    
    private func transactionView() -> some View {
        VStack(spacing: Spacing.space24) {
            if viewModel.shouldShowTransactionSortTabs {
                transactionSortTabs()
            }
            ForEach(viewModel.transactionItems, id: \.0) { (groupTitle, items) in
                VStack(spacing: 0) {
                    Text(groupTitle.uppercased())
                        .font(.vvCaptionBold)
                        .foregroundColor(.slateGray)
                        .kerning(1.2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, Spacing.space24)
                        .padding(.vertical, Spacing.space8)
                        .background(Color.softGray)
                    
                    ForEach(items, id: \.self) { transaction in
                        FolioTransactionRow(
                            name: transaction.name,
                            iconURL: transaction.iconUrl,
                            profileImageURL: transaction.profileImageUrl,
                            price: transaction.price,
                            onTap: {
                                viewModel.onTransactionClick(transaction: transaction)
                            }
                        )
                        if transaction != items.last {
                            Divider()
                                .foregroundStyle(Color.borderGray)
                                .padding(.horizontal, Spacing.space24)
                        }
                    }
                }
            }
        }
        .padding(.top, Spacing.space24)
    }

    
    private func transactionSortTabs() -> some View {
        HStack(spacing: .zero) {
            Button(action: { viewModel.selectedTab = .date }) {
                VStack {
                    Text("Sort by Date")
                        .font(.vvSmallMedium)
                        .foregroundColor(viewModel.selectedTab == .date ? .vvRed : .slateGray)
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(viewModel.selectedTab == .date ? .vvRed : .clear)
                        .padding(.top, 2)
                }
            }

            Button(action: { viewModel.selectedTab = .sailor }) {
                VStack {
                    Text("Sort by Sailor")
                        .font(.vvSmallMedium)
                        .foregroundColor(viewModel.selectedTab == .sailor ? .vvRed : .slateGray)
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(viewModel.selectedTab == .sailor ? .vvRed : .clear)
                        .padding(.top, 2)
                }
            }
        }
        .padding(.horizontal, 52)
    }
    
    private func toolbar() -> some View {
        HStack(alignment: .top) {
            Spacer()

            LoadingButton(progressTint: .white, loading: viewModel.isDownloadingInvoice, image: "Download") {
                viewModel.onDownloadClick()
            }
            .frame(width: Spacing.space16, height: Spacing.space16)
            .padding(.horizontal, Spacing.space10)
            .padding(.vertical, Spacing.space8)
        }
        .padding(.top, Spacing.space48)
        .padding(.trailing, Spacing.space16)
    }
    
    @ViewBuilder
    private func infoSheet() -> some View {
        if let content = viewModel.folioInfoContent {
            FolioDrawerInfoSheet(
                title: content.title,
                description: content.description,
                close: { viewModel.onCloseFolioInfoSheet() }
            )
        }
    }
}

final class FolioShipboardViewPreviewViewModel: FolioShipboardViewModelProtocol {
    
    var selectedTransaction: FolioTransaction?
    var shouldShowFolioDrawerInfoSheet: Bool = false
    var folioInfoContent: FolioInfoContent? = nil
    var cardHeader: String? = "Amount"
    var cardSubHeader: String? = "Due"
    var cardOnFileText: String = "Your card on file"
    var cardExplainerText: String = "Payments and refunds explained"
    var barCardExplainerText: String = "Bar Tab explained" 
    var accountBalance: String = "$50.00"
    var barTabBalance: String? = "$30.00"
    var items: [FolioCardItem] = [FolioCardItem(name: "$300 Bar Tab", price: FolioPrice(integerPart: "5", decimalPart: "10"))]
    var sailorLootTitle: String?
    var sailorLootDescription: String?
    var transactionItems: [(String, [FolioTransaction])] = []
    var selectedTab: FolioSortType = .date
    var shouldShowTransactionSortTabs: Bool = false
    var cardNumber: String = "1234"
    var cardIconURL: String = ""
    var invoiceData: Data? = Data()
    var isDownloadingInvoice: Bool = false
    var isShowPdfViewer: Bool = false
    var sailorName: String = ""
    
    func onDownloadClick() {}
    func onCloseFolioInfoSheet() {}
    func onInfoAccountClick() {}
    func onInfoBarTabClick() {}
    func onTransactionClick(transaction: FolioTransaction) {}
    func onCloseTransaction() {}

    
}

#Preview {
    FolioShipboardView(viewModel: FolioShipboardViewPreviewViewModel())
}

