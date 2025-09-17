//
//  GetPaymentMethodTask.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 5/17/23.
//

import Foundation

extension Endpoint {
	struct GetPaymentMethodTask: Requestable {
		typealias RequestType = NoRequest
		typealias QueryType = Query
		typealias ResponseType = Response
		var authenticationType: AuthenticationType = .user
		var path = "/rts-bff/paymentmethod"
		var method: Method = .get
		var cachePolicy: CachePolicy = .always
		var scope: RequestScope = .shoresideOnly
		var pathComponent: String?
		var request: NoRequest?
		var query: Query?
		
		init(reservation: VoyageReservation) {
			let sailor = reservation.assistingSailor ?? reservation.primarySailor
			query = .init(guestId: sailor.reservationGuestId, reservationId: sailor.reservationId)
		}
		
		// MARK: Query Data
		
		struct Query: Encodable {
			var guestId: String // 57f041d7-9b26-428c-860f-f6163b87264
			var reservationId: String // 685850
			
			private enum CodingKeys: String, CodingKey {
				case guestId = "reservation-guest-id"
				case reservationId = "reservation-id"
			}
		}
		
		struct Response: Decodable {
			var labels: [String : String] // Labels
			var buttons: Buttons
			var cashDepositPages: CashDepositPages
			var updateURL: String // ""
			var dependentsSection: DependentsSection
			var creditCardPages: CreditCardPages
			var paymentMethodSelectionPages: PaymentMethodSelectionPages
			var paymentModes: [String] // ["9ef030f9-e5c1-e611-80c5-00155df80332", "02ee248e-e3d5-4242-8c99-94a51608a63d"]
			var paymentDetails: PaymentDetails
			var someoneElsePages: SomeoneElsePages
			
			struct Labels: Decodable {
				var expiry: String // "Exp. date"
				var cardNumber: String // "Card number"
				var zip: String // "Zip"
				var cvv: String // "CVV"
				var name: String // "Name on card"
			}
			
			struct Buttons: Decodable {
				var edit: String // "Edit"
			}
			
			struct CashDepositPages: Decodable {
				var reviewPage: ReviewPage
				var introPage: IntroPage
				
				struct ReviewPage: Decodable {
					var confirmationQuestion: String // "All good?"
					var imageURL: String // ""
					var title: String // "Cash deposit"
					var description: String // ""
				}
				
				struct IntroPage: Decodable {
					var title: String // "Pay using cash"
					var description: String // ""
				}
			}
			
			struct DependentsSection: Decodable {
				var completedPaymentDependentDescription: String // "These Sailors have already set up their payment method. You can overwrite them, but you should *probably* check with them first. But hey, your call."
				var dependentTitle: String // "Footing someone’s bill?"
				var pendingPaymentDependentDescription: String // "That's really kind of you. Just be aware — you'll be responsible for whoever you add and everything they do (financially, of course)."
			}
			
			struct CreditCardPages: Decodable {
				var existingCardModal: ExistingCardModal
				var deleteCardModal: DeleteCardModal
				
				struct ExistingCardModal: Decodable {
					var confirmationQuestion: String // "Use this card?"
					var title: String // "Quick question..."
					var description: String // "Looks like you already have a card on file."
				}
				
				struct DeleteCardModal: Decodable {
					var title: String // "Delete Payment card?"
					var description: String // "Are you sure? You'll need to select another onboard payment method."
				}
			}
			
			struct PaymentMethodSelectionPages: Decodable {
				var paymentInfoModal: PaymentInfoModal
				var question: String // "How would you like to pay on board?",
				var imageURL: String // "https:\/\/cdn.speedsize.com\/eb8d0010-7300-4129-8a6d-74bc221f9caf\/https:\/\/www.virginvoyages.com\/.imaging\/desktop\/dam\/23184903-9a4c-4552-a72e-ee6ba2be017f\/Sailor-App\/background\/payment.jpg"
				
				struct PaymentInfoModal: Decodable {
					var okayMessageText: String // "Okay, I got it"
					var imageURL: String // ""
					var title: String // "Onboard payment"
					var description: String // "Scarlet Lady is a cashless vessel which means you pay for everything with The Band. We need to either hold a credit card for you or collect a cash deposit for you to use The Band."
				}
			}
			
			struct PaymentDetails: Decodable {
				var partyMembers: [PartyMember]
				var selectedPaymentMethodCode: String // ""
				var cardDetails: [CreditCard]
				
				struct PartyMember: Codable {
					var reservationGuestId: String // "12345"
					var name: String // "Guest"
					var imageURL: String // "https://dev.virginvoyages.com/svc/multimediastorage-service/mediaitems/c43f78ff-9969-4fb3-8585-cfc6edb404c0"
					var genderCode: String // "M"
					var isPaymentMethodAlreadySet: Bool // true
					var isDependent: Bool // true
					var selectedPaymentMethodCode: String // "f8205196-993b-11e7-adc9-0a1a4261e962"
				}
				
				struct CreditCard: Codable {
					var cardMaskedNo: String
					var cardType: String
					var cardExpiryMonth: String
					var cardExpiryYear: String
					var paymentToken: String
					var name: String 
					var zipcode: String?
				}
			}
			
			struct SomeoneElsePages: Decodable {
				var reviewPage: ReviewPage
				var introPage: IntroPage
				
				struct ReviewPage: Decodable {
					var confirmationQuestion: String // "Happy with this?"
					var imageURL: String // ""
					var title: String // "Someone else footing the bill?"
					var description: String // "{Name}’s going to cover your expenses on board, you lucky thing."
				}
				
				struct IntroPage: Decodable {
					var title: String // "Someone else footing the bill?"
					var description: String // "Traveling with someone else and would prefer use one payment method? No problem — they just need to confirm you on their account and you'll be good to go."
				}
			}
		}
	}
}
