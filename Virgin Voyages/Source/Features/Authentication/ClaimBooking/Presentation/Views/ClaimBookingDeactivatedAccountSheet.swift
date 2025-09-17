//
//  ClaimBookingDeactivatedAccountSheet.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 12/17/24.
//

import SwiftUI
import VVUIKit

@Observable class ClaimBookingDeactivatedAccountSheetViewModel  {
    
    var appCoordinator: AppCoordinator = .shared
    var shouldShowDeactivatedAccountInfoModal: Bool = false
    private let checkIfAccountIsDeactivatedUseCase: CheckIfAccountIsDeactivatedUseCase
    
    init(checkIfAccountIsDeactivatedUseCase: CheckIfAccountIsDeactivatedUseCase = CheckIfAccountIsDeactivatedUseCase()) {
        self.checkIfAccountIsDeactivatedUseCase = checkIfAccountIsDeactivatedUseCase
    }
    
    // MARK: Navigation
    func closeSheet() {
        appCoordinator.executeCommand(LandingScreensCoordinator.DismissCurrentSheetCommand())
    }
    
    func openBookingDetails() {
        let isAccountDeactivated = checkIfAccountIsDeactivatedUseCase.execute()
        if isAccountDeactivated {
            appCoordinator.executeCommand(ClaimABookingCoordinator.OpenManualEntryView())
        } else {
            appCoordinator.executeCommand(ClaimABookingCoordinator.OpenBookingDetailsCommand())
        }
    }
}

struct ClaimBookingDeactivatedAccountSheet: View, CoordinatorNavitationDestinationViewProvider {

	@State var viewModel: ClaimBookingDeactivatedAccountSheetViewModel

	init(viewModel: ClaimBookingDeactivatedAccountSheetViewModel = ClaimBookingDeactivatedAccountSheetViewModel()) {
		_viewModel = State(wrappedValue: viewModel)
	}

	var body: some View {
        NavigationStack(path: $viewModel.appCoordinator.landingScreenCoordinator.claimABookingCoordinator.navigationRouter.navigationPath) {
            destinationView(for: ClaimABookingNavigationRoute.landing)
                .sheet(isPresented: $viewModel.shouldShowDeactivatedAccountInfoModal) {
                    ClaimBookingDeactivatedAccountInfoSheet {
                        viewModel.shouldShowDeactivatedAccountInfoModal = false
                    }
                        .presentationDetents([.medium])
                }
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
                ClaimBookingDeactivatedAccountLandingView(
                    didTapClose: {
                        viewModel.closeSheet()
                    }, didTapWhyThisHappened: {
                        viewModel.shouldShowDeactivatedAccountInfoModal = true
                    }, didTapClaimABooking: {
                        viewModel.openBookingDetails()
                    }
                )
            )
        case .bookingDetails:
            return AnyView(
                ClaimBookingReservationDetailsView.create()
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
		case .landing:
			return AnyView(
				ClaimBookingView.create()
			)
		}
    }
    
}
