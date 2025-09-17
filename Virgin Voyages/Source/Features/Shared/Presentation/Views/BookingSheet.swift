//
//  BookingSheet.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 29.4.25.
//

import SwiftUI
import VVUIKit

protocol BookingSheetViewModelProtocol {
	var screenState: ScreenState {get set}

	var title: String {get}

	var availableSailors: [SailorModel] {get}
	var warningForSailors: [SailorModel] {get}
	var bookedSailors: [SailorModel] {get}
	var notAllowedSailors: [SailorModel] {get}
	var selectedSailors: [SailorModel] {get set}
	var previousBookedSailorIds: [String] {get}

	var availableDates: [Date] {get}
	var disabledDates: [Date] {get}
	var itineraryDates: [Date] {get}
	var selectedDay: Date {get set}
	var availableTimeSlots: [TimeSlotOptionV2] {get}
	var selectedTimeSlot: TimeSlotOptionV2 {get set}
	var isSingleSelection: Bool {get}
	var isBookingCompleted: Bool {get}
	var isCancelCompleted: Bool {get}

	var bookErrorMessage: String? {get}
	var cancelErrorMessage: String? {get}

	var isEditFlow: Bool {get}
	var isPreviewMyAgendaVisible: Bool {get}
	var showBookingCancellationConfirmation: Bool {get set}
	var showPreviewMyAgendaSheet: Bool {get set}
	var isCancelBookSlotLoading: Bool {get}
	var isWithinCancellationWindow: Bool {get}

	var conflict: BookableConflictsModel? {get}
	var showClarificationStatesSheet: Bool {get set}
	var isNextButtonLoading: Bool {get}
	var showAddNewSailorButton: Bool {get}
	var labels: BookingSheet.Labels { get }

	func onFirstAppear()
	func onReAppear()
	func onRefresh()

	func onCancelTapped()
	func onNextTapped()

	func cancelAppointment(guests: Int) async -> Bool
	func onCancellationFlowFinished()
	func onCancellationFlowDismiss()

	func onDaySelectionChanged()
	func onSailorSelectionChanged()
	func onTimeSlotSelectionChanged()

	func onClarificationStatesSheetDismiss()
	func onClarificationsButtonTapped()

	func onPreviewAgendaTapped()
	func onPreviewMyAgendaDismiss()
	func viewInYourAgendaTapped()

	func isNextButtonDisabled() -> Bool
	func getBookingButtonText() -> String
	func getDescriptionText() -> String?
	func isNonInventoried() -> Bool
	func getSlotBookedTitle() -> String
	func getTotalPriceFormatted() -> String?
}

extension BookingSheet {
	struct Labels {
		let bookingNotAllowed: String
	}
}


struct BookingSheet: View {
	@State var viewModel: BookingSheetViewModelProtocol

	let onBookingAdded: VoidCallback?
	let onBookingUpdated: VoidCallback?
	let onDismiss: VoidCallback?
	let onAddNewSailorTapped: VoidCallback?

	init(viewModel: BookingSheetViewModelProtocol,
		 onBookingAdded: VoidCallback? = nil,
		 onBookingUpdated: VoidCallback? = nil,
		 onDismiss: VoidCallback? = nil,
		 onAddNewSailorTapped: VoidCallback? = nil) {
		_viewModel = State(wrappedValue: viewModel)

		self.onBookingAdded = onBookingAdded
		self.onBookingUpdated = onBookingUpdated
		self.onDismiss = onDismiss
		self.onAddNewSailorTapped = onAddNewSailorTapped
	}

	var body: some View {
		DefaultScreenView(state: $viewModel.screenState) {
			VVUIKit.ContentView(backgroundColor: Color.white) {
				toolbar()
				if !viewModel.isWithinCancellationWindow && viewModel.isEditFlow {
					bookingNotAllowed()
				}
				else if viewModel.isBookingCompleted {
					bookingCompleted()
				}
				else {
					saveBooking()
				}
			}
		} onRefresh: {
			viewModel.onRefresh()
		}.onAppear(onFirstAppear: {
			viewModel.onFirstAppear()

		},
				   onReAppear: {
			viewModel.onReAppear()
		})

		.sheet(isPresented: $viewModel.showPreviewMyAgendaSheet) {
			PreviewMyAgendaSheet(date: viewModel.selectedDay, onDismiss: {
				viewModel.onPreviewMyAgendaDismiss()
			})
		}

		.sheet(isPresented: $viewModel.showBookingCancellationConfirmation) {
			if viewModel.isNonInventoried() {
				NonTicketedCancellationFlow(
					guests: viewModel.previousBookedSailorIds.count,
					isAllowedToCancel: viewModel.isWithinCancellationWindow,
					onCancelHandler: {
						await viewModel.cancelAppointment(guests: $0)
					},
					onDismiss: {
						viewModel.onCancellationFlowDismiss()
					},
					onFinish: {
						viewModel.onCancellationFlowFinished()
					}
				)
			}
			else {
				CancellationFlow(guests: viewModel.previousBookedSailorIds.count,
								 isAllowedToCancel: viewModel.isWithinCancellationWindow,
								 errorMessage: viewModel.cancelErrorMessage,
								 onCancelHandler: {
					await viewModel.cancelAppointment(guests: $0)
				},
								 onDismiss: {
					viewModel.onCancellationFlowDismiss()
				}, onFinish: {
					viewModel.onCancellationFlowFinished()
				})
			}
		}
		.sheet(isPresented: $viewModel.showClarificationStatesSheet) {
			if let conflictDetails = viewModel.conflict?.getHardConflictDetails(sailorIds: viewModel.selectedSailors.getOnlyReservationGuestIds()) {
				ClarificationStatesSheet(conflict: conflictDetails) {
					viewModel.onClarificationStatesSheetDismiss()
				}
			}
		}
	}

	private func toolbar() -> some View {
		HStack {
			Spacer()

			XClosableButton {
				if viewModel.isBookingCompleted {
					if viewModel.isEditFlow {
						onBookingUpdated?()
					} else {
						onBookingAdded?()
					}
				}
				else {
					onDismiss?()
				}
			}
		}.padding(Spacing.space16)
	}

	private func saveBooking() -> some View {
		VStack(alignment: .leading, spacing: Spacing.space0) {
			VStack(alignment: .leading, spacing: Spacing.space16) {

				VStack(alignment: .leading) {
					if viewModel.isEditFlow {
						Text("Edit Booking")
							.font(.vvHeading3Bold)
							.foregroundColor(.darkGray)
							.padding(.bottom, Spacing.space16)
					}

					HStack {
						Text(viewModel.title)
							.font(.vvHeading5Bold)
							.foregroundColor(.darkGray)

						Spacer()

						if let price = viewModel.getTotalPriceFormatted() {
							Text(price)
								.font(.vvHeading5Bold)
								.foregroundColor(.darkGray)
						}
					}

					if let descripion = viewModel.getDescriptionText() {
						Text(descripion)
							.font(.vvBody)
							.foregroundColor(.slateGray)
					}

				}.padding(Spacing.space16)

				VStack(alignment: .leading, spacing: Spacing.space0) {
					SailorPickerV2(sailors: viewModel.availableSailors,
								   selected: $viewModel.selectedSailors,
								   warnings: viewModel.warningForSailors,
								   booked: viewModel.bookedSailors,
								   notAllowed: viewModel.notAllowedSailors,
								   isSingleSelection: viewModel.isSingleSelection,
								   onAddNew: viewModel.showAddNewSailorButton ? { onAddNewSailorTapped?() } : nil,
								   onSelected: {_ in viewModel.onSailorSelectionChanged() }
					)

				}.padding(Spacing.space16)

				if viewModel.availableDates.count > 1 {
					VStack(alignment: .leading, spacing: Spacing.space16) {
						Divider()

						DateSelector(selected: $viewModel.selectedDay,
									 options: viewModel.itineraryDates,
									 disabledDates: viewModel.disabledDates,
									 onSelected: {_ in viewModel.onDaySelectionChanged() }
						)
					}
				}

				if viewModel.availableTimeSlots.count > 1 {
					VStack(alignment: .leading) {
						Divider()

						VStack(alignment: .leading, spacing: Spacing.space16) {
							Text("Select a timeslot for \(viewModel.selectedDay.weekdayName())")
								.font(.vvSmall)
								.foregroundColor(.slateGray)

							TimeSlotPickerV2(options: viewModel.availableTimeSlots,
											 selected: $viewModel.selectedTimeSlot,
											 onSelected: {_ in viewModel.onTimeSlotSelectionChanged() }
							)
						}.padding(Spacing.space16)
					}
				}
			}.padding(Spacing.space0)


			if viewModel.availableTimeSlots.count <= 1 {
				VStack(alignment: .leading) {
					Divider()
				}.padding(.top, Spacing.space16)
			}

			if let errorMessage = viewModel.bookErrorMessage {
				VStack {
					MessageBar(style: .Warning, text: errorMessage)
				}.padding(Spacing.space16)
			}

			//At the moment, we are not showing the soft conflict message until we define the correct messaging

//			if let softConflictMessage = viewModel.conflict?.softConflictDetails?.description {
//				VStack {
//					MessageBar(style: .Warning, text: softConflictMessage)
//				}.padding(Spacing.space16)
//			}

			VStack(alignment: .leading) {
				VStack(spacing: Spacing.space0) {
					if let conflictDetails = viewModel.conflict?.getHardConflictDetails(sailorIds: viewModel.selectedSailors.getOnlyReservationGuestIds()) {
						WarningButton(conflictDetails.buttonText, action:{
							viewModel.onClarificationsButtonTapped()
						})
					} else {
						PrimaryButton(viewModel.getBookingButtonText(),
									  isDisabled: viewModel.isNextButtonDisabled(),
									  isLoading: viewModel.isNextButtonLoading
						) {
							viewModel.onNextTapped()
						}
						if viewModel.isPreviewMyAgendaVisible {
							HorizontalImageTextButton("Preview your Agenda", image: Image("Preview"), action: {
								viewModel.onPreviewAgendaTapped()
							})
						}
					}

					if viewModel.isEditFlow {
						LinkButton("Cancel booking") {
							viewModel.onCancelTapped()
						}
					}
				}
			}.padding(Spacing.space16)
		}
        .padding(Spacing.space0)
        .disabled(viewModel.isNextButtonLoading)
	}

	private func bookingCompleted() -> some View {
		VStack(alignment: .center) {
			VStack(alignment: .center, spacing: Spacing.space16) {
				Image("NonTicketedCancelationConfirmed")
					.resizable()
					.aspectRatio(contentMode: .fit)
					.frame(width: 80, height: 80)
					.padding(.top, Spacing.space64)

				if viewModel.isEditFlow {
					Text("Updated")
						.foregroundStyle(Color.blackText)
						.font(.vvHeading3Bold)
						.padding(.bottom, 10)
				} else {
					Text("Added to your Agenda")
						.foregroundStyle(Color.blackText)
						.font(.vvHeading3Bold)
						.padding(.bottom, 10)

					Text(viewModel.getSlotBookedTitle())
						.foregroundColor(Color.blackText)
						.font(.vvBody)
				}


				Text("This event is first come, first served — arrive early to secure your spot!")
					.foregroundColor(Color.blackText)
					.multilineTextAlignment(.center)
					.font(.vvBody)

			}.padding(Spacing.space16)

			DoubleDivider()

			VStack(alignment: .leading) {
				VStack(spacing: Spacing.space16) {
					PrimaryButton("Done") {
						if viewModel.isEditFlow {
							onBookingUpdated?()
						} else {
							onBookingAdded?()
						}
					}

					LinkButton("View in your Agenda", action: {
						onDismiss?()
						viewModel.viewInYourAgendaTapped()
					})
				}
			}.padding(Spacing.space16)
		}

	}

	private func bookingNotAllowed() -> some View {
		VStack(alignment: .center) {
			VStack(alignment: .center, spacing: Spacing.space16) {
				Image("anchor")
					.resizable()
					.aspectRatio(contentMode: .fit)
					.frame(width: Spacing.space176, height: Spacing.space176)
					.padding(.top, Spacing.space64)

				Text(viewModel.labels.bookingNotAllowed)
					.foregroundColor(Color.gray)
					.multilineTextAlignment(.center)
					.font(.vvBodyLight)


			}.padding(Spacing.space16)


			VStack(alignment: .leading) {
				VStack(spacing: Spacing.space16) {
					SecondaryButton("OK") {
						onDismiss?()
					}
				}
			}.padding(Spacing.space16)
		}

	}
}


#Preview("Booking SDSI") {
	let availableDates: [Date] = [Date()]
	let availableTimeSlots: [TimeSlotOptionV2] = [TimeSlotOptionV2(id:"1", text: "5:00 pm")]

	ScrollView {
		BookingSheet(viewModel: BookingSheetPreviewViewModel(title: "[Heading]",
															 priceFormatted: "[Price]",
															 itineraryDates: availableDates,
															 availableTimeSlots: availableTimeSlots
															))
	}
}

#Preview("Booking SDMI") {
	let availableDates: [Date] = [Date()]
	let availableTimeSlots: [TimeSlotOptionV2] = TimeSlotOptionV2.samples

	ScrollView {
		BookingSheet(viewModel: BookingSheetPreviewViewModel(title: "[Heading]",
															 priceFormatted: "[Price]",
															 itineraryDates: availableDates,
															 availableTimeSlots: availableTimeSlots))
	}
}

#Preview("Booking MDSI") {
	let availableDates: [Date] = DateGenerator.generateDates(from: Date(), totalDays: 7)
	let availableTimeSlots: [TimeSlotOptionV2] = [TimeSlotOptionV2(id:"1", text: "5:00 pm")]

	ScrollView {
		BookingSheet(viewModel: BookingSheetPreviewViewModel(title: "[Heading]",
															 priceFormatted: "[Price]",
															 itineraryDates: availableDates,
															 availableTimeSlots: availableTimeSlots))
	}
}

#Preview("Booking MDMI") {
	let availableDates: [Date] = DateGenerator.generateDates(from: Date(), totalDays: 7)
	let availableTimeSlots: [TimeSlotOptionV2] = TimeSlotOptionV2.samples

	ScrollView {
		BookingSheet(viewModel: BookingSheetPreviewViewModel(title: "[Heading]",
															 priceFormatted: "[Price]",
															 itineraryDates: availableDates,
															 availableTimeSlots: availableTimeSlots))
	}
}

#Preview("Edit booking") {
	ScrollView {
		BookingSheet(viewModel: BookingSheetPreviewViewModel(title: "[Heading]", isEditFlow: true))
	}
}

#Preview("Booking with hard clashes") {
	let availableDates: [Date] = DateGenerator.generateDates(from: Date(), totalDays: 7)
	let availableTimeSlots: [TimeSlotOptionV2] = TimeSlotOptionV2.samples
	let hardClash = BookableConflicts.sampleHardConflict()
	let avaibleSailors = SailorModel.samples()
	let wanringSailors = SailorModel.samples()

	ScrollView {
		BookingSheet(viewModel: BookingSheetPreviewViewModel(title: "[Heading]",
															 priceFormatted: "[Price]",
															 availableSailors: avaibleSailors,
															 warningForSailors: wanringSailors,
															 itineraryDates: availableDates,
															 availableTimeSlots: availableTimeSlots,
															 conflicts: .sampleHardConflict()))
	}
}

#Preview("Booking completed") {
	ScrollView {
		BookingSheet(viewModel: BookingSheetPreviewViewModel(title: "[Heading]",
															 isBookingCompleted: true))
	}
}

#Preview("Booking not allowed") {
	ScrollView {
		BookingSheet(viewModel: BookingSheetPreviewViewModel(title: "[Heading]",
															 isEditFlow: true, isWithinCancellationWindow: false))
	}
}

#Preview("Booking with not allowed sailor") {
	let availableDates: [Date] = DateGenerator.generateDates(from: Date(), totalDays: 7)
	let availableTimeSlots: [TimeSlotOptionV2] = TimeSlotOptionV2.samples
	let availableSailors = SailorModel.samples()
	let notAllowedSailors = [availableSailors[1]]

	ScrollView {
		BookingSheet(viewModel: BookingSheetPreviewViewModel(
			title: "[Heading]",
			priceFormatted: "[Price]",
			availableSailors: availableSailors,
			warningForSailors: [],
			bookedSailors: [],
			notAllowedSailors: notAllowedSailors,
			itineraryDates: availableDates,
			availableTimeSlots: availableTimeSlots
		))
	}
}

class BookingSheetPreviewViewModel : BookingSheetViewModelProtocol {

	var labels: BookingSheet.Labels = .init(bookingNotAllowed: "Hi Sailor - Sorry, but you can’t amend a booking so close to the start time")

	var portNameOrSeaDayText: String? = nil

	var screenState: ScreenState = .content
	var title: String = "Add booking"
	var inventoryState: InventoryState = .nonInventoried

	var priceFormatted: String? = nil

	var availableSailors: [SailorModel] = []
	var warningForSailors: [SailorModel] = []
	var selectedSailors: [SailorModel] = []
	var notAllowedSailors: [SailorModel] = []

	var availableDates: [Date] = []
	var itineraryDates: [Date] = []
	var selectedDay: Date = Date()
	var isSingleSelection: Bool = false
	var availableTimeSlots: [TimeSlotOptionV2] = []
	var selectedTimeSlot: TimeSlotOptionV2 = .empty

	var isBookingCompleted: Bool = false
	var isCancelCompleted: Bool = false

	var bookErrorMessage: String? = nil
	var cancelErrorMessage: String? = nil

	var isEditFlow: Bool = false
	var showBookingCancellationConfirmation: Bool = false
	var isCancelBookSlotLoading: Bool = false
	var isWithinCancellationWindow: Bool = false

	var conflict: BookableConflictsModel? = nil
	var showClarificationStatesSheet: Bool = false

	var bookedSailors: [SailorModel] = []
	var disabledDates: [Date] = []

	var showAddNewSailorButton: Bool = false
	var previousBookedSailorIds: [String] = []
	var showPreviewMyAgendaSheet: Bool

	var isPreviewMyAgendaVisible: Bool {
		return true
	}

	init(title: String,
		 priceFormatted: String? = nil,
		 availableSailors: [SailorModel] = [],
		 warningForSailors: [SailorModel] = [],
		 bookedSailors: [SailorModel] = [],
		 notAllowedSailors: [SailorModel] = [],
		 itineraryDates: [Date] = [],
		 availableTimeSlots: [TimeSlotOptionV2] = [],
		 isEditFlow: Bool = false,
		 conflicts: BookableConflictsModel? = nil,
		 isBookingCompleted: Bool = false,
		 showPreviewMyAgendaSheet: Bool = false,
		 isWithinCancellationWindow: Bool = false

	) {
		self.title = title
		self.priceFormatted = priceFormatted
		self.availableSailors = availableSailors.isEmpty ? SailorModel.samples() : availableSailors
		self.notAllowedSailors = notAllowedSailors
		self.availableDates = itineraryDates.isEmpty ? DateGenerator.generateDates(from: Date(), totalDays: 7) : itineraryDates
		self.availableTimeSlots = availableTimeSlots.isEmpty ? TimeSlotOptionV2.samples : availableTimeSlots
		self.isEditFlow = isEditFlow
		self.conflict = conflicts
		self.warningForSailors = warningForSailors
		self.bookedSailors = bookedSailors
		self.isBookingCompleted = isBookingCompleted
		self.showPreviewMyAgendaSheet = showPreviewMyAgendaSheet
		self.isWithinCancellationWindow = isWithinCancellationWindow
	}

	func onFirstAppear() {

	}

	func onReAppear() {

	}

	func onRefresh() {

	}

	func onCancelTapped() {

	}

	func cancelAppointment(guests: Int) async -> Bool {
		false
	}

	func onCancellationFlowFinished() {

	}

	func onCancellationFlowDismiss() {

	}

	func onDaySelectionChanged() {

	}

	func onSailorSelectionChanged() {

	}

	func onNextTapped() {

	}

	func isNextButtonDisabled() -> Bool {
		false
	}

	func getBookingButtonText() -> String {
		"Next"
	}

	func getDescriptionText() -> String? {
		return nil
	}

	func isNonInventoried() -> Bool {
		return false
	}

	func onTimeSlotSelectionChanged() {

	}

	func onClarificationStatesSheetDismiss() {

	}

	func onClarificationsButtonTapped() {

	}

	func getSlotBookedTitle() -> String {
		"[Title], [Day], [Time]"
	}

	func getTotalPriceFormatted() -> String? {
		return nil
	}

	func onPreviewAgendaTapped() {
		self.showPreviewMyAgendaSheet = true
	}

	func onPreviewMyAgendaDismiss() {
		self.showPreviewMyAgendaSheet = false
	}

	func viewInYourAgendaTapped() {}
	
	var isNextButtonLoading: Bool = false
}

