//
//  AddFriendRepository.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 30.10.24.
//

protocol MessengerFriendsRepositoryProtocol {

    func addContacts(reservationId: String, personId: String, connectionPersonId: String, isEventVisibleCabinMates: Bool) async -> Result<EmptyModel, VVDomainError>
    
    func addFriendToContacts(reservationId: String, reservationGuestId: String, connectionResevationId: String, connectionReservationGuestId: String) async throws
    
    func removeFriendFromContacts(reservationId: String, reservationGuestId: String, connectionResevationId: String, connectionReservationGuestId: String) async throws
}

class MessengerFriendsRepository: MessengerFriendsRepositoryProtocol {
    
    private let networkService: NetworkServiceProtocol
    private let friendsEventsNotificationService: FriendsEventsNotificationService
   
    init(networkService: NetworkServiceProtocol = NetworkService.create(), friendsEventsNotificationService: FriendsEventsNotificationService = .shared) {
        self.networkService = networkService
        self.friendsEventsNotificationService = friendsEventsNotificationService
    }
    
    func addContacts(reservationId: String, personId: String, connectionPersonId: String, isEventVisibleCabinMates: Bool) async -> Result<EmptyModel, VVDomainError> {
        let result = await networkService.addContact(request: .init(personId: personId, connectionPersonId: connectionPersonId, isEventVisibleCabinMates: isEventVisibleCabinMates))
        
        if let networkError = result.error {
            return .failure(NetworkToVVDomainErrorMapper.map(from: networkError))
        } else {
			Task {
				await reloadCacheForContacts(reservationId: reservationId, personId: personId)
			}
        }
        
        friendsEventsNotificationService.publish(.friendAdded)

        return .success(.init())
    }
    
    func addFriendToContacts(reservationId: String, reservationGuestId: String, connectionResevationId: String, connectionReservationGuestId: String) async throws {
       
        if (try await networkService.addOrRemoveFriendFromContacts(request:
                .init(
                    isDeleted: false,
                    reservationId: reservationId,
                    personId: reservationGuestId,
                    connectionPersonId: connectionReservationGuestId,
                    connectionReservationId: connectionResevationId)
        )) != nil {
			Task {
				await reloadCacheForContacts(reservationId: reservationId, personId: reservationGuestId)
			}
			
            friendsEventsNotificationService.publish(.friendAdded)
        }
    }
    
    
    func removeFriendFromContacts(reservationId: String, reservationGuestId: String, connectionResevationId: String, connectionReservationGuestId: String) async throws {
        
        if (try await networkService.addOrRemoveFriendFromContacts(request:
                .init(
                    isDeleted: true,
                    reservationId: reservationId,
                    personId: reservationGuestId,
                    connectionPersonId: connectionReservationGuestId,
                    connectionReservationId: connectionResevationId)
        )) != nil {
			Task {
				await reloadCacheForContacts(reservationId: reservationId, personId: reservationGuestId)
			}
            
			friendsEventsNotificationService.publish(.friendRemoved)
        }
    }
	
	private func reloadCacheForContacts(reservationId: String, personId: String) async {
		_ = try? await networkService.getMessengerContacts(reservationId: reservationId, personId: personId, cacheOption: .timedCache(forceReload: true))
	}
}
