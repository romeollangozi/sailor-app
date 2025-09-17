//
//  HomePageLandingScreenViewModel.swift
//  Virgin Voyages
//
//  Created by TX on 12.3.25.
//

import Foundation


@Observable class HomeLandingScreenViewModel: BaseViewModel, HomeLandingScreenViewModelProtocol {
    
    var appCoordinator: AppCoordinator = .shared
    var screenState: ScreenState = .loading
    
    private let getHomePageDataUseCase: GetHomePageDataUseCaseProtocol
    private let getSailingModeUseCase: GetSailingModeUseCaseProtocol
    private let getUserLocationShoresideOrShipsideLocationUseCase: GetUserShoresideOrShipsideLocationUseCaseProtocol
	private let currentSailorManager: CurrentSailorManagerProtocol
	private let auhenticationService: AuthenticationServiceProtocol
    private var broadcastService: BroadcastServiceProtocol
	
	var reloadableViewModels: HomeReloadableViewModels = .init()

    var sections: [HomeSection] = []
    var sailingMode: SailingMode = .undefined
    var sailorLocation: SailorLocation = .shore
   
    var yOffset: CGFloat = 0.0
    var headerHeight: CGFloat = 0.0
    
    // Muster drill
    private var musterDrillEventsNotificationService: MusterDrillEventsNotificationService
    private var listenerKey = "HomeLandingScreenViewModel"
    let eventNotificationService: ReservationStatusEventNotificationService

    private let notificationsEventsNotificationService: NotificationsEventNotificationService
    private var broadcastDetectionNotificationService: BroadcastDetectionNotificationService

    
    init(getHomePageDataUseCase: GetHomePageDataUseCaseProtocol = GetHomePageDataUseCase(),
         getSailingModeUseCase: GetSailingModeUseCaseProtocol = GetSailingModeUseCase(),
         getUserLocationShoresideOrShipsideLocationUseCase: GetUserShoresideOrShipsideLocationUseCaseProtocol = GetUserShoresideOrShipsideLocationUseCase(),
         musterDrillEventsNotificationService: MusterDrillEventsNotificationService = .shared,
         notificationsEventsNotificationService: NotificationsEventNotificationService = .shared,
		 currentSailorManager: CurrentSailorManagerProtocol = CurrentSailorManager(),
         eventNotificationService: ReservationStatusEventNotificationService = .shared,
		 auhenticationService: AuthenticationServiceProtocol = AuthenticationService.shared,
         broadcastService: BroadcastServiceProtocol = BroadcastService.shared,
         broadcastDetectionNotificationService: BroadcastDetectionNotificationService = .shared
    ) {
        self.getHomePageDataUseCase = getHomePageDataUseCase
        self.getSailingModeUseCase = getSailingModeUseCase
        self.getUserLocationShoresideOrShipsideLocationUseCase = getUserLocationShoresideOrShipsideLocationUseCase
        self.musterDrillEventsNotificationService = musterDrillEventsNotificationService
        self.notificationsEventsNotificationService = notificationsEventsNotificationService
        self.currentSailorManager = currentSailorManager
        self.eventNotificationService = eventNotificationService
		self.auhenticationService = auhenticationService
        self.broadcastService = broadcastService
        self.broadcastDetectionNotificationService = broadcastDetectionNotificationService

        super.init()
        self.startObservingEvents()
    }
    
    func onAppear() {
		Task {
			await loadSailingMode()
		}
    }
	
	func onRefresh() {
		Task {
			await loadSailingMode()
		}
	}
    
    func loadSailorLocation() {
        let sailorLocation = getUserLocationShoresideOrShipsideLocationUseCase.execute()
        self.sailorLocation = sailorLocation
        
        if self.sailorLocation == .ship {
            startBroadcasting()
        }
    }
    
    private func startBroadcasting() {
        broadcastService.startBroadcasting()
    }

    private func loadSailingMode() async {
        if let result = await executeUseCase({
            try await self.getSailingModeUseCase.execute()
        }) {
			await executeOnMain {
				self.sailingMode = result
                self.isVisibleTabBar()
			}
            await loadHomePageData(forSailingMode: self.sailingMode)
        } else {
			await executeOnMain {
				self.screenState = .error
			}
        }
    }
    
    private func loadHomePageData(forSailingMode: SailingMode) async {
        if let result = await executeUseCase({
            try await self.getHomePageDataUseCase.execute(forSailingMode: forSailingMode)
        }) {
			await executeOnMain {
				self.sections = result.sections
				self.screenState = .content
				self.loadSailorLocation()
				self.reloadableViewModels.reload(sections: sections, sailingMode: forSailingMode)
			}
        } else {
			await executeOnMain {
				self.screenState = .error
			}
        }
    }

    private func isVisibleTabBar() {
        self.appCoordinator.homeTabBarCoordinator.isTabBarHidden = sailingMode == .postCruise
    }
    
    deinit {
        stopObservingEvents()
    }

    // MARK: - Event Handling

    func stopObservingEvents() {
        musterDrillEventsNotificationService.stopListening(key: listenerKey)
        notificationsEventsNotificationService.stopListening(key: listenerKey)
        broadcastDetectionNotificationService.stopListening(key: listenerKey)
    }
    
    func startObservingEvents() {
        musterDrillEventsNotificationService.listen(key: listenerKey) { [weak self] in
            guard let self else { return }
            self.handleEvent($0)
        }
        notificationsEventsNotificationService.listen(key: listenerKey) { [weak self] in
            guard let self else { return }
            self.handleNotificationEvent($0)
        }
        
        broadcastDetectionNotificationService.listen(key: listenerKey) { [weak self] in
            guard let self else { return }
            self.handleBroadcastingEvent($0)
        }
    }

    func handleEvent(_ event: MusterDrillNotification) {
        switch event {
        case .userDidFinishWatchingMusterDrill, .homeViewDidAppear:
            // Reload all home sections because muster section status is returned from the home/general API
            onRefresh()
        default: break
        }
    }
    
    func handleNotificationEvent(_ event: NotificationsEventNotification) {
        switch event {
        case .shouldUpdateNotificationSection:
            // Reload all home sections because muster section status is returned from the home/general API
            onRefresh()
        }
    }
    
    func handleBroadcastingEvent(_ event: BroadcastDetectionNotification) {
        switch event {
        case .didDetectPeripheralPoweredOn:
            self.startBroadcasting()
        }
    }

    func updateSailorReservation(reservationNumber: String) {
		Task {
			do {
				try await auhenticationService.reloadReservation(reservationNumber: reservationNumber, displayLoadingFlow: true)
				eventNotificationService.publish(.newReservationReceived)
			} catch {
				// Handle error if needed
			}
		}
    }
}

@Observable
class HomeReloadableViewModels {
    var voyageActivitiesViewModel: VoyageActivitiesViewModelProtocol = VoyageActivitiesViewModel()
    var homeCheckInViewModel: HomeCheckInViewModel = HomeCheckInViewModel()
    var homeNotificationsViewModel: HomeNotificationsViewModelProtocol = HomeNotificationsViewModel()
    var homePlannerOnboardViewModel: HomePlannerOnboardViewModelProtocol = HomePlannerOnboardViewModel()

    func reload(sections: [HomeSection] = [], sailingMode: SailingMode) {
        sections.enumerated().forEach { index, section in
            switch section {
            case _ as HomeCheckInSection:
                homeCheckInViewModel.reload(sailingMode: sailingMode)
            case _ as HomeNotificationsSection:
                homeNotificationsViewModel.reload()
            case _ as HomePlannerSection:
                homePlannerOnboardViewModel.reload()
            case _ as VoyageActivitiesSection:
                voyageActivitiesViewModel.reload(sailingMode: sailingMode)
            default:
                break
            }
        }
    }
}

// MARK: - Coordinator Destination Views
extension HomeLandingScreenViewModel {
    
    // MARK: - Navigation helpers (moved from View)

    // MARK: - “Open …” helpers (wrap coordinator commands)
    func openDiningDetails(slug: String, filter: EateriesSlotsInputModel?) {
        appCoordinator.executeCommand(
            HomeDashboardCoordinator.OpenDiningDetailsScreenCommand(slug: slug, filter: filter)
        )
    }

    func openDiningOpeningTimes(filter: EateriesSlotsInputModel) {
        appCoordinator.executeCommand(
            HomeDashboardCoordinator.OpenDiningOpeningTimesCommand(filter: filter)
        )
    }

    func openDiningReceipt(appointmentId: String) {
        appCoordinator.executeCommand(
            HomeDashboardCoordinator.OpenDiningReceiptScreenCommand(appointmentId: appointmentId)
        )
    }

    func openShipSpaceDetails(shipSpaceDetailsItem: ShipSpaceDetails) {
        appCoordinator.executeCommand(
            HomeDashboardCoordinator.OpenShipSpaceDetailsScreenCommand(shipSpaceDetailsItem: shipSpaceDetailsItem)
        )
    }

    func openTreatments(treatmentID: String) {
        appCoordinator.executeCommand(
            HomeDashboardCoordinator.OpenTreatmentsScreenCommand(treatmentID: treatmentID)
        )
    }

    func openTreatmentsReceipt(appointmentID: String) {
        appCoordinator.executeCommand(
            HomeDashboardCoordinator.OpenTreatmentsReceiptScreenCommand(appointmentID: appointmentID)
        )
    }

    func openEventLineUpDetails(event: LineUpEvents.EventItem) {
        appCoordinator.executeCommand(
            HomeDashboardCoordinator.OpenEventLineUpDetailsScreenCommand(event: event)
        )
    }

    func openEventLineUpReceipt(id: String) {
        appCoordinator.executeCommand(
            HomeDashboardCoordinator.OpenEventLineUpDetailsReceiptScreenCommand(id: id)
        )
    }

    func openShoreThingsList(portCode: String, arrivalDateTime: Date?, departureDateTime: Date?) {
        appCoordinator.executeCommand(
            HomeDashboardCoordinator.OpenShoreThingsListScreenCommand(
                portCode: portCode,
                arrivalDateTime: arrivalDateTime,
                departureDateTime: departureDateTime
            )
        )
    }

    func openShoreThingItemDetails(shoreThingItem: ShoreThingItem) {
        appCoordinator.executeCommand(
            HomeDashboardCoordinator.OpenShoreThingItemDetailsScreenCommand(shoreThingItem: shoreThingItem)
        )
    }

    func openShoreThingsReceipt(appointmentId: String) {
        appCoordinator.executeCommand(
            HomeDashboardCoordinator.OpenShoreThingsReceiptScreenCommand(appointmentId: appointmentId)
        )
    }

    
    func navigateBack() {
        appCoordinator.executeCommand(HomeDashboardCoordinator.NavigateBackCommand())
    }
    
    func navigateBack(steps: Int) {
        self.appCoordinator.executeCommand(HomeDashboardCoordinator.NavigateBackForStepsCommand(steps: steps))
    }
    
    func dismissSheet() {
        appCoordinator.executeCommand(HomeDashboardCoordinator.DismissAnySheetCommand())
    }
}

