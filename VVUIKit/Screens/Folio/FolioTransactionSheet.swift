//
//  FolioTransactionSheet.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 8.7.25.
//

import SwiftUI

struct NonPosReceipt {
    let itemDescription: String
    let type: TransactionType
    let amount: String
    let subTotal: String
    let tax: String
    let total: String
    let folioResources: FolioStringResources
}

struct FolioTransactionSheet: View {
    let name: String
    let dateTime: String
    let iconURL: String
    let receiptURL: URL?
    let nonPosReceipt: NonPosReceipt?
    let close: () -> Void

    init(name: String, dateTime: String, iconURL: String, receiptURL: URL? = nil, nonPosReceipt: NonPosReceipt?, close: @escaping () -> Void) {
        self.name = name
        self.dateTime = dateTime
        self.iconURL = iconURL
        self.receiptURL = receiptURL
        self.nonPosReceipt = nonPosReceipt
        self.close = close
    }

    var body: some View {
        VStack(spacing: 0) {
            AdaptiveMultiTicketLabel(spacing: Spacing.space8, backgroundColor: Color.black.opacity(0.7), hasLabel: false) {
                toolbar()
                headerContent()
                
            } label: {}
            footer: {
                if receiptURL != nil {
                    posReceiptFooter()
                } else {
                    nonPosReceiptFooter()
                }
            }
        }
        .padding(.vertical, receiptURL != nil ? 0 : Spacing.space64)
        .padding(Spacing.space24)
        .background(Color.black.opacity(0.7))
    }

    func toolbar() -> some View {
        Toolbar(buttonStyle: .closeButton) {
            close()
        }
    }

    private func headerContent() -> some View {
        VStack(alignment: .leading, spacing: Spacing.space24) {
            if !iconURL.isEmpty {
                ImageViewer(url: iconURL, width: Spacing.space40, height: Spacing.space40)
            }
            VStack(spacing: Spacing.space4) {
                Text(name)
                    .font(.vvHeading3Bold)
                    .foregroundColor(Color.blackText)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(dateTime)
                    .font(.vvSmall)
                    .foregroundColor(Color.blackText)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

        }
        .padding(.horizontal, Spacing.space24)
        .padding(.bottom, Spacing.space24)
    }
    
    private func posReceiptFooter() -> some View {
        VStack {
            ProgressImage(url: receiptURL)
                .aspectRatio(contentMode: .fit)
        }
        .padding(Spacing.space24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func nonPosReceiptFooter() -> some View {
        VStack {
            if let nonPosReceipt {
                ReceiptPriceView(price: nonPosReceipt.amount, type: nonPosReceipt.type, description: nonPosReceipt.itemDescription)
                    .padding(.top, Spacing.space40)
                    .padding(.bottom, Spacing.space24)
                Divider()
                VStack(spacing: Spacing.space16) {
                    ReceiptPriceView(price: nonPosReceipt.subTotal, type: nonPosReceipt.type, description: nonPosReceipt.folioResources.globalGlobalShortStringsSubtotal ?? "Subtotal")

                    ReceiptPriceView(price: nonPosReceipt.tax, type: nonPosReceipt.type, description: nonPosReceipt.folioResources.shipEatsTaxText?.uppercased() ?? "TAX")
                }
                .padding(.top, Spacing.space40)

                Spacer()
                HStack {
                    Text(nonPosReceipt.folioResources.walletFolioTotalText?.uppercased() ?? "TOTAL")
                        .font(.vvSmallBold)
                        .kerning(1)
                    Spacer()
                    Text(nonPosReceipt.total)
                        .font(.vvHeading4Bold)
                }
                .padding()
                .frame(height: 74)
                .foregroundStyle(.white)
                .background(Color.deepPurple)

            }
        }
        .padding(.horizontal, Spacing.space24)
        .padding(.bottom, Spacing.space24)
    }
}

#Preview {
    FolioTransactionSheet(name: "Title", dateTime: "June 06 - 2:00pm", iconURL: "", nonPosReceipt: nil, close: {})
}
