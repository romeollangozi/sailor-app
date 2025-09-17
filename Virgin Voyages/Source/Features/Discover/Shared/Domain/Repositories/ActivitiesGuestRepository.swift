//
//  ActivitiesGuestRepository.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 10/14/24.
//

protocol ActivitiesGuestRepositoryProtocol {
	func fetchActivitiesGuestList() async -> Result<[ActivitiesGuest], VVDomainError>
    func fetchActivitiesGuests() async throws -> [ActivitiesGuest]?
    func fetchActivitiesGuestListV2(reservationGuestId: String) async throws -> [ActivitiesGuest]
}

class ActivitiesGuestRepository: ActivitiesGuestRepositoryProtocol {

    let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol = NetworkService.create()) {
        self.networkService = networkService
    }

	func fetchActivitiesGuestList() async -> Result<[ActivitiesGuest], VVDomainError> {
		if let reservationGuestID = try? AuthenticationService.shared.currentSailor().reservation.reservationGuestId {
			let apiResult = await networkService.fetchActivitiesGuestList(reservationGuestID: reservationGuestID)
            if let networkError = apiResult.error {
                return .failure(NetworkToVVDomainErrorMapper.map(from: networkError))
            }

            let result = apiResult.response?.guests?.compactMap { ActivitiesGuest.mapFrom(input: $0) } ?? []
            return .success(result)
		}

        return .success([])
	}

    func fetchActivitiesGuests() async throws -> [ActivitiesGuest]? {
        if let reservationGuestID = try? AuthenticationService.shared.currentSailor().reservation.reservationGuestId {
            let apiResult = await networkService.fetchActivitiesGuestList(reservationGuestID: reservationGuestID)
            if let networkError = apiResult.error {
                throw networkError
            }

            let result = apiResult.response?.guests?.compactMap { ActivitiesGuest.mapFrom(input: $0) } ?? []
            return result
        }
        return []
    }

    func fetchActivitiesGuestListV2(reservationGuestId: String) async throws -> [ActivitiesGuest] {
		guard let response = try await networkService.fetchActivitiesGuestListV2(reservationGuestID: reservationGuestId) else { return [] }

        return response.guests?.compactMap { ActivitiesGuest.mapFrom(input: $0) } ?? []
    }
}

