//
//  HomeDashboardCoordinator.swift
//  Virgin Voyages
//
//  Created by TX on 13.3.25.
//

import Foundation
import SwiftUI

enum HomeDashboardNavigationRoute: BaseNavigationRoute {
    case landingPage
    case travelPartyAssist
    
    case boardingPass
    
    case eateriesList
    case diningDetails(slug: String, filter: EateriesSlotsInputModel? = nil)
    case diningOpeningTimes(filter: EateriesSlotsInputModel)
	case diningReceipt(appointmentId: String)
	
    case eventLineUp
    case eventLineUpDetails(event: LineUpEvents.EventItem)
    case eventLineUpDetailsReceipt(id: String)

    case shipSpace(String)
    case shipSpaceDetails(ShipSpaceDetails)
    
    case treatment(String)
    case treatmentReceipt(appointmentID: String)
    
    case shoreThings
	case shoreThingsList(portCode: String, arrivalDateTime: Date?, departureDateTime : Date?)
	case shoreThingItemDetails(shoreThingItem: ShoreThingItem)
    case shoreThingsReceipt(appointmentId: String)
    case switchVoyage
    case wallet
    case homeComingGuide
}

enum HomeDashboardSheetRoute: BaseSheetRouter {
    case shipMap
    case itineraryDetails
    var id: String {
        switch self {
        case .shipMap:
            return "shipMap"
        case .itineraryDetails:
            return "itineraryDetails"
        }
    }
}

enum HomeDashboardFullScreenRoute: BaseFullScreenRoute {
    case rts(sailor: Sailor?, dashboardTask: TaskDetail?)
    case travelAssist
    case healthCheckLanding

    var id: String {
        switch self {
        case .rts(_,_):
            return "rts"
        case .travelAssist:
            return "travelAssist"
        case .healthCheckLanding:
            return "healthCheckLanding"
        }
    }
}

@Observable class HomeDashboardCoordinator {
    var navigationRouter: NavigationRouter<HomeDashboardNavigationRoute>
    var sheetRouter: SheetRouter<HomeDashboardSheetRoute>
    var fullScreenRouter: HomeDashboardFullScreenRoute?

    init(navigationRouter: NavigationRouter<HomeDashboardNavigationRoute> = .init(),
         sheetRouter: SheetRouter<HomeDashboardSheetRoute> = .init(),
         fullScreenRouter: HomeDashboardFullScreenRoute? = nil)
    {
        self.navigationRouter = navigationRouter
        self.sheetRouter = sheetRouter
        self.fullScreenRouter = fullScreenRouter
    }
}


extension HomeDashboardCoordinator {
    
    struct DismissFullScreenCoverCommand: NavigationCommandProtocol {
        let pathToDismiss: HomeDashboardFullScreenRoute
        
        func execute(on coordinator: AppCoordinator) {
            if coordinator.homeTabBarCoordinator.homeDashboardCoordinator.fullScreenRouter == pathToDismiss {
                coordinator.homeTabBarCoordinator.homeDashboardCoordinator.fullScreenRouter = nil
            }
        }
    }

    struct OpenTravelPartyAssistantCommand: NavigationCommandProtocol {
        func execute(on coordinator: AppCoordinator) {
            coordinator.homeTabBarCoordinator.homeDashboardCoordinator.navigationRouter.navigateTo(.travelPartyAssist)
        }
    }
    
    struct OpenSwitchVoyageCommand: NavigationCommandProtocol {
        func execute(on coordinator: AppCoordinator) {
            coordinator.homeTabBarCoordinator.homeDashboardCoordinator.navigationRouter.navigateTo(.switchVoyage)
        }
    }
    
    struct OpenWalletCommand: NavigationCommandProtocol {
        func execute(on coordinator: AppCoordinator) {
            coordinator.homeTabBarCoordinator.homeDashboardCoordinator.navigationRouter.navigateTo(.wallet)
        }
    }

    struct OpenHomeComingGuideCommand: NavigationCommandProtocol {
        func execute(on coordinator: AppCoordinator) {
            coordinator.homeTabBarCoordinator.homeDashboardCoordinator.navigationRouter.navigateTo(.homeComingGuide)
        }
    }
    
    struct OpenHealthCheckLandingFullScreenCommand: NavigationCommandProtocol {
        func execute(on coordinator: AppCoordinator) {
            coordinator.homeTabBarCoordinator.homeDashboardCoordinator.fullScreenRouter = .healthCheckLanding
        }
    }

    struct PresentItineraryDetailsSheetCommand: NavigationCommandProtocol {
        func execute(on coordinator: AppCoordinator) {
            coordinator.homeTabBarCoordinator.homeDashboardCoordinator.sheetRouter.present(sheet: .itineraryDetails)
        }
    }

    struct OpenBoardingPassCommand: NavigationCommandProtocol {
                
        func execute(on coordinator: AppCoordinator) {
            coordinator.homeTabBarCoordinator.homeDashboardCoordinator.navigationRouter.navigateTo(.boardingPass)
        }
    }

    struct ShowReadyToSailFullScreenCoverCommand: NavigationCommandProtocol {
        let taskDetail: TaskDetail?, sailor: Sailor?

        func execute(on coordinator: AppCoordinator) {
            coordinator.homeTabBarCoordinator.homeDashboardCoordinator.fullScreenRouter = .rts(sailor: sailor, dashboardTask: taskDetail)
        }
    }
    
    struct NavigateBackCommand: NavigationCommandProtocol {
        func execute(on coordinator: AppCoordinator) {
            coordinator.homeTabBarCoordinator.homeDashboardCoordinator.navigationRouter.navigateBack()
        }
    }
    
    struct NavigateBackForStepsCommand: NavigationCommandProtocol {
        let steps: Int
        func execute(on coordinator: AppCoordinator) {
            coordinator.homeTabBarCoordinator.homeDashboardCoordinator.navigationRouter.navigateBack(steps: steps)
        }
    }
    
    struct PresentShipMapSheetCommand: NavigationCommandProtocol {
        func execute(on coordinator: AppCoordinator) {
            coordinator.homeTabBarCoordinator.homeDashboardCoordinator.sheetRouter.present(sheet: .shipMap)
        }
    }
    
    struct DismissAnySheetCommand: NavigationCommandProtocol {
        func execute(on coordinator: AppCoordinator) {
            coordinator.homeTabBarCoordinator.sheetRouter.dismiss()
        }
    }

    struct DismissAnyDashboardSheetCommand: NavigationCommandProtocol {
        func execute(on coordinator: AppCoordinator) {
            coordinator.homeTabBarCoordinator.homeDashboardCoordinator.sheetRouter.dismiss()
        }
    }

    // Home book
    struct OpenEateriesListScreenCommand: NavigationCommandProtocol {
        func execute(on coordinator: AppCoordinator) {
            coordinator.homeTabBarCoordinator.homeDashboardCoordinator.navigationRouter.navigateTo(.eateriesList)
        }
    }
    
    struct OpenDiningDetailsScreenCommand: NavigationCommandProtocol {
        let slug: String, filter: EateriesSlotsInputModel?
        func execute(on coordinator: AppCoordinator) {
            coordinator.homeTabBarCoordinator.homeDashboardCoordinator.navigationRouter.navigateTo(.diningDetails(slug: slug, filter: filter))
        }
    }
    
    struct OpenDiningOpeningTimesCommand: NavigationCommandProtocol {
        let filter: EateriesSlotsInputModel
        func execute(on coordinator: AppCoordinator) {
            coordinator.homeTabBarCoordinator.homeDashboardCoordinator.navigationRouter.navigateTo(.diningOpeningTimes(filter: filter))
        }
    }
	
	struct OpenDiningReceiptScreenCommand: NavigationCommandProtocol {
		let appointmentId: String
		func execute(on coordinator: AppCoordinator) {
			coordinator.homeTabBarCoordinator.homeDashboardCoordinator.navigationRouter.navigateTo(.diningReceipt(appointmentId: appointmentId))
		}
	}

    struct OpenEventLineUpScreenCommand: NavigationCommandProtocol {
        func execute(on coordinator: AppCoordinator) {
            coordinator.homeTabBarCoordinator.homeDashboardCoordinator.navigationRouter.navigateTo(.eventLineUp)
        }
    }

    struct OpenEventLineUpDetailsScreenCommand: NavigationCommandProtocol {
        let event: LineUpEvents.EventItem
        func execute(on coordinator: AppCoordinator) {
            coordinator.homeTabBarCoordinator.homeDashboardCoordinator.navigationRouter.navigateTo(.eventLineUpDetails(event: event))
        }
    }
    
    struct OpenEventLineUpDetailsReceiptScreenCommand: NavigationCommandProtocol {
        let id: String
        func execute(on coordinator: AppCoordinator) {
            coordinator.homeTabBarCoordinator.homeDashboardCoordinator.navigationRouter.navigateTo(.eventLineUpDetailsReceipt(id: id))
        }
    }
    
    // Home explore
    struct OpenShipSpaceScreenCommand: NavigationCommandProtocol {
        let shipSpaceCode: String
        func execute(on coordinator: AppCoordinator) {
            coordinator.homeTabBarCoordinator.homeDashboardCoordinator.navigationRouter.navigateTo(.shipSpace(shipSpaceCode))
        }
    }
    
    struct OpenShipSpaceDetailsScreenCommand: NavigationCommandProtocol {
        let shipSpaceDetailsItem: ShipSpaceDetails
        func execute(on coordinator: AppCoordinator) {
            coordinator.homeTabBarCoordinator.homeDashboardCoordinator.navigationRouter.navigateTo(.shipSpaceDetails(shipSpaceDetailsItem))
        }
    }
    
    struct OpenTreatmentsScreenCommand: NavigationCommandProtocol {
        let treatmentID: String
        func execute(on coordinator: AppCoordinator) {
            coordinator.homeTabBarCoordinator.homeDashboardCoordinator.navigationRouter.navigateTo(.treatment(treatmentID))
        }
    }
    
    struct OpenTreatmentsReceiptScreenCommand: NavigationCommandProtocol {
        let appointmentID: String
        func execute(on coordinator: AppCoordinator) {
            coordinator.homeTabBarCoordinator.homeDashboardCoordinator.navigationRouter.navigateTo(.treatmentReceipt(appointmentID: appointmentID))
        }
    }
    
    struct OpenShoreThingsScreenCommand: NavigationCommandProtocol {
        func execute(on coordinator: AppCoordinator) {
            coordinator.homeTabBarCoordinator.homeDashboardCoordinator.navigationRouter.navigateTo(.shoreThings)
        }
    }
	
	struct OpenShoreThingsListScreenCommand: NavigationCommandProtocol {
		let portCode: String
		let arrivalDateTime, departureDateTime : Date?
		func execute(on coordinator: AppCoordinator) {
			coordinator.homeTabBarCoordinator.homeDashboardCoordinator.navigationRouter.navigateTo(.shoreThingsList(portCode: portCode, arrivalDateTime: arrivalDateTime, departureDateTime: departureDateTime))
		}
	}
	
	struct OpenShoreThingItemDetailsScreenCommand: NavigationCommandProtocol {
		let shoreThingItem: ShoreThingItem
		
		func execute(on coordinator: AppCoordinator) {
			coordinator.homeTabBarCoordinator.homeDashboardCoordinator.navigationRouter.navigateTo(.shoreThingItemDetails(shoreThingItem: shoreThingItem))
		}
	}
    
    struct OpenShoreThingsReceiptScreenCommand: NavigationCommandProtocol {
        let appointmentId: String
        func execute(on coordinator: AppCoordinator) {
            coordinator.homeTabBarCoordinator.homeDashboardCoordinator.navigationRouter.navigateTo(.shoreThingsReceipt(appointmentId: appointmentId))
        }
    }
}
