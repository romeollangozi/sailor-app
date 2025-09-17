//
//  GetLookupData.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 5/1/24.
//

import Foundation

extension Endpoint {
	struct GetLookupData: Requestable {
		typealias RequestType = NoRequest
		typealias QueryType = NoQuery
		typealias ResponseType = Response
		var authenticationType: AuthenticationType = .user
		var path = "/rts-bff/lookup"
		var method: Method = .get
		var cachePolicy: CachePolicy = .always
		var scope: RequestScope = .shoresideOnly
		var pathComponent: String?
		var request: NoRequest?
		var query: NoQuery?
		
		struct Response: Decodable {
			var referenceData: LookupData
			
			struct LookupData: Decodable {
				var airlines: [Airline]
				var airports: [Airport]
				var cardTypes: [CardType]
				var cities: [City]?
				var countries: [Country]
				var documentTypes: [DocumentType]
				var genders: [Gender]
				var languages: [Language]?
				var paymentModes: [PaymentMode]
				var ports: [Port]
				var rejectionReasons: [RejectionReason]
				var relations: [Relation]
				var states: [State]
				var visaEntries: [VisaEntry]
				var visaTypes: [VisaType]
				var postCruiseAddressTypes: [PostCruiseAddressType]
				var postCruiseTransportationOptions: [PostCruiseTransportationOption]
				var documentCategories: [DocumentCategory]
				
				struct Airline: Decodable {
					var code: String // "VB"
					var name: String // "Virgin Blue"
				}
				
				struct Airport: Decodable {
					var name: String // "Heathrow Airport"
					var code: String // "LHR"
					var cityId: String // "ba3d9d1a-cd67-45e4-b3fd-b55c82c573e0"
					var cityName: String // "Alaska"
				}
				
				struct CardType: Decodable {
					var referenceId: String // "001"
					var name: String // "VISA"
					var image: Image
					
					struct Image: Decodable {
						var src: String // "https://int.virginvoyages.com/svc/multimediastorage-service/mediaitems/71ad0400-0d92-464d-be5b-6c14a2857977"
						var alt: String // "VISA"
					}
				}
				
				struct City: Decodable {
					var name: String // "Abbeville"
					var id: String // "30fc54fb-036c-4a22-8cce-d836167aa92f"
					var countryCode: String // "US"
				}
				
				struct Country: Decodable {
					var name: String // "Austria"
					var code: String // "AT"
					var threeLetterCode: String? // "USA"
					var dialingCode: String? // "43"
				}
				
				struct DocumentType: Decodable {
					var code: String // "BC"
					var name: String // "Birth Certificate"
				}
				
				struct Gender: Decodable {
					var name: String // "Male"
					var code: String // "M"
				}
				
				struct Language: Decodable {
					var code: String // "en"
					var name: String // "ENGLISH"
				}
				
				struct PaymentMode: Decodable {
					var id: String // "02ee248e-e3d5-4242-8c99-94a51608a63d"
					var name: String // "Cash Payment"
				}
				
				struct Port: Decodable {
					var code: String // "PCV"
					var name: String // "Port Canaveral (Orlando), FL"
                    var countryCode: String // "NL"
				}
				
				struct RejectionReason: Decodable {
					var rejectionReasonId: String // "62d2fd04-94a9-4e2b-8656-43938af1c2f0"
					var name: String // "Photo has No valid face."
				}
				
				struct Relation: Decodable {
					var code: String // "FATHER"
					var name: String // "Father"
				}
				
				struct State: Decodable {
					var code: String // "AG"
					var countryCode: String // "CH"
					var name: String // "Aagau"
				}
				
				struct VisaEntry: Decodable {
					var code: String // "SINGLE"
					var name: String // "Single"
				}
				
				struct VisaType: Decodable {
					var code: String // "BCC"
					var name: String // "Border Crossing Card"
					var countryCode: String // "US"
				}
				
				struct PostCruiseAddressType: Decodable {
					var name: String // "home"
					var code: String // "HOME"
				}
				
				struct PostCruiseTransportationOption: Decodable {
					var name: String // "Airways"
					var code: String // "AIR"
				}
				
				struct DocumentCategory: Decodable {
					var id: String // "1c31c19a-3fde-4777-860c-d265f1e546b6"
					var code: String // "EV"
					var name: String // "E-Visa"
					var typeCode: String // "V"
				}
			}
		}
	}
}
