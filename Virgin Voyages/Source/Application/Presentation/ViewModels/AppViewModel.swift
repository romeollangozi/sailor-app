//
//  AppViewModel.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 8/19/24.
//

import Network
import Foundation
import UIKit

@MainActor
protocol AppViewModelProtocol {
    var shouldShowAppStoreUpdate: Bool  { get set } 
}

@MainActor
@Observable class AppViewModel: BaseViewModelV2, NetworkMonitorObserver, AppViewModelProtocol {

	private let monitor: NetworkMonitor = NetworkMonitor.shared
	private var detectShoresideShipsideUseCase: DetectShoresideShipsideUseCase = DetectShoresideShipsideUseCase()
	private let getUserShoresideOrShipsideLocationUseCase: GetUserShoresideOrShipsideLocationUseCaseProtocol = GetUserShoresideOrShipsideLocationUseCase()
	private var checkShipWiFiConnectivityUseCase: MonitorShipWiFiConnectivityUseCase = MonitorShipWiFiConnectivityUseCase()
    private let getMusterDrillContentUseCase: GetMusterDrillContentUseCaseProtocol
    
    private let authenticationEventNotificationService: AuthenticationEventNotificationService
    private let musterDrillEventsNotificationService: MusterDrillEventsNotificationService
    private let userShoreShipLocationEventsNotificationService: UserShoreShipLocationEventsNotificationService
	private let listeningKey = "AppViewModel"
    
    private let authenticationService: AuthenticationServiceProtocol
	private var syncAllAboardTimesUseCase: SyncAllAboardTimesUseCase = SyncAllAboardTimesUseCase()
	private var syncShipTimeUseCase: SyncShipTimeUseCase = SyncShipTimeUseCase()
	private var syncMyAgendaUseCase: SyncMyAgendaUseCase = SyncMyAgendaUseCase()
	private var syncLineUpUseCase: SyncLineUpUseCase = SyncLineUpUseCase()
    private var fetchShipWiFiConnectivityStateUseCase: FetchShipWiFiConnectivityStateUseCase = FetchShipWiFiConnectivityStateUseCase()
    private var getForceUpdateUseCase: GetForceUpdateUseCaseProtocol
	private var sessionCacheRefresher: SessionCacheRefresherProtocol
    private var motionDetectionService: MotionDetectionServiceProtocol
    private var getUserApplicationStatusUseCase: GetUserApplicationStatusUseCaseProtocol
    private var deepLinkNotificationDispatcher: DeepLinkNotificationDispatcherProtocol
    private var deepLinkJSONEncoder: DeepLinkJSONEncoderProtocol
    private var userApplicationStatus: UserApplicationStatus?

    let errorHandlingViewModel: ErrorHandlerViewModel
    let pushNotificationService: PushNotificationService
    
    var appStoreInfo: AppStoreInfo? = nil
    var shouldShowAppStoreUpdate: Bool = false
    var appCoordinator: AppCoordinator

    init (getUserApplicationStatusUseCase: GetUserApplicationStatusUseCaseProtocol = GetUserApplicationStatusUseCase(),
          deepLinkNotificationDispatcher: DeepLinkNotificationDispatcherProtocol = DeepLinkNotificationDispatcher(),
          deepLinkJSONEncoder: DeepLinkJSONEncoderProtocol = DeepLinkJSONEncoder(),
          motionDetectionService: MotionDetectionServiceProtocol = MotionDetectionService.shared,
          errorHandlingViewModel: ErrorHandlerViewModel = ErrorHandlerViewModel(errorService: ErrorService.shared),
          pushNotificationService: PushNotificationService? = nil,
          getMusterDrillContentUseCase: GetMusterDrillContentUseCaseProtocol = GetMusterDrillContentUseCase(),
          authenticationEventNotificationService: AuthenticationEventNotificationService = .shared,
          musterDrillEventsNotificationService: MusterDrillEventsNotificationService = .shared,
          userShoreShipLocationEventsNotificationService: UserShoreShipLocationEventsNotificationService = .shared,
		  authenticationService: AuthenticationServiceProtocol = AuthenticationService.shared,
          fetchShipWiFiConnectivityStateUseCase: FetchShipWiFiConnectivityStateUseCase = FetchShipWiFiConnectivityStateUseCase(),
          getForceUpdateUseCase: GetForceUpdateUseCaseProtocol = GetForceUpdateUseCase(),
		  sessionCacheRefresher: SessionCacheRefresherProtocol = SessionCacheRefresher(),
          appCoordinator: AppCoordinator = .shared) {
        
        self.errorHandlingViewModel = errorHandlingViewModel
        self.pushNotificationService = pushNotificationService ?? PushNotificationService(provider: FirebasePushNotificationService.shared)
        self.getMusterDrillContentUseCase = getMusterDrillContentUseCase
        self.authenticationEventNotificationService = authenticationEventNotificationService
        self.musterDrillEventsNotificationService = musterDrillEventsNotificationService
        self.userShoreShipLocationEventsNotificationService = userShoreShipLocationEventsNotificationService
        self.authenticationService = authenticationService
        self.fetchShipWiFiConnectivityStateUseCase = fetchShipWiFiConnectivityStateUseCase
        self.getForceUpdateUseCase = getForceUpdateUseCase
		self.sessionCacheRefresher = sessionCacheRefresher
        self.appCoordinator = appCoordinator
        self.motionDetectionService = motionDetectionService
        self.getUserApplicationStatusUseCase = getUserApplicationStatusUseCase
        self.deepLinkNotificationDispatcher = deepLinkNotificationDispatcher
        self.deepLinkJSONEncoder = deepLinkJSONEncoder
        
        super.init()
        setupNetworkMonitor()
        
        // If user is logged out and loggs in while muster drill is happening,
        // we need to listen to the event in order to check for mustering on AppView and present the the view if muster.mode != "None".
        startListeningToEvents()
    }
    
	private func setupNetworkMonitor() {
		monitor.addObserver(self)
	}
    
	func networkStatusChanged() {
		Task {
			await refreshUserSessionData()
		}
	}
    
    func onAppear() {
        checkForAppStoreUpdate()
        if isFirstLaunch {
            navigationCoordinator.calculateCurrentScreenFlow()
        }
    }

	func appDidBecomeActive() {
        checkForAppStoreUpdate()
        musterDrillEventsNotificationService.publish(.shouldRestartMusterDrillVideo)
        motionDetectionService.startMotionDetection()
		Task {
			await refreshUserSessionData()
		}
	}
    
    func preloadUserApplicationStatus() async {
        do {
            let status = try await getUserApplicationStatusUseCase.execute()
            self.userApplicationStatus = status
        } catch {
            print("userApplicationStatus not correct: \(error)")
        }
    }
    
    func handleExternalURL(url: URL) {
        
        if authenticationService.isLoggedIn() {
            let result = deepLinkJSONEncoder.encodeExternalURLLink(url: url.absoluteString)
            
            Task { [weak self] in
                await self?.handleExternalURLNavigation(type: result.type,
                                                        data: result.jsonString)
            }
            
        } else {
            print("Handle user not loged-in")
        }
        
    }
    
    func handleExternalURLNavigation(type: String, data: String) async {
        if let status = userApplicationStatus {
            deepLinkNotificationDispatcher.dispatch(userStatus: status,
                                                    type: type,
                                                    data: data)
        } else {
            // If user is not loaded, wait to load userAppStatus, then Handle notification action again
            await preloadUserApplicationStatus()
            await handleExternalURLNavigation(type: type, data: data)
        }
    }

	func refreshUserSessionData() async {

		await detectShoresideShipsideUseCase.execute()

        
        // TODO: this needs to be removed.
        // this was a temp fix to avoid the issue for event background to foreground causing re-rendering of content view.
		try? await authenticationService.reloadOnlyTheCurrentSailor()

		await checkShipWiFiConnectivityUseCase.execute() { [weak self] in
            guard let self else { return }
            self.connectivityDidChange()
		}

		let sailorLocation = getUserShoresideOrShipsideLocationUseCase.execute()

        // Trigger reservation related synchronization only if there is a reservation
        if authenticationService.isLoggedIn() && authenticationService.userHasReservation() {
            await syncShipTimeUseCase.execute()
            try? await syncAllAboardTimesUseCase.execute()
            try? await syncMyAgendaUseCase.execute()
            try? await syncLineUpUseCase.execute()
            
            if sailorLocation == .ship {
                await checkMusterDrillMode()
            }
        }
    }
    
    
    private func connectivityDidChange() {
        // Ship WiFi connectivity did change from
    }
    
	func appDidBecomeInactive() {

        // disconnectFromWebSocket()
         motionDetectionService.stopMotionDetection()
	}
        
    private func checkMusterDrillMode() async {
        if let musterDrillResult = await executeUseCase({ try await self.getMusterDrillContentUseCase.execute() }) {
            print("checkMusterDrillMode - musterDrillResult: \n", musterDrillResult)
			if musterDrillResult.mode == .important {
				// User has not watched the video OR muster drill mode is emergency
				let musterDrillRemainsOpenAfterUserHasWatchedVideo = !musterDrillResult.video.guest.status
				self.appCoordinator.executeCommand(HomeTabBarCoordinator.ShowMusterDrillFullScreenCommand(shouldRemainOpenAfterUserHasWatchedSafteyVideo: musterDrillRemainsOpenAfterUserHasWatchedVideo))
			} else if musterDrillResult.mode == .info {
				// User has watched safety video
				self.appCoordinator.executeCommand(HomeTabBarCoordinator.ShowMusterDrillFullScreenCommand(shouldRemainOpenAfterUserHasWatchedSafteyVideo: false))
			} else {
				// Muster drill should not be presented
				self.appCoordinator.executeCommand(HomeTabBarCoordinator.DismissMusterDrillFullScreenCommand())
			}

			// Triggers muster drill view to reload its content, if presented
			musterDrillEventsNotificationService.publish(.shouldRefreshMusterDrill)
        }
    }

    
    private func startListeningToEvents() {
        musterDrillEventsNotificationService.listen(key: listeningKey) { [weak self] in
            guard let self else { return }
            self.handleMusterDrillEvent(event: $0)
        }
        
        userShoreShipLocationEventsNotificationService.listen(key: listeningKey) { [weak self] in
            guard let self else { return }
            self.handleSailorLocationEvent(event: $0)
        }
        
        authenticationEventNotificationService.listen(key: listeningKey) { [weak self] in
            guard let self else { return }
            self.handleAuthenticationServiceEvents(event: $0)
        }
    }
    
    private func checkForMusterDrillOnNewUserLogin() {
        let sailorLocation = getUserShoresideOrShipsideLocationUseCase.execute()
        if sailorLocation == .ship {
            Task {
                await checkMusterDrillMode()
            }
        }
    }
    
    private func handleMusterDrillEvent(event: MusterDrillNotification) {
        switch event {
        case .homeViewDidAppear:
            checkForMusterDrillOnNewUserLogin()
        default: break
        }
    }
    
    private func handleSailorLocationEvent(event: UserShoreShipLocationEventNotification) {
        switch event {
        case .userDidSwitchFromShoreToShip:
            Task {
                try? await authenticationService.reloadReservation(reservationNumber: nil, displayLoadingFlow: true)
            }
        default: break
        }
    }
    
    private func handleAuthenticationServiceEvents(event: AuthenticationEventNotification) {
        switch event {
        case .shouldRecalculateApplicationScreenFlow:
            appCoordinator.calculateCurrentScreenFlow()
        default: break
        }
    }
    
    
    func checkForAppStoreUpdate() {
		guard authenticationService.isLoggedIn() else {
			return
		}
        Task {
            if let appStoreInfo = try? await getForceUpdateUseCase.execute(),
               appStoreInfo.hasUpdates {
				showAlertForAppUpdate()
            }
        }
    }
    
    func openAppStore() {
        if let appID = appStoreInfo?.appID, let url = URL(string: "itms-apps://itunes.apple.com/app/id\(appID)") {
            UIApplication.shared.open(url)
        }
    }
    
    private func showAlertForAppUpdate() {
        shouldShowAppStoreUpdate = true
    }
    
    deinit {
        musterDrillEventsNotificationService.stopListening(key: listeningKey)
        userShoreShipLocationEventsNotificationService.stopListening(key: listeningKey)
        authenticationEventNotificationService.stopListening(key: listeningKey)
    }
}

