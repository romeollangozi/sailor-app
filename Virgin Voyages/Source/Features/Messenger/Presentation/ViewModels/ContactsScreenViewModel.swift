//
//  ContactsScreenViewModel.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 28.10.24.
//

import Foundation
import SwiftUI

protocol ContactsScreenViewModelProtocol: CoordinatorSheetViewProvider {
    var appCoordinator: AppCoordinator { get set }
    var contactsScreenModel: MessengerContactsModel { get set }
    var screenState: ScreenState { get set }
    var selectedOption: CodeOption { get set }
    var qrCodeImage: Data? { get set }
    var showConfirmation: Bool { get set }
    var sailorMateDeepLink: String { get }
    var isEventVisible: Bool { get }
    func onAppear(useCache: Bool)
    func onClick(sailorMate: MessengerContactsModel.ContactItemModel, isSailorMate: Bool)
    func share() async
    func dismissSheetView()
    func showAddAFriendSheet()
    func showMyQRCodeSheet()
}

extension ContactsScreenViewModelProtocol {
    func onAppear() {
        onAppear(useCache: false)
    }
}

@Observable class ContactsScreenViewModel: BaseViewModel, ContactsScreenViewModelProtocol {

	// MARK: - Properties

	var appCoordinator: AppCoordinator
	private var getMessengerContactsUseCase: GetMessengerContactsUseCaseProtocol
	private var socialShareUseCase: SocialShareUseCaseProtocol
	private var friendsEventsNotificationService: FriendsEventsNotificationService
	private var listenerKey = "ContactsScreenViewModel"

	var contactsScreenModel: MessengerContactsModel
	var screenState: ScreenState = .loading
	var selectedOption: CodeOption = .yourCode
	var qrCodeImage: Data?
	var deepLink: String?
	var showConfirmation: Bool = false
	var sailorMateDeepLink: String = ""
	var isEventVisible: Bool = false

	// MARK: - Init

	init(appCoordinator: AppCoordinator = .shared,
		 getMessengerContactsUseCase: GetMessengerContactsUseCaseProtocol = GetMessengerContactsUseCase(),
		 friendsEventsNotificationService: FriendsEventsNotificationService = .shared,
		 screenState: ScreenState = .content,
		 socialShareUseCase: SocialShareUseCaseProtocol = SocialShareUseCase(),
		 qrCodeImage: Data? = nil,
		 deepLink: String? = nil)
	{
		self.appCoordinator = appCoordinator
		contactsScreenModel = MessengerContactsModel.empty()
		self.getMessengerContactsUseCase = getMessengerContactsUseCase
		self.friendsEventsNotificationService = friendsEventsNotificationService
		self.screenState = screenState
		self.qrCodeImage = qrCodeImage
		self.deepLink = deepLink
		self.socialShareUseCase = socialShareUseCase
	}

	deinit {
		stopObservingEvents()
	}

	// MARK: - Event Handling

	func stopObservingEvents() {
		friendsEventsNotificationService.stopListening(key: listenerKey)
	}

	func startObservingEvents() {
		friendsEventsNotificationService.listen(key: listenerKey) { [weak self] in
			guard let self else { return }
			self.handleEvent($0)
		}
	}

	func handleEvent(_ event: FriendsEventNotification) {
		switch event {
		case .friendAdded, .friendRemoved:
			Task { await getContacts(useCache: false) }
		}
	}

	// MARK: - OnAppear

	func onAppear(useCache: Bool) {
		startObservingEvents()

		Task {
			screenState = isFirstLaunch ? .loading : .content
			await getContacts(useCache: useCache)
			isFirstLaunch = false
		}
	}

	private func getContacts(useCache: Bool) async {
		let result = await executeUseCase {
			try await self.getMessengerContactsUseCase.execute(useCache: useCache)
		}

		guard let result else { return }

		contactsScreenModel = result
		screenState = .content
	}

	func onClick(sailorMate: MessengerContactsModel.ContactItemModel, isSailorMate: Bool) {
		let deepLink = DeepLinkGenerator.generate(reservationGuestId: sailorMate.personId, reservationId: sailorMate.reservationId, voyageNumber: contactsScreenModel.user.voyageNumber, name: sailorMate.name)

		appCoordinator.executeCommand(MessengerCoordinator.OpenContactDetailsPage(sailorMate: sailorMate, deepLink: deepLink, isSailorMate: isSailorMate))
	}

	func share() async {
		socialShareUseCase.shareCustomData([contactsScreenModel.shareText, contactsScreenModel.deepLink])
	}

	func destinationView(for sheetRoute: any BaseSheetRouter) -> AnyView {
		guard let messengerSheetRoute = sheetRoute as? MessengerSheetRoute else {
			return AnyView(Text("View route not implemented"))
		}

		switch messengerSheetRoute {
		case .addAFriend:
			return AnyView(
				AddAFriendScreen()
					.onDisappear {
						self.appCoordinator.executeCommand(AddAFriendCoordinator.ResetNavigationRouteCommand())
					}
			)

		case .addAFriendFromDeepLink(contact: let contact):
			return AnyView(AddContactSheet(contact: contact, isFromDeepLink: true, onDismiss: {
				self.dismissSheetView()
			}))

		case .myQRCode:
			return AnyView(
				MyQRCodeView(
					deepLink: contactsScreenModel.deepLink,
					profileImageUrl: contactsScreenModel.user.profileImageUrl,
					shareText: contactsScreenModel.shareText,
					preferredName: contactsScreenModel.user.preferredName,
					qrCodeImageCallback: { (qr, deepLink) in
						self.qrCodeImage = qr
					}
				)
				.onDisappear { [self] in
					onAppear()
				}
			)
		}
	}

	func showAddAFriendSheet() {
		appCoordinator.executeCommand(MessengerCoordinator.ShowAddFriendSheetCommand())
	}

	func showMyQRCodeSheet() {
		appCoordinator.executeCommand(MessengerCoordinator.ShowMyQRCodeSheetCommand())
	}

	func dismissSheetView() {
		appCoordinator.executeCommand(MessengerCoordinator.DismissCurrentSheetCommand())
	}
}
