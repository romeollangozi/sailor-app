//
//  VoyageActivitiesViewModel.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 3/11/25.
//

import Foundation
import Observation

@Observable class VoyageActivitiesViewModel: BaseViewModel, VoyageActivitiesViewModelProtocol {
    var sectionModel: VoyageActivitiesSection = .init(bookActivities: [],
                                                      exploreActivities: [])
    var screenState: ScreenState = .loading
    
    private var getVoyageActivitiesUseCase: GetVoyageActivitiesContentUseCaseProtocol
    private var sailingMode: String = ""
    
    // MARK: - Init
    init(getVoyageActivitiesUseCase: GetVoyageActivitiesContentUseCaseProtocol = GetVoyageActivitiesContentUseCase()) {
        self.getVoyageActivitiesUseCase = getVoyageActivitiesUseCase
    }
    
    func onAppear() {
		
    }
    
	func reload(sailingMode: SailingMode) {
		self.sailingMode = sailingMode.rawValue
		
		Task { [weak self] in
			guard let self else { return }
			
			await loadPlanAndBook()
		}
	}
	
    // MARK: - Private Methods
    private func loadPlanAndBook() async {
		if let result = await executeUseCase({
			try await self.getVoyageActivitiesUseCase.execute(sailingMode: self.sailingMode)
		}) {
			await executeOnMain {
				self.sectionModel = result
				self.screenState = .content
			}
		}
    }
}

// MARK: - Navigation
extension VoyageActivitiesViewModel {
    func navigateToActivityDetail(for activity: VoyageActivitiesSection.VoyageActivityItem) {
        if let bookableType = activity.bookableType {
            // Book section
            switch bookableType {
            case .eatery:
				navigationCoordinator.executeCommand(HomeDashboardCoordinator.OpenEateriesListScreenCommand())
            case .entertainment:
				navigationCoordinator.executeCommand(HomeDashboardCoordinator.OpenEventLineUpScreenCommand())
            case .shoreExcursion:
				navigationCoordinator.executeCommand(HomeDashboardCoordinator.OpenShoreThingsScreenCommand())
            case .treatment:
				// For treatments, we will open the ShipSpace screen with the specific ship space code
                let code = "Beauty---Body"
				navigationCoordinator.executeCommand(HomeDashboardCoordinator.OpenShipSpaceScreenCommand(shipSpaceCode: code))
            case .addOns:
				navigationCoordinator.executeCommand(HomeTabBarCoordinator.OpenAddonsListCommand())
            case .undefined:
                break
            }
        } else {
            // Explore section
            switch activity.code {
            case "ShipMap":
				navigationCoordinator.executeCommand(HomeDashboardCoordinator.PresentShipMapSheetCommand())
                break
            case "Dining":
				navigationCoordinator.executeCommand(HomeDashboardCoordinator.OpenEateriesListScreenCommand())
            default:
				navigationCoordinator.executeCommand(HomeDashboardCoordinator.OpenShipSpaceScreenCommand(shipSpaceCode: activity.code))
                break
            }
        }
    }
    
    func openAddAFriend() {
		navigationCoordinator.executeCommand(HomeTabBarCoordinator.OpenAddAFriendSheetCommand())
    }
}

// MARK: - Mock ViewModel
struct VoyageActivitiesMockViewModel: VoyageActivitiesViewModelProtocol {
    var screenState: ScreenState = .content
    var sectionModel: VoyageActivitiesSection = VoyageActivitiesSection.sample()
    
	func onAppear() { }
	func reload(sailingMode: SailingMode) {
		
	}
	
	func reload(sailingMode: String) {}
    func navigateToActivityDetail(for activity: VoyageActivitiesSection.VoyageActivityItem) {}
    func openAddAFriend() {}
}
