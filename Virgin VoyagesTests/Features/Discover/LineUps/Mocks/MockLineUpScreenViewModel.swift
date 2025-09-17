//
//  MockLineUpScreenViewModel.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 24.7.25.
//

import XCTest
@testable import Virgin_Voyages

class MockLineUpScreenViewModel {
	var onReAppearHandler: (() -> Void)?

	func onReAppear() {
		onReAppearHandler?()
	}

	func handleEvent(_ event: BookingEventNotification) {
		switch event {
		case .userDidMakeABooking:
			onReAppear()
		default: break
		}
	}
}
