//
//  TravelDocumentTask.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 6/6/24.
//

import Foundation

@Observable class TravelDocumentTask: Sailable {
	var content: Endpoint.GetTravelDocumentTask.Response
	let assets: Endpoint.GetSailAssets.Response
	let countries: [Endpoint.GetLookupData.Response.LookupData.Country]
	let documentTypes: [Endpoint.GetLookupData.Response.LookupData.DocumentType]
	let airlines: [Endpoint.GetLookupData.Response.LookupData.Airline]
	let airports: [Endpoint.GetLookupData.Response.LookupData.Airport]
	let states: [Endpoint.GetLookupData.Response.LookupData.State]
	let visaEntries: [Endpoint.GetLookupData.Response.LookupData.VisaEntry]
	let visaTypes: [Endpoint.GetLookupData.Response.LookupData.VisaType]
	var screenTask = ScreenTask()
	var step: Step
    var sailTask: ReadyToSail.Task?
    var rejectionReasons: [Endpoint.GetLookupData.Response.LookupData.RejectionReason]
    var lookup: Endpoint.GetLookupData.Response.LookupData

    init(content: Endpoint.GetTravelDocumentTask.Response, assets: Endpoint.GetSailAssets.Response, lookup: Endpoint.GetLookupData.Response.LookupData, sailTask: ReadyToSail.Task? = nil) {
		self.content = content
		self.assets = assets
		self.countries = lookup.countries
		self.documentTypes = lookup.documentTypes
		self.airlines = lookup.airlines
		self.airports = lookup.airports
		self.states = lookup.states
		self.visaEntries = lookup.visaEntries
		self.visaTypes = lookup.visaTypes
		self.step = .unknownCitizenship
        self.sailTask = sailTask
        self.rejectionReasons = lookup.rejectionReasons
        self.lookup = lookup
		startOver()
	}
	
	var completed: Bool {
		var primaryIsSelected = content.primaryDocumentOptions.contains {
			$0.isSelected
		}
		
		if primaryIsSelected == false {
			primaryIsSelected = documents.contains {
				$0.mode == .primary
			}
		}
		
		// Primary document such as Passport is selected
		if primaryIsSelected == true {
			
			// No secondary options
			if content.additionalDocumentsOptions.count == 0 {
				return true
			}
			
			let secondaryIsSelected = content.additionalDocumentsOptions.contains {
				$0.isSelected
			}

			// Secondary document selection is finished
			// This only happens once ALL secondary documents have been selected
			if secondaryIsSelected == true {
				return true
			}
		}
		
		return false
	}
	
	var task: SailTask {
		.travelDocuments
	}
	
	func documentName(for type: DocumentType) -> String {
		let documentType = documentTypes.first {
			$0.code == type.id
		}
		
		guard let documentType else {
			return type.id
		}
		
		switch type {
		case .visa(let code):
			var countryName = "Schengen"
			if code != "ES" {
				let country = countries.first {
					$0.code == code
				}
				
				countryName = country?.name ?? code
			}
			
			return "\(countryName) \(documentType.name)"
			
		default:
			return documentType.name
		}
	}
	
	func choosePage(mode: DocumentMode) -> ChoosePage {
		.init(content: content, page: assets.travelDocuments.chooseDocumentsStagePage, mode: mode)
	}
	
	func capturePage(documentType: DocumentType, entryPermitFor: String) -> CapturePage {
        .init(page: assets.travelDocuments.documentScan, documentName: documentName(for: documentType), documentType: documentType, entryPermitFor: entryPermitFor, documentErrorData: assets.travelDocuments.documentErrorData)
	}
	
	func reviewPage() -> ReviewPage {
		.init(content: assets.travelDocuments, country: "", documents: documents)
	}
	
	func choose(documentType: DocumentType) {
		let option = content.additionalDocumentsOptions.first {
			$0.documentTypeCode == documentType.id
		}
		
		step = .capture(capturePage(documentType: documentType, entryPermitFor: option?.entryPermitFor ?? ""))
	}
	
	func startInterview() {
		// Current documents
		let documents = self.documents
		
		// Get primary documents
		let primaryStagePage = choosePage(mode: .primary)

        if content.primaryDocumentOptions.isEmpty {
            step = .notReady
            return
        }

        let primaryIsCompleted = content.primaryDocumentOptions.contains {
            $0.isSelected
        }

        if !primaryIsCompleted && primaryStagePage.hasMultipleDocuments {
            step = .choose(primaryStagePage)
            return
        }

        // User has a primary document
        if primaryIsCompleted {
            let secondaryStagePage = choosePage(mode: .secondary)
            let secondaryIsCompleted = content.additionalDocumentsOptions.contains {
                $0.isSelected
            }

            if secondaryIsCompleted || content.additionalDocumentsOptions.isEmpty {
                step = .review(reviewPage())
                return
            }
            // User needs to select a secondary document
            step = .choose(secondaryStagePage)
            return
        }

        guard let primaryDocumentType =  primaryStagePage.primaryDocumentType  else {
            return step = .choose(primaryStagePage)
        }
        step = .capture(capturePage(documentType: primaryDocumentType, entryPermitFor: content.travelDocumentsDetail.countryOfCitizenship ?? ""))
	}
	
	func startOver() {
		if completed {
			step = .review(.init(content: assets.travelDocuments, country: "", documents: documents))
		} else if let countryOfCitizenship {
			step = .knownCitizenship(.init(content: assets.travelDocuments.landingPageData, countryOfCitizenship: countryOfCitizenship.name))
		} else {
			step = .unknownCitizenship
		}
	}
	
	func back() {
		switch step {
		case .capture:
			startOver()
		case .choose:
			startOver()
		case .knownCitizenship:
			startOver()
		case .unknownCitizenship:
			startOver()
		case .notReady:
			startOver()
		case .selectSaved:
			startOver()
		case .postVoyage:
			startOver()
		case .passport(let passport):
			switch passport.photo {
			case .data:
				startOver()
			case .url:
				step = .review(reviewPage())
			}
		case .visa(let visa):
			switch visa.photo {
			case .data:
				startOver()
			case .url:
				step = .review(reviewPage())
			}
		case .saving:
			startOver()
		case .review:
			startOver()
		}
	}
	
	var navigationMode: NavigationMode {
		switch step {
		case .capture, .choose, .selectSaved, .postVoyage, .saving: .both
		case .passport, .visa: .back
		case .knownCitizenship, .unknownCitizenship, .notReady, .review: .dismiss
		}
	}
	
	var postVoyageIsRequired: Bool {
		content.enablePostCruiseTab
	}
	
	var countryOfCitizenship: Endpoint.GetLookupData.Response.LookupData.Country? {
		countries.first {
			$0.code == content.travelDocumentsDetail.countryOfCitizenship
		}
	}
	
	var currentPrimaryDocument: Endpoint.GetTravelDocumentTask.Response.TravelDocumentsDetail.Document? {
		let option = content.primaryDocumentOptions.first {
			$0.isSelected == true
		}
		
		guard let selectedCode = option?.documentTypeCode else {
			return nil
		}
		
		return content.travelDocumentsDetail.identificationDocuments.first {
			$0.documentTypeCode == selectedCode
		}
	}
	
	var currentAdditionalDocument: Endpoint.GetTravelDocumentTask.Response.TravelDocumentsDetail.Document? {
		let option = content.additionalDocumentsOptions.first {
			$0.isSelected == true
		}
		
		guard let selectedCode = option?.documentTypeCode else {
			return nil
		}
		
		return content.travelDocumentsDetail.identificationDocuments.first {
			$0.documentTypeCode == selectedCode
		}
	}
	
	var stayingOptions: [PostVoyage.StayingOption] {
		let order = assets.travelDocuments.postVoyagePage.stayingOptionsOrder
		let options = assets.travelDocuments.postVoyagePage.stayingOptions
		let hotel = order.HOTEL
		let home = order.HOME
		let other = order.OTHER
		
		let array: [PostVoyage.StayingOption] = [
			.init(id: "HOTEL", type: .hotel, name: options.HOTEL, order: hotel),
			.init(id: "HOME", type: .home, name: options.HOME, order: home),
			.init(id: "OTHER", type: .other, name: options.OTHER, order: other)
		].sorted {
			$0.order < $1.order
		}
		
		return array
	}
	
	var leavingOptions: [PostVoyage.LeavingOption] {
		let options = assets.travelDocuments.postVoyagePage.leavingOptions
		let array: [PostVoyage.LeavingOption] = [
			.init(id: "AIR", type: .air, name: options.AIR),
			.init(id: "WATER", type: .sea, name: options.WATER),
			.init(id: "LAND", type: .land, name: options.LAND)
		]
		
		return array
	}
	
	var documents: [any BoardingDocument] {
		let countryCode = content.travelDocumentsDetail.countryOfResidenceCode ?? ""
		var documents: [any BoardingDocument] = []
		documents += content.travelDocumentsDetail.identificationDocuments.compactMap {
			guard let url = URL(string: $0.documentPhotoUrl) else {
				return nil
			}
			
			return switch DocumentType(code: $0.documentTypeCode) {
			case .passport:
				Passport($0, photo: url, residenceCountryCode: countryCode)
				
			default:
				nil
			}
		}
		
		documents += content.travelDocumentsDetail.visaInfoList.compactMap {
			guard let url = URL(string: $0.documentPhotoUrl) else {
				return nil
			}
			
			return Visa($0, photo: url)
		}
		
		return documents
	}
	
	func reload(_ sailor: Endpoint.SailorAuthentication) async throws {
		self.content = try await sailor.fetch(Endpoint.GetTravelDocumentTask(reservation: sailor.reservation))
		startInterview()
	}

    var fieldErrors: [PassportField: String] = [:]

/*
	func remove(document: any BoardingDocument) {
		documents.removeAll {
			$0.id == document.id
		}
	}
	
	func update(document: any BoardingDocument, photoUrl: URL) -> Step {
		switch document {
		case let passport as Passport:
			passport.photo = .url(photoUrl)
			self.documents += [passport]
			
		case let visa as Visa:
			visa.photo = .url(photoUrl)
			self.documents += [visa]
			
		default:
			break
		}		
		
		if completed {
			return postVoyageIsRequired && content.postCruiseInfo == nil ? .postVoyage(.init(content: content.postCruiseInfo)) : .review(reviewPage())
		} else {
			return .choose(choosePage(mode: .secondary))
		}
	}
*/
}

extension TravelDocumentTask {
	struct LandingPage {
		var title: String
		var description: String
		
		init(content: Endpoint.GetSailAssets.Response.TravelDocuments.LandingPageData, countryOfCitizenship: String) {
			title = content.title
			description = content.description.replacingOccurrences(of: "{Nationality}", with: countryOfCitizenship)
		}
	}
	
	struct ReviewPage {
		var title: String
		var description: String
		var imageUrl: URL?
		var postVoyageRowTitle: String
		var postVoyageRowDescription: String
		var documents: [any BoardingDocument]
		
		init(content: Endpoint.GetSailAssets.Response.TravelDocuments, country: String?, documents: [any BoardingDocument]) {
			self.title = content.finalDocumentsReviewPage.title
			self.description = content.finalDocumentsReviewPage.description
			self.imageUrl = URL(string: content.finalDocumentsReviewPage.imageURL)
			self.postVoyageRowTitle = content.postVoyagePage.title
			self.postVoyageRowDescription = content.labels.stayPostVoaygeText.replacingOccurrences(of: "{country}", with: country ?? "country")
			self.documents = documents
		}
	}
	
	struct ModalPage {
		var title: String
		var description: String
		var document: Endpoint.GetTravelDocumentTask.Response.TravelDocumentsDetail.Document
		var documentType: Endpoint.GetLookupData.Response.LookupData.DocumentType
		
		init(page: Endpoint.GetSailAssets.Response.TravelDocuments.DocumentModalData, document: Endpoint.GetTravelDocumentTask.Response.TravelDocumentsDetail.Document, documentTypes: [Endpoint.GetLookupData.Response.LookupData.DocumentType]) throws {
						
			let documentType = documentTypes.first {
				$0.code == document.documentTypeCode
			}
			
			guard let documentType else {
				throw Endpoint.Error("Unknown document type")
			}
					
			self.title = page.title
			self.description = page.description.replacingOccurrences(of: "{document}", with: documentType.name.lowercased())
			self.document = document
			self.documentType = documentType
		}
	}
	
	struct CapturePage {
		var title: String
		var description: String
		var question: String
		var takePhoto: String = "Take photo"
		var uploadPhoto: String = "Upload from Photos"
		var documentType: DocumentType
		var entryPermitFor: String
        var answerModal: Endpoint.GetSailAssets.Response.TravelDocuments.DocumentScan.AnswerModal
        var documentErrorData: Endpoint.GetSailAssets.Response.TravelDocuments.DocumentErrorData

		init(page: Endpoint.GetSailAssets.Response.TravelDocuments.DocumentScan, documentName: String, documentType: DocumentType, entryPermitFor: String, documentErrorData: Endpoint.GetSailAssets.Response.TravelDocuments.DocumentErrorData) {
			// let documentName = documentType.name
			title = page.title.replacingOccurrences(of: "{Document}", with: documentName)
			description = page.description.replacingOccurrences(of: "{Document}", with: documentName)
			question = page.dontHaveLinkText.replacingOccurrences(of: "{document}", with: documentName)
			self.documentType = documentType
			self.entryPermitFor = entryPermitFor
            answerModal = page.answerModal
            self.documentErrorData = documentErrorData
		}
	}
	
	struct ChoosePage {
		var title: String
		var description: String
		var question: String
		var documentTypes: [DocumentType]

		init(content: Endpoint.GetTravelDocumentTask.Response, page: Endpoint.GetSailAssets.Response.TravelDocuments.ChooseDocumentsStagePage, mode: DocumentMode) {
			let modeName = mode.name.lowercased()
			title = page.title.replacingOccurrences(of: "{stage}", with: modeName)
			description = page.description.replacingOccurrences(of: "{stage}", with: modeName)
			question = page.question

			documentTypes = switch mode {
			case .primary:
				content.primaryDocumentOptions.compactMap { option in
					DocumentType(code: option.documentTypeCode)
				}
			case .secondary:
				content.additionalDocumentsOptions.compactMap { option in
					if option.documentTypeCode == "V" {
						return DocumentType(entryPermitForVisa: option.entryPermitFor)
					}
					
					return DocumentType(code: option.documentTypeCode)
				}
			}
		}
		
		var primaryDocumentType: DocumentType? {
			if let type = documentTypes.first {
				return type
			}
            return nil
		}

        var hasMultipleDocuments: Bool {
            documentTypes.count > 1 ? true : false
        }
	}
	
	enum DocumentMode {
		case primary
		case secondary
		
		var name: String {
			switch self {
			case .primary: "primary"
			case .secondary: "secondary"
			}
		}
	}
	
	enum DocumentPhoto {
		case data(Data, ImageType)
		case url(URL)
		
		var isSaved: Bool {
			switch self {
			case .data:
				false
			case .url:
				true
			}
		}
		
		var url: URL? {
			switch self {
			case .url(let url):
				url
			case .data:
				nil
			}
		}
	}
	
	struct DocumentScan {
		var content: Endpoint.GetTravelDocumentData.Response
		var imageData: Data
		var imageType: ImageType
		var type: DocumentType
	}

	enum DocumentType: Identifiable, CaseIterable, Equatable {
		case alienResidentCard
		case birthCertificate
		case certificateOfNaturalization
		case driverLicense
		case electronicSystemForTravelAuthorization
		case electronicTravelAuthority
		case enhancedDriversLicense
		case euIDCard
		case fastCard
		case globalEntryCard
		case governmentIssuedID
		case nexusCard
		case passport
		case passportCard
		case permanentResidentCard
		case profilePhoto
		case securityPhoto
		case stateIssuedID
		case usVisa
		case visa(String)
		
		var id: String {
			switch self {
			case .alienResidentCard: "ARC"
			case .birthCertificate: "BC"
			case .certificateOfNaturalization: "CON"
			case .driverLicense: "DL"
			case .electronicSystemForTravelAuthorization: "ESTA"
			case .electronicTravelAuthority: "ETA"
			case .enhancedDriversLicense: "EDL"
			case .euIDCard: "EUID"
			case .fastCard: "FAST"
			case .globalEntryCard: "GLOENT"
			case .governmentIssuedID: "GOVISSID"
			case .nexusCard: "NEXUS"
			case .passport: "P"
			case .passportCard: "PPC"
			case .permanentResidentCard: "PRC"
			case .profilePhoto: "PP"
			case .securityPhoto: "SP"
			case .stateIssuedID: "STISSID"
			case .usVisa: "USVISA"
			case .visa: "V"
			}
		}
		
		static var visaCode: String {
			Self.visa("ES").id
		}
		
		static var allCases: [DocumentType] {
			return [
				.alienResidentCard,
				.birthCertificate,
				.certificateOfNaturalization,
				.driverLicense,
				.electronicSystemForTravelAuthorization,
				.electronicTravelAuthority,
				.enhancedDriversLicense,
				.euIDCard,
				.fastCard,
				.globalEntryCard,
				.governmentIssuedID,
				.nexusCard,
				.passport,
				.passportCard,
				.permanentResidentCard,
				.profilePhoto,
				.securityPhoto,
				.stateIssuedID,
				.usVisa,
				.visa("ES")
			]
		}

		init?(code: String) {
			for type in DocumentType.allCases {
				if type.id == code {
					self = type
					return
				}
			}
			
			return nil
		}
		
		init(entryPermitForVisa: String) {
			self = Self.visa(entryPermitForVisa)
		}

		var name: String {
			switch self {
			case .alienResidentCard: "Alien Resident Card"
			case .birthCertificate: "Birth Certificate"
			case .certificateOfNaturalization: "Certificate of Naturalization"
			case .driverLicense: "Driver License"
			case .electronicSystemForTravelAuthorization: "Electronic System for Travel Authorization"
			case .electronicTravelAuthority: "Electronic Travel Authority"
			case .enhancedDriversLicense: "Enhanced Drivers License"
			case .euIDCard: "EU ID Card"
			case .fastCard: "Fast Card"
			case .globalEntryCard: "Global Entry Card"
			case .governmentIssuedID: "Government Issued ID"
			case .nexusCard: "Nexus Card"
			case .passport: "Passport"
			case .passportCard: "Passport Card"
			case .permanentResidentCard: "Permanent Resident Card"
			case .profilePhoto: "Profile Photo"
			case .securityPhoto: "Security Photo"
			case .stateIssuedID: "State Issued ID"
			case .usVisa: "US Visa"
			case .visa: "Visa"
			}
		}

		var path: String {
			switch self {
			case .alienResidentCard: "alienresidentcard"
			case .birthCertificate: "birthcertificate"
			case .certificateOfNaturalization: "certificateofnaturalization"
			case .driverLicense: "driverlicense"
			case .electronicSystemForTravelAuthorization: "electronicsystemfortravelauthorization"
			case .electronicTravelAuthority: "electronictravelauthority"
			case .enhancedDriversLicense: "enhanceddriverslicense"
			case .euIDCard: "euidcard"
			case .fastCard: "fastcard"
			case .globalEntryCard: "globalentrycard"
			case .governmentIssuedID: "governmentissuedid"
			case .nexusCard: "nexuscard"
			case .passport: "passport"
			case .passportCard: "passportcard"
			case .permanentResidentCard: "permanentresidentcard"
			case .profilePhoto: "profilephoto"
			case .securityPhoto: "securityphoto"
			case .stateIssuedID: "stateissuedid"
			case .usVisa: "usvisa"
			case .visa: "visa"
			}
		}
	}
	
	protocol BoardingDocument {
		var id: UUID { get }
		var number: String { get }
		var expiryDate: Date { get } // "July 26 2020"
		var type: DocumentType { get }
		var photo: DocumentPhoto { get }
		var mode: DocumentMode { get set }
	}
	
	@Observable class Passport: BoardingDocument {
		init(_ scan: DocumentScan) {
			let response = scan.content
			number = response.number ?? ""
			surname = response.surname ?? ""
			givenName = response.givenName ?? ""
			gender = response.gender ?? ""
			birthCountryCode = response.birthCountryCode ?? ""
			issueCountryCode = response.issueCountryCode ?? ""
			birthDate = response.birthDate?.dateStyle(.travelDocument) ?? .now
			issueDate = response.issueDate?.dateStyle(.travelDocument) ?? .now.addingTimeInterval(100) // Default date should be invalid (in future)
			expiryDate = response.expiryDate?.dateStyle(.travelDocument) ?? .now
			countryOfResidenceCode = ""
			photo = .data(scan.imageData, scan.imageType)
			mode = .primary
		}
		
		init(_ response: Endpoint.GetTravelDocumentTask.Response.TravelDocumentsDetail.Document, photo url: URL, residenceCountryCode: String) {
			number = response.number
			surname = response.surname
			givenName = response.givenName
			gender = response.gender
			birthCountryCode = response.birthCountryCode ?? ""
			issueCountryCode = response.issueCountryCode
			birthDate = response.birthDate.dateStyle(.travelDocument) ?? .now
            issueDate = response.issueDate.dateStyle(.travelDocument) ?? .now.addingTimeInterval(100) // Default date should be invalid (in future)
			expiryDate = response.expiryDate.dateStyle(.travelDocument) ?? .now
			countryOfResidenceCode = residenceCountryCode
			photo = .url(url)
			mode = .primary
		}
		
		let id = UUID()
		var mode: DocumentMode
		var number: String // "37698001"
		var surname: String // "Jones"
		var givenName: String // "David Robert"
		var gender: String // "M"
//		var nationalityCountryCode: String // "UK"
		var birthCountryCode: String // "UK"
		var issueCountryCode: String // "EN"
		var birthDate: Date // "July 26 2013"
		var issueDate: Date // "July 26 2013"
		var expiryDate: Date // "July 26 2020"
		var countryOfResidenceCode: String
		let type: DocumentType = .passport
		var photo: DocumentPhoto
	}

	@Observable class Visa: BoardingDocument {
		init(_ scan: DocumentScan, permitCountryCode: String) {
			let response = scan.content
			number = response.number ?? ""
			surname = response.surname ?? ""
			givenName = response.givenName ?? ""
			issueCountryCode = response.issueCountryCode ?? ""
			typeCode = ""
			issueDate = response.issueDate?.dateStyle(.travelDocument) ?? .now
			expiryDate = response.expiryDate?.dateStyle(.travelDocument) ?? .now
			entriesCode = ""
			photo = .data(scan.imageData, scan.imageType)
			mode = .secondary
			type = .visa(permitCountryCode)
			self.permitCountryCode = permitCountryCode
		}
		
		init(_ response: Endpoint.GetTravelDocumentTask.Response.TravelDocumentsDetail.Visa, photo url: URL) {
			number = response.number
			surname = response.surname
			givenName = response.givenName
			issueCountryCode = response.issueCountryCode
			typeCode = response.typeCode ?? ""
			issueDate = response.issueDate.dateStyle(.travelDocument) ?? .now
			expiryDate = response.expiryDate.dateStyle(.travelDocument) ?? .now
			entriesCode = response.entriesCode ?? ""
			photo = .url(url)
			mode = .secondary
			permitCountryCode = response.issuedFor
			type = .visa(response.issuedFor)
		}
		
		let id = UUID()
		var mode: DocumentMode
		var permitCountryCode: String
		var number: String // "37698001"
		var surname: String // "Jones"
		var givenName: String // "David Robert"
		var issueCountryCode: String // "UK"
		var typeCode: String // "B-1"
		var issueDate: Date // "July 26 2020"
		var expiryDate: Date // "July 26 2020"
		var entriesCode: String // "SINGLE"
		let type: DocumentType
		var photo: DocumentPhoto
	}

	@Observable class ESTA: BoardingDocument {
		init(_ scan: DocumentScan, mode: DocumentMode) {
			let response = scan.content
			number = response.number ?? ""
			expiryDate = response.expiryDate?.dateStyle(.travelDocument) ?? .now
			photo = .data(scan.imageData, scan.imageType)
			self.mode = mode
		}
		
		let id = UUID()
		var mode: DocumentMode
		var number: String
		var expiryDate: Date
		let type: DocumentType = .electronicSystemForTravelAuthorization
		var photo: DocumentPhoto
	}
	
	@Observable class PostVoyage {
		init(content: Endpoint.GetTravelDocumentTask.Response.PostCruiseInfo?) {
			residenceName = content?.residenceName ?? ""
			addressTypeCode = content?.addressInfo?.addressTypeCode ?? ""
			streetNumber = content?.addressInfo?.line1 ?? ""
			streetName = content?.addressInfo?.line2 ?? ""
			city = content?.addressInfo?.city ?? ""
			stateCode = content?.addressInfo?.stateCode ?? ""
			zip = content?.addressInfo?.zip ?? ""
			countryCode = content?.addressInfo?.countryCode ?? ""
			
			airport = ""
			airline = content?.flightDetails?.airlineCode ?? ""
			flightNumber = content?.flightDetails?.number ?? ""
			
			if let staying = content?.isStayingIn {
				stayingMode = staying ? .staying : .leaving
			}
			
			if let travelCode = content?.transportationTypeCode {
				travelMode = switch travelCode {
				case "AIR": .air
				case "LAND": .land
				case "WATER": .sea
				default: nil
				}
			
			}
		}

		// Post-Voyage Staying
		var stayingMode: Mode?
		var residenceName: String // "diamond florist"
		var addressTypeCode: String // "HOME"
		var streetNumber: String // "L-10"
		var streetName: String // "Gloden Lane"
		var city: String // "chicago"
		var stateCode: String // "AK"
		var zip: String // "301221"
		var countryCode: String // "US"
		
		// Post-Voyage Leaving
		var travelMode: LeavingOption.Travel?
		var residenceMode: StayingOption.Residence?
		var airport: String
		var airline: String
		var flightNumber: String
		
		enum Mode {
			case staying
			case leaving
		}
		
		struct StayingOption: Identifiable {
			var id: String
			var type: Residence
			var name: String
			var order: Int
			
			enum Residence {
				case hotel
				case home
				case other
			}
		}
		
		struct LeavingOption: Identifiable {
			var id: String
			var type: Travel
			var name: String
			
			enum Travel {
				case air
				case sea
				case land
			}
		}
	}
	
	enum Step {
		case capture(CapturePage)
		case choose(ChoosePage)
		case knownCitizenship(LandingPage)
		case unknownCitizenship
		case notReady
		case selectSaved(ModalPage)
		case postVoyage(PostVoyage)
		case passport(Passport)
		case visa(Visa)
		case saving(String, Double)
		case review(ReviewPage)
	}
}

extension Endpoint.SailorAuthentication {
	func expiryDateError(date: Date) -> String? {
		if date < reservation.startDate {
			return "Pasport expires pre voyage"
		}
		
		if date < reservation.endDate {
			return "Pasport expires during voyage"
		}
		
		return nil
	}
	
	func passportSaveDisabled(passport: TravelDocumentTask.Passport) -> Bool {
		if expiryDateError(date: passport.expiryDate) != nil {
			return true
		}

        if passport.givenName.isEmptyOrWhitespace || passport.surname.isEmptyOrWhitespace || passport.number.isEmptyOrWhitespace || passport.issueCountryCode.isEmptyOrWhitespace || passport.countryOfResidenceCode.isEmptyOrWhitespace || passport.gender.isEmptyOrWhitespace {
            return true
        }

        if isFutureDate(date: passport.issueDate) != nil || isFutureDate(date: passport.birthDate) != nil {
            return true
        }
		return false
	}

    func isFutureDate(date: Date) -> String? {
        if date > .now {
            return "Please enter a valid date"
        }
        return nil
    }
	
	func scan(photo: Data, documentType: TravelDocumentTask.DocumentType) async throws -> TravelDocumentTask.DocumentScan {
		let content = try await fetch(Endpoint.GetTravelDocumentData(photoData: photo, documentType: documentType, reservation: reservation))
		return .init(content: content, imageData: photo, imageType: .jpeg, type: documentType)
	}
	
	func fetchMediaUrl(photo: TravelDocumentTask.DocumentPhoto) async throws -> URL {
		switch photo {
		case .data(let data, let type):
			return try await uploadData(Endpoint.UploadMediaItem(imageData: data, imageType: type))
			
		case .url(let url):
			return url
		}
	}

    @discardableResult
    func validate(passport: TravelDocumentTask.Passport, mediaUrl: URL) async throws -> Endpoint.ValidateTravelDocumentTask.Response? {
        let response = try await fetch(Endpoint.ValidateTravelDocumentTask(passport: passport, photoUrl: mediaUrl, reservation: reservation))
        return response
    }

	@discardableResult func save(passport: TravelDocumentTask.Passport, mediaUrl: URL) async throws -> Endpoint.GetReadyToSail.UpdateTask {
		let response = try await fetch(Endpoint.UpdateTravelDocumentTask(passport: passport, photoUrl: mediaUrl, reservation: reservation))
		if let error = response.fieldErrors?.fieldErrors.first {
			// throw Endpoint.Error(error.errorMessage)
		}
		
		return response
	}
	
	@discardableResult func delete(passport: TravelDocumentTask.Passport) async throws -> Endpoint.GetReadyToSail.UpdateTask? {
		guard let url = passport.photo.url else {
			return nil
		}
		
		return try await fetch(Endpoint.UpdateTravelDocumentTask(passport: passport, photoUrl: url, delete: true, reservation: reservation))
	}
	
	@discardableResult func save(visa: TravelDocumentTask.Visa, mediaUrl: URL) async throws -> Endpoint.GetReadyToSail.UpdateTask {
		let response = try await fetch(Endpoint.UpdateTravelDocumentTask(visa: visa, photoUrl: mediaUrl, reservation: reservation), debug: true)
		if let error = response.fieldErrors?.fieldErrors.first {
			// throw Endpoint.Error(error.errorMessage)
		}
		
		return response
	}
	
	@discardableResult func delete(visa: TravelDocumentTask.Visa) async throws -> Endpoint.GetReadyToSail.UpdateTask? {
		guard let url = visa.photo.url else {
			return nil
		}
		
		return try await fetch(Endpoint.UpdateTravelDocumentTask(visa: visa, photoUrl: url, delete: true, reservation: reservation))
	}
	
	@discardableResult func save(postVoyage: TravelDocumentTask.PostVoyage, travel: TravelDocumentTask) async throws -> Endpoint.GetReadyToSail.UpdateTask {
		guard let travelMode = postVoyage.travelMode else {
			throw Endpoint.Error("No transportation option selected")
		}
		
		let transportationOption = travel.leavingOptions.first {
			$0.type == travelMode
		}
		
		guard let transportationOption else {
			throw Endpoint.Error("No transportation mode")
		}
				
		let isStayingIn = postVoyage.stayingMode == .staying
		var request = Endpoint.UpdateTravelDocumentTask.Request.PostCruiseInfo(transportationTypeCode: transportationOption.id, isStayingIn: isStayingIn)
		if transportationOption.type == .air {
			request.flightDetails = .init(number: postVoyage.flightNumber, airlineCode: postVoyage.airline, departureAirportCode: postVoyage.airport)
		}
		
		return try await fetch(Endpoint.UpdateTravelDocumentTask(postVoyage: request, reservation: reservation))
	}
}

extension TravelDocumentTask {
    func rejectedReasonsText(from ids: [String]) -> [String] {
        return rejectionReasons
                .filter { ids.contains($0.rejectionReasonId) }
                .map { $0.name }
    }
}

extension TravelDocumentTask {
    enum PassportField: String {
        case givenName = "givenName"
        case surname = "surname"
        case number = "number"
        case issueCountryCode = "issueCountryCode"
        case birthDate = "birthDate"
        case issueDate = "issueDate"
        case expiryDate = "expiryDate"
        case countryOfResidenceCode = "countryOfResidenceCode"
        case gender = "gender"
    }
}

extension TravelDocumentTask {
    func countryName(from code: String) -> String {
        self.countries.first { $0.code == code }?.name ?? ""
    }

    func countryCode(from name: String) -> String {
        self.countries.first { $0.name == name }?.code ?? ""
    }

    func genderName(from code: String) -> String {
        self.lookup.genders.first { $0.code == code }?.name ?? ""
    }

    func genderCode(from name: String) -> String {
        self.lookup.genders.first { $0.name == name }?.code ?? ""
    }

}
