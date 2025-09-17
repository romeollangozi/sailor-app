//
//  MainViewViewModel.swift
//  Virgin Voyages
//
//  Created by TX on 11.2.25.
//

import Foundation
import Observation
import SwiftUI
import VVUIKit

protocol MainViewViewModelProtocol: CoordinatorSheetViewProvider, DeepLinkHandlingViewModel {
	var showShakeForChampagne: Bool { get set }
	var isOfflineModePortDay: Bool { get }
	var showConnectToWiFiScreen: Bool { get set }
    var statusBannerNotifications: [StatusBannersNotifications.StatusBannersNotificationItem] { get set }
    var appCoordinator: AppCoordinator { get set }
	func onAppear()
    func navigate(to screen: MainViewScreen)
	func openReactNativeApp()
	func showConnectToWiFi()
    func resetSelectedTabState()
    func trackShoreThings()
    func dismissSheet()
    func publishEventsOnHomeViewDidAppear()
    func getStatusBannerNotifications()
    func handleNotificationTap(statusBanerNotificationItem: StatusBannersNotifications.StatusBannersNotificationItem)
    func deleteOneNotification(notificationId: String, completion: (() -> Void)?)
}

@Observable class MainViewViewModel: BaseViewModel, MainViewViewModelProtocol {

	var showShakeForChampagne: Bool = false

	var isOfflineModePortDay: Bool = false

	var showConnectToWiFiScreen: Bool = false
    
    var statusBannerNotifications: [StatusBannersNotifications.StatusBannersNotificationItem] = []
    
    var deepLinkNotificationDispatcher: DeepLinkNotificationDispatcherProtocol
    var getUserApplicationStatusUseCase: GetUserApplicationStatusUseCaseProtocol
    var userApplicationStatus: UserApplicationStatus?
    
	private let currentSailorManager: CurrentSailorManagerProtocol
	private let checkShipWiFiConnectivityUseCase: MonitorShipWiFiConnectivityUseCase
	private let fetchShipWiFiConnectivityStateUseCase: FetchShipWiFiConnectivityStateUseCase = FetchShipWiFiConnectivityStateUseCase()
	private let openReactNativeAppUseCase: OpenReactNativeAppUseCaseProtocol

    var appCoordinator: AppCoordinator
    var currentDeepLink: DeepLinkType?
    let quantumMetricService: QuantumMetricServiceProtocol

    private var musterDrillEventsNotificationService: MusterDrillEventsNotificationService
	private var bookingEventsNotificationService: BookingEventsNotificationService
    
    private var motionDetectionService: MotionDetectionServiceProtocol
    private var motionDetectionNotificationService: MotionDetectionNotificationService
    private let shakeForChampagneEventsNotificationService: ShakeForChampagneEventsNotificationService
    
    private var listenerKey = "MainViewViewModel"
	
	private let getMyVoyageAgendaUseCase: GetMyVoyageAgendaUseCaseProtocol
	private let getLineUpUseCase: GetLineUpUseCaseProtocol
    private let statusBannersNotificationsUseCase: StatusBannersNotificationsUseCaseProtocol
    private let deleteOneNotificationUseCase: DeleteOneNotificationUseCaseProtocol
	
    init(
        deepLinkNotificationDispatcher: DeepLinkNotificationDispatcherProtocol = DeepLinkNotificationDispatcher(),
        getUserApplicationStatusUseCase: GetUserApplicationStatusUseCaseProtocol = GetUserApplicationStatusUseCase(),
        motionDetectionService: MotionDetectionServiceProtocol = MotionDetectionService.shared,
        motionDetectionNotificationService: MotionDetectionNotificationService = .shared,
		currentSailorManager: CurrentSailorManagerProtocol = CurrentSailorManager(),
		checkShipWiFiConnectivityUseCase: MonitorShipWiFiConnectivityUseCase = MonitorShipWiFiConnectivityUseCase(),
		fetchShipWiFiConnectivityStateUseCase: FetchShipWiFiConnectivityStateUseCase = FetchShipWiFiConnectivityStateUseCase(),
		currentDeepLink: DeepLinkType? = nil,
		appCoordinator: AppCoordinator = .shared,
		quantumMetricService: QuantumMetricServiceProtocol = QuantumMetricService.create(),
        musterDrillEventsNotificationService: MusterDrillEventsNotificationService = .shared,
		bookingEventsNotificationService: BookingEventsNotificationService = .shared,
		getMyVoyageAgendaUseCase: GetMyVoyageAgendaUseCaseProtocol = GetMyVoyageAgendaUseCase(),
		getLineUpUseCase: GetLineUpUseCaseProtocol = GetLineUpUseCase(),
		openReactNativeAppUseCase: OpenReactNativeAppUseCaseProtocol = OpenReactNativeAppUseCase(),
        statusBannersNotificationsUseCase: StatusBannersNotificationsUseCaseProtocol = StatusBannersNotificationsUseCase(),
        deleteOneNotificationUseCase: DeleteOneNotificationUseCaseProtocol = DeleteOneNotificationUseCase(),
        shakeForChampagneEventsNotificationService: ShakeForChampagneEventsNotificationService = .shared
	) {
        self.deepLinkNotificationDispatcher = deepLinkNotificationDispatcher
        self.getUserApplicationStatusUseCase = getUserApplicationStatusUseCase
        self.motionDetectionService = motionDetectionService
        self.motionDetectionNotificationService = motionDetectionNotificationService
		self.currentSailorManager = currentSailorManager
		self.checkShipWiFiConnectivityUseCase = checkShipWiFiConnectivityUseCase
        self.currentDeepLink = currentDeepLink
        self.appCoordinator = appCoordinator
        self.quantumMetricService = quantumMetricService
        self.musterDrillEventsNotificationService = musterDrillEventsNotificationService
		self.bookingEventsNotificationService = bookingEventsNotificationService
		self.getMyVoyageAgendaUseCase = getMyVoyageAgendaUseCase
		self.getLineUpUseCase = getLineUpUseCase
		self.openReactNativeAppUseCase = openReactNativeAppUseCase
        self.statusBannersNotificationsUseCase = statusBannersNotificationsUseCase
        self.deleteOneNotificationUseCase = deleteOneNotificationUseCase
        self.shakeForChampagneEventsNotificationService = shakeForChampagneEventsNotificationService
        
        super.init()
        
        self.startObservingEvents()
    }

	func openReactNativeApp() {
		openReactNativeAppUseCase.execute()
	}

    func navigate(to screen: MainViewScreen) {
        self.appCoordinator.homeTabBarCoordinator.selectedTab = screen
    }
    
    func handleDeepLink(deepLink: DeepLinkType?) {
        guard let deepLink else { return }
        switch deepLink {
        case .messengerScreen:
            self.appCoordinator.homeTabBarCoordinator.selectedTab = .messenger
        default: break
        }
    }
    
    func resetSelectedTabState() {
        if self.currentDeepLink == nil {
            self.appCoordinator.homeTabBarCoordinator.selectedTab = .dashboard
			self.appCoordinator.homeTabBarCoordinator.homeDashboardCoordinator.navigationRouter.goToRoot(animation: false)
        }
    }
    
    func trackShoreThings() {
        let event: QMEvent = (id: 1, value: "buttonTapped_shorething")
        quantumMetricService.trackEvent(event: .buttonTapped(event: event))
    }

	func onAppear() {
        
        self.motionDetectionService.startMotionDetection()
        self.startObservingEvents()
        
		Task {
			await executeUseCase { [self] in
				await self.checkShipWiFiConnectivityUseCase.execute {
					Task {
						await self.connectivityDidChange()
					}
				}
			}
		}
        publishEventsOnHomeViewDidAppear()
        getStatusBannerNotifications()
	}

    func publishEventsOnHomeViewDidAppear() {
        // Trigger mustering call, which happens on AppViewModel.
        musterDrillEventsNotificationService.publish(.homeViewDidAppear)
    }
    
	@MainActor
	func connectivityDidChange() {
		let state = fetchShipWiFiConnectivityStateUseCase.execute()
		showConnectToWiFiScreen = state.shouldShowConnectToWiFi
		isOfflineModePortDay = state.isOfflineModePortDay
	}

	func showConnectToWiFi() {
		showConnectToWiFiScreen = true
	}
    
    func getStatusBannerNotifications() {
        
        Task { [weak self] in
            
            guard let self else { return }
            
            if let result = await executeUseCase({
                
                try await self.statusBannersNotificationsUseCase.execute()
                
            }) {
                
                let displayNotifications = result.display
                let deleteNotifications = result.delete
                
                deleteNotifications.forEach { notification in
                    self.deleteOneNotification(notificationId: notification.id)
                }
                
                await executeOnMain {
                    self.statusBannerNotifications = displayNotifications
                }
            }
        }
    }
    
    func deleteOneNotification(notificationId: String, completion: (() -> Void)? = nil) {
        
        Task { [weak self] in
            
            guard let self else { return }
            
            if let _ = await executeUseCase({
                try await self.deleteOneNotificationUseCase.execute(notificationId: notificationId)
            }) {
                
                await executeOnMain {
                    completion?()
                }
                
            }
            
        }
        
    }

    deinit {
        stopObservingEvents()
    }

    // MARK: - Event Handling

    func stopObservingEvents() {
        shakeForChampagneEventsNotificationService.stopListening(key: listenerKey)
        motionDetectionNotificationService.stopListening(key: listenerKey)
        bookingEventsNotificationService.stopListening(key: listenerKey)
    }
    
    func startObservingEvents() {
        
        shakeForChampagneEventsNotificationService.listen(key: listenerKey) { [weak self] in
            guard let self else { return }
            handleShakeForChampagneEvent($0)
        }
        
        motionDetectionNotificationService.listen(key: listenerKey) { [weak self] in
            guard let self else { return }
            handleMotionDetectionEvent($0)
        }
        		
		bookingEventsNotificationService.listen(key: listenerKey) { [weak self] event in
			guard let self else { return }
			self.handleBookingEvent(event)
		}
    }
    
    func handleShakeForChampagneEvent(_ event: ShakeForChampagneEventNotification) {
        switch event {
        case .didDetectShakeForChampagneDelivered:
            self.getStatusBannerNotifications()
        }
    }
    
    func handleMotionDetectionEvent(_ event: MotionDetectionNotification) {
        switch event {
        case .didDetectMotion:
            self.appCoordinator.executeCommand(HomeTabBarCoordinator.ShowShakeForChampagneAnimationFullScreenCommand(orderId: nil))
        }
    }
	
	private func handleBookingEvent(_ event: BookingEventNotification) {
		switch event {
		case .userDidMakeABooking, .userDidUpdateABooking, .userDidCancelABooking:
			Task {
				//Refresh cacche for my agenda
				try? await getMyVoyageAgendaUseCase.execute(useCache: false)
			}
			
			Task {
				//Refresh cacche for line ups
				try? await getLineUpUseCase.execute(useCache: false)
			}
		}
	}
}

// MARK: - Navigation
extension MainViewViewModel {
    func destinationView(for sheetRoute: any BaseSheetRouter) -> AnyView {
        guard let homeTabBarSheetRoute = sheetRoute as? HomeSheetRoute else { return AnyView(Text("View for path not implemented"))}
        
        switch homeTabBarSheetRoute {
        case .addAFriend:
            return AnyView(
                AddAFriendScreen()
                    .onDisappear {
                        self.appCoordinator.executeCommand(AddAFriendCoordinator.ResetNavigationRouteCommand())
                    }
            )
        }
    }
    
    func dismissSheet() {
        appCoordinator.executeCommand(HomeTabBarCoordinator.DismissAnySheetCommand())
    }
}

// MARK: Notifications & Deeplinking

extension MainViewViewModel {
    
    func preloadUserApplicationStatus() async {
        do {
            let status = try await getUserApplicationStatusUseCase.execute()
            self.userApplicationStatus = status
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func handleNotificationTap(statusBanerNotificationItem: StatusBannersNotifications.StatusBannersNotificationItem) {
        
        Task { [weak self] in
            
            guard let self else { return }
            
            if let status = userApplicationStatus {
                
                self.deepLinkNotificationDispatcher.dispatch(userStatus: status,
                                                             type: statusBanerNotificationItem.type,
                                                             data: statusBanerNotificationItem.data)
                
            } else {
                
                await self.preloadUserApplicationStatus()
                self.handleNotificationTap(statusBanerNotificationItem: statusBanerNotificationItem)
            }
        }
        
    }
    
}
