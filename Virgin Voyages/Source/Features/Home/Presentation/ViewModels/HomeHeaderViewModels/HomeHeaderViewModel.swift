//
//  HomeHeaderViewModel.swift
//  Virgin Voyages
//
//  Created by TX on 12.3.25.
//

import Foundation

protocol SkeletonLoadable {
    var isLoading: Bool { get set }
}

extension HomeHeaderViewModel {
    struct Labels: HomeHeaderLabelsProtocol {
        let shipTimeTooltipHeader: String
        let shipTimeTooltipDescription: String
    }
}

@Observable
class HomeHeaderViewModel: HomeHeaderViewModelProtocol, SkeletonLoadable {
    
    private var appCoordinator: AppCoordinator = .shared
    
    var header: HomeHeader
    var isLoading: Bool
    var displayMessengerButton: Bool
    var sailingMode: SailingMode
    
    var shouldShowShipTimeTooltip: Bool = false
    // MARK: - Localization manager
    private let localizationManager: LocalizationManagerProtocol
    var labels: HomeHeaderLabelsProtocol
    
    // Track ship time
    var shipTime: String = ""
    private var shipTimeTimer: Timer?
    
	var gangwayOpeningTime: String {
		if !header.gangwayOpeningTime.isEmpty {
			return Date.fromISOString(string: header.gangwayOpeningTime).toHourMinuteDeviceTimeLowercaseMeridiem()
		}
		return "--"
	}
	
	var gangwayClosingTime: String {
		if !header.gangwayClosingTime.isEmpty {
			return Date.fromISOString(string: header.gangwayClosingTime).toHourMinuteDeviceTimeLowercaseMeridiem()
		}
		return "--"
	}
    
    init(header: HomeHeader,
         sailingMode: SailingMode,
         displayMessengerButton: Bool = false,
         isLoading: Bool = false,
         localizationManager: LocalizationManager = LocalizationManager.shared) {
        self.header = header
        self.sailingMode = sailingMode
        self.isLoading = isLoading
        self.displayMessengerButton = displayMessengerButton
        self.localizationManager = localizationManager
        
        self.labels = HomeHeaderViewModel.Labels(
            shipTimeTooltipHeader: localizationManager.getString(for: .shipTimeBottomSheetHeadline),
            shipTimeTooltipDescription: localizationManager.getString(for: .shipTimeBottomSheetDescription)
        )
    }

    func calculateShipTime() {
        
        // Clean up any existing timers
        stopShipTimeCalculation()
        
        guard shouldShowShipInfo && header.shipTimeOffset != -1 else {
            return
        }
        
        // Set initial ship time
        updateShipTime(offset: header.shipTimeOffset)
        
        // Calculate initial delay to align with minute changes
        let calendar = Calendar.current
        let currentSeconds = calendar.component(.second, from: Date())
        let initialDelay = 60 - currentSeconds
        
        // Create a timer that fires once after the initial delay
        Timer.scheduledTimer(withTimeInterval: TimeInterval(initialDelay), repeats: false) { [weak self] _ in
            guard let self = self else { return }
            
            // Update ship time
            self.updateShipTime(offset: self.header.shipTimeOffset)
            
            // Then create a repeating timer that fires every minute
            self.shipTimeTimer = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { [weak self] _ in
                guard let self = self else { return }
                self.updateShipTime(offset: self.header.shipTimeOffset)
            }
            
            // Make sure timer runs even when scrolling
            if let timer = self.shipTimeTimer {
                RunLoop.current.add(timer, forMode: .common)
            }
        }
    }
    
    private func updateShipTime(offset: Int) {
        shipTime = offset.toTimeWithUTCOffsetInMinutes()
    }
    
    private func stopShipTimeCalculation() {
        shipTimeTimer?.invalidate()
        shipTimeTimer = nil
    }
    
    deinit {
        stopShipTimeCalculation()
    }
    
}



//MARK: - Button Actions
extension HomeHeaderViewModel {
    func didTapMessengerButton() {
        appCoordinator.executeCommand(HomeTabBarCoordinator.OpenMessengerScreenCommand())
    }
    
    func didTapBookingRefButton() {
        appCoordinator.executeCommand(HomeTabBarCoordinator.OpenMeScreenCommand())
    }
    
    func didTapCabinNumberButton() {
        appCoordinator.executeCommand(HomeTabBarCoordinator.OpenMeScreenCommand())
    }
    
    func didTapItineraryButton() {
        appCoordinator.executeCommand(HomeDashboardCoordinator.PresentItineraryDetailsSheetCommand())
    }
    
    func didTapShipTimeTooltip() {
        shouldShowShipTimeTooltip = true
    }
    
    func shipTimeTooltipCloseButtonTapped() {
        shouldShowShipTimeTooltip = false
    }
}

extension HomeHeaderViewModel {
    var shouldShowTextContentInHeader: Bool {
        self.sailingMode == .preCruise ||
        self.sailingMode == .preCruiseEmbarkationDay ||
        self.sailingMode == .postCruise
    }
    
    var shouldShowShipInfo: Bool {
        self.sailingMode == .shipBoardEmbarkationDay ||
        self.sailingMode == .shipBoardPortDay ||
        self.sailingMode == .shipBoardSeaDay ||
        self.sailingMode == .shipBoardDebarkationDay
    }
    
    var shouldShowGangwayInShipInfo: Bool {
        self.sailingMode != .shipBoardSeaDay
    }

    var shouldShowGangwayOpenInShipInfo: Bool {
        self.sailingMode != .shipBoardEmbarkationDay &&
        !header.gangwayOpeningTime.isEmpty
    }

    var shouldShowGangwayCloseInShipInfo: Bool {
        self.sailingMode != .shipBoardDebarkationDay &&
        !header.gangwayClosingTime.isEmpty
    }
    
    var shouldShowSingleActionButton: Bool {
        self.sailingMode == .shipBoardEmbarkationDay ||
        self.sailingMode == .shipBoardPortDay ||
        self.sailingMode == .shipBoardSeaDay ||
        self.sailingMode == .shipBoardDebarkationDay
    }
    
    var shouldShowActionButtons: Bool {
        self.sailingMode == .preCruise ||
        self.sailingMode == .preCruiseEmbarkationDay
    }
    
    var shouldShowMessengerButtonInHeader: Bool {
        self.sailingMode != .postCruise
    }
    
    var shouldShowFooterText: Bool {
        self.sailingMode == .postCruise
    }
}
