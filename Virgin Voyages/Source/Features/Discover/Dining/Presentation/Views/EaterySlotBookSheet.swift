//
//  EateryBookingSheet.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 26.11.24.
//


import SwiftUI
import VVUIKit

protocol EaterySlotBookViewModelProtocol {
	var screenState: ScreenState {get set}
	var selectedSailors: [SailorModel] {get set}
	var warningForSailors: [SailorModel] {get}
	var availableSailors: [SailorModel] {get}
	
	var title: String {get}
	var slot: Slot {get}
	var disclaimer: String? {get}
	
	var isBookingCompleted: Bool {get}
	var isSwapCompleted: Bool {get}
	var bookSlotErrorMessage: String? {get}
	var conflictData: EateryConflictsModel {get}
	var acknowledgeDisclaimer: Bool {get set}
	var showDisclaimerErroMessage: Bool {get}
	var isSwapping: Bool {get}
	
	func onAppear() async
	func onRefresh() async
	func onBookClick() async
	func onConfirmSwapClick()
}

struct EaterySlotBookSheet: View {
	@State var viewModel: EaterySlotBookViewModelProtocol
	
	let onBooked: VoidCallback?
	let onCancelClick: VoidCallback?
	let onChangePartySizeClick: VoidCallback?
	
	init(viewModel: EaterySlotBookViewModelProtocol,
		 onBooked: VoidCallback? = nil,
		 onCancelClick: VoidCallback? = nil,
		 onChangePartySizeClick: VoidCallback? = nil) {
		_viewModel = State(wrappedValue: viewModel)
		
		self.onBooked = onBooked
		self.onCancelClick = onCancelClick
		self.onChangePartySizeClick = onChangePartySizeClick
	}
	
	var body: some View {
		DefaultScreenView(state: $viewModel.screenState) {
			VVUIKit.ContentView(backgroundColor: Color.white) {
				HStack {
					Spacer()
					
					XClosableButton {
						if viewModel.isBookingCompleted || viewModel.isSwapCompleted {
							onBooked?()
						}
						else {
							onCancelClick?()
						}
					}
				}.padding(Spacing.space16)
				
				VStack(alignment: .leading) {
					if viewModel.isBookingCompleted || viewModel.isSwapCompleted {
						bookingCompleted()
					} else if(viewModel.conflictData.conflict != nil && !viewModel.isSwapping) {
						if((viewModel.conflictData.conflict!.isClash == true)) {
							if (viewModel.conflictData.conflict!.isSoftClash) {
								newBooking()
							} else {
								hardClash()
							}
							
						} else {
							swap()
						}
					} else {
						newBooking()
					}
				}
			}
		} onRefresh: {
			Task {
				await viewModel.onRefresh()
			}
		}.onAppear {
			Task {
				await viewModel.onAppear()
			}
		}
	}
	
	private func newBooking() -> some View {
		VStack(alignment: .leading) {
			VStack(alignment: .leading, spacing: Spacing.space16) {
				
				Text("Confirm your booking")
					.font(.vvHeading3Bold)
				
				VStack(alignment: .leading, spacing: Spacing.space0) {
					Text(viewModel.title)
						.font(.vvHeading4Bold)
					
					Text(viewModel.slot.startDateTime.toFullDateTimeWithOrdinal())
						.font(.vvBody)
						.foregroundStyle(Color.slateGray)
				}
				
				VStack(alignment: .leading, spacing: Spacing.space8) {
					HStack {
						Text("Table for \(viewModel.selectedSailors.count)")
							.font(.vvBodyBold)
						
						if onChangePartySizeClick != nil {
							Button(action: {
								(onChangePartySizeClick ?? {})()
							}) {
								Text("change party size")
									.font(.vvSmall)
									.foregroundStyle(Color.slateGray)
									.underline()
							}
						}
					}
					
					VStack {
						SailorPickerV2(sailors: viewModel.availableSailors, selected: .constant(viewModel.selectedSailors))
					}.padding(Spacing.space16)
					
				}
				
				if let disclaimer = viewModel.disclaimer {
					CheckboxView(isChecked: $viewModel.acknowledgeDisclaimer, text: disclaimer)
					
					if (!viewModel.acknowledgeDisclaimer && viewModel.showDisclaimerErroMessage) {
						Text("Please confirm you understand the shared table policy")
							.fontStyle(.smallButton)
							.foregroundColor(Color.red)
					}
				}
				
				if viewModel.conflictData.conflict != nil && viewModel.conflictData.conflict?.isSoftClash == true {
					MessageBar(style: .Warning, text: viewModel.conflictData.conflict?.description ?? "")
				}
				
				Text("We hold your table for 15 mins from your booking time so please let us know if you’re running late.")
					.fontStyle(.body)
					.foregroundStyle(.secondary)
				
				if let errorMessage = viewModel.bookSlotErrorMessage {
					MessageBar(style: .Warning, text: errorMessage)
				}
				
			}.padding(Paddings.defaultVerticalPadding16)
			
			DoubleDivider()
			
			VStack(alignment: .leading) {
				VStack(spacing: Paddings.defaultVerticalPadding16) {
					Button("Book") {
						Task {
							await viewModel.onBookClick()
						}
					}
					.buttonStyle(PrimaryButtonStyle())
					
					Button("Cancel") {
						(onCancelClick ?? {})()
					}
					.buttonStyle(SecondaryButtonStyle())
				}
			}.padding(Paddings.defaultVerticalPadding16)
		}
	}
	
	private func hardClash() -> some View {
		VStack(alignment: .leading) {
			VStack(alignment: .leading, spacing: Paddings.defaultVerticalPadding16) {
				Text(viewModel.conflictData.conflict?.title ?? "")
					.fontStyle(.title)
					.fontWeight(.bold)
				
				SailorPickerV2(sailors: viewModel.selectedSailors,
                               selected: .constant(viewModel.selectedSailors),
							   warnings: viewModel.warningForSailors)
				
				VStack(alignment: .leading) {
					Text(viewModel.conflictData.conflict?.description ?? "")
						.fontStyle(.smallButton)
						.foregroundStyle(.secondary)
				}
				.padding(Paddings.defaultVerticalPadding16)
				.background(Color.lightYellow)
				
			}.padding(Paddings.defaultVerticalPadding16)
			
			DoubleDivider()
			
			VStack(alignment: .leading) {
				VStack(spacing: Paddings.defaultVerticalPadding16) {
					Button("Ok, got it") {
						(onCancelClick ?? {})()
					}
					.buttonStyle(PrimaryButtonStyle())
				}
			}.padding(Paddings.defaultVerticalPadding16)
		}
	}
	
	private func swap() -> some View {
		VStack(alignment: .leading) {
			VStack(alignment: .leading, spacing: Paddings.defaultVerticalPadding16) {
				VStack(alignment: .leading, spacing: 5) {
					Text(viewModel.conflictData.conflict?.title ?? "")
						.fontStyle(.largeCaption)
					Text(viewModel.conflictData.conflict?.description ?? "")
						.fontStyle(.body)
						.foregroundStyle(.secondary)
				}
				
				Text("Want to swap your booking?")
					.fontStyle(.title)
					.fontWeight(.bold)
				
				HStack {
					Image(systemName: "xmark.circle.fill")
						.imageScale(.large)
						.foregroundStyle(.gray)
					
					VStack(alignment: .leading) {
						Text("Cancel: \(viewModel.conflictData.conflict?.swapConflictDetails?.cancellableRestaurantName ?? "")")
							.fontStyle(.headline)
						Text(viewModel.conflictData.conflict?.swapConflictDetails?.cancellableAppointmentDateTime ?? "")
							.fontStyle(.body)
							.foregroundStyle(.secondary)
					}
				}
				
				HStack {
					Image(systemName: "checkmark.circle.fill")
						.imageScale(.large)
						.foregroundStyle(.green)
					
					VStack(alignment: .leading) {
						Text("Book: \(viewModel.conflictData.conflict?.swapConflictDetails?.swappableRestaurantName ?? "")")
							.fontStyle(.headline)
						Text(viewModel.conflictData.conflict?.swapConflictDetails?.swappableAppointmentDateTime ?? "")
							.fontStyle(.body)
							.foregroundStyle(.secondary)
					}
				}
				
			}.padding(Paddings.defaultVerticalPadding16)
			
			DoubleDivider()
			
			VStack(alignment: .leading) {
				VStack(spacing: Paddings.defaultVerticalPadding16) {
					if let errorMessage = viewModel.bookSlotErrorMessage {
						MessageBar(style: .Warning, text: errorMessage)
					}
					
					Button("Swap Booking") {
						viewModel.onConfirmSwapClick()
					}
					.buttonStyle(PrimaryButtonStyle())
					
					Button("Cancel - Keep existing booking") {
						(onCancelClick ?? {})()
					}
					.buttonStyle(SecondaryButtonStyle())
				}
			}.padding(Paddings.defaultVerticalPadding16)
		}
	}
	
	private func bookingCompleted() -> some View {
		
		VStack(alignment: .center) {
			
			VStack(alignment: .center, spacing: Spacing.space16) {
				Image("CancelationConfirmed")
					.resizable()
					.aspectRatio(contentMode: .fit)
					.frame(width: 80, height: 80)
					.padding(.top, Spacing.space64)
				
				Text("Reservation confirmed")
					.foregroundStyle(Color.blackText)
					.font(.vvHeading3Bold)
					.padding(.bottom, 10)
				
			}.padding(Spacing.space16)
			
			DoubleDivider()
			
			VStack(alignment: .leading) {
				VStack(spacing: Spacing.space16) {
					PrimaryButton("Done") {
						onBooked?()
					}
				}
			}.padding(Spacing.space16)
		}
		
	}
}

#Preview("New booking") {
	EaterySlotBookSheet(viewModel: EaterySlotBookPreviewViewModel())
}

#Preview("Booking Completed") {
	EaterySlotBookSheet(viewModel: EaterySlotBookPreviewViewModel(isBookingCompleted: true))
}

#Preview("Soft Clash") {
	EaterySlotBookSheet(viewModel: EaterySlotBookPreviewViewModel(conflict: EateryConflictsModel.softClash()))
}

#Preview("Hard Clash") {
	EaterySlotBookSheet(viewModel: EaterySlotBookPreviewViewModel(conflict: EateryConflictsModel.hardClash()))
}

#Preview("Repeat Clash") {
	EaterySlotBookSheet(viewModel: EaterySlotBookPreviewViewModel(conflict: EateryConflictsModel.repeatClash()))
}

#Preview("Swap Clash") {
	EaterySlotBookSheet(viewModel: EaterySlotBookPreviewViewModel(conflict: EateryConflictsModel.swapClash()))
}

struct EaterySlotBookPreviewViewModel: EaterySlotBookViewModelProtocol {
	var screenState: ScreenState = .content
	var title: String
	var slot: Slot
	
	var availableSailors: [SailorModel]
	var selectedSailors: [SailorModel]
	var warningForSailors: [SailorModel]
	
	var isBookingCompleted: Bool
	var isSwapCompleted: Bool
	var bookSlotErrorMessage: String?
	var conflictData: EateryConflictsModel
	var acknowledgeDisclaimer: Bool
	var showDisclaimerErroMessage: Bool
	var isSwapping: Bool
	var disclaimer: String? = nil
	
	init(title: String = "Razzle Dazzle Restaurant",
		 slot: Slot = .sample(),
		 isBookingCompleted: Bool = false,
		 conflict: EateryConflictsModel = EateryConflictsModel.none) {
		self.title = title
		self.slot = slot
		self.conflictData = conflict
		self.isBookingCompleted = isBookingCompleted
		
		availableSailors = SailorModel.samples()
		selectedSailors = SailorModel.samples()
		warningForSailors = []
		
		isSwapping = false
		isSwapCompleted = false
		
		bookSlotErrorMessage = nil
		
		acknowledgeDisclaimer = false
		
		showDisclaimerErroMessage = false
	}

	func onAppear() async {
		
	}
	
	func onRefresh() async {
		
	}
	
	func onBookClick() async {
		
	}
	
	func onConfirmSwapClick() {
		
	}
}
