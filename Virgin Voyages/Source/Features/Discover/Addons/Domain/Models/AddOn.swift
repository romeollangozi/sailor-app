//
//  AddOn.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 29.9.24.
//

import Foundation


// MARK: - Addon states
enum AddonState {
    case regular
    case closed
    case purchased
    case soldOut
}

enum AddOnSellType: String {
	case perSailor
	case perCabin

	init?(rawValue: String) {
        switch rawValue {
        case "perSailor":
            self = .perSailor
        case "perCabin":
            self = .perCabin
        default:
            return nil
        }
	}
}

struct AddOn {
    // MARK: - Properties
	let id: UUID = UUID()
    let shortDescription: String?
    let name: String?
    let subtitle: String?
    let amount: Double?
    let bonusAmount: Double?
    let addonCategory: String?
    let needToKnows: [String]
    let code: String?
    let bonusDescription: String?
    let longDescription: String?
    let imageURL: String?
    let detailReceiptDescription: String?
    let currencyCode: String?
    let isCancellable: Bool
    let isPurchased: Bool
	let sellType: AddOnSellType
	let isPerSailorPurchase: Bool?
    let isBookingEnabled: Bool
    let guests: [String]
    let isActionButtonsDisplay: Bool
    let isSoldOut: Bool
    let isSoldOutText: String?
    let isPurchasedText: String?
    let closedText: String?
    let explainer: String?
    let eligibleGuestIds: [String]
	let totalAmount: Double
	let guestRefNumbers: [Int]

	var priceFormatted: String? {
		if let currencyCode = currencyCode, let amount = amount {
			return "\(currencyCode.currencySign) \(amount.toCurrency())"
		}
		return nil
	}

    // MARK: - Init
    init(shortDescription: String? = nil,
         name: String? = nil,
         subtitle: String? = nil,
         amount: Double? = nil,
         bonusAmount: Double? = nil,
         addonCategory: String? = nil,
         code: String? = nil,
         bonusDescription: String? = nil,
         longDescription: String? = nil,
         imageURL: String? = nil,
         detailReceiptDescription: String? = nil,
         currencyCode: String? = nil,
         isCancellable: Bool = false,
         isPurchased: Bool = false,
		 sellType: AddOnSellType = .perSailor,
		 isPerSailorPurchase: Bool? = false,
         isBookingEnabled: Bool = false,
         isActionButtonsDisplay: Bool = false,
         isSoldOut: Bool = false,
         isSoldOutText: String?  = nil,
         isPurchasedText: String? = nil,
         closedText: String? = nil,
         needToKnows: [String] = [],
         explainer: String? = nil,
         eligibleGuestIds: [String] = [],
         guests: [String] = [],
		 totalAmount: Double = 0.0,
		 guestRefNumbers: [Int] = []) {
        self.shortDescription = shortDescription
        self.name = name
        self.subtitle = subtitle
        self.amount = amount
        self.bonusAmount = bonusAmount
        self.addonCategory = addonCategory
        self.code = code
        self.bonusDescription = bonusDescription
        self.longDescription = longDescription
        self.imageURL = imageURL
        self.detailReceiptDescription = detailReceiptDescription
        self.currencyCode = currencyCode
        self.isCancellable = isCancellable
        self.isPurchased = isPurchased
		self.sellType = sellType
		self.isPerSailorPurchase = isPerSailorPurchase
        self.isBookingEnabled = isBookingEnabled
        self.isActionButtonsDisplay = isActionButtonsDisplay
        self.isSoldOut = isSoldOut
        self.isSoldOutText = isSoldOutText
        self.isPurchasedText = isPurchasedText
        self.closedText = closedText
        self.needToKnows = needToKnows
        self.explainer = explainer
        self.guests = guests
        self.eligibleGuestIds = eligibleGuestIds
		self.totalAmount = totalAmount
		self.guestRefNumbers = guestRefNumbers
    }
    

}

extension AddOn {
	static let sample = AddOn(
		shortDescription: "Relax and unwind",
		name: "Thermal Spa Experience",
		subtitle: "Includes massage and steam room",
		amount: 49.99,
		bonusAmount: 10.0,
		addonCategory: "Wellness",
		code: "SPA001",
		bonusDescription: "Free foot massage included",
		longDescription: "Enjoy a rejuvenating experience with full access to the spa, including sauna, steam room, and hydrotherapy pools.",
		imageURL: "https://example.com/spa.jpg",
		detailReceiptDescription: "Spa package with bonus",
		currencyCode: "USD",
		isCancellable: true,
		isPurchased: false,
		sellType: .perSailor,
		isPerSailorPurchase: false,
		isBookingEnabled: true,
		isActionButtonsDisplay: true,
		isSoldOut: false,
		isSoldOutText: nil,
		isPurchasedText: nil,
		closedText: nil,
		needToKnows: ["Bring swimsuit", "Arrive 15 minutes early"],
		explainer: "Perfect way to relax during your trip.",
		eligibleGuestIds: ["guest_001", "guest_002"],
		guests: ["John Doe", "Jane Smith"]
	)
}

extension AddOn {
    // MARK: - Formatted price with currency code
    var price: String? {
        if let currencyCode, let amount {
            return "\(currencyCode.currencySign) \(amount.toCurrency())"
        }
        return nil
    }
    
    // MARK: - Image URL
    var image: URL? {
        guard let urlString = imageURL else { return nil }
        return URL(string: urlString)
    }

	// MARK: - Addon state
	var addOnState: AddonState {
		if isSoldOut == true { return .soldOut }
		if isPurchased == true && isSoldOut == false { return .purchased }
		switch(isBookingEnabled, isSoldOut) {
		case (true, true):
			return .soldOut
		case (true, false):
			return .regular
		case (false, true):
			return .soldOut
		case (false, false):
			return .closed
		}
	}

    var isPurchaseButtonDisabled: Bool {
        return isBookingEnabled ? false : true
    }
    
    var purchaseButtonTitle: String {
        return isPurchaseButtonDisabled ? "Purchase Window Closed" : "Purchase"
    }
    
    var needToKnow: String {
        return needToKnows.joined(separator: "\n")
    }

}

extension AddOn: Hashable {
    
    // MARK: - Hashable Protocol Methods
    static func == (lhs: AddOn, rhs: AddOn) -> Bool {
        return lhs.code == rhs.code
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(code)
    }
}

