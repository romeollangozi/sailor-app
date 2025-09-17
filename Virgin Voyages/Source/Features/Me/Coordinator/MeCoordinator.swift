//
//  MeCoordinator.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 5.3.25.
//

import Foundation

enum MeNavigationRoute: BaseNavigationRoute {
	case vipBenefits
	case settings
	case lineUpDetails
	case addons(addonCode: String)
    case eateryReceipt(appointmentId: String)
    case shoreExcursionReceipt(appointmentId: String)
    case treatmentReceipt(appointmentId: String)
    case entertainmentReceipt(appointmentId: String)
    case wallet
	case termsAndConditions
	case switchVoyage
	case setPinLanding
	case setPin
}

enum MeFullScreenRoute: BaseFullScreenRoute {
    case claimABooking(showBackButton: Bool = false, initialRoute: ClaimABookingNavigationRoute? = nil)
    
    var id: String {
        switch self {
        case .claimABooking: return "claimABooking"
        }
    }
}

@Observable class MeCoordinator {
	var navigationRouter: NavigationRouter<MeNavigationRoute>
    var fullScreenRouter: MeFullScreenRoute?

	init(
		navigationRouter: NavigationRouter<MeNavigationRoute> = .init(),
        fullScreenRouter: MeFullScreenRoute? = nil
	) {
		self.navigationRouter = navigationRouter
        self.fullScreenRouter = fullScreenRouter
	}
}



extension MeCoordinator {
    struct OpenClaimABookingCommand: NavigationCommandProtocol {
        func execute(on coordinator: AppCoordinator) {
            coordinator.homeTabBarCoordinator.selectedTab = .me(section: .agenda)
            coordinator.homeTabBarCoordinator.meCoordinator.fullScreenRouter = .claimABooking(showBackButton: true, initialRoute: .bookingDetails)
        }
    }
    
    struct DismissClaimABookingFullScreenCommand: NavigationCommandProtocol {
        func execute(on coordinator: AppCoordinator) {
            coordinator.homeTabBarCoordinator.meCoordinator.fullScreenRouter = nil
        }
    }
}
