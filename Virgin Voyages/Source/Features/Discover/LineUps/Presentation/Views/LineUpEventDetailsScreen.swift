//
//  LineUpEventDetails.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 17.1.25.
//

import SwiftUI
import VVUIKit

protocol LineUpEventDetailsScreenViewModelProtocol {
	var screenState: ScreenState { get set }
	var event: LineUpEvents.EventItem { get }

	var showBookEventSheet: Bool { get set }
	var showPreVoyageBookingStopped: Bool { get set }

	var bookingSheetViewModel: BookingSheetViewModel? { get }

	func onAppear()
	func onRefresh()
	func addToAgenda()
	func navigateBack()
}

struct LineUpEventDetailsScreen: View {
	@State var viewModel: LineUpEventDetailsScreenViewModelProtocol

	let backAction: VoidCallback?
	let onViewReceiptClick: ((String) -> Void)?

	init(
		event: LineUpEvents.EventItem,
		backAction: (() -> Void)? = nil,
		onViewReceiptClick: ((String) -> Void)? = nil
	) {
		self.init(viewModel: LineUpEventDetailsScreenViewModel(event: event), backAction: backAction, onViewReceiptClick: onViewReceiptClick)
	}

	init(
		viewModel: LineUpEventDetailsScreenViewModelProtocol,
		backAction: VoidCallback? = nil,
		onViewReceiptClick: ((String) -> Void)? = nil
	) {
		_viewModel = State(wrappedValue: viewModel)

		self.backAction = backAction
		self.onViewReceiptClick = onViewReceiptClick
	}

	var body: some View {
		DefaultScreenView(state: $viewModel.screenState) {
            ZStack(alignment: .top) {
                VVUIKit.ContentView(backgroundColor: .white) {
                    VStack(alignment: .leading, spacing: .zero) {
                        header()
                        
                        titleAndInfo()
                        
                        content()
                    }
                }
                toolbar()
                    .padding(.top, Spacing.space24)
            }
		} onRefresh: {
			viewModel.onRefresh()
		}
		.sheet(isPresented: $viewModel.showBookEventSheet) {
			if let bookingSheetViewModel = viewModel.bookingSheetViewModel {
				BookingSheetFlow(isPresented: $viewModel.showBookEventSheet, bookingSheetViewModel: bookingSheetViewModel)
			}
		}
		.sheet(isPresented: $viewModel.showPreVoyageBookingStopped) {
			PreVoyageEditingModal {
				viewModel.showPreVoyageBookingStopped = false
			}
		}
		.onAppear {
			viewModel.onAppear()
		}
		.ignoresSafeArea(edges: [.top])
		.navigationTitle("")
		.navigationBarBackButtonHidden(true)
		.toolbar {
			ToolbarItem(placement: .bottomBar) {
				addToAgendaButton()
					.background(Color.white)
			}
		}
		.toolbarBackground(.white, for: .bottomBar)
	}

	private func header() -> some View {
		VStack(alignment:.leading, spacing: Spacing.space0) {
			ZStack(alignment: .topLeading) {
				ZStack(alignment: .bottomLeading) {
					if let imageUrl = viewModel.event.imageUrl, let url = URL(string: imageUrl) {
						FlexibleProgressImage(url: url, heightRatio: 0.6)
							.grayscale(viewModel.event.selectedSlot?.status != SlotStatus.available ? 1.0 : 0.0)
					} else {
						Color.gray
							.frame(maxWidth: .infinity)
					}

					if let price = viewModel.event.priceFormatted, !price.isEmpty {
						let style = viewModel.event.selectedSlot?.status == .available ? MessageBarStyle.Purple : MessageBarStyle.Dark
						let statusText = viewModel.event.selectedSlotStatusText
						let text = viewModel.event.selectedSlot?.status == .available
							? price
							: statusText?.isEmpty == false
								? "\(price) | \(statusText!)"
								: price
						let fullWidth = viewModel.event.selectedSlot?.status != .available
						MessageBar(style: style, text: text, fullWidht: fullWidth)
					} else if viewModel.event.selectedSlot?.status != .available {
						if let selectedSlotStatusText = viewModel.event.selectedSlotStatusText {
							MessageBar(
								style: MessageBarStyle.Dark,
								text: selectedSlotStatusText
							)
						}
					}
				}
			}
			.frame(maxWidth: .infinity)

			//TODO: At the moment the backend is not sending multiple appointments for the same event.
			//Once it is implemented, we will use the appointments() to render the multiple messages.
			if let appointments = viewModel.event.appointments, appointments.items.count > 0 {
				let style = viewModel.event.inventoryState == .nonInventoried
				? MessageBarStyle.Info
				: MessageBarStyle.Success

				MessageBar(style: style, text: appointments.bannerText)
					.onTapGesture {
						onViewReceiptClick?(appointments.items[0].id)
					}
			}
		}
	}

	private func appointments() -> some View {
		VStack(spacing: Spacing.space0) {
			if let appointments = viewModel.event.appointments, appointments.items.count > 0 {
				let style = viewModel.event.inventoryState == .nonInventoried
				? MessageBarStyle.Info
				: MessageBarStyle.Success

				if appointments.items.count == 1 {
					MessageBar(style: style, text: appointments.items[0].bannerText)
						.onTapGesture {
							onViewReceiptClick?(appointments.items[0].id)
						}
				} else {
					VStack(spacing: Spacing.space0) {
						MessageBar(style: style, text: appointments.bannerText)

						ForEach(appointments.items, id: \.id) { item in
							MessageBar(style: style, text: item.bannerText)
								.onTapGesture {
									onViewReceiptClick?(item.id)
								}
						}
					}
				}
			}
		}
	}

	private func titleAndInfo() -> some View {
		VStack(alignment: .leading) {
			VStack(alignment: .leading, spacing: Spacing.space16) {
				Text(viewModel.event.name)
					.font(.vvHeading1Bold)

				VStack(alignment: .leading, spacing: Spacing.space8) {
					HStack(spacing: Spacing.space8) {
						Image("Location")
						Text(viewModel.event.location)
							.font(.vvHeading5)
							.foregroundColor(.blackText)
					}

					HStack(spacing: Spacing.space8) {
						Image("Calendar")
						Text(viewModel.event.selectedSlot?.startDateTime.toDayMonthDayTime() ?? "")
							.font(.vvHeading5)
							.foregroundColor(.blackText)
					}

					if viewModel.event.inventoryState == .nonInventoried {
						HStack(spacing: Spacing.space8) {
							Image("Ticket")
							Text("Non-ticketed event")
								.font(.vvHeading5)
								.foregroundColor(.blackText)
						}
					}

				}
			}
			.frame(maxWidth: .infinity, alignment: .leading)
			.padding(Spacing.space24)
		}
		.frame(maxWidth: .infinity)
		.background(Color.softGray)
	}

	private func content() -> some View {
		VStack(alignment: .leading) {
			VStack(alignment: .leading, spacing: Spacing.space24) {

				VStack(alignment: .leading, spacing: Spacing.space16) {
					Text(viewModel.event.introduction ?? "")
						.font(.vvHeading3Light)

					if let longDescription = viewModel.event.longDescription {
						HTMLText(htmlString: longDescription,
								 fontType: FontType.normal,
								 fontSize: FontSize.size16,
								 color: Color.slateGray)
					}
				}

				if viewModel.event.otherTimes.count > 0 {
					VStack(alignment: .leading, spacing: Spacing.space16) {
						Text("Other times")
							.font(.vvHeading3Bold)

						VStack(alignment: .leading, spacing: Spacing.space8) {
							ForEach(viewModel.event.otherTimes, id: \.self) { x in
								HStack(spacing: Spacing.space8) {
									Image("Calendar")
									Text(x.startDateTime.toDayMonthDayTime())
										.font(.vvHeading5)
										.foregroundColor(.blackText)
								}
							}
						}
					}
				}


			}.padding(Spacing.space24)
			needToKnow()
			receiptEditorialBlocks()
		}.background(Color.white)
	}

	private func addToAgendaButton() -> some View {
		LoadingButton(
			title: viewModel.event.bookButtonText ?? "Add to agenda",
			loading: false
		) {
			viewModel.addToAgenda()
		}
		.buttonStyle(PrimaryButtonStyle())
		.padding(.bottom, Spacing.space24)
	}

	private func needToKnow() -> some View {
		VStack {
			if viewModel.event.needToKnows.count > 0 {
				VStack(alignment: .leading) {
					Text("Need to know")
						.frame(alignment: .leading)
						.fontStyle(.largeCaption)
						.foregroundColor(.black)
						.multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
					VStack(alignment: .leading, spacing: Paddings.defaultVerticalPadding16) {
						ForEach(viewModel.event.needToKnows, id: \.self) { item in
							HStack(alignment: .top, spacing: Paddings.defaultVerticalPadding16) {
								Image("NeedToKnow")
									.resizable()
									.frame(width: 24, height: 24)
									.aspectRatio(contentMode: .fit)
								Text(item)
									.fontStyle(.lightBody)
									.foregroundColor(.lightGreyColor)
									.multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
							}
							.padding(.bottom, Paddings.defaultVerticalPadding)
						}
					}
				}
				.frame(maxWidth: .infinity, alignment: .leading)
				.padding(.horizontal, Paddings.defaultHorizontalPadding)
				.padding(.vertical, Paddings.defaultVerticalPadding32)
				.background(Color.addonSecondaryColor)
			}
		}
	}
    
	private func receiptEditorialBlocks() -> some View {
		VStack {
            ForEach(viewModel.event.editorialBlocksWithContent ?? [], id: \.self) { editorial in
                HTMLText(htmlString: editorial.html ?? "", fontType: .normal, fontSize: .size16, color: .slateGray, options: .init(strongOverride: .init(fontType: .bold, fontSize: .size24, color: .blackText), shouldInsertLineBreakAfterStrong: true, wrapInPre: false))
                    .padding(.horizontal, Paddings.defaultHorizontalPadding)
                    .padding(.vertical, Paddings.defaultVerticalPadding32)
			}
		}
	}
    
    private func toolbar() -> some View {
        HStack(alignment: .top) {
            BackButton {
                (backAction ?? viewModel.navigateBack)()
            }
            .padding(.leading, Spacing.space32)
            .padding(.top, Spacing.space32)
            .opacity(0.8)
            Spacer()
        }
    }
}

#Preview("Non inventoried") {
	LineUpEventDetailsScreen(viewModel: LineUpEventDetailsScreenPreviewViewModel(event: LineUpEvents.EventItem.sample().copy(slots:[Slot.sample(), Slot.sample()])))
}

#Preview("Inventoried") {
	LineUpEventDetailsScreen(viewModel: LineUpEventDetailsScreenPreviewViewModel(event: LineUpEvents.EventItem.sample().copy(inventoryState: InventoryState.nonPaidInventoried)))
}

#Preview("Sold out") {
	LineUpEventDetailsScreen(viewModel: LineUpEventDetailsScreenPreviewViewModel(event: LineUpEvents.EventItem.sample().copy(selectedSlot: Slot.sample().copy(status: SlotStatus.soldOut))))
}

#Preview("Booking Closed") {
	LineUpEventDetailsScreen(viewModel: LineUpEventDetailsScreenPreviewViewModel(event: LineUpEvents.EventItem.sample().copy(selectedSlot: Slot.sample().copy(status: SlotStatus.closed))))
}

#Preview("Inventoried Paid") {
	LineUpEventDetailsScreen(viewModel: LineUpEventDetailsScreenPreviewViewModel(event: LineUpEvents.EventItem.sample().copy(priceFormatted: "$10", selectedSlot: Slot.sample().copy(status: SlotStatus.available))))
}

#Preview("Inventoried Paid Passed") {
	LineUpEventDetailsScreen(viewModel: LineUpEventDetailsScreenPreviewViewModel(event: LineUpEvents.EventItem.sample().copy(priceFormatted: "$10", selectedSlot: Slot.sample().copy(status: SlotStatus.passed))))
}

#Preview("Inventoried Paid Booked") {
	LineUpEventDetailsScreen(viewModel: LineUpEventDetailsScreenPreviewViewModel(event: LineUpEvents.EventItem.sample().copy(
		priceFormatted: "$10",
		appointments:
			Appointments(bannerText: "Booked: 1 ticket for this Event", items: [AppointmentItem.sample().copy(bannerText: "Booked: 1 ticket for this Event")]),
		inventoryState: InventoryState.paidInventoried
	)))
}

#Preview("Inventoried Paid Booked Multiple Times") {
	
	LineUpEventDetailsScreen(viewModel: LineUpEventDetailsScreenPreviewViewModel(event: LineUpEvents.EventItem.sample().copy(
		priceFormatted: "$10",
		appointments: Appointments(bannerText: "Booked: Multiple bookings",
								   items: [AppointmentItem.sample().copy(bannerText: "1 ticket, Wed July 20, 9am"),
										   AppointmentItem.sample().copy(bannerText: "1 ticket, Thu July 21, 9am")]
								  ),
		inventoryState: InventoryState.paidInventoried
	)))
}

#Preview("Inventoried Non Paid Booked") {
	LineUpEventDetailsScreen(viewModel: LineUpEventDetailsScreenPreviewViewModel(event: LineUpEvents.EventItem.sample().copy(
		priceFormatted: nil,
		appointments: Appointments(bannerText: "Booked: 1 ticket for this Event", items: [AppointmentItem.sample().copy(bannerText: "Booked: 1 ticket for this Event")]),
		inventoryState: InventoryState.nonPaidInventoried
	)))
}

#Preview("Non Inventoried Booked") {
	LineUpEventDetailsScreen(viewModel: LineUpEventDetailsScreenPreviewViewModel(event: LineUpEvents.EventItem.sample().copy(
		priceFormatted: "$10",
		appointments: Appointments(bannerText: "Added to agenda, Sun October 20, 10:30am", items: [AppointmentItem.sample().copy(bannerText: "Added to agenda, Sun October 20")]),
		inventoryState: InventoryState.nonInventoried
	)))
}

private struct LineUpEventDetailsScreenPreviewViewModel : LineUpEventDetailsScreenViewModelProtocol {
	var screenState: ScreenState = .content
	var event: LineUpEvents.EventItem
	var showBookEventSheet: Bool = false
	var showPreVoyageBookingStopped: Bool = false
	var bookingSheetViewModel: BookingSheetViewModel? = nil

	init(event: LineUpEvents.EventItem) {
		self.event = event
	}
	
	func onAppear() { }
	func onRefresh() {}
	func addToAgenda() {}
	func navigateBack() {}
}
