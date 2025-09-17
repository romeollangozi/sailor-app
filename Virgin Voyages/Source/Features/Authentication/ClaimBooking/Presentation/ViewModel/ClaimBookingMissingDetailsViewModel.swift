//
//  ClaimBookingMissingDetailsViewModelProtocol.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 26.12.24.
//

import SwiftUI

protocol ClaimBookingMissingDetailsViewModelProtocol {
    var dateOfBirthError: String? { get set }
    var dateOfBirth: DateComponents { get set }
    var selectedGuest: ClaimBookingGuestDetails { get set }
    var missingDetailsTitle: String { get }
    var missingDetailsDescription: String { get }
    var dateOfBirthTitle: String { get }
    var next: String { get }
    var cancelText: String { get }
    func isValidDate() -> Bool

	func cancel()
    func navigateBack()
    func openCheckDetailsScreen()
}

@Observable class ClaimBookingMissingDetailsViewModel: ClaimBookingMissingDetailsViewModelProtocol {
    private var appCoordinator: CoordinatorProtocol

    var dateOfBirthError: String?
    var dateOfBirth: DateComponents
    var selectedGuest: ClaimBookingGuestDetails
    let bookingReferenceNumber: String

    
    var missingDetailsTitle = "We’re missing some details from your reservation"
    var missingDetailsDescription = "We need the following details to get your reservation all set for sea."
    var dateOfBirthTitle = "Date of Birth"
    var next = "Next"
    var cancelText = "Cancel"
    
    init(appCoordinator: CoordinatorProtocol = AppCoordinator.shared,
         dateOfBirthError: String? = nil,
         dateOfBirth: DateComponents = DateComponents(calendar: Calendar.current),
         bookingReferenceNumber: String,
         selectedGuest: ClaimBookingGuestDetails = ClaimBookingGuestDetails.empty()) {
        
        self.appCoordinator = appCoordinator
        self.dateOfBirthError = dateOfBirthError
        self.dateOfBirth = dateOfBirth
        self.bookingReferenceNumber = bookingReferenceNumber
        self.selectedGuest = selectedGuest
    }
    
    func isValidDate() -> Bool {
        return (dateOfBirthError == nil) && dateOfBirth.isOlderThan16Years
    }
    
    var guestDetails: ClaimBookingGuestDetails {
        guard let date = self.dateOfBirth.date else { return selectedGuest }
        self.selectedGuest.birthDate = date
        return self.selectedGuest
    }
    
    // MARK: Navigation
	func cancel() {
		appCoordinator.executeCommand(ClaimABookingCoordinator.GoBackToRootViewCommand())
	}

    func navigateBack() {
        appCoordinator.executeCommand(ClaimABookingCoordinator.GoBackCommand())
    }
        
    func openCheckDetailsScreen() {
        appCoordinator.executeCommand(ClaimABookingCoordinator.OpenCheckBookingDetailsCommand(bookingReferenceNumber: self.bookingReferenceNumber, selectedGuest: guestDetails))
    }

}
