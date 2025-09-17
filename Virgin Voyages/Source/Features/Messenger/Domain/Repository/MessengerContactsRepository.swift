//
//  MessengerContactsRepository.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 28.10.24.
//

protocol MessengerContactsRepositoryProtocol {
    func getMessengerContacts(reservationId: String, personId: String, useCache: Bool) async throws -> MessengerContacts?
}

class MessengerContactsRepository: MessengerContactsRepositoryProtocol {
    private let networkService: NetworkServiceProtocol
 
    init(networkService: NetworkServiceProtocol = NetworkService.create()) {
        self.networkService = networkService
    }
    
    func getMessengerContacts(reservationId: String, personId: String, useCache: Bool) async throws -> MessengerContacts? {
		guard let response = try await networkService.getMessengerContacts(reservationId: reservationId, personId: personId, cacheOption: .timedCache(forceReload: !useCache)) else { return nil }
		
		return MessengerContacts.map(from: response)

    }
}
