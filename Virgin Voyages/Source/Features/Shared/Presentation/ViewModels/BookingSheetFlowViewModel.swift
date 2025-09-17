//
//  BookingSheetFlowViewModel.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 1.5.25.
//

import SwiftUI

@Observable class BookingSheetFlowViewModel {
	enum RootViewType {
		case bookingSheet
		case purchaseSummary(BookingSummaryInputModel)
	}
	
	private var bookingEventsNotificationService: BookingEventsNotificationService
	
	var appCoordinator: AppCoordinator = .shared
	var bookingSheetViewModel: BookingSheetViewModel?
	var rootViewType: RootViewType = .bookingSheet
	
	var paymentError: String? = nil
	var showScanner = false
	var isSheetVisible: Bool
	
	init(isSheetVisible: Bool,
		 bookingSheetViewModel: BookingSheetViewModel? = nil,
		 rootViewType: RootViewType = .bookingSheet,
		 bookingEventsNotificationService: BookingEventsNotificationService = .shared) {
		self.isSheetVisible = isSheetVisible
		self.bookingSheetViewModel = bookingSheetViewModel
		self.rootViewType = rootViewType
		self.bookingEventsNotificationService = bookingEventsNotificationService
	}
	
	// Convenience initializer for booking sheet (maintains existing API)
	convenience init(isSheetVisible: Bool,
					 bookingSheetViewModel: BookingSheetViewModel,
					 bookingEventsNotificationService: BookingEventsNotificationService = .shared) {
		self.init(isSheetVisible: isSheetVisible,
				  bookingSheetViewModel: bookingSheetViewModel,
				  rootViewType: .bookingSheet,
				  bookingEventsNotificationService: bookingEventsNotificationService)
	}
	
	/// Creates BookingSheetFlowViewModel for purchase summary root view
	convenience init(isSheetVisible: Binding<Bool>,
					 summaryInput: BookingSummaryInputModel,
					 bookingEventsNotificationService: BookingEventsNotificationService = .shared) {
		self.init(isSheetVisible: isSheetVisible.wrappedValue,
				  bookingSheetViewModel: nil,
				  rootViewType: .purchaseSummary(summaryInput),
				  bookingEventsNotificationService: bookingEventsNotificationService)
	}
	
	func navigateToScanSuccessScreen(_ qrCode: String) {
		self.appCoordinator.executeCommand(PurchaseSheetCoordinator.PresentScanningSuccessScreen(qrCode: qrCode))
	}
	
	func navigateBack() {
		self.appCoordinator.executeCommand(PurchaseSheetCoordinator.GoBackCommand())
	}
	
	func navigateBackToRoot() {
		self.appCoordinator.executeCommand(PurchaseSheetCoordinator.GoBackToRootViewCommand())
	}
	
	func removePurchaseSheet() {
		self.isSheetVisible = false
	}
	
	func navigateToAddFriend() {
		self.appCoordinator.executeCommand(PurchaseSheetCoordinator.OpenAddAFriendCommand())
	}
	
	func onBookingAdded() {
		removePurchaseSheet()
	}
	
	func onBookingUpdated() {
		removePurchaseSheet()
	}
	
    func onPaymentSuccessFromWeb(activityCode: String, activitySlotCode: String, isEditBooking: Bool, appointmentId: String) {
		if isEditBooking {
            bookingEventsNotificationService.publish(.userDidUpdateABooking(activityCode: activityCode, activitySlotCode: activitySlotCode, appointmentId: appointmentId))
		} else {
			bookingEventsNotificationService.publish(.userDidMakeABooking(activityCode: activityCode, activitySlotCode: activitySlotCode))
		}
		self.isSheetVisible = false
	}
}
