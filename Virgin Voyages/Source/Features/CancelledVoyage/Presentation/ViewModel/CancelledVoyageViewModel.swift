//
//  CancelledVoyageViewModel.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 7.8.25.
//


import SwiftUI

@Observable class CancelledVoyageViewModel {
	var appCoordinator: CoordinatorProtocol

	init(appCoordinator: CoordinatorProtocol = AppCoordinator.shared) {
		self.appCoordinator = appCoordinator
	}
}

extension CancelledVoyageViewModel: CoordinatorNavitationDestinationViewProvider {

	func destinationView(for navigationRoute: any BaseNavigationRoute) -> AnyView {
		guard let claimBookingNavigationRoute = navigationRoute as? ClaimABookingNavigationRoute  else { return AnyView(Text("View not supported")) }
		switch claimBookingNavigationRoute {
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
