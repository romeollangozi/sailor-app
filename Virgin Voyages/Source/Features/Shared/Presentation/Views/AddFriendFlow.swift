//
//  AddFriendFlow.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 17.5.25.
//

import SwiftUI
import VVUIKit

struct AddFriendFlow: View {
	@State var showScanner = false
	@State var contactData: AddContactData? = nil
	let onDismiss: VoidCallback?

	init(onDismiss: VoidCallback? = nil) {
		_showScanner = State(initialValue: false)
		_contactData = State(initialValue: nil)
		self.onDismiss = onDismiss
	}

	var body: some View {
		AddFriendSheet(closeAction: {
			onDismiss?()
		}, shareAction: {

		}, scanAction: {
			showScanner = true
		}, searchAction: {
			// TODO: Need a logic for find friend
		})
		.fullScreenCover(isPresented: $showScanner, content: {
			ContactsScanView(displaysViewOnSuccess: false, back: {
				self.showScanner = false
			}, action: { scannedCode in
				DispatchQueue.main.async {
					self.showScanner = false
					self.contactData = AddContactData.from(sailorLink: scannedCode)
				}
			}, viewModel: ContactsScanViewModel(selectedOption: .scanCode, yourCodeText: "Your code", scanCodeText: "Scan code", showScanerSegmentControl: false))
		})
		.sheet(item: $contactData) { contactData in
			AddContactSheet(contact: contactData, isFromDeepLink: false, onDismiss: {
				self.contactData = nil
				onDismiss?()
			})
		}
	}
}
