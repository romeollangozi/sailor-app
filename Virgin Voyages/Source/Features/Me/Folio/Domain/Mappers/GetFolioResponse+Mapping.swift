//
//  GetFolio+Mapping.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 14.5.25.
//

import Foundation

extension GetFolioResponse {
    func toDomain() -> Folio {
        Folio(
            preCruise: mapPreCruise(preCruise),
            shipboard: mapShipboard(shipboard)
        )
    }

    private func mapPreCruise(_ model: PreCruise?) -> Folio.PreCruise? {
        guard let model = model else { return nil }
        return .init(
            imageUrl: model.imageUrl.value,
            header: model.header.value,
            subheader: model.subHeader.value,
            body: model.body.value
        )
    }

    private func mapShipboard(_ model: Shipboard?) -> Folio.Shipboard? {
        guard let model = model else { return nil }
        
        let dependent = model.dependent.map {
            Folio.Shipboard.Dependent(
                   imageUrl: $0.imageUrl.value,
                   name: $0.name.value,
                   status: $0.status.value,
                   description: $0.description.value,
                   instructions: $0.instructions.value
               )
           }

        var wallet: Folio.Shipboard.Wallet? = nil
         if let walletModel = model.wallet,
            let headerModel = walletModel.header {

             let header = Folio.Shipboard.Wallet.Header(
                 account: mapAccountInfo(headerModel.account),
                 barTabRemaining: mapBarTabRemaining(headerModel.barTabRemaining)
             )

             wallet = Folio.Shipboard.Wallet(
                 header: header,
                 sailorLoot: mapSailorLoot(walletModel.sailorLoot),
                 transactions: mapTransactions(walletModel.transactions)
             )
         }

         return Folio.Shipboard(
             dependent: dependent,
             wallet: wallet
         )
    }

    private func mapBarTabRemaining(_ model: Shipboard.Wallet.WalletHeader.BarTabRemaining?) -> Folio.Shipboard.Wallet.Header.BarTabRemaining? {
        guard let model = model else { return nil }
        let items = model.items?.map {
            Folio.Shipboard.Wallet.Header.BarTabRemaining.Item(
                name: $0.name.value,
                amount: $0.amount.value,
                dependentSailor: mapSailor($0.dependentSailor)
            )
        } ?? []
        return .init(
            totalAmount: model.totalAmount.value,
            items: items
        )
    }
    
    private func mapAccountInfo(_ model: Shipboard.Wallet.WalletHeader.AccountInfo?) -> Folio.Shipboard.Wallet.Header.AccountInfo? {
        guard let model = model else { return nil }
        return .init(
            amount: model.amount.value,
            isAmountCredit: model.isAmountCredit.value,
            cardIconURL: model.cardIconUrl.value,
            cardNumber: model.cardNumber.value
        )
    }

    private func mapSailorLoot(_ model: Shipboard.Wallet.SailorLoot?) -> Folio.Shipboard.Wallet.SailorLoot? {
        guard let model = model else { return nil }
        return .init(
            title: model.title.value,
            description: model.description.value
        )
    }

    private func mapTransactions(_ models: [Shipboard.Wallet.Transaction]?) -> [Folio.Shipboard.Wallet.Transaction] {
        guard let models = models else { return [] }
        return models.map {
            Folio.Shipboard.Wallet.Transaction(
                iconUrl: $0.iconUrl.value,
                name: $0.name.value,
                date: Date.fromISOString(string: $0.dateTime.value),
                itemDescription: $0.itemDescription.value,
                itemQuantity: $0.itemQuantity.value,
                type: Folio.Shipboard.Wallet.TransactionType(rawValue: $0.type.value) ?? .pos,
                amount: $0.amount.value,
                subTotal: $0.subTotal.value,
                tax: $0.tax.value,
                total: $0.total.value,
                receiptNr: $0.receiptNr.value,
                receiptImageUrl: $0.receiptImageUrl,
                dependentSailor: mapSailor($0.dependentSailor)
            )
        }
    }

    private func mapSailor(_ model: Shipboard.Wallet.TransactionSailor?) -> Folio.Shipboard.Wallet.Sailor? {
        guard let model = model else { return nil }
        return .init(
            reservationGuestId: model.reservationGuestId.value,
            name: model.name.value,
            profileImageUrl: model.profileImageUrl.value
        )
    }
}
