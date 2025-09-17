//
//  AddContactSheetViewModel.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 2.3.25.
//

import Observation

@Observable class AddContactSheetViewModel: BaseViewModel, AddContactSheetViewModelProtocol {

	private let contact: AddContactData
	private let deepLinkContactDataUseCase: DeepLinkContactDataUseCaseProtocol
	private let addContactUseCase: AddContactUseCaseProtocol
	private let addFriendUseCase: AddFriendUseCaseProtocol
	private let friendsEventsNotificationService: FriendsEventsNotificationService
	private let onDismiss: (() -> Void)

	var deepLinkContactDataModel: DeepLinkContactDataModel
	var allowAttending: Bool
	var screenState: ScreenState = .content
	var addFriendButtonLoading: Bool = false

	init(contact: AddContactData, isFromDeepLink: Bool, onDismiss: @escaping (() -> Void)) {
		self.contact = contact
		self.deepLinkContactDataUseCase = DeepLinkContactDataUseCase(contact: contact, isFromDeepLink: isFromDeepLink)
		self.addContactUseCase = AddContactUseCase()
		self.addFriendUseCase = AddFriendUseCase()
		self.deepLinkContactDataModel = DeepLinkContactDataModel.empty()
		self.friendsEventsNotificationService = FriendsEventsNotificationService()
		self.allowAttending = false
		self.onDismiss = onDismiss
	}

	func onAppear() {
		guard let deepLinkData = deepLinkContactDataUseCase.execute() else {
			return
		}
		self.deepLinkContactDataModel = deepLinkData
	}

	private func addContact() {
		Task {
			await executeUseCase { [self] in
			let result = await self.addContactUseCase.execute(connectionPersonId: self.deepLinkContactDataModel.connectionReservationGuestId, isEventVisibleCabinMates: true)
				switch result {
				default:
					self.addFriendButtonLoading = false
					onDismiss()
				}
			}
		}
	}

	func addFriend() {
		Task {
			self.addFriendButtonLoading = true
			await executeUseCase {
				let result = try await self.addFriendUseCase.execute(connectionReservationId: self.deepLinkContactDataModel.connectionReservationId, connectionReservationGuestId: self.deepLinkContactDataModel.connectionReservationGuestId)

				await self.executeOnMain { [weak self] in
					guard let self = self else { return }
					if result {
						friendsEventsNotificationService.publish(.friendAdded)
						if allowAttending {
							addContact()
						}else {
							self.screenState = .content
							self.addFriendButtonLoading = false
							onDismiss()
						}
					}else {
						self.screenState = .error
					}
				}
			}
		}
	}
}
