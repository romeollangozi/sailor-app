//
//  HomeCheckInViewModel.swift
//  Virgin Voyages
//
//  Created by TX on 17.3.25.
//

import Foundation
import UIKit
import SwiftUI

@Observable
class HomeCheckInViewModel: BaseViewModel, HomeCheckInViewModelProtocol {

    private(set) var section: HomeCheckInSection
    private(set) var sailingMode: SailingMode
    private(set) var screenState: ScreenState = .loading
    
    private let getHomeCheckInUseCase: GetHomeCheckInUseCaseProtocol
    private let getHomeRTSDetailsUseCase: GetHomeRTSDetailsUseCaseProtocol
    private var rtsDetail: TaskDetail?
    private let checkInStatusEventNotificationService: CheckInStatusEventNotificationService
    private let listenerKey = "HomeCheckInViewModel"

	init(section: HomeCheckInSection = .empty(),
		 getHomeCheckInUseCase: GetHomeCheckInUseCaseProtocol = GetHomeCheckInUseCase(),
         getHomeRTSDetailsUseCase: GetHomeRTSDetailsUseCaseProtocol = GetHomeRTSDetailsUseCase(),
         checkInStatusEventNotificationService: CheckInStatusEventNotificationService = .shared) {
		self.section = .empty()
        self.sailingMode = .preCruiseEmbarkationDay
        self.getHomeCheckInUseCase = getHomeCheckInUseCase
        self.getHomeRTSDetailsUseCase = getHomeRTSDetailsUseCase
        self.checkInStatusEventNotificationService = checkInStatusEventNotificationService

		
        super.init()
        self.startObservingEvents()
    }
        
    func onAppear() {

    }
	
	func reload(sailingMode: SailingMode) {
		self.sailingMode = sailingMode
		Task {
			[weak self] in
			guard let self else { return }
			
			await self.loadData()
		}
	}

    func loadData() async {
        if let result = await executeUseCase({
            try await self.getHomeCheckInUseCase.execute()
        }) {
            await executeOnMain {
                self.section = result
                self.screenState = .content
            }
            
            await self.loadRTSDetails()
        } else {
            await executeOnMain {
                self.screenState = .error
            }
        }
    }
    
    func loadRTSDetails() async {
        if let result = await executeUseCase({
            try await self.getHomeRTSDetailsUseCase.execute()
        }) {
            rtsDetail = result
        }
    }
    
    func travelAssistantButtonTapped() {
		navigationCoordinator.executeCommand(HomeDashboardCoordinator.OpenTravelPartyAssistantCommand())
    }
    
    func showRTSView() {
		navigationCoordinator.executeCommand(HomeDashboardCoordinator.ShowReadyToSailFullScreenCoverCommand(taskDetail: rtsDetail, sailor: nil))
    }
    
    func ctaButtonTapped() {
        switch section.rts.status {
        case .OnHold:
            if let url = URL(string: section.rts.paymentNavigationUrl) {
                UIApplication.shared.open(url)
            }
        default:
            showRTSView()
        }
    }
    
    var shouldDisplayCTAInLargeCheckinSection: Bool {
        if section.rts.status == .Closed {
            return false
        } else {
            return true
        }
    }
    
    var shouldDisplayLargeCheckinSection: Bool {
        if section.rts.status == .ModerationIssue ||
            section.rts.status == .Completed {
            return false
        } else {
            return true
        }
    }
    
    var shouldShowErrorIcon: Bool {
        if section.rts.status == .ModerationIssue {
            return true
        } else {
            return false
        }
    }
    
    // MARK: - Embarcation
    
    var isStandardSailorType: Bool {
        section.embarkation.details?.sailorType == .standard
    }
    
    var isPreCruiseEmbarkationDay: Bool {
        sailingMode == .preCruiseEmbarkationDay
    }
    
    var sailorTypeBackgroundColor: Color {
        switch section.embarkation.details?.sailorType {
        case .standard:
            Color.darkRed
        case .priority:
            Color.deepPurple
        case .rockStar, .megaRockStar:
            Color.darkGrayText
        case nil:
            .white
        }
    }
    
    func getLocationURL() -> URL? {
        
        guard let coordinate = section.embarkation.details?.coordinates else { return nil }
        let coordinates = coordinate.components(separatedBy: ",")
        if let latitude = coordinates.first,
           let longitude = coordinates.last,
           let placeId = section.embarkation.details?.placeId,
           let url = URL(string: MapUrls.googleMapsURL(latitude: latitude,
                                                       longitude: longitude,
                                                       placeId: placeId)) {
            
            return url
        } else {
            return nil
        }
    }
    
    func didTapViewBoardingPass() {
		navigationCoordinator.executeCommand(HomeDashboardCoordinator.OpenBoardingPassCommand())
    }
    
    func didTapEmbarcationGuide() {
        
        if let urlString = self.section.embarkation.guide?.navigationUrl,
            let url = URL(string: urlString)  {
            
            UIApplication.shared.open(url)
        }
    }
    
    // MARK: - Health Check
    
    var isHealthCheckAvailable: Bool {
        section.healthCheck.status == .opened || section.healthCheck.status == .completed || section.healthCheck.status == .moderationIssue
    }
    
    var getHealthCheckIconName: String {
        switch section.healthCheck.status {
        case .closed:
            "healthCheckClosed"
        case .opened:
            "healthCheckOpened"
        case .completed:
            "healthCheckCompleted"
        case .moderationIssue:
            "healthCheckIssue"
        case .none:
            ""
        }
    }
    
    func onHealthCheckTapped() {
        guard isHealthCheckAvailable else { return }
		navigationCoordinator.executeCommand(HomeDashboardCoordinator.OpenHealthCheckLandingFullScreenCommand())
    }

    // MARK: - Service Gratuities

    var isServiceGratuitiesAvailable: Bool {
        section.serviceGratuitiesSection.status == .opened
    }

    var getServiceGratuitiesImageURL: String {
        section.serviceGratuitiesSection.imageUrl ?? ""
    }

    func onServiceGratuitiesTapped() {
        guard isServiceGratuitiesAvailable else { return }
        let code = "GRATUITIESPRE"
        navigationCoordinator.executeCommand(HomeTabBarCoordinator.OpenDiscoverAddonDetailsByCodeCommand(addonCode: code))
    }

    func startObservingEvents() {
        checkInStatusEventNotificationService.listen(key: listenerKey) { [weak self] in
            guard let self else { return }
            self.handleEvent($0)
        }
    }
    
    func handleEvent(_ event: CheckInkEventNotification) {
        switch event {
        case .checkInHasChanged:
            Task {
                await loadData()
            }
        }
    }

    func stopObservingEvents() {
        checkInStatusEventNotificationService.stopListening(key: listenerKey)
    }

    deinit {
        stopObservingEvents()
    }
}

extension HomeCheckInViewModel {
    
	static func mockViewModel(healthCheckStatus: HealthCheckTaskStatus = .closed, coordinates: String = "25.78011907532392,-80.1798794875817") -> HomeCheckInViewModel {
        
        HomeCheckInViewModel(
            section:.init(
                id: "123",
                title: "This is the title",
                rts: .init(
                    title: "Ready To Sail",
                    imageUrl: "123",
                    description: "This is the description",
                    status: .Closed,
                    buttonLabel: "Button label",
                    paymentNavigationUrl: "nav url",
                    cabinMate: .init(
                        imageUrl: "url",
                        title: "cabin mate title",
                        description: "cabin mate description")),
                embarkation: .init(imageUrl: "https://example.com/embarkation.jpg",
                                   title: "Embarkation Details Test",
                                   description: "Get ready for a smooth embarkation process test.",
                                   status: .inCompleted,
                                   details: .init(sailorType: .priority,
                                                  title: "Boarding Slot Confirmed",
                                                  imageUrl: "https://example.com/sailor.jpg",
                                                  arrivalSlot: "TBC",
                                                  location: "Port Terminal 3",
                                                  coordinates: coordinates,
                                                  placeId: "ChIJFfjVPFKipBIRHSOvLv8cReQ",
                                                  cabinType: "Balcony",
                                                  cabinDetails: "Deck 7 | Room 7204"),
                                   guide: .init(title: "Embarkation guide",
                                                description: "More information on your voyage embarkation",
                                                navigationUrl: "https://example.com")),
                healthCheck: .init(imageUrl: "https://example.com/health-check.jpg",
                                   title: "Test Health Check",
                                   description: "Test Complete your health declaration before boarding.",
								   status: healthCheckStatus),
				serviceGratuitiesSection: .init(title: "",
												description: "",
												imageUrl: "",
												status: nil)
            ))
    }
}
