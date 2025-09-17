//
//  ContentViewModel.swift
//  Virgin Voyages
//
//  Created by Timur Xhabiri on 12.11.24.
//

import Foundation
import UIKit

protocol ContentViewViewModelProtocol: BaseViewModel, DeepLinkHandlingViewModel {
    var errorHandlingViewModel: ErrorHandlerViewModel { get set }
    var notificationService: PushNotificationServiceProtocol { get set }
	var shouldShowWifiSheet: Bool { get set }

    // MARK: ViewModel functions
    func onAppear()
    func onDisappear()

    // MARK: Notification handling
    func preloadUserApplicationStatus() async
    func handleNotificationTap(notification: PushNotificationModel) async
    
    // MARK: Subviews view models
    var landingScreenViewModel: LandingScreenViewModelProtocol { get set }
    var mainViewViewModel: MainViewViewModelProtocol { get set }
    
    // MARK: Shared DataModel API
    var authenticationService: AuthenticationServiceProtocol { get set }
    func showWifiSheet()
}

@Observable class ContentViewViewModel: BaseViewModel, ContentViewViewModelProtocol {

    var notificationService: PushNotificationServiceProtocol
    var errorHandlingViewModel: ErrorHandlerViewModel
    var getUserApplicationStatusUseCase: GetUserApplicationStatusUseCaseProtocol
    var registerDeviceTokenUseCase: RegisterDeviceTokenUseCaseProtocol

    var authenticationService: AuthenticationServiceProtocol = AuthenticationService.shared
    var deepLinkNotificationDispatcher: DeepLinkNotificationDispatcherProtocol
    
    var landingScreenViewModel: LandingScreenViewModelProtocol
    var mainViewViewModel: MainViewViewModelProtocol
    var createBeaconUseCase: CreateBeaconUseCaseProtocol
    var clearBeaconUseCase: ClearBeaconUseCaseProtocol
    
    var currentDeepLink: DeepLinkType? = nil
    var userApplicationStatus: UserApplicationStatus?

    private let notificationsEventsNotificationService: PushNotificationsEventNotificationService
    private let authenticationEventNotificationService: AuthenticationEventNotificationService
    private var foregroundObserver: NSObjectProtocol?

    private var listenerKey = "ContentViewViewModel"
	var shouldShowWifiSheet: Bool = false

	private let currentSailorManager: CurrentSailorManagerProtocol

    init(
        errorHandlingViewModel: ErrorHandlerViewModel,
        notificationService: PushNotificationServiceProtocol,
        getUserApplicationStatusUseCase: GetUserApplicationStatusUseCaseProtocol = GetUserApplicationStatusUseCase(),
        registerDeviceTokenUseCase: RegisterDeviceTokenUseCaseProtocol = RegisterDeviceTokenUseCase(),
		authenticationService: AuthenticationServiceProtocol = AuthenticationService.shared,
        landingScreenViewModel: LandingScreenViewModelProtocol,
        mainViewViewModel: MainViewViewModelProtocol,
        notificationsEventsNotificationService: PushNotificationsEventNotificationService = PushNotificationsEventNotificationService.shared,
        authenticationEventNotificationService: AuthenticationEventNotificationService = .shared,
        deepLinkNotificationDispatcher: DeepLinkNotificationDispatcherProtocol = DeepLinkNotificationDispatcher(),
		currentSailorManager: CurrentSailorManagerProtocol = CurrentSailorManager(),
        createBeaconUseCase: CreateBeaconUseCaseProtocol = CreateBeaconUseCase(),
        clearBeaconUseCase: ClearBeaconUseCaseProtocol = ClearBeaconUseCase()
    ) {
        self.errorHandlingViewModel = errorHandlingViewModel
        self.notificationService = notificationService
        self.getUserApplicationStatusUseCase = getUserApplicationStatusUseCase
        self.registerDeviceTokenUseCase = registerDeviceTokenUseCase
        self.authenticationService = authenticationService
        self.landingScreenViewModel = landingScreenViewModel
        self.mainViewViewModel = mainViewViewModel
        self.notificationsEventsNotificationService = notificationsEventsNotificationService
        self.authenticationEventNotificationService = authenticationEventNotificationService

        self.deepLinkNotificationDispatcher = deepLinkNotificationDispatcher
		self.currentSailorManager = currentSailorManager
        
        self.createBeaconUseCase = createBeaconUseCase
        self.clearBeaconUseCase = clearBeaconUseCase

        super.init()
        self.startObservingEvents()
    }
    
    func onAppear() {
        self.landingScreenViewModel.loadLanding()
        self.registerDeviceTokenForPushNotifications()
        UpdateApptentivePersonDataUseCase().execute()
    }
    
    func onDisappear() { }
    
    deinit {
        stopObservingEvents()
    }

    private func registerDeviceTokenForPushNotifications() {
        Task {
            let _ = await registerDeviceTokenUseCase.execute()
        }
    }
    private func handleDeviceTokenChange(_ token: String) {
        Task {
            let _ = await registerDeviceTokenUseCase.execute()
        }
    }

	func showWifiSheet() {
		shouldShowWifiSheet = true
	}
}

// MARK: - Event Handling
extension ContentViewViewModel {
    func stopObservingEvents() {
        notificationsEventsNotificationService.stopListening(key: listenerKey)
        authenticationEventNotificationService.stopListening(key: listenerKey)
        if let foregroundObserver {
            NotificationCenter.default.removeObserver(foregroundObserver)
            self.foregroundObserver = nil
        }
    }
    
    func startObservingEvents() {
        
        notificationsEventsNotificationService.listen(key: listenerKey) { [weak self] in
            guard let self else { return }
            self.handleEvent($0)
        }
        
        authenticationEventNotificationService.listen(key: listenerKey) { [weak self] in
            guard let self else { return }
            self.handleEvent($0)
        }

        // Update Apptentive person data whenever app returns to foreground
        foregroundObserver = NotificationCenter.default.addObserver(
            forName: UIApplication.willEnterForegroundNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard self != nil else { return }
            UpdateApptentivePersonDataUseCase().execute()
        }
    }
    
    func handleEvent(_ event: PushNotificationsEventNotification) {
        switch event {
        case .deviceTokenHasbeenUpdated(let token):
            self.handleDeviceTokenChange(token)
        }
    }
    
    func handleEvent(_ event: AuthenticationEventNotification) {
        switch event {
        case .userDidLogIn:
            /// Update the main screen flow
            navigationCoordinator.calculateCurrentScreenFlow()
            UpdateApptentivePersonDataUseCase().execute()
            createBeacon()
        case .userDidLogOut:
            navigationCoordinator.calculateCurrentScreenFlow()
            UpdateApptentivePersonDataUseCase().execute()
            clearBeacon()
        case .userDidRegister:
            /// When registered we trigger:
            /// Dismiss SignupSheetWithoutAnimation to reset the state
            /// Update the main screen flow
            navigationCoordinator.executeCommand(SignupCoordinator.DismissSignUpSheetWithoutAnimationCommand())
            navigationCoordinator.calculateCurrentScreenFlow()
            UpdateApptentivePersonDataUseCase().execute()
            createBeacon()
        default: break

        }
    }
    
    private func createBeacon() {
        Task {
            try await createBeaconUseCase.execute(beaconId: nil)
        }
    }
    
    private func clearBeacon() {
        Task {
            try await clearBeaconUseCase.execute()
        }
    }
}


// MARK: Notifications & Deeplinking API
extension ContentViewViewModel {
    
    func preloadUserApplicationStatus() async {
        do {
            let status = try await getUserApplicationStatusUseCase.execute()
            self.userApplicationStatus = status
        } catch {
        }
    }
    
    func handleNotificationTap(notification: PushNotificationModel) async {
        if let status = userApplicationStatus {
            deepLinkNotificationDispatcher.dispatch(userStatus: status,
                                                    type: notification.notificationType,
                                                    data: notification.notificationData)
        } else {
            // If user is not loaded, wait to load userAppStatus, then Handle notification action again
            await preloadUserApplicationStatus()
            await handleNotificationTap(notification: notification)
        }
    }
    
    func handleDeepLink(deepLink: DeepLinkType?) {
        if let deepLink {
            switch deepLink {
            case .loginScreen:
                landingScreenViewModel.currentDeepLink = deepLink
            case .messengerScreen:
                mainViewViewModel.currentDeepLink = deepLink
            default: break
            }
        } else {
            landingScreenViewModel.currentDeepLink = nil
            mainViewViewModel.currentDeepLink = nil
        }
    }
}
