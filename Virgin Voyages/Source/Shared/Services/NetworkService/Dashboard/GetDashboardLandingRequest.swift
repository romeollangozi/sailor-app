//
//  GetDashboardLandingRequest.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 10/24/24.
//

import Foundation

struct GetDashboardLandingRequest: AuthenticatedHTTPRequestProtocol {

	let reservationNumber: String
	let guestId: String

	var path: String {
		return NetworkServiceEndpoint.dashboardLandingPath
	}

	var method: HTTPMethod {
		return .GET
	}

	var headers: (any HTTPHeadersProtocol)? {
		return JSONContentTypeHeader()
	}

	init(reservationNumber: String,
		 guestId: String) {
		self.reservationNumber = reservationNumber
		self.guestId = guestId
	}

	var queryItems: [URLQueryItem]? {
		return [
			.init(name: "reservation-number", value: reservationNumber),
			.init(name: "reservation-guest-id", value: guestId)
		]
	}
}

struct GetDashboardLandingResponse: Decodable {
	var heroSection: HeroSection?
	var voyageTicket: VoyageTicket?
	var musterDrill: MusterDrill?
	var taskList: TaskList?
	var articles: Articles?
	var fact: Fact?
	var isGuestOnBoard: Bool?
	var isVIP: Bool?
	var firstBoardingStartTime: String?
	var isGuestCheckedIn: Bool?
	var isGuestCheckedOut: Bool?
	var externalRefId: String?
	var nextDaySection: NextDaySection?
	var disembarkationHomecoming: DisembarkationHomecoming?
	var crewTask: CrewTask?

	struct CrewTask: Decodable {
		var isEnabled: Bool?
		var isError: Bool?
		var errorImageUrl: String?
		var moduleKey: String?
		var title: String?
		var description: String?
		var travelPartyImageUrls: [String]?
		var navigationLinkText: String?
	}

	struct HeroSection: Decodable {
		var headline: String?
		var title: String?
		var description: String?
		var imageURL: String?
		var videoURL: String?
		var dividerImageURL: String?
	}

	struct VoyageTicket: Decodable {
		var date: String?
		var voyageName: String?
		var portsName: [String]?
		var cabinType: String?
		var cabinNumber: String?
		var deck: String?
		var embarkationDetail: Embarkation?
		var cabinSide: String?

		struct Embarkation: Codable {
			var title: String?
			var timeLabel: String?
			var time: String?
			var locationLabel: String?
			var location: String?
			var buttonText: String?
			var moduleKey: String?
			var coordinate: String?
			var vipLabel: String?
			var placeId: String?
		}
	}

	struct TaskList: Decodable {
		var headerImageUrl: String?
		var title: String?
		var description: String?
		var navIconImageUrl: String?
		var tasksDetail: [TaskDetail]?
		var errorImageUrl: String?

		class TaskDetail: Decodable {
			var thumbnailImageUrl: String?
			var title: String?
			var description: String?
			var moduleKey: String?
			var sequence: Int?
			var isEnabled: Bool?
			var isHealthCheckComplete: Bool?
			var isError: Bool?
			var isFitToTravel: Bool?
			var isCompleted: Bool?
		}
	}

	struct Articles: Decodable {
		var dividerImageUrl: String?
		var headerImageUrl: String?
		var title: String?
		var description: String?
		var cards: [Card]?

		struct Card: Decodable {
			var backgroundImageUrl: String?
			var headline: String?
			var title: String?
			var description: String?
			var actionURL: String?
			var cardType: String?
			var sequence: Int?
		}
	}

	struct Fact: Decodable {
		var pictogramImageUrl: String?
		var title: String?
		var description: String?
		var footerImageURL: String?
	}

	struct MusterDrill: Decodable {
		var linkText: String?
		var subheader: String?
		var imageURL: String?
		var header: String?
		var eyebrow: String?
	}

	struct NextDaySection: Decodable {
	}

	struct DisembarkationHomecoming: Decodable {
		let nextIconURL: String?
		let header: String?
		let description: String?
		let thumbnailURL: String?
		let actionURL: String?
	}
}

extension NetworkServiceProtocol {
	func fetchDashboardLanding(reservationNumber: String, guestId: String) async -> GetDashboardLandingResponse? {
		let fetchDashboardLandingRequest = GetDashboardLandingRequest(reservationNumber: reservationNumber,
																	  guestId: guestId)
		let response = await request(fetchDashboardLandingRequest, responseModel: GetDashboardLandingResponse.self)
		return response.response
	}
}
