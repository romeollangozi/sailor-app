//
//  HomeNotificationsRepository.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 11.3.25.
//

protocol HomeNotificationsRepositoryProtocol {
    func fetchHomeNotification(reservationGuestId: String, reservationNumber: String, voyageNumber: String) async throws -> HomeNotificationsSection?
}

final class HomeNotificationsRepository: HomeNotificationsRepositoryProtocol {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService.create()) {
        self.networkService = networkService
    }
    
    func fetchHomeNotification(reservationGuestId: String, reservationNumber: String, voyageNumber: String) async throws -> HomeNotificationsSection? {
        guard let response = try? await networkService.getHomeNotifications(reservationGuestId: reservationGuestId, reservationNumber: reservationNumber, voyageNumber: voyageNumber) else {
            return nil
        }
        return response.toDomain()
    }
}
