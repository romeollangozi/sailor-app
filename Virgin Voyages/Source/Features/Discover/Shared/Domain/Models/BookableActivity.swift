//
//  BookableActivity.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 2/6/25.
//

import Foundation

protocol BookableActivity {
	var activityCode: String { get }
	var categoryCode: String { get }
	var totalAmount: Double { get }
	var currencyCode: String { get }
}

protocol CancelBookableActivity: Equatable, Hashable {
	var sailors: [SailorModel] { get }
	var appointmentLinkId: String { get }
	var category: String { get }
	var isWithinCancellationWindow: Bool { get }
	var inventoryState: InventoryState { get }
	var cancelationCompletedText: String { get }
	var refundTextForIndividual: String { get }
	var refundTextForGroup: String? { get }
	var refundConfirmationMessage: String { get }
}
