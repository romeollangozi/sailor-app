//
//  GetEmbarkationSlotTask.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 5/20/24.
//

import Foundation

extension Endpoint {
	struct GetEmbarkationSlotTask: Requestable {
		typealias RequestType = NoRequest
		typealias QueryType = Query
		typealias ResponseType = Response
		var authenticationType: AuthenticationType = .user
		var path = "/rts-bff/embarkationslot"
		var method: Method = .get
		var cachePolicy: CachePolicy = .always
		var scope: RequestScope = .shoresideOnly
		var pathComponent: String?
		var request: NoRequest?
		var query: Query?
		
		init(reservation: VoyageReservation) {
			let sailor = reservation.assistingSailor ?? reservation.primarySailor
			query = .init(reservationId: sailor.reservationId, guestId: sailor.reservationGuestId)
		}
		
		struct Query: Encodable {
			var reservationId: String // a45c3a44-7d3a-41ac-809a-da3db915c350
			var guestId: String // fe777d31-5993-4803-896b-07789fac5a74
			
			private enum CodingKeys: String, CodingKey {
				case reservationId = "reservation-id"
				case guestId = "reservation-guest-id"
			}
		}
		
		struct Response: Decodable {
			var requiredFields: [String]
			var hiddenFields: [String]
			var readonlyFields: [String]
			var optionalFields: [String]
			var pageDetails: PageDetails
			var flightDetails: FlightDetails?
			var updateURL: String // "https://cert.gcpshore.virginvoyages.com/rts-bff/embarkationslot?reservation-guest-id=5e1d120e-b98c-4dad-8c38-c54e05ce540e&reservation-id=51cbe16d-e229-4ba0-8805-fc5731f9ba0c"
			var flightSearchURL: String // "https://cert.gcpshore.virginvoyages.com/rts-bff/flight/search?flight-number=&airline-code="
			var flightUpdateURL: String // "https://cert.gcpshore.virginvoyages.com/rts-bff/flight?reservation-guest-id=5e1d120e-b98c-4dad-8c38-c54e05ce540e&reservation-id=51cbe16d-e229-4ba0-8805-fc5731f9ba0c"
			var isVip: Bool // false
			var isVIPGuest: Bool // false
			var selectedSlotInfo: SelectedSlotInfo?
			var availableSlots: [Slot]?
			var vipArrivalTimeSlots: [String]?
			var partyMembers: [PartyMember]
			var slotStartTime: String? // "1:30pm"
			var slotEndTime: String? // "5:30pm"
			var sailorServicesEmailId: String // "redgloveservice@virginvoyages.com"
			var postCruiseInfo: PostCruiseInfo?
			var isCarBookingRequired: Bool // false
			var isPriorityBoardingGuest: Bool // false
			var isRockStarBoardingGuest: Bool // false
			var isFlyingIn: Bool? // true
			var isParkingOpted: Bool?
			
			struct FlightDetails: Decodable {
				var sequence: Int? // 0
				var number: String? // "3456"
				var arrivalTime: String? // "06:30:00"
				var airlineCode: String? // "AA"
				var isOpted: Bool? // true
			}
			
			struct SelectedSlotInfo: Decodable {
				var number: Int? // 2
				var time: String // "11:30:00"
			}
			
			struct PostCruiseInfo: Decodable {
				var showAsPrePopulatedFlight: Bool // false
				var isFlyingOut: Bool? // true
				var flightDetails: FlightDetails?
				var partyMembers: [PartyMember]
				
				struct PartyMember: Decodable {
					var reservationGuestId: String // "bd8d0d1b-a05b-42dc-be25-d67148b80520"
					var photoURL: String // "bd8d0d1b-a05b-42dc-be25-d67148b80520"
					var name: String // "Jane Jacb"
                    var isPostCruiseInfoAvailable: Bool?
				}
			}

			struct PageDetails: Decodable {
				var labels: Labels
				var buttons: Buttons
				var flightDetailsPage: FlightDetailsPage
				var flightPage: FlightPage
				var flightSearchSuccessPage: FlightSearchSuccessPage
				var flightSearchFailurePage: FlightSearchFailurePage
				var changeArrivalMethodPage: ChangeArrivalMethodPage
				var vipFlowContent: VIPFlowContent
				var nonVipFlowContent: NonVIPFlowContent
				var postVoyagePlansContent: PostVoyagePlansContent
				var carServiceContent: CarServiceContent
				var boardingWindowContent: BoardingWindowContent
			}

			struct Labels: Decodable {
				var parking: String // "Parking"
				var departureTime: String // "departure time"
				var flight: String // "Flight"
				var confirmationQuestion: String // "All good?"
				var carrier: String // "Airline"
				var arrivalTime: String // "Arrival time"
				var location: String // "Location"
				var time: String // "Time"
				var airline: String // "Airline"
				var flightNumber: String // "Flight"
			}

			struct Buttons: Decodable {
				var no: String // "No"
				var reEnterFlightDetails: String // "Re-enter flight details"
				var edit: String // "Edit"
				var yes: String // "Yes"
				var pickUp: String // "Pick me up"
				var skip: String // "Skip"
				var callNow: String // "Call now"
				var call: String // "Call now"
				var search: String // "Search again"
				var later: String // "Email"
				var nativeMobilePopup: String // "Want your agent on the line to arrange a chauffeur?"
				var yesSameDay: String // "Yes, same day"
				var notNeeded: String // "Not needed"
				var email: String // "Email"
			}

			struct FlightDetailsPage: Decodable {
				var question: String // "Hey high-flyer, what flight are you on {date}?"
				var imageURL: String // "https://cert.gcpshore.virginvoyages.com/dam/jcr:4bcc45db-3b1b-4b52-85a9-6ff2ae501511/embark1.jpg"
				var description: String // "Please only add your flight details into Miami, not a connecting flight"
			}

			struct FlightPage: Decodable {
				var question: String // "Do you plan to fly in on the day of embarkation?"
				var imageURL: String // "https://cert.gcpshore.virginvoyages.com/dam/jcr:4bcc45db-3b1b-4b52-85a9-6ff2ae501511/embark1.jpg"
				var description: String // "We ask this so that we can offer you appropriate Terminal Arrival Time based on your flight arrival time"
			}

			struct FlightSearchSuccessPage: Decodable {
				var question: String // "Is this your flight?"
			}

			struct FlightSearchFailurePage: Decodable {
				var imageURL: String // "https://cert.gcpshore.virginvoyages.com/dam/jcr:5e1b154a-711a-4cdd-96d6-9fe314ad0a3e/illo-app-error-porthole-628x628.svg"
				var description: String // "<p>We can&rsquo;t seem to find your flight. Please double-check the info and try again.</p>\n"
				var title: String // "We searched the skies, but..."
			}

			struct ChangeArrivalMethodPage: Decodable {
				var question: String // "Change arrival method?"
				var imageURL: String // "https://cert.gcpshore.virginvoyages.com/dam/jcr:12b94d03-684b-42b1-a23b-a7011b35acf3/awkward@2x.png"
				var description: String // "If you change your arrival methods, you may not be able to select the same Terminal Arrival Time you have now."
				var title: String // "Change Arrival Method"
			}

			struct VIPFlowContent: Decodable {
				var airportPickupPage: AirportPickupPage
				var contactPage: ContactPage
				var arrivalTimeInputPage: ArrivalTimeInputPage
				var contactEmailContent: ContactEmailContent

				struct AirportPickupPage: Decodable {
					var header: String // "Arrive in style"
					var description: String // "<p>With RockStar status, you can arrive (fashionably) anytime between 1:30pm &amp; 5:30pm..."
					var bookDriverQuestion: String // "Would you like to book a driver?"
				}

				struct ContactPage: Decodable {
					var header: String // "Let’s talk"
					var description: String // "We can't wait to have you aboard. Get in touch now to arrange your chauffeur, or drop us an email if it’s not a good time."
				}

				struct ArrivalTimeInputPage: Decodable {
					var header: String // "Rock-up from 1:30pm & 5:30pm"
					var description: String // "With RockStar status, you can arrive (fashionably) anytime during embarkation..."
				}

				struct ContactEmailContent: Decodable {
					var subject: String // "Rhea witting Ship Arrival Plans, Reference # 543905"
					var body: String // "Ahoy RockStar Agent,\n\nHere are my details for arrival to the ship:..."
				}
			}

			struct NonVIPFlowContent: Decodable {
				var embarkSlotPage: EmbarkSlotPage
				var parkingOptPage: ParkingOptPage
				var partyMembersSlotExpand: PartyMembersSlotExpand
				var embarkationSlotReviewPage: EmbarkationSlotReviewPage

				struct EmbarkSlotPage: Decodable {
					var flyingInQuestion: String? // "When would you like to join us?"
					var header: String // "Arrival time"
					var notFlyingInQuestion: String? // "Embarkation generally begins at 2 pm, please pick your Terminal Arrival Time."
				}

				struct ParkingOptPage: Decodable {
					var bookDriverQuestion: String // "Would you like to book a driver?"
					var notEmbarkDayQuestion: String // "Are you parking at the Port?"
					var parkingBody: String // "We ask so we can keep track of your car and make sure you get back to it as seamlessly as possible."
					var onEmbarkDayQuestion: String // "Are you planning to park at the Port of Miami?"
				}

				struct PartyMembersSlotExpand: Decodable {
					var alreadySelectedSlotDescription: String // "These Sailors have already selected their Terminal Arrival Time..."
					var title: String // "Anyone else arriving with you"
				}

				struct EmbarkationSlotReviewPage: Decodable {
					var imageURL: String // "https://cert.gcpshore.virginvoyages.com/dam/jcr:0ba1b3cc-9388-4f22-b824-f65994e61159/embark-dogear.png"
					var title: String // "Step aboard"
				}
			}

			struct PostVoyagePlansContent: Decodable {
				var introPage: IntroPage
				var flightDetailsQuestion: String // "What are your flight details for Oct 6, 2024?"
				var flightSearchSuccessPage: FlightSearchSuccessPage
				var inAndOutBoundReviewPage: InAndOutBoundReviewPage
				var partyMembersPostCruiseExpand: PartyMembersPostCruiseExpand

				struct IntroPage: Decodable {
					var description: String // "Are you planning to fly anywhere on debarkation day?..."
					var flyingOutQuestion: String // "Do you plan to fly out on debarkation day?"
					var title: String // "One last thing"
				}

				struct InAndOutBoundReviewPage: Decodable {
					var outBoundTitle: String // "Outbound"
					var inBoundTitle: String // "Inbound"
					var emptyOutboundInfo: String // "Please let us know your outbound flight details if applicable"
					var title: String // "Step aboard"
				}

				struct PartyMembersPostCruiseExpand: Decodable {
					var existingInfoDescription: String // "These Sailors have already selected their Terminal Arrival Time..."
					var subtitle: String // "We will make sure any arrangements made in the event of a delay works for all of you"
					var title: String // "Anyone else leaving with you?"
				}
			}

			struct CarServiceContent: Decodable {
				var contact: String // "We can't wait to have you aboard. Call us to arrange your complimentary chauffeur..."
				var pickup: String // "With Mega RockStar status, you can arrive (fashionably) anytime between 12:30pm & 5:00pm..."
			}

			struct BoardingWindowContent: Decodable {
				var priorityBoarding: PriorityBoarding
				var vipBoarding: PriorityBoarding
				var terminalArrivalTime: String // "Terminal arrival time"
				var arrivalTime: String // "Arrival time"
				var arrivalStyle: ArrivalStyle

				struct PriorityBoarding: Decodable {
					var header: String // "Priority boarding"
					var description: String // "You get to turn up when you like, early boarding from 1:45pm till last boarding at {TIME}."
				}
				
				struct ArrivalStyle: Decodable {
					var header: String // "Arrive in Style"
					var description: String // ""
					var buttons: Buttons
					
					struct Buttons: Decodable {
						var no: String // "No car needed"
						var yes: String // "Yes I want a car"
						var skip: String // "Skip for now"
					}
				}
			}

			struct Slot: Decodable {
				var time: String // "13:30:00"
				var number: Int? // 25
				var optedByReservationGuestIds: [String]
			}

			struct PartyMember: Decodable {
				var reservationGuestId: String // "c01f3c77-a072-40d6-a463-3c924d11f6ae"
				var name: String // "Tisha lubowitzsec"
				var photoURL: String
				var genderCode: String // "F"
				var isSlotSelected: Bool // false
				var isSameSlotSelected: Bool // false
			}
		}
	}
}
