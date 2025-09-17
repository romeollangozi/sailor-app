//
//  GetAllNotificationsUseCase.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 25.5.25.
//

protocol GetAllNotificationsUseCaseProtocol {
	func execute(page: Int) async throws -> Notifications
}

final class GetAllNotificationsUseCase: GetAllNotificationsUseCaseProtocol {
	private let currentSailorManager: CurrentSailorManagerProtocol
	private let notificationsRepository: NotificationMessagesRepositoryProtocol
	
	init(currentSailorManager: CurrentSailorManagerProtocol = CurrentSailorManager(),
		 notificationsRepository: NotificationMessagesRepositoryProtocol = NotificationMessagesRepository()) {
		self.notificationsRepository = notificationsRepository
		self.currentSailorManager = currentSailorManager
	}
	
	func execute(page: Int) async throws -> Notifications {
		guard let currentSailor = currentSailorManager.getCurrentSailor() else {
			throw VVDomainError.unauthorized
		}

		guard let notifications = try await notificationsRepository.getAllNotifications(voyageNumber: currentSailor.voyageNumber, page: page) else {
			throw VVDomainError.genericError
		}
		
		return notifications
	}
}

