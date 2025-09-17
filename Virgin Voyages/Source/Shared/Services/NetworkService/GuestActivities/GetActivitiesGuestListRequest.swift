//
//  GetActivitiesGuestListRequest.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 10/11/24.
//

struct GetActivitiesGuestListRequest: AuthenticatedHTTPRequestProtocol {

	var reservationGuestID: String

	var path: String {
		return NetworkServiceEndpoint.getActivitiesGuestList
	}

	var method: HTTPMethod {
		return .POST
	}

	var headers: (any HTTPHeadersProtocol)? {
		return JSONContentTypeHeader()
	}

	init(reservationGuestID: String) {
		self.reservationGuestID = reservationGuestID
	}

	var body: [String : Any]? {
		return ["reservationGuestId": reservationGuestID]
	}
}

struct GetActivitiesGuestListResponse: Decodable {

	struct Guest: Decodable {
		let guestId: String?
		let firstName: String?
		let lastName: String?
		let genderCode: String?
		let email: String?
		let guestName: String?
		let isVip: Bool?
		let age: Int?
		let reservationGuestId: String?
		let reservationNumber: String?
		let profileImageUrl: String?
		let guestTypeCode: String?
		let isCabinMate: Bool?
	}

	var guests: [Guest]?
}

extension NetworkServiceProtocol {
    
    func fetchActivitiesGuestList(reservationGuestID: String) async -> ApiResponse<GetActivitiesGuestListResponse> {
        let request = GetActivitiesGuestListRequest(reservationGuestID: reservationGuestID)
        return await self.request(request, responseModel: GetActivitiesGuestListResponse.self)
    }
    
    func fetchActivitiesGuestListV2(reservationGuestID: String) async throws -> GetActivitiesGuestListResponse? {
        let request = GetActivitiesGuestListRequest(reservationGuestID: reservationGuestID)
        return try await self.requestV2(request, responseModel: GetActivitiesGuestListResponse.self)
    }
}
