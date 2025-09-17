//
//  PurchaseSheetCoordinator.swift
//  Virgin Voyages
//
//  Created by TX on 5.2.25.
//

import SwiftUI
import Foundation

enum PurchaseSheetNavigationRoute: BaseNavigationRoute {
    case landing
    case addAFriend
    case friendAddedSuccessfully(qrCode: String)
	case clarification(conflicts: [BookableConflicts], sailors: [ActivitiesGuest])
    case paymentPage(paymentURL: URL,
					 bookingConfirmationTitle: String,
					 bookingConfirmationSubheadline: String,
					 activityCode: String,
					 activitySlotCode: String,
					 isEditBooking: Bool,
					 appointmentId: String,
					 summaryInput: BookingSummaryInputModel)

    case bookingSummary(summaryInput: BookingSummaryInputModel)
    case termsAndConditions
    case privacyPolicy


}

@Observable class PurchaseSheetCoordinator {

    var navigationRouter: NavigationRouter<PurchaseSheetNavigationRoute>
    
    init(navigationRouter: NavigationRouter<PurchaseSheetNavigationRoute> = .init()) {
        self.navigationRouter = navigationRouter
    }
}

// MARK: - Navigation Commands
extension PurchaseSheetCoordinator {
    
    struct OpenAddAFriendCommand: NavigationCommandProtocol {
        func execute(on coordinator: AppCoordinator) {
            coordinator.homeTabBarCoordinator.purchaseSheetCoordinator.navigationRouter.navigateTo(.addAFriend)
        }
    }
    
    struct PresentScanningSuccessScreen: NavigationCommandProtocol {
        let qrCode: String
        func execute(on coordinator: AppCoordinator) {
			coordinator.homeTabBarCoordinator.purchaseSheetCoordinator.navigationRouter.navigateTo(.friendAddedSuccessfully(qrCode: qrCode),
																			 animation: false)
        }
    }

    struct OpenAddOnPurchaseSummaryV2Command: NavigationCommandProtocol {
        let summaryInput: BookingSummaryInputModel
        func execute(on coordinator: AppCoordinator) {
            coordinator.homeTabBarCoordinator.purchaseSheetCoordinator.navigationRouter.navigateTo(.bookingSummary(summaryInput: summaryInput))
        }
    }
        
    
    struct GoBackCommand: NavigationCommandProtocol {
        func execute(on coordinator: AppCoordinator) {
            coordinator.homeTabBarCoordinator.purchaseSheetCoordinator.navigationRouter.navigateBack()
        }
    }
    
    struct GoBackToRootViewCommand: NavigationCommandProtocol {
        func execute(on coordinator: AppCoordinator) {
            coordinator.homeTabBarCoordinator.purchaseSheetCoordinator.navigationRouter.goToRoot()
        }
    }
    
    struct OpenPaymentPageCommand: NavigationCommandProtocol {
		let summaryInput: BookingSummaryInputModel
        let appointmentId: String
        let paymentURL: URL
		let bookingConfirmationSubheadline: String
		let bookingConfirmationTitle: String
		let activityCode: String
		let activitySlotCode: String
		let isEditBooking: Bool
		
        func execute(on coordinator: AppCoordinator) {
			coordinator.homeTabBarCoordinator.purchaseSheetCoordinator.navigationRouter.navigateTo(.paymentPage(paymentURL: paymentURL, bookingConfirmationTitle: bookingConfirmationTitle, bookingConfirmationSubheadline: bookingConfirmationSubheadline, activityCode: activityCode, activitySlotCode: activitySlotCode, isEditBooking: isEditBooking, appointmentId: appointmentId, summaryInput: summaryInput))
        }
    }
    
    
    struct OpenTermsAndConditionsScreenCommand: NavigationCommandProtocol {
        func execute(on coordinator: AppCoordinator) {
            coordinator.homeTabBarCoordinator.purchaseSheetCoordinator.navigationRouter.navigateTo(.termsAndConditions)
        }
    }

    struct OpenPrivacyPolicyScreenCommand: NavigationCommandProtocol {
        func execute(on coordinator: AppCoordinator) {
            coordinator.homeTabBarCoordinator.purchaseSheetCoordinator.navigationRouter.navigateTo(.privacyPolicy)
        }
    }

}
