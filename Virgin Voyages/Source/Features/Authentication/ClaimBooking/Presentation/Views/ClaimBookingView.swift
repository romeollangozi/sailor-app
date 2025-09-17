//
//  ClaimBookingView.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 9/10/24.
//

import SwiftUI

extension ClaimBookingView {
    static func create(shouldShowCloseFlowButton: Bool = false, rootPath: ClaimABookingNavigationRoute? = .landing) -> ClaimBookingView {
		ClaimBookingView(viewModel: ClaimBookingViewModel(shouldShowCloseFlowButton: shouldShowCloseFlowButton, rootPath: rootPath))
	}
}

struct ClaimBookingView: View, CoordinatorNavitationDestinationViewProvider {
	@State private var viewModel: ClaimBookingViewModel
        
	init(viewModel: ClaimBookingViewModel) {
		_viewModel = State(wrappedValue: viewModel)
	}

	var body: some View {
        NavigationStack(path: $viewModel.appCoordinator.landingScreenCoordinator.claimABookingCoordinator.navigationRouter.navigationPath) {
            destinationView(for: viewModel.initialRoute)
                .navigationDestination(for: ClaimABookingNavigationRoute.self) { route in
                    destinationView(for: route)
			}
			.navigationBarBackButtonHidden(true)
		}
	}
    
    func destinationView(for navigationRoute: any BaseNavigationRoute) -> AnyView {
        guard let claimBookingNavigationRoute = navigationRoute as? ClaimABookingNavigationRoute  else { return AnyView(Text("View not supported")) }
        switch claimBookingNavigationRoute {
        case .landing:
            return AnyView(
                ClaimBookingLandingView.create()
            )
        case .bookingDetails:
            return AnyView(
                ClaimBookingReservationDetailsView.create(showCloseFlowButton: viewModel.shouldShowCloseFlowButton, onCloseButtonTapped: {
                    viewModel.appCoordinator.executeCommand(MeCoordinator.DismissClaimABookingFullScreenCommand())
                })
                    .navigationBarBackButtonHidden(true)
            )

        case .bookingNotFound:
            return AnyView(
                ClaimBookingNotFoundView.create()
                    .navigationBarBackButtonHidden(true)
            )
        case .manualEntry:
            return AnyView(
                ClaimBookingManualEntryView.create()
                    .navigationBarBackButtonHidden(true)
            )
        case .emailConflict(let email, let reservationNumber, let reservationGuestID):
            return AnyView(
                ClaimBookingEmailConflictView.create(
                    email: email,
                    reservationNumber: reservationNumber,
                    reservationGuestID: reservationGuestID
                )
                    .navigationBarBackButtonHidden(true)
            )
        case .guestConflict(let currentGuest, let bookingReferenceNumber, let guestDetails):
            return AnyView(
                ClaimBookingSelectSailorView.create(currentGuest: currentGuest, bookingReference: bookingReferenceNumber, guestDetails: guestDetails)
                    .navigationBarBackButtonHidden(true)
            )
        case .successRequiresAuthentication:
            return AnyView(
                ClaimBookingSuccessRequiresAuthenticationView()
                    .navigationBarBackButtonHidden(true)
            )
        case .checkBookingDetails(let bookingReferenceNumber, let selectedGuest):
            return AnyView(
                CheckBookingDetailsView(viewModel: CheckBookingDetailsViewModel(claimBookingCheckDetailsUseCase: ClaimBookingCheckDetailsUseCase(sailorProfileDetails: selectedGuest), bookingReferenceNumber: bookingReferenceNumber, selectedGuest: selectedGuest, claimBookingCheckDetails: .empty()))
                    .navigationBarBackButtonHidden(true)
            )
        case .missingBookingDetails(let bookingReferenceNumber, let selectedGuest):
            return AnyView(
                ClaimBookingMissingDetailsView(viewModel: ClaimBookingMissingDetailsViewModel(bookingReferenceNumber: bookingReferenceNumber, selectedGuest: selectedGuest))
                .navigationBarBackButtonHidden(true)
            )
        }
    }

}
