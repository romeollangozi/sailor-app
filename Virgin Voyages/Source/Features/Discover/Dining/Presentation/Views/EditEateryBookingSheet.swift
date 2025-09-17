//
//  EditEateryBookingSheet.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 4.12.24.
//

import SwiftUI
import VVUIKit

protocol EditEateryBookingSheetViewModelProtocol {
	var screenState: ScreenState {get set}
	
	var availableSailors: [SailorModel] {get}
	var warningForSailors: [SailorModel] {get}
	
	var availableTimeSlots: [TimeSlotOptionV2] {get}
	var selectedTimeSlot: TimeSlotOptionV2 {get set}

	var eateryName: String {get}
	var previousBookedSailorIds: [String] {get}
	var isWithinCancellationWindow: Bool {get}
	
	var availableDates: [Date] {get}
	
	var filter: EateriesSlotsInputModel {get set}
	var isEateriesSlotsLoading: Bool {get}
	var isBookingCompleted: Bool {get}
	var isCancelCompleted: Bool {get}
	var bookSlotErrorMessage: String? {get}
	var cancelErrorMessage: String? {get}
	var showBookingCancellationConfirmation: Bool {get set}
	var showAddFriend: Bool {get set}
	
	var isCancelBookSlotLoading: Bool {get}
	
	func onAppear()
	func onRefresh()
	func onFilterChanged()
	func onUpdateBookSlotClick()
	func onCancelClick()
	func cancelAppointment(guests: Int) async -> Bool
	func onCancellationFlowFinished()
	func onCancellationFlowDismiss()
	
	func onAddFriendTapped()
	func onAddFriendDismiss()
	
	func IsUpdateButtonDisabled() -> Bool
}

struct EditEateryBookingSheet: View {
	@State var viewModel: EditEateryBookingSheetViewModelProtocol
	
	let onBooked: VoidCallback?
	let onDismiss: VoidCallback?
	let onCanceled: VoidCallback?
	
	init(viewModel: EditEateryBookingSheetViewModelProtocol,
		 onBooked: VoidCallback? = nil,
		 onDismiss: VoidCallback? = nil,
		 onCanceled: VoidCallback? = nil) {
		_viewModel = State(wrappedValue: viewModel)
		
		self.onBooked = onBooked
		self.onDismiss = onDismiss
		self.onCanceled = onCanceled
	}
	
	var body: some View {
		DefaultScreenView(state: $viewModel.screenState) {
			VVUIKit.ContentView(backgroundColor: Color.white) {
				HStack {
					Spacer()
					
					XClosableButton {
						if viewModel.isBookingCompleted {
							onBooked?()
						} else if viewModel.isCancelCompleted {
							onCanceled?()
						}
						else {
							onDismiss?()
						}
					}
				}.padding(Spacing.space16)
				
				if viewModel.isBookingCompleted {
					bookingCompleted()
				}
				else {
					editBooking()
				}
			}
		} onRefresh: {
			viewModel.onRefresh()
		}.onAppear {
			viewModel.onAppear()
		}.sheet(isPresented: $viewModel.showBookingCancellationConfirmation) {
			CancellationFlow(guests: viewModel.previousBookedSailorIds.count,
							 isAllowedToCancel: viewModel.isWithinCancellationWindow,
							 errorMessage: viewModel.cancelErrorMessage,
			onCancelHandler: { guests in
				return await viewModel.cancelAppointment(guests: guests)
			},
			onDismiss: {
				viewModel.onCancellationFlowDismiss()
			}, onFinish: {
				viewModel.onCancellationFlowFinished()
				onCanceled?()
			})
		}.sheet(isPresented: $viewModel.showAddFriend, content: {
			AddFriendFlow(onDismiss: {
				viewModel.onAddFriendDismiss()
			})
		})
	}
	
	private func editBooking() -> some View {
		VStack(alignment: .leading) {
			VStack(alignment: .leading, spacing: Paddings.defaultVerticalPadding16) {
				Text("Edit Booking")
					.fontStyle(.title)
					.fontWeight(.bold)
				
				VStack(alignment: .leading, spacing: Paddings.zero) {
					Text(viewModel.eateryName)
						.fontStyle(.smallTitle)
					
					Text("Table for \(viewModel.filter.guests.count), \(viewModel.selectedTimeSlot.text)")
						.fontStyle(.body)
						.foregroundStyle(.secondary)
					
					VStack {
						SailorPickerV2(sailors: viewModel.availableSailors,
									   selected: $viewModel.filter.guests,
									   warnings: viewModel.warningForSailors,
									   onAddNew: {
											viewModel.onAddFriendTapped()
										})
						.onChange(of: viewModel.filter.guests) {
							viewModel.onFilterChanged()
						}
					}.padding(Spacing.space16)
				}
				
				VStack(alignment: .leading, spacing: Paddings.defaultVerticalPadding16) {
					Divider()
					
					DateSelector(selected: $viewModel.filter.searchSlotDate, options: viewModel.availableDates)
						.onChange(of: viewModel.filter.searchSlotDate) {
							viewModel.onFilterChanged()
						}
					
					Divider()
				}
				
				VStack(alignment: .leading) {
					Text("Select a timeslot for \(viewModel.filter.searchSlotDate.weekdayName())")
						.fontStyle(.smallTitle)
					
					LoaderWrapper(isLoading: viewModel.isEateriesSlotsLoading) {
						TimeSlotPickerV2(options: viewModel.availableTimeSlots,
										 selected: $viewModel.selectedTimeSlot)
						
						if(viewModel.availableTimeSlots.isEmpty) {
							MessageBar(style: .Warning, text: "No timeslot available")
						}
					}
				}
			}.padding(Paddings.defaultVerticalPadding16)
			
			
			if let errorMessage = viewModel.bookSlotErrorMessage {
				VStack {
					MessageBar(style: .Warning, text: errorMessage)
				}.padding(Paddings.defaultVerticalPadding16)
			}
			
			
			DoubleDivider()
			
			VStack(alignment: .leading) {
				VStack(spacing: Paddings.defaultVerticalPadding16) {
					Button("Update") {
						viewModel.onUpdateBookSlotClick()
					}
					.buttonStyle(PrimaryButtonStyle())
					.disabled(viewModel.IsUpdateButtonDisabled())
					
					Button("Cancel booking") {
						viewModel.onCancelClick()
					}
					.buttonStyle(DismissServiceButtonStyle(foregroundColor: Color.vvDarkGray))
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

#Preview("Edit Eatery Booking") {
	ScrollView {
		EditEateryBookingSheet(viewModel: EditEateryBookingSheetPreviewViewModel())
	}
}

struct EditEateryBookingSheetPreviewViewModel: EditEateryBookingSheetViewModelProtocol {
	var screenState: ScreenState = .content
	
	var availableSailors: [SailorModel] = []
	var warningForSailors: [SailorModel] = []
	
	var availableTimeSlots: [TimeSlotOptionV2] = []
	var selectedTimeSlot: TimeSlotOptionV2 = .empty
	
	var eateryName: String = ""
	var previousBookedSailorIds: [String] = []
	var isWithinCancellationWindow: Bool = false
	var availableDates: [Date] = []
	var filter: EateriesSlotsInputModel = .init()
	var isEateriesSlotsLoading: Bool = false
	var isBookingCompleted: Bool = false
	var isCancelCompleted: Bool = false
	var bookSlotErrorMessage: String? = nil
	var cancelErrorMessage: String? = nil
	var showBookingCancellationConfirmation: Bool = false
	var isCancelBookSlotLoading: Bool = false
	var showAddFriend: Bool = false
	
	init(eateryName: String = "Razzle Dazzle Restaurant") {
		self.eateryName = eateryName
		
		availableSailors = SailorModel.samples()
		availableDates = ItineraryDay.samples().getDates()
		
		availableTimeSlots = TimeSlotOptionV2.samples
		selectedTimeSlot = availableTimeSlots.first?.copy(isHignlighted: true) ?? .empty
		
		filter = .init(guests: availableSailors)
	}
	
	func onAppear() {
		
	}
	
	func onRefresh() {
		
	}
	
	func onFilterChanged() {
		
	}
	
	func onUpdateBookSlotClick() {
		
	}
	
	func onCancelClick() {
		
	}
	
	func cancelAppointment(guests: Int) async -> Bool {
		return false
	}
	
	func onCancellationFlowFinished() {
		
	}
	
	func onCancellationFlowDismiss() {
		
	}
	
	func IsUpdateButtonDisabled() -> Bool {
		return false
	}
	
	func onAddFriendTapped() {
		
	}
	
	func onAddFriendDismiss() {
		
	}
}


