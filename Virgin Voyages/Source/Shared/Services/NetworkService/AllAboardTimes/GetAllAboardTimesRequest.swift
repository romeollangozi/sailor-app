//
//  GetAllAboardTimesRequest.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 3/31/25.
//


import Foundation

struct GetAllAboardTimesRequest: AuthenticatedHTTPRequestProtocol {
    let voyageNumber: String

    var path: String {
		return NetworkServiceEndpoint.allAboardTimes
    }
    
    var method: HTTPMethod {
        return .GET
    }
    
    var headers: (any HTTPHeadersProtocol)? {
        return JSONContentTypeHeader()
    }
    
    var queryItems: [URLQueryItem]? {
        return [
			URLQueryItem(name: "voyagenumber", value: self.voyageNumber),
			URLQueryItem(name: "includeVoyageItinerary", value: "true")
		]
    }
}

struct GetAllAboardTimesResponse: Decodable {
	let allAboardGuestsTimes: [String]

	private enum CodingKeys: String, CodingKey {
		case embedded = "_embedded"
	}

	private enum EmbeddedKeys: String, CodingKey {
		case voyages
	}

	private enum VoyageKeys: String, CodingKey {
		case voyageItineraries
	}

	private enum ItineraryKeys: String, CodingKey {
		case allAboardGuestsTime
	}

	init(from decoder: Decoder) throws {
		var allAboardGuestsTimes = [String]()
		let container = try decoder.container(keyedBy: CodingKeys.self)
		let embedded = try container.nestedContainer(keyedBy: EmbeddedKeys.self, forKey: .embedded)
		var voyages = try embedded.nestedUnkeyedContainer(forKey: .voyages)

		while !voyages.isAtEnd {
			let voyage = try voyages.nestedContainer(keyedBy: VoyageKeys.self)
			var itineraries = try voyage.nestedUnkeyedContainer(forKey: .voyageItineraries)

			while !itineraries.isAtEnd {
				let itinerary = try itineraries.nestedContainer(keyedBy: ItineraryKeys.self)
				if let time = try itinerary.decodeIfPresent(String.self, forKey: .allAboardGuestsTime) {
					allAboardGuestsTimes.append(time)
				}
			}
		}

		self.allAboardGuestsTimes = allAboardGuestsTimes
	}
}

extension NetworkServiceProtocol {
    func getAllAboardTimes(voyageNumber: String) async throws -> GetAllAboardTimesResponse? {
		let request = GetAllAboardTimesRequest(voyageNumber: voyageNumber)
        return try await self.requestV2(request, responseModel: GetAllAboardTimesResponse.self)
    }
}
