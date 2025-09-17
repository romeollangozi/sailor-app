//
//  GetReadyToSail.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 5/11/23.
//

import Foundation

extension Endpoint {
	struct GetReadyToSail: Requestable {
		typealias RequestType = NoRequest
		typealias QueryType = Query
		typealias ResponseType = Response
		var authenticationType: AuthenticationType = .user
		var path = "/rts-bff/landing"
		var method: Method = .get
		var cachePolicy: CachePolicy = .always
		var scope: RequestScope = .shoresideOnly
		var pathComponent: String?
		var request: NoRequest?
		var query: Query?
		
		init(reservation: VoyageReservation) {
			let sailor = reservation.assistingSailor ?? reservation.primarySailor
			query = .init(guestId: sailor.id, reservationNumber: sailor.reservationNumber)
		}
		
		// MARK: Query Data
		
		struct Query: Encodable {
			var guestId: String // 57f041d7-9b26-428c-860f-f6163b87264
			var reservationNumber: String // 685850
			
			private enum CodingKeys: String, CodingKey {
				case guestId = "reservation-guest-id"
				case reservationNumber = "reservation-number"
			}
		}
		
		struct UpdateTask: Decodable {
			var tasksCompletionPercentage: TasksCompletionPercentage?
			var finalPage: FinalPage?
			var fieldErrors: FieldErrors?
			var enablePostCruiseTab: Bool? // true

			struct FinalPage: Decodable {
				var title: String // "Emergency contact"
				var caption: String // "COMPLETE"
				var imageURL: String // "https://dev.virginvoyages.com/svc/multimediastorage-service/mediaitems/c43f78ff-9969-4fb3-8585-cfc6edb404c0"
			}

			struct TasksCompletionPercentage: Decodable {
				var security: Double // 100
				var travelDocuments: Double // 100
				var paymentMethod: Double // 100
				var pregnancy: Double // 100
				var voyageContract: Double // 100
				var emergencyContact: Double // 100
				var embarkationSlotSelection: Double // 100
			}

			struct FieldErrors: Decodable {
				var fieldErrors: [FieldError]
				
				struct FieldError: Decodable {
					var field: String // "string"
					var errorMessage: String // "string"
				}
			}
		}
		
		struct Response: Decodable {
            struct TaskCompletionPercentage: Decodable, Equatable {
				var emergencyContact: Double // 0
				var voyageContract: Double // 0
				var pregnancy: Double // 0
				var travelDocuments: Double // 0
				var paymentMethod: Double // 0
				var embarkationSlotSelection: Double // 0
				var security: Double // 100
			}
			
			struct Task: Decodable, Hashable {
				var title: String // "Pregnancy"
				var caption: String // "Start"
				var detailsURL: String // ""
				var imageURL: String // ""
				var backgroundColorCode: String // "#f0cedf"
				var failedStateTextColorCode: String? // "#ff9400"
				var failedStateText: String? // "There's an issue with the document(s) you uploaded. Please review and re-upload."

				var detailsURLV1: String? // ""
				var documentOCRUrlV1: String? // ""
                var reasonRejectionText: String?
                var failedDocumentErrorText: String?
                var documentRejectionReasons: DocumentRejectionReasons?

                struct RejectionReasons: Decodable, Hashable {
                    var rejectionReasonId: String
                    var documentTypeCode: String
                }

                enum DocumentRejectionReasons: Decodable, Hashable {
                    case stringArray([String])
                    case structuredArray([RejectionReasons])

                    init(from decoder: Decoder) throws {
                        let container = try decoder.singleValueContainer()
                        if let stringArray = try? container.decode([String].self) {
                            self = .stringArray(stringArray)
                            return
                        }

                        if let structuredArray = try? container.decode([RejectionReasons].self) {
                            self = .structuredArray(structuredArray)
                            return
                        }

                        self = .stringArray([]) 
                    }
                }
            }

			struct LandingIntroStart: Decodable {
				struct AnswerModal: Decodable {
					var title: String // "Ready to sail"
					var description: String // ""
				}
				
				var answerModal: AnswerModal
				var title: String // "Seaworthy in seconds"
				var question: String // "Why do I need to do this?"
				var heading: String // "Let’s go!"
				var description: String // ""
			}
			
			struct LandingIntroEnd: Decodable {
				var heading: String // "Good job 🙌🏻"
				var title: String // "You're set to sail!"
				var description: String // ""
			}
			
			var voyageContract: Task
			var emergencyContact: Task
			var security: Task
			var pregnancy: Task
			var embarkationSlotSelection: Task
			var paymentMethod: Task
			var travelDocuments: Task // TravelDocuments
			var tasksCompletionPercentage: TaskCompletionPercentage
			var tasksOrder: [String]
			var reservationId: String // "56b4ec20-5886-4421-b955-36aaaa4a5faf"
			var landingIntroStart: LandingIntroStart
			var landingIntroEnd: LandingIntroEnd
		}
	}
}
