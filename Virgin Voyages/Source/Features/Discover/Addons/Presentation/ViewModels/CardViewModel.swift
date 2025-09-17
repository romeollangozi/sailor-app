//
//  CardViewModel.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 11/7/24.
//

import UIKit

enum CardIssuer {
	case americanExpress
	case dinersClub
	case discoverCard
	case mastercard
	case visa

	var name: String? {
		switch self {
		case .americanExpress:
			return "American Express"
		case .dinersClub:
			return "Diners Club"
		case .discoverCard:
			return "Discover"
		case .mastercard:
			return "Mastercard"
		case .visa:
			return "VISA"
		}
	}

	var image: UIImage? {
		switch self {
		case .americanExpress:
			return UIImage(imageLiteralResourceName: "amex")
		case .dinersClub:
			return UIImage(imageLiteralResourceName: "diners_club")
		case .discoverCard:
			return UIImage(imageLiteralResourceName: "discover")
		case .mastercard:
			return UIImage(imageLiteralResourceName: "mastercard")
		case .visa:
			return UIImage(imageLiteralResourceName: "visa")
		}
	}
}

struct CardViewModel {

	let cardMaskedNo: String?
	private let cardType: String?
	let cardExpiryMonth: String?
	let cardExpiryYear: String?
	let paymentToken: String?
	let name: String?
	let zipcode: String?

	var cardIssuer: CardIssuer? {
		switch cardType {
		case "003":
			return .americanExpress
		case "005":
			return .dinersClub
		case "004":
			return .discoverCard
		case "002":
			return .mastercard
		case "001":
			return .visa
		default:
			return nil
		}
	}

	init(cardMaskedNo: String? = nil,
		 cardType: String? = nil,
		 cardExpiryMonth: String? = nil,
		 cardExpiryYear: String? = nil,
		 paymentToken: String? = nil,
		 name: String? = nil,
		 zipcode: String? = nil) {
		self.cardMaskedNo = cardMaskedNo
		self.cardType = cardType
		self.cardExpiryMonth = cardExpiryMonth
		self.cardExpiryYear = cardExpiryYear
		self.paymentToken = paymentToken
		self.name = name
		self.zipcode = zipcode
	}
}
