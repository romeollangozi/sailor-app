//
//  Folio.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 14.5.25.
//

import Foundation

struct Folio: Equatable, Hashable {
    let preCruise: PreCruise?
    let shipboard: Shipboard?

    struct PreCruise: Equatable, Hashable {
        let imageUrl: String
        let header: String
        let subheader: String
        let body: String
    }

    struct Shipboard: Equatable, Hashable {
        let dependent: Dependent?
        let wallet: Wallet?

        struct Dependent: Equatable, Hashable {
            let imageUrl: String
            let name: String
            let status: String
            let description: String
            let instructions: String
        }

        struct Wallet: Equatable, Hashable {
            let header: Header?
            let sailorLoot: SailorLoot?
            let transactions: [Transaction]

            struct Header: Equatable, Hashable {
                let account: AccountInfo?
                let barTabRemaining: BarTabRemaining?
                
                struct AccountInfo: Equatable, Hashable {
                    let amount: String
                    let isAmountCredit: Bool
                    let cardIconURL: String
                    let cardNumber: String
                }

                struct BarTabRemaining: Equatable, Hashable {
                    let totalAmount: String
                    let items: [Item]

                    struct Item: Equatable, Hashable, Identifiable {
                        let id = UUID()
                        let name: String
                        let amount: String
                        let dependentSailor: Sailor?
                    }
                }
            }

            struct SailorLoot: Equatable, Hashable {
                let title: String
                let description: String
            }

            struct Transaction: Equatable, Hashable {
                let iconUrl: String
                let name: String
                let date: Date
                let itemDescription: String
                let itemQuantity: Int
                let type: TransactionType
                let amount: String
                let subTotal: String
                let tax: String
                let total: String
                let receiptNr: Int
                let receiptImageUrl: String?
                let dependentSailor: Sailor?
            }

            struct Sailor: Equatable, Hashable {
                let reservationGuestId: String
                let name: String
                let profileImageUrl: String
            }
            
            enum TransactionType: String, Codable {
                case pos
                case refund
                case cash
                case sailorLoot
            }
        }
    }
}

extension Folio.Shipboard.Wallet {
    var groupedByDate: [(String, [Transaction])] {
        Dictionary(grouping: transactions, by: { $0.date.toMonthDDYYY() })
            .sorted { lhs, rhs in
                guard let lhsDate = lhs.value.first?.date,
                      let rhsDate = rhs.value.first?.date else {
                    return false
                }
                return lhsDate > rhsDate
            }
    }
}

extension Folio.Shipboard.Wallet.Header.BarTabRemaining {
    var sortedItems: [Item] {
        items.sorted { lhs, rhs in
            switch (lhs.dependentSailor, rhs.dependentSailor) {
            case (nil, nil):
                return lhs.name < rhs.name
            case (nil, _):
                return true
            case (_, nil):
                return false
            case let (lhsSailor?, rhsSailor?):
                if lhsSailor.name == rhsSailor.name {
                    return lhs.name < rhs.name
                } else {
                    return lhsSailor.name < rhsSailor.name
                }
            }
        }
    }
}


extension Folio.Shipboard {
    var accountDescriptionText: String {
        """
    At the end of your voyage any balance due on your account will be deducted from the credit card listed against your folio. 
    If you have refundable credit it will be paid back to the same credit card.
    Refundable credit includes:
    Any refunds of events and activities that were     purchased pre-voyage and cancelled shipboard
    Unused cash deposits
    Examples of non refundable credit
    Bar Tab
    Sailor Loot   
    """
    }
}

extension Folio {
    static func sample() -> Folio {
        Folio(
            preCruise: .init(
                imageUrl: "https:/cert.gcpshore.virginvoyages.com/dam/jcr:ae64597f-bce4-40b7-98eb-38e7182af638/ILLO-folio-wallet-464x464.png",
                header: "My Wallet",
                subheader: "Once you get onboard the ship, this is where you’ll see all your purchases.",
                body: """
                <p>You have already set up your payment method using cash. You can deposit cash at embarkation or during your voyage at sailor services<br />
                **** **** **** 1234<br />
                You can change your payment method in your check-in</p>
                """
            ),
            shipboard: .init(
                dependent: .init(
                    imageUrl: "https://example.com/dependant.jpg",
                    name: "Liam Doe",
                    status: "Approved",
                    description: "All set to sail",
                    instructions: "Check-in at Deck 6"
                ),
                wallet: .init(
                    header: .init(
                        account: .init(
                            amount: "$200.00",
                            isAmountCredit: false,
                            cardIconURL: "https://example.com",
                            cardNumber: "**** **** **** 1234"
                        ),
                        barTabRemaining: .init(
                            totalAmount: "$50.00",
                            items: [
                                .init(
                                    name: "$50 Bar Tab Bonus",
                                    amount: "$30.00",
                                    dependentSailor: nil
                                ),
                                .init(
                                    name: "$300 Bar Tab",
                                    amount: "$20.00",
                                    dependentSailor: .init(
                                        reservationGuestId: "RG001",
                                        name: "Frankie Makie",
                                        profileImageUrl: "https://example.com/profiles/frankie.jpg"
                                    )
                                )
                            ]
                        )
                    ),
                    sailorLoot: .init(
                        title: "SAILOR LOOT: Pending",
                        description: "Enjoy your $100 onboard credit!"
                    ),
                    transactions: [
                        .init(
                            iconUrl: "https://example.com/icon.png",
                            name: "Bar",
                            date: ISO8601DateFormatter().date(from: "2025-06-12T00:00") ?? Date(),
                            itemDescription: "All-Inclusive Beach Club Pass",
                            itemQuantity: 1,
                            type: .cash,
                            amount: "$120",
                            subTotal: "$120",
                            tax: "0",
                            total: "$120",
                            receiptNr: 1234,
                            receiptImageUrl: "https://example.com/receipt.png",
                            dependentSailor: .init(
                                reservationGuestId: "RG001",
                                name: "John Doe",
                                profileImageUrl: "https://example.com/profile.jpg"
                            )
                        )
                    ]
                )
            )
        )
    }
	
	static func sampleWithPrecruise() -> Folio {
		Folio(
			preCruise: .init(
				imageUrl: "https:/cert.gcpshore.virginvoyages.com/dam/jcr:ae64597f-bce4-40b7-98eb-38e7182af638/ILLO-folio-wallet-464x464.png",
				header: "My Wallet",
				subheader: "Once you get onboard the ship, this is where you’ll see all your purchases.",
				body: """
				<p>You have already set up your payment method using cash. You can deposit cash at embarkation or during your voyage at sailor services<br />
				**** **** **** 1234<br />
				You can change your payment method in your check-in</p>
				"""
			),
			shipboard: nil
		)
	}
    
    static func sampleWithShipboard() -> Folio {
        Folio(
            preCruise: nil,
            shipboard: .init(
                dependent: .init(
                    imageUrl: "https:/cert.gcpshore.virginvoyages.com/dam/jcr:ae64597f-bce4-40b7-98eb-38e7182af638/ILLO-folio-wallet-464x464.png",
                    name: "Liam Doe",
                    status: "Has it covered",
                    description: "Your folio has been set up so your purchases are being paid for by your sugar mommy or daddy.",
                    instructions: "To request a list of transactions please visit sailor services on deck 5 or refer to the folio of your generous mommy or daddy."
                ),
                wallet: .init(
                    header: .init(
                        account: .init(
                            amount: "$200.00",
                            isAmountCredit: false,
                            cardIconURL: "https://example.com",
                            cardNumber: "**** **** **** 1234"
                        ),
                        barTabRemaining: .init(
                            totalAmount: "$50.00",
                            items: [
                                .init(
                                    name: "$50 Bar Tab Bonus",
                                    amount: "$30.00",
                                    dependentSailor: nil
                                ),
                                .init(
                                    name: "$300 Bar Tab",
                                    amount: "$20.00",
                                    dependentSailor: .init(
                                        reservationGuestId: "RG001",
                                        name: "Frankie Makie",
                                        profileImageUrl: "https://cert.gcpshore.virginvoyages.com/dam/jcr:a6233f56-5316-4826-a5f8-533709598e56/IMG-FNB-razzle-dazzle-interior-bw-1200x1440.jpg"
                                    )
                                ),
                                .init(
                                    name: "$100 Bar Tab",
                                    amount: "$20.00",
                                    dependentSailor: .init(
                                        reservationGuestId: "RG001",
                                        name: "Frankie Makie",
                                        profileImageUrl: "https://cert.gcpshore.virginvoyages.com/dam/jcr:a6233f56-5316-4826-a5f8-533709598e56/IMG-FNB-razzle-dazzle-interior-bw-1200x1440.jpg"
                                    )
                                ),
                                .init(
                                    name: "$200 Bar Tab",
                                    amount: "$20.00",
                                    dependentSailor: .init(
                                        reservationGuestId: "RG002",
                                        name: "Crankie Makie",
                                        profileImageUrl: "https://cert.gcpshore.virginvoyages.com/dam/jcr:a6233f56-5316-4826-a5f8-533709598e56/IMG-FNB-razzle-dazzle-interior-bw-1200x1440.jpg"
                                    )
                                ),
                                .init(
                                    name: "$40 Bar Tab Bonus",
                                    amount: "$40.00",
                                    dependentSailor: nil
                                ),
                            ]
                        )
                    ),
                    sailorLoot: .init(
                        title: "SAILOR LOOT: Pending",
                        description: "Your Sailor Loot will appear here shortly after embarkation is complete. But feel free to get spending and any applicable purchases will be credited to your Loot once it appears."
                    ),
                    transactions: [
                        .init(
                            iconUrl: "https://cms-cert.ship.virginvoyages.com/dam/jcr:400f7433-8774-47c6-bfad-b5eb9b6b4891/ICN-spa-salon-32x32.svg",
                            name: "Spa Massage",
                            date: ISO8601DateFormatter().date(from: "2025-05-29T18:15:00Z") ?? Date(),
                            itemDescription: "60 min deep tissue massage",
                            itemQuantity: 1,
                            type: .cash,
                            amount: "$25.00",
                            subTotal: "$25.00",
                            tax: "$0.00",
                            total: "$25.00",
                            receiptNr: 1234,
                            receiptImageUrl: "https://example.com/receipt.png",
                            dependentSailor: .init(
                                reservationGuestId: "RG001",
                                name: "John Doe",
                                profileImageUrl: "https://cert.gcpshore.virginvoyages.com/dam/jcr:a6233f56-5316-4826-a5f8-533709598e56/IMG-FNB-razzle-dazzle-interior-bw-1200x1440.jpg"
                            )
                        ),
                        .init(
                            iconUrl: "https://cms-cert.ship.virginvoyages.com/dam/jcr:400f7433-8774-47c6-bfad-b5eb9b6b4891/ICN-spa-salon-32x32.svg",
                            name: "Razzle Dazzle Brunch",
                            date: ISO8601DateFormatter().date(from: "2025-05-30T18:15:00Z") ?? Date(),
                            itemDescription: "Brunch meal with drinks",
                            itemQuantity: 1,
                            type: .pos,
                            amount: "$25.00",
                            subTotal: "$25.00",
                            tax: "$0.00",
                            total: "$25.00",
                            receiptNr: 1234,
                            receiptImageUrl: "http://dxpcoreservices-blue/dxpcore/folio/receiptImage?receiptNumber=5143406",
                            dependentSailor: nil
                        ),
                        .init(
                            iconUrl: "https://cms-cert.ship.virginvoyages.com/dam/jcr:9bc5b773-7c7f-4d4d-b58c-218e7ad7083e/ICN-FNB-bar-32x32.svg",
                            name: "Bar",
                            date: ISO8601DateFormatter().date(from: "2025-05-29T18:16:00Z") ?? Date(),
                            itemDescription: "Refund for bar charge",
                            itemQuantity: 1,
                            type: .refund,
                            amount: "$25.00",
                            subTotal: "$25.00",
                            tax: "$0.00",
                            total: "$25.00",
                            receiptNr: 1234,
                            receiptImageUrl: "http://dxpcoreservices-blue/dxpcore/folio/receiptImage?receiptNumber=5139755",
                            dependentSailor: .init(
                                reservationGuestId: "RG001",
                                name: "John Doe",
                                profileImageUrl: "https://cert.gcpshore.virginvoyages.com/dam/jcr:a6233f56-5316-4826-a5f8-533709598e56/IMG-FNB-razzle-dazzle-interior-bw-1200x1440.jpg"
                            )
                        )
                    ]
                )
            )
        )
    }


    static func empty() -> Folio {
        Folio(
            preCruise: nil,
            shipboard: nil
        )
    }
    
    static func emptyShipboard() -> Folio.Shipboard {
        Folio.Shipboard(
            dependent: nil,
            wallet: nil
        )
    }
}
