//
//  GetSailAssets.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 6/5/24.
//

import Foundation

extension Endpoint {
	struct GetSailAssets: Requestable {
		typealias RequestType = NoRequest
		typealias QueryType = NoQuery
		typealias ResponseType = Response
		var authenticationType: AuthenticationType = .user
		var path = "/rts-bff/assets"
		var method: Method = .get
		var cachePolicy: CachePolicy = .always
		var scope: RequestScope = .shoresideOnly
		var pathComponent: String?
		var request: NoRequest?
		var query: NoQuery?
		
		struct Response: Decodable {
			var portPassportRulesLinks: [PortPassportRulesLink]
			var assets: Assets
			var landing: Landing
			var travelDocuments: TravelDocuments
			var labels: Labels
			
			struct PortPassportRulesLink: Decodable {
				var name: String // "Piraeus (Athens)"
				var passportRulesLink: String // "https://www.visitgreece.gr/before-travelling-to-greece/passports-visas/"
				var code: String // "ATH"
			}
			
			struct Assets: Decodable {
				var download: String // "https://cdn.speedsize.com/eb8d0010-7300-4129-8a6d-74bc221f9caf/https://www.virginvoyages.com/dam/jcr:c350a49f-6349-4411-a373-bbf477f846eb/ICN-download-black-v1-01-32x32.svg"
				var edit: String // "https://cdn.speedsize.com/eb8d0010-7300-4129-8a6d-74bc221f9caf/https://www.virginvoyages.com/dam/jcr:8801e146-b4df-460a-849b-b84ccdfd2a4c/ICN_VV_Icon_Pencil_black24x24.svg"
				var wallet: String // "https://cdn.speedsize.com/eb8d0010-7300-4129-8a6d-74bc221f9caf/https://www.virginvoyages.com/dam/jcr:33e76690-f30f-4c6b-a2f6-4525907bdab1/ICN-payment-grey-v1-01-24x24.svg"
				var cancel: String // "https://cdn.speedsize.com/eb8d0010-7300-4129-8a6d-74bc221f9caf/https://www.virginvoyages.com/dam/jcr:c19b0549-27c8-4d25-b97a-2c20c218f1a7/ICN-close-black-v1-01-24x24.svg"
				var camera: String // "https://cdn.speedsize.com/eb8d0010-7300-4129-8a6d-74bc221f9caf/https://www.virginvoyages.com/dam/jcr:191ea381-16f4-413b-b88d-11208b5b866e/ICN-camera-black-v1-01-24x24.svg"
				var search: String // "https://cdn.speedsize.com/eb8d0010-7300-4129-8a6d-74bc221f9caf/https://www.virginvoyages.com/dam/jcr:d561d383-ba8b-48c9-a1c8-1a7b17fe5fd7/ICN-search-black-v1-01-24x24.svg"
				var backIcon: String // "https://cdn.speedsize.com/eb8d0010-7300-4129-8a6d-74bc221f9caf/https://www.virginvoyages.com/dam/jcr:49400db9-daf8-4163-965f-4dcdb1c0b2d3/ICN-left-arrow-white-24x24.svg"
				var showPassword: String // "https://cdn.speedsize.com/eb8d0010-7300-4129-8a6d-74bc221f9caf/https://www.virginvoyages.com/dam/jcr:0ecadbf8-a7ea-43dc-b8a1-e403fcd9f1c5/ICN-show-black-v1-01-24x24.svg"
				var hidePassword: String // "https://cdn.speedsize.com/eb8d0010-7300-4129-8a6d-74bc221f9caf/https://www.virginvoyages.com/dam/jcr:4cbc39bc-35b6-4447-9958-8a5bd8dd9536/ICN-hide-black-v1-01-24x24.svg"
				var informationIcon: String // "https://cdn.speedsize.com/eb8d0010-7300-4129-8a6d-74bc221f9caf/https://www.virginvoyages.com/dam/jcr:1ef0eae1-a3a1-46b1-bacf-05c8027b1454/vv_app_svgnewicons-info.svg"
				var unselectedIncomplete: String // "https://cdn.speedsize.com/eb8d0010-7300-4129-8a6d-74bc221f9caf/https://www.virginvoyages.com/dam/jcr:61b2ab7c-d481-4e3a-b4b7-90c1df8dc7ad/FPO_80x80.png"
				var accordionTapToOpen: String // "https://cdn.speedsize.com/eb8d0010-7300-4129-8a6d-74bc221f9caf/https://www.virginvoyages.com/dam/jcr:a0361702-78c7-4b44-8f46-8e0a0d448a6c/ICN-destinations-black-v1-01-24x24.svg"
				var complete: String // "https://cdn.speedsize.com/eb8d0010-7300-4129-8a6d-74bc221f9caf/https://www.virginvoyages.com/dam/jcr:61b2ab7c-d481-4e3a-b4b7-90c1df8dc7ad/FPO_80x80.png"
				var loader: String // "https://cdn.speedsize.com/eb8d0010-7300-4129-8a6d-74bc221f9caf/https://www.virginvoyages.com/dam/jcr:073aaa67-3eaf-4f49-9274-d6c0f0893608/VV_Loader_Mobile_100x115px.gif"
				var anchor: String // "https://cdn.speedsize.com/eb8d0010-7300-4129-8a6d-74bc221f9caf/https://www.virginvoyages.com/dam/jcr:ddd40c3a-6474-4b26-92ec-0b6c77a60626/ICN-VVB-presale-anchor-v1-01.svg"
				var downChevron: String // "https://cdn.speedsize.com/eb8d0010-7300-4129-8a6d-74bc221f9caf/https://www.virginvoyages.com/dam/jcr:b6dd0c18-7db6-40f2-94fc-a30ff7f94700/ICN-chevron-down-black-v1-01-24x24.svg"
				var calendar: String // "https://cdn.speedsize.com/eb8d0010-7300-4129-8a6d-74bc221f9caf/https://www.virginvoyages.com/dam/jcr:9f34691b-21b1-4bf3-b6e7-6b8e83686c4e/ICN-calendar-black-v1-01-24x24.svg"
				var pageProgressIndicator: String // "https://cdn.speedsize.com/eb8d0010-7300-4129-8a6d-74bc221f9caf/https://www.virginvoyages.com/dam/jcr:f07ac37a-1651-455c-a03b-a89d4d23b073/ICN-chevron-right-black-v1-01-32x32.svg"
				var upChevron: String // "https://cdn.speedsize.com/eb8d0010-7300-4129-8a6d-74bc221f9caf/https://www.virginvoyages.com/dam/jcr:e98ffd43-0806-48c3-9696-b45eb25b6c4b/ICN-chevron-up-black-v1-01-24x24.svg"
				var phoneCallIcon: String // "https://cdn.speedsize.com/eb8d0010-7300-4129-8a6d-74bc221f9caf/https://www.virginvoyages.com/dam/jcr:ed227c66-c04d-4b2e-9fc6-38eafd8a36be/cabin_entertainment_icon_phone.svg"
				var settingsCog: String // "https://cdn.speedsize.com/eb8d0010-7300-4129-8a6d-74bc221f9caf/https://www.virginvoyages.com/dam/jcr:010f31b5-21b8-4e04-9217-a4008deac7f2/ICN-WEB-settings-gray-v1-01-24x24.svg"
				var downArrow: String // "https://cdn.speedsize.com/eb8d0010-7300-4129-8a6d-74bc221f9caf/https://www.virginvoyages.com/dam/jcr:1d95cb28-01a0-4f18-8924-7902a4536cf0/ICN-arrow-up-black-v1-01-32x32.svg"
				var cameraFlashTurnOff: String // "https://cdn.speedsize.com/eb8d0010-7300-4129-8a6d-74bc221f9caf/https://www.virginvoyages.com/dam/jcr:c3829a55-1294-4a1d-90e6-557079397918/ICN-VVB-app-flash-on-lightning-bolt-v1-01.svg"
				var closeIcon: String // "https://cdn.speedsize.com/eb8d0010-7300-4129-8a6d-74bc221f9caf/https://www.virginvoyages.com/dam/jcr:53483c3e-8837-45d9-9e63-019e7e45f9c5/ICN-close-white-v1-01-24x24.svg"
				var lock: String // "https://cdn.speedsize.com/eb8d0010-7300-4129-8a6d-74bc221f9caf/https://www.virginvoyages.com/dam/jcr:e18326c2-2629-4c4c-931a-b2b01fdef821/ICN-locked-black-v1-01-24x24.svg"
				var accordionTapToClose: String // "https://cdn.speedsize.com/eb8d0010-7300-4129-8a6d-74bc221f9caf/https://www.virginvoyages.com/dam/jcr:a0361702-78c7-4b44-8f46-8e0a0d448a6c/ICN-destinations-black-v1-01-24x24.svg"
				var plusIcon: String // "https://cdn.speedsize.com/eb8d0010-7300-4129-8a6d-74bc221f9caf/https://www.virginvoyages.com/dam/jcr:aa01555a-50a9-4c53-bd0b-56b2330db4a0/ILLO-global-add-plus-black-24x24.svg"
			}
			
			struct Landing: Decodable {
				var travelDocuments: TravelDocumentsDetails
				var landingIntroEnd: LandingIntroEnd
				var landingIntroStart: LandingIntroStart
				
				struct TravelDocumentsDetails: Decodable {
					var images: Images
					var backgroundColorCode: String // "#faf2d4"
					var startCaption: String // "Start"
					var title: String // "Travel documents"
					var partialCaption: String // "Partially Complete"
					var failedStateTextColorCode: String // "#ff9400"
					var redoCaption: String // "Redo"
					var doneCaption: String // "EDIT"
					var failedStateText: String // "There's an issue with the document(s) you uploaded. Please review and re-upload."
					
					struct Images: Decodable {
						var start: String // "https://cdn.speedsize.com/eb8d0010-7300-4129-8a6d-74bc221f9caf/https://www.virginvoyages.com/dam/jcr:8d1cadd3-8c32-4c5c-ab5c-ae4ad7681ea5/security-red.jpg"
						var done: String // "https://cdn.speedsize.com/eb8d0010-7300-4129-8a6d-74bc221f9caf/https://www.virginvoyages.com/dam/jcr:891fe142-8784-45cf-b569-bd80c5bf1ba5/travel-docs_start-800x1280.jpg"
						var partial: String // "https://cdn.speedsize.com/eb8d0010-7300-4129-8a6d-74bc221f9caf/https://www.virginvoyages.com/dam/jcr:8d1cadd3-8c32-4c5c-ab5c-ae4ad7681ea5/security-red.jpg"
					}
				}
				
				struct LandingIntroEnd: Decodable {
					var heading: String // "Good job 🙌🏻"
					var title: String // "You're set to sail!"
					var description: String // "<p>That&#39;s all for now but don&#39;t forget to complete your health check 24 hours before your voyage begins.</p>"
				}
				
				struct LandingIntroStart: Decodable {
					var answerModal: AnswerModal
					var title: String // "Seaworthy in seconds"
					var question: String // "Why do I need to do this?"
					var heading: String // "Let’s go!"
					var description: String // "<p>This only takes <strong>10 mins</strong> and it&rsquo;ll be totally worth it when you stroll onto the ship and nab the <strong>best hammock</strong>. All you need is your <strong>passport &amp; flight or arrival details.</strong></p>"
					
					struct AnswerModal: Decodable {
						var title: String // "Ready to sail"
						var description: String // "This is a big adventure, so we need to make sure you (and your paperwork) are shipshape. Get it done now and you’ll be aboard in no time on departure day, calling dibs on the best pool spot as you go 👌🏾"
					}
				}
			}
			
			struct TravelDocuments: Decodable {
				var documentExpirationPages: DocumentExpirationPages
				var visas: Visas
				var esta: ESTA
				var arc: ARC
				var labels: Labels
				var documentErrorData: DocumentErrorData
				var buttons: Buttons
				var documentTitles: DocumentTitles
				var finalDocumentsReviewPage: FinalDocumentsReviewPage
				var chooseDocumentsStagePage: ChooseDocumentsStagePage
				var documentScannedPages: DocumentScannedPages
				var deleteModalData: DeleteModalData
				var documentDeclaration: DocumentDeclaration
				var finalPage: FinalPage
				var passport: Passport
				var documentScan: DocumentScan
				var scannableDocumentActionDrawerContent: ScannableDocumentActionDrawerContent
				var declareDocumentActionDrawerContent: DeclareDocumentActionDrawerContent
				var documentModalData: DocumentModalData
				var landingPageData: LandingPageData
				var additionalDocumentsPage: AdditionalDocumentsPage
				var postVoyagePage: PostVoyagePage
				
				struct DocumentExpirationPages: Decodable {
					var passport: Passport
					var cancelText: String // "Cancel"
					var goodToTravelText: String // "I checked! I'm good to go"
					
					struct Passport: Decodable {
						var linkText: String // "{Country} Traveler Passport Info"
						var title: String // "Potential passport expiration issue"
						var content: String // "<p>It looks like your passport will expire less than 6 months after you return to {DebarkationCountry}. For some visitors, passports must be valid for more than 6 months from their planned departure date from {DebarkationCountry}. Please check if you are exempt from this rule at the following website:<br /><br />{CountrysWebsite}<br /><br />We&#39;re here to help, but please know that it&#39;s your legal responsibility to ensure you meet all immigration requirements or you may not be able to sail with us.</p>"
					}
				}
				
				struct Visas: Decodable {
					var reviewPage: ReviewPage
					var deleteDocumentPage: DeleteDocumentPage
					var multiEntryErrorPage: MultiEntryErrorPage
					var introPage: IntroPage
					
					struct ReviewPage: Decodable {
						var confirmationQuestion: String // "Use this visa?"
						var subTitle: String // "Visa"
						var imageURL: String // "https://cdn.speedsize.com/eb8d0010-7300-4129-8a6d-74bc221f9caf/https://www.virginvoyages.com/dam/jcr:982bb7a6-e1ce-4a22-ba60-b5a5a9ae3ea0/signals-dogear-yellow.png"
						var description: String // "Please double check your details are correct"
						var title: String // "Travel documents"
					}
					
					struct DeleteDocumentPage: Decodable {
						var description: String // "Are you sure? You'll need valid documentation to return to the US. After deleting, you'll have the opportunity to add a new card or another form of documentation."
						var title: String // "Delete visa?"
						var imageURL: String // "https://cdn.speedsize.com/eb8d0010-7300-4129-8a6d-74bc221f9caf/https://www.virginvoyages.com/dam/jcr:982bb7a6-e1ce-4a22-ba60-b5a5a9ae3ea0/signals-dogear-yellow.png"
					}
					
					struct MultiEntryErrorPage: Decodable {
						var quitButtonText: String // "Quit travel documents"
						var body: String // "<p>It looks like the visa you&#39;ve submitted is NOT a multi-entry visa &mdash; an immigration requirement for all Sailors in this itinerary and/or with your citizenship status.</p><p>Please update your visa type or upload a valid, multi-entry visa.</p>"
						var viewDocumentText: String // "View document details"
						var header: String // "<p><strong>Multi-entry visa required</strong></p>"
					}
					
					struct IntroPage: Decodable {
						var description: String // "We need to take a photo of your visa for immigration."
						var title: String // "Visa"
						var imageURL: String // "https://cdn.speedsize.com/eb8d0010-7300-4129-8a6d-74bc221f9caf/https://www.virginvoyages.com/dam/jcr:8d1cadd3-8c32-4c5c-ab5c-ae4ad7681ea5/security-red.jpg"
					}
				}
				
				struct Labels: Decodable {
					var visaTitleText: String // "USA Visa"
					var flightNumber: String // "Flight"
					var zipcode: String // "Zip Code"
					var pleaseReviewText: String // "Please double check your details are correct before saving your document."
					var visaEntries: String // "Entries"
					var instructionText: String // "Please make sure that the name on your passport matches exactly what you enter here — as well as all the relevant details featured on your passport."
					var hotelName: String // "Hotel name (if applicable)"
					var visaType: String // "Visa type"
					var enteringHeadLineText: String // "Entering {Country}"
					var docNumberText: String // "Document Number"
					var street: String // "Street"
					var city: String // "City"
					var airport: String // "Airport"
					var airline: String // "Airline"
					var EUIdCardTitleText: String // "EU ID Card"
					var state: String // "State"
					var enteringBodyText: String // "When you voyage with us in {country}, you must show valid travel documents as part of the entry process. The documents you need depend on the country you are arriving from and your citizenship or status. Please ensure that you have the correct documents or you may not be able to voyage with us."
					var stayPostVoaygeText: String // "Details of your stay in {country} post-voyage"
					var number: String // "No"
					var websiteLinkText: String // "Learn more"
					var countryOfBirth: String // "Country of birth"
					var visaWaiverText: String // "All eligible international travelers who wish to travel to the United States under the Visa Waiver Program must apply for authorization. If you haven’t done so already, please check the site below to apply"
					var travellingUnderText: String // "You have said you are traveling under an {document}"
				}
				
				struct DocumentErrorData: Decodable {
					var tryAgainText: String // "Let's give it another go"
					var manualEnterText: String // "I'll enter my info manually"
					var description: String // "We're excited too—but this image is too blurry for us to verify. Please try again with a clearer image."
				}
				
				struct Buttons: Decodable {
					var cancel: String // "Cancel"
					var visas: String // "Visa"
					var arc: String // "Green card"
					var edit: String // "Edit"
					var change: String // "Change"
					var deleteVisa: String // "Yes, delete visa"
					var deleteGreenCard: String // "Yes, delete green card"
					var deletePassport: String // "Yes, delete passport"
					var esta: String // "ESTA"
					var passport: String // "Passport"
				}
				
				struct DocumentTitles: Decodable {
					var ukvisa: String // "UK Visa"
					var visas: String // "Visa"
					var arc: String // "Green card"
					var drivingLicense: String? // "DL - Driving License"
					var euid: String // "European ID"
					var schengenVisa: String // "Schengen Visa"
					var prc: String // "Permanent Resident Card"
					var sprc: String // "Schengen Permanent Resident Card"
					var enhancedDrivingLicense: String // "EDL - Enhance Driving License"
					var esta: String // "ESTA"
					var passport: String // "Passport"
				}
				
				struct FinalDocumentsReviewPage: Decodable {
					var declarationTitle: String // "You have said you are traveling under an {document}"
					var missingDocumentDescription: String // "Tap to upload additional documentation if necessary."
					var missingPassportDescription: String // "Tap here to add your passport"
					var title: String // "Travel documents"
					var documentDescription: DocumentDescription
					var backgroundDeclarationColorCode: String // "#74EAD2"
					var imageURL: String // "https://cdn.speedsize.com/eb8d0010-7300-4129-8a6d-74bc221f9caf/https://www.virginvoyages.com/dam/jcr:982bb7a6-e1ce-4a22-ba60-b5a5a9ae3ea0/signals-dogear-yellow.png"
					var description: String // "<p><strong>Important!</strong>&nbsp;Please remember to bring your passport and any other documents that might be required to complete immigration</p><p>&nbsp;</p><p>&nbsp;</p>"
					
					struct DocumentDescription: Decodable {
						var visas: String // "You have said you are travelling under a Visa"
						var arc: String // "You have said you are travelling under a Green Card"
						var passport: String // "You have said you are travelling under a Passport"
						var esta: String // "You have said you are travelling under an ESTA"
					}
				}
				
				struct ChooseDocumentsStagePage: Decodable {
					var answerModal: AnswerModal
					var imageURL: String // "https://cdn.speedsize.com/eb8d0010-7300-4129-8a6d-74bc221f9caf/https://www.virginvoyages.com/dam/jcr:8d1cadd3-8c32-4c5c-ab5c-ae4ad7681ea5/security-red.jpg"
					var title: String // "Choose your {stage} document"
					var chooseDocumentsQuestion: String // "Please select the document you wish to travel under"
					var question: String // "I don’t have any of these"
					var description: String // "Looks like there are some options for your {stage} document"
					
					struct AnswerModal: Decodable {
						var link: String // "https://usa.gov/enter-us"
						var title: String // "Entering the USA"
						var description: String // "When you sail with us in the United States, you must show valid travel documents as part of the entry process. The documents you need depend on the country you are arriving from and your citizenship or status. Please make sure you have the correct documents or you may not be able to sail with us."
					}
				}
				
				struct DocumentScannedPages: Decodable {
					var description: String // "Please confirm if you are planning on traveling under a {document}"
					var visas: DocumentDetails
					var arc: DocumentDetails
					var euid: DocumentDetails
					var prc: DocumentDetails
					var title: String // "{Document}"
					var esta: String? // null
					var passport: PassportDetails
					var imageURL: String // "https://cdn.speedsize.com/eb8d0010-7300-4129-8a6d-74bc221f9caf/https://www.virginvoyages.com/dam/jcr:982bb7a6-e1ce-4a22-ba60-b5a5a9ae3ea0/signals-dogear-yellow.png"
					
					struct DocumentDetails: Decodable {
						var number: DocumentField
						var gender: DocumentField
						var expiryDate: DocumentField
						var issueCountryCode: DocumentField
						var surname: DocumentField
						var issueDate: DocumentField
						var birthDate: DocumentField
						var givenName: DocumentField
						var birthCountryCode: DocumentField
						var visaEntries: DocumentField?
						
						struct DocumentField: Decodable {
							var displayOrder: Int
							var type: String
							var value: String
						}
					}
					
					struct PassportDetails: Decodable {
						var number: DocumentField
						var gender: DocumentField
						var expiryDate: DocumentField
						var issueCountryCode: DocumentField
						var surname: DocumentField
						var issueDate: DocumentField
						var birthDate: DocumentField
						var countryOfResidenceCode: DocumentField
						var givenName: DocumentField
						var birthCountryCode: DocumentField
						
						struct DocumentField: Decodable {
							var displayOrder: Int
							var type: String
							var value: String
						}
					}
				}
				
				struct DeleteModalData: Decodable {
					var footerText: String // "Yes, delete {document}"
					var title: String // "Delete {Document}?"
					var description: String // "Are you sure. You will need a valid {document} to voyage with us. After deleting you will have the opportunity to add a new one…"
				}
				
				struct DocumentDeclaration: Decodable {
					var answerModal: AnswerModal
					var imageURL: String // "https://cdn.speedsize.com/eb8d0010-7300-4129-8a6d-74bc221f9caf/https://www.virginvoyages.com/dam/jcr:8d1cadd3-8c32-4c5c-ab5c-ae4ad7681ea5/security-red.jpg"
					var dontHaveLinkText: String // "I still need to apply for a {document}"
					var description: String // "Please confirm if you are planning on traveling under a {document}"
					var title: String // "{Document}"
					
					struct AnswerModal: Decodable {
						var link: String // "https://usa.gov/enter-us"
						var title: String // "Entering the USA"
						var description: String // "When you sail with us in the United States, you must show valid travel documents as part of the entry process. The documents you need depend on the country you are arriving from and your citizenship or status. Please make sure you have the correct documents or you may not be able to sail with us."
					}
				}
				
				struct FinalPage: Decodable {
					var doneCaption: String // "EDIT"
					var partialCaption: String // "Partially Complete"
					var title: String // "Travel documents"
					var images: Images
					var startCaption: String // "Start"
					
					struct Images: Decodable {
						var start: String // "https://cdn.speedsize.com/eb8d0010-7300-4129-8a6d-74bc221f9caf/https://www.virginvoyages.com/dam/jcr:8d1cadd3-8c32-4c5c-ab5c-ae4ad7681ea5/security-red.jpg"
						var done: String // "https://cdn.speedsize.com/eb8d0010-7300-4129-8a6d-74bc221f9caf/https://www.virginvoyages.com/dam/jcr:891fe142-8784-45cf-b569-bd80c5bf1ba5/travel-docs_start-800x1280.jpg"
						var partial: String // "https://cdn.speedsize.com/eb8d0010-7300-4129-8a6d-74bc221f9caf/https://www.virginvoyages.com/dam/jcr:8d1cadd3-8c32-4c5c-ab5c-ae4ad7681ea5/security-red.jpg"
					}
				}

				struct Passport: Decodable {
					var additionalInformationHeader: String // "Additional Information"
					var reviewPage: ReviewPage
					var deleteDocumentPage: DeleteDocumentPage
					var introPage: IntroPage
					
					struct ReviewPage: Decodable {
						var confirmationQuestion: String // "Use this passport information:"
						var subTitle: String // "Passport"
						var imageURL: String // "https://cdn.speedsize.com/eb8d0010-7300-4129-8a6d-74bc221f9caf/https://www.virginvoyages.com/dam/jcr:982bb7a6-e1ce-4a22-ba60-b5a5a9ae3ea0/signals-dogear-yellow.png"
						var description: String // "Please double check your details are correct"
						var title: String // "Travel documents"
					}
					
					struct DeleteDocumentPage: Decodable {
						var description: String // "You will need valid passport to voyage with us. After deleting, you'll have the opportunity to add a new one."
						var title: String // "Delete passport?"
						var imageURL: String // "https://cdn.speedsize.com/eb8d0010-7300-4129-8a6d-74bc221f9caf/https://www.virginvoyages.com/dam/jcr:982bb7a6-e1ce-4a22-ba60-b5a5a9ae3ea0/signals-dogear-yellow.png"
					}
					
					struct IntroPage: Decodable {
						var answerModal: AnswerModal
						var imageURL: String // "https://cdn.speedsize.com/eb8d0010-7300-4129-8a6d-74bc221f9caf/https://www.virginvoyages.com/dam/jcr:8d1cadd3-8c32-4c5c-ab5c-ae4ad7681ea5/security-red.jpg"
						var title: String // "Passport scan"
						var question: String // "I don’t have a passport"
						var description: String // "Position your passport in the box. Make sure it’s flat, the light is good and everything is visible."
						
						struct AnswerModal: Decodable {
							var link: String // "https://travel.state.gov/"
							var title: String // "I don’t have a passport"
							var description: String // "We’re taking you into international waters so to sail with us you need a passport that’s valid for at least six months after the start of your voyage. For US nationals, head to the site below to apply for one. For everyone else, look up your national passport office."
						}
					}
				}
				
				struct DocumentScan: Decodable {
					var answerModal: AnswerModal
					var imageURL: String // "https://cdn.speedsize.com/eb8d0010-7300-4129-8a6d-74bc221f9caf/https://www.virginvoyages.com/dam/jcr:8d1cadd3-8c32-4c5c-ab5c-ae4ad7681ea5/security-red.jpg"
					var dontHaveLinkText: String // "I don’t have a {document}"
					var description: String // "We need to take a photo of your {Document} for immigration."
					var title: String // "{Document} scan"
					
					struct AnswerModal: Decodable {
						var link: String // "https://usa.gov/enter-us"
						var title: String // "Entering the USA"
						var description: String // "When you sail with us in the United States, you must show valid travel documents as part of the entry process. The documents you need depend on the country you are arriving from and your citizenship or status. Please make sure you have the correct documents or you may not be able to sail with us."
					}
				}
				
				struct ScannableDocumentActionDrawerContent: Decodable {
					var title: String // "Entering {Country}"
					var content: String // "When you voyage with us in {country}, you must show valid travel documents as part of the entry process. The documents you need depend on the country you are arriving from and your citizenship or status. Please ensure that you have the correct documents or you may not be able to voyage with us."
					var learnMoreText: String // "Learn more"
				}
				
				struct DeclareDocumentActionDrawerContent: Decodable {
					var title: String // "{Document}"
					var content: String // "All eligible international travelers who wish to travel to the United States under the Visa Waiver Program must apply for authorization. If you haven’t done so already, please check the site below to apply"
					var learnMoreText: String // "Learn more"
				}
				
				struct DocumentModalData: Decodable {
					var title: String // "One minute, sailor"
					var footerContent: String // "Use this {document}?"
					var description: String // "Looks like you already have a {document} on file."
				}
				
				struct LandingPageData: Decodable {
					var imageURL: String // "https://cdn.speedsize.com/eb8d0010-7300-4129-8a6d-74bc221f9caf/https://www.virginvoyages.com/dam/jcr:8d1cadd3-8c32-4c5c-ab5c-ae4ad7681ea5/security-red.jpg"
					var citizenshipUnknown: CitizenshipUnknown
					var description: String // "You told us your nationality is {Nationality}, based on that, we need to take some documents from you. This it to make immigration easier at all our ports."
					var title: String // "Travel documents"
					var itineryMissingError: ItineryMissingError
					
					struct CitizenshipUnknown: Decodable {
						var pleaseSelectText: String? // "please select"
						var selectCitizenshipDescription: String? // "Please select your citizenship so we can determine the travel documents required for your itinerary."
						var citizenshipText: String? // "Citizenship"
						var description: String // "Travel documents are required at all ports. We’ll need to scan your travel documents to speed up entry and immigration."
					}
					
					struct ItineryMissingError: Decodable {
						var subHeader: String // "Please check back later."
						var header: String // "We’re still getting ship ready before you can upload your travel documents."
					}
				}
				
				struct ESTA: Decodable {
					var introPage: IntroPage
					
					struct IntroPage: Decodable {
						var answerModal: AnswerModal
						var imageURL: String // "https://cdn.speedsize.com/eb8d0010-7300-4129-8a6d-74bc221f9caf/https://www.virginvoyages.com/dam/jcr:8d1cadd3-8c32-4c5c-ab5c-ae4ad7681ea5/security-red.jpg"
						var title: String // "ESTA"
						var question: String // "I still need to apply for an ESTA"
						var description: String // "If you plan on traveling under an ESTA, please make sure you bring it with you."
						
						struct AnswerModal: Decodable {
							var link: String // "https://esta.cbp.dhs.gov/"
							var title: String // "Electronic System for Travel Authorization"
							var description: String // "All eligible international travelers who wish to travel to the United States under the Visa Waiver Program must apply for authorization. If you haven’t done so already, please check the site below to apply"
						}
					}
				}
				
				struct ARC: Decodable {
					var deleteDocumentPage: DeleteDocumentPage
					var reviewPage: ReviewPage
					var introPage: IntroPage
					
					struct DeleteDocumentPage: Decodable {
						var description: String // "Are you sure? You'll need valid documentation to return to the US. After deleting, you'll have the opportunity to add a new card or another form of documentation."
						var title: String // "Delete green card?"
						var imageURL: String // "https://cdn.speedsize.com/eb8d0010-7300-4129-8a6d-74bc221f9caf/https://www.virginvoyages.com/dam/jcr:982bb7a6-e1ce-4a22-ba60-b5a5a9ae3ea0/signals-dogear-yellow.png"
					}
					
					struct ReviewPage: Decodable {
						var confirmationQuestion: String // "Use this green card?"
						var subTitle: String // "Green card"
						var imageURL: String // "https://cdn.speedsize.com/eb8d0010-7300-4129-8a6d-74bc221f9caf/https://www.virginvoyages.com/dam/jcr:982bb7a6-e1ce-4a22-ba60-b5a5a9ae3ea0/signals-dogear-yellow.png"
						var description: String // "Please double check your details are correct"
						var title: String // "Travel documents"
					}
					
					struct IntroPage: Decodable {
						var imageURL: String // "https://cdn.speedsize.com/eb8d0010-7300-4129-8a6d-74bc221f9caf/https://www.virginvoyages.com/dam/jcr:8d1cadd3-8c32-4c5c-ab5c-ae4ad7681ea5/security-red.jpg"
						var title: String // "Green card"
						var cameraHelpText: String // "Please scan the BACK of the card"
						var description: String // "We need to take a photo of the back of your green card for immigration."
					}
				}
				
				struct AdditionalDocumentsPage: Decodable {
					var title: String // "One more thing"
					var question: String // "I don’t have any of these"
					var description: String // "Tap to upload additional documentation if necessary."
					var additionalDocumentsQuestion: String // "Which document will you be traveling under?"
				}
				
				struct PostVoyagePage: Decodable {
					var stayingCountrySelection: String // "I will be remaining in the country after ending the voyage"
					var reviewDescription: String // "Details of your stay after your voyage"
					var stayingOptionsOrder: StayingOptionsOrder
					var stayingOptions: StayingOptions
					var title: String // "Post voyage plans"
					var leavingCountrySelection: String // "I will be leaving the country on the same day after ending the voyage"
					var leavingOptions: LeavingOptions
					var description: String // "We need to inform border control of your plans post-voyage. This will help us make sure debarkation is silky smooth and effortless for you."
					
					struct StayingOptionsOrder: Decodable {
						var OTHER: Int // 2
						var HOME: Int // 1
						var HOTEL: Int // 0
					}
					
					struct StayingOptions: Decodable {
						var title: String // "Please give details of where you will be staying."
						var HOTEL: String // "Hotel"
						var HOME: String // "Private residence"
						var OTHER: String // "Other"
					}
					
					struct LeavingOptions: Decodable {
						var AIR: String // "I will be departing by Air"
						var title: String // "Please give details of how you will be departing"
						var WATER: String // "I will be departing by Sea"
						var LAND: String // "I will be departing by land"
						var flightDetailsTitle: String // "Please provide your flight details"
					}
				}
			}
			
			struct Labels: Decodable {
				var reasonRejectionText: String // "Reason for rejection"
			}
		}
	}
}
