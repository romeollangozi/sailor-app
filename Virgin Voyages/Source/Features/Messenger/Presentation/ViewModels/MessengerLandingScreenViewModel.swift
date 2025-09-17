//
//  MessengerLandingScreenViewModel.swift
//  Virgin Voyages
//
//  Created by Timur Xhabiri on 18.10.24.
//

import Foundation
import SwiftUI

protocol MessengerLandingScreenViewModelProtocol: CoordinatorNavitationDestinationViewProvider {
    var appCoordinator: AppCoordinator { get set }
    func destinationView(for navigationRoute: any BaseNavigationRoute) -> AnyView

    var landingScreenModel: MessengerLandingScreenModel { get set }
    var screenState: ScreenState { get set }
    var isRefreshing: Bool { get set } // Used only on notifications card and not for the whole screen.
    var isSailorShip: Bool { get } // Used only on notifications card and not for the whole screen.
    var sailorType: SailorType { get }
    
    func onAppear()
    func refresh() async
    func notificationMessagesHaveChanged(shouldUpdate: Bool)
    func sailorServicesButtonTapped()
}


@Observable class MessengerLandingScreenViewModel: BaseViewModel, MessengerLandingScreenViewModelProtocol {
    var appCoordinator: AppCoordinator

    var screenState: ScreenState = .loading
    var landingScreenModel: MessengerLandingScreenModel = .init()
    var isRefreshing = false
    var isSailorShip: Bool = false
    var sailorType: SailorType = .standard
    
    private var messengerLandingScreenUseCase: MessengerLandingScreensUseCaseProtocol
    private let getSailorShoreOrShipUseCase: GetSailorShoreOrShipUseCaseProtocol
    private var getSailorTypeUseCase: GetSailorTypeUseCaseProtocol
    private var chatPollingService: ChatPollingServiceProtocol

    init(appCoordinator: AppCoordinator = .shared,
         messengerLandingScreenUseCase: MessengerLandingScreensUseCaseProtocol = MessengerLandingScreensUseCase(),
         getSailorShoreOrShipUseCase: GetSailorShoreOrShipUseCaseProtocol = GetSailorShoreOrShipUseCase(),
         getSailorTypeUseCase: GetSailorTypeUseCaseProtocol = GetSailorTypeUseCase(),
         chatPollingService: ChatPollingServiceProtocol = ChatPollingService.shared
    ) {
        self.appCoordinator = appCoordinator
        self.messengerLandingScreenUseCase = messengerLandingScreenUseCase
        self.getSailorShoreOrShipUseCase = getSailorShoreOrShipUseCase
        self.getSailorTypeUseCase = getSailorTypeUseCase
        
        self.chatPollingService = chatPollingService
        
        super.init()
        
        self.startChatPollingIfNeeded()
    }

    // MARK: Public API

    func onAppear() {
        startChatPollingIfNeeded()
    }
    
    func refresh() async {
        screenState = isFirstLaunch ? .loading : .content
        
        let result = await messengerLandingScreenUseCase.execute()
        switch result {
        case let .success(content):
            finishLoading(with: .content, content: content)
        case let .failure(failure):
            print("Error - failure : ", failure.localizedDescription)
            finishLoading(with: .error, content: landingScreenModel)
        }
        
        let shoreOrSail = await executeUseCase {
            self.getSailorShoreOrShipUseCase.execute()
        }
        
        if let shoreOrSail = shoreOrSail {
            await executeOnMain {
                self.isSailorShip = shoreOrSail.isOnShip
            }
        }
        
        let sailorType = await executeUseCase {
            self.getSailorTypeUseCase.execute()
        }
        
        if let sailorType = sailorType {
            await executeOnMain {
                self.sailorType = sailorType
            }
        }
        await executeOnMain {
            isFirstLaunch = false
        }
    }
    
    // MARK: Private Methods
    
    private func finishLoading(with state: ScreenState, content: MessengerLandingScreenModel) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            // Sort array
            self.landingScreenModel = content
            // Update Screen State
            self.isRefreshing = false
            self.screenState = state
        }
    }

    func notificationMessagesHaveChanged(shouldUpdate: Bool) {
        guard shouldUpdate else { return }
        // refresh the screen and show spinner on notifications card.
        isRefreshing = true
        Task {
            await refresh()
        }
    }

    func destinationView(for navigationRoute: any BaseNavigationRoute) -> AnyView {
        guard let messengerNavigationRoute = navigationRoute as? MessengerNavigationRoute else { return AnyView(Text("View not supported")) }
        switch messengerNavigationRoute {
        case let .contacts(link: deepLink):
            return AnyView(
                ContactsScreen(viewModel: ContactsScreenViewModel(deepLink: deepLink), back: {
                    self.appCoordinator.homeTabBarCoordinator.messengerCoordinator.navigationRouter.navigateBack()
                })
                .navigationBarHidden(true)
            )
        case let .contactDetails(contactItem: contactItem, deepLink: deepLink, isSailorMate: isSailorMate):
            return AnyView(
                ContactConfirmationView.create(
					viewModel: ContactConfirmationViewModel(qrCodeInput: deepLink, sailorProfileImage: contactItem.photoUrl, allowAttending: contactItem.isEventVisible, isSailorMate: isSailorMate),
                    toolbarButtonStyle: .backButton,
                    back: {
                        self.appCoordinator.homeTabBarCoordinator.messengerCoordinator.navigationRouter.navigateBack()
                    }, closeScanner: {
                        self.appCoordinator.homeTabBarCoordinator.messengerCoordinator.navigationRouter.navigateBack()
                    }, onAllowAttendingChange: { _ in
                        // TODO: handle onAllowAttendingChange response
                    }, onContactDeleted: {
                        self.appCoordinator.homeTabBarCoordinator.messengerCoordinator.navigationRouter.navigateBack()
                    }
                )
                .navigationBarHidden(true)
            )
        case let .chatThread(chatThread: chatThread):
            return AnyView(
                ChatThreadMessagesScreen(chatThread: chatThread)
                    .navigationBarHidden(true)
            )
		case .contactList:
			return AnyView(
				ContactsScreen(viewModel: ContactsScreenViewModel(), back: {
					self.appCoordinator.homeTabBarCoordinator.messengerCoordinator.navigationRouter.navigateBack()
				}).navigationBarHidden(true)
			)
        }
    }
    
    // MARK: - Polling Management

    private func startChatPollingIfNeeded() {
        guard isSailorShip else {
            print("MessengerLandingScreenViewModel - chat service will not start on shore")
            return
        }
        guard !chatPollingService.isPollingActive else {
            print("MessengerLandingScreenViewModel - chat service is allready polling")
            return
        }

        Task {
            do {
                try await chatPollingService.startPolling()
            } catch {
                // We ignore polling errors from UI
                print("MessengerLandingScreenViewModel - Failed to start polling: \(error)")
            }
        }
    }
    
    func sailorServicesButtonTapped() {
        // Sending empty thread for newly initiated sailor service chat.
        let chatType = ChatType.sailorServices
        let thread = ChatThread.init(id: "", title: chatType.title, unreadCount: 0, isClosed: false, type: chatType, description: chatType.description, lastMessageTime: nil, imageURL: nil)
        appCoordinator.executeCommand(MessengerCoordinator.OpenChatThreadsCommand(chatThread: thread))
    }
}

// MARK: Mock View Model

@Observable class MockMessengerLandingViewModel: MessengerLandingScreenViewModelProtocol {
    var appCoordinator: AppCoordinator = .init()

    var screenState: ScreenState = .content
    var landingScreenModel: MessengerLandingScreenModel = .mock()
    var isRefreshing = false
    var sailorType: SailorType = .standard

    private var usecase: MessengerLandingScreensUseCase = .init()

    var isSailorShip: Bool = true
    
    func onAppear() {}
    
    func refresh() async {
        let result = await usecase.execute()
        switch result {
        case let .success(content):
            landingScreenModel = content
            screenState = .content
        case .failure:
            screenState = .error
        }
    }

    func destinationView(for navigationRoute: any BaseNavigationRoute) -> AnyView {
        return AnyView(Text("Destionation view for \(navigationRoute)"))
    }
    
    func notificationMessagesHaveChanged(shouldUpdate _: Bool) {}
    
    func sailorServicesButtonTapped() {}
}
