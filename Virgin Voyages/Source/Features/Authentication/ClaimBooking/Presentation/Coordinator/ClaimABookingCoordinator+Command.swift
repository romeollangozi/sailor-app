//
//  ClaimABookingCoordinator+Command.swift
//  Virgin Voyages
//
//  Created by TX on 21.1.25.
//

import Foundation

extension ClaimABookingCoordinator {

	struct OpenLandingViewCommand: NavigationCommandProtocol {
		func execute(on coordinator: AppCoordinator) {
			coordinator.landingScreenCoordinator.claimABookingCoordinator.navigationRouter.navigateTo(.landing)
		}
	}
    struct OpenBookingDetailsCommand: NavigationCommandProtocol {
        func execute(on coordinator: AppCoordinator) {
            coordinator.landingScreenCoordinator.claimABookingCoordinator.navigationRouter.navigateTo(.bookingDetails)
        }
    }
    
    struct OpenBookingNotFoundCommand: NavigationCommandProtocol {
        func execute(on coordinator: AppCoordinator) {
            coordinator.landingScreenCoordinator.claimABookingCoordinator.navigationRouter.navigateTo(.bookingNotFound)
        }
    }
    
    struct OpenRequiresAuthenticationCommand: NavigationCommandProtocol {
        func execute(on coordinator: AppCoordinator) {
            coordinator.landingScreenCoordinator.claimABookingCoordinator.navigationRouter.navigateTo(.successRequiresAuthentication)
        }
    }
    
    struct OpenEmailConflictViewCommand: NavigationCommandProtocol {
        let email: String
        let reservationNumber: String
        let reservationGuestID: String
        
        func execute(on coordinator: AppCoordinator) {
            coordinator.landingScreenCoordinator.claimABookingCoordinator.navigationRouter.navigateTo( .emailConflict(email: email, reservationNumber: reservationNumber, reservationGuestID: reservationGuestID))
        }
    }
    
    struct OpenGuestConflictViewCommand: NavigationCommandProtocol {
        let currentGuest: ClaimBookingGuestDetails?
        let bookingReferenceNumber: String
        let guestDetails: [ClaimBookingGuestDetails]
        
        func execute(on coordinator: AppCoordinator) {
            coordinator.landingScreenCoordinator.claimABookingCoordinator.navigationRouter.navigateTo(
                .guestConflict(
                    currentGuest: currentGuest,
                    bookingReferenceNumber: bookingReferenceNumber,
                    guestDetails: guestDetails
                )
            )
        }
    }
    
    struct OpenManualEntryView: NavigationCommandProtocol {
        func execute(on coordinator: AppCoordinator) {
            coordinator.landingScreenCoordinator.claimABookingCoordinator.navigationRouter.navigateTo(.manualEntry)
        }
    }

    struct OpenCheckBookingDetailsCommand: NavigationCommandProtocol {
        let bookingReferenceNumber: String
        let selectedGuest: ClaimBookingGuestDetails
        
        func execute(on coordinator: AppCoordinator) {
            coordinator.landingScreenCoordinator.claimABookingCoordinator.navigationRouter.navigateTo( .checkBookingDetails(bookingReferenceNumber: bookingReferenceNumber, selectedGuest: selectedGuest))
        }
    }
    
    struct OpenMissingBookingDetailsCommand: NavigationCommandProtocol {
        let bookingReferenceNumber: String
        let selectedGuest: ClaimBookingGuestDetails
        
        func execute(on coordinator: AppCoordinator) {
            coordinator.landingScreenCoordinator.claimABookingCoordinator.navigationRouter.navigateTo( .missingBookingDetails(bookingReferenceNumber: bookingReferenceNumber, selectedGuest: selectedGuest))
        }
    }
    
    struct GoBackCommand: NavigationCommandProtocol {
        func execute(on coordinator: AppCoordinator) {
            coordinator.landingScreenCoordinator.claimABookingCoordinator.navigationRouter.navigateBack()
        }
    }

    struct GoBackToRootViewCommand: NavigationCommandProtocol {
        func execute(on coordinator: AppCoordinator) {
            coordinator.landingScreenCoordinator.claimABookingCoordinator.navigationRouter.root()
        }
    }    
    
}
