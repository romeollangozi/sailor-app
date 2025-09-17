//
//  ReceiptView.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 23.11.24.
//

import SwiftUI
import VVUIKit

@MainActor
protocol ShoreThingReceiptScreenViewModelProtocol {
	var screenState: ScreenState { get set }
	var shoreThingReceipt: ShoreThingReceiptDetails {get}
	var bookingSheetViewModel: BookingSheetViewModel? {get}
	var showPreVoyageEditingStopped: Bool {get set}
	var showEditBooking: Bool {get set}
    var availableSailors: [SailorModel] { get }
	
	func onAppear() async
    func onDisappear()
	func onRefresh()
	func onEditBookingTapped()
	func onViewAllTapped()
}

struct ShoreThingReceiptScreen: View {
	// MARK: - ViewModel
	@State private var viewModel: ShoreThingReceiptScreenViewModelProtocol
	private let onBackClick: VoidCallback?

	// MARK: - Init
	init(viewModel: ShoreThingReceiptScreenViewModelProtocol, onBackClick: VoidCallback? = nil) {
		_viewModel = State(wrappedValue: viewModel)
		self.onBackClick = onBackClick
	}

	var body: some View {
		DefaultScreenView(state: $viewModel.screenState) {
            ZStack(alignment: .top) {
                VVUIKit.ContentView {
                    ZStack(alignment: .topLeading) {
                        ScrollView(.vertical) {
                            VStack(spacing: .zero) {
                                FlexibleProgressImage(url: URL(string: viewModel.shoreThingReceipt.imageUrl))
                                    .frame(height: Sizes.receiptViewImageSize)
                                    .frame(maxWidth: .infinity)
                                
                                VStack(spacing: .zero){
                                    TicketStubSection(position: .top) {
                                        receiptHeaderView()
                                    }
                                    TicketStubTearOffSection()
                                    
                                    TicketStubSection(position: .middle) {
                                        receiptDataLocationView()
                                    }
                                    TicketStubTearOffSection()
                                    
                                    TicketStubSection(position: .middle) {
                                        receiptMoreInfo()
                                    }
                                    TicketStubTearOffSection()
                                    
                                    TicketStubSection(position: .middle) {
                                        receiptPurchaseForView()
                                    }
                                    TicketStubTearOffSection()
                                    
                                    if !viewModel.shoreThingReceipt.reminders.isEmpty {
                                        TicketStubSection(position: .bottom) {
                                            receiptDontForgetView()
                                        }
                                    }
                                }
                                .padding()
                                .padding(.top, Paddings.minus50)
                            }
                            
                            DoubleDivider()
                                .padding(.bottom, Spacing.space16)
                            
                            receiptButtonView()
                        }
                    }
                }
                toolbar()
                    .padding(.top, Spacing.space24)
            }
		} onRefresh: {
			viewModel.onRefresh()
		}
		.onAppear {
            Task {
                await viewModel.onAppear()
            }
		}
        .onDisappear {
            viewModel.onDisappear()
        }
		.sheet(isPresented: $viewModel.showPreVoyageEditingStopped) {
			PreVoyageEditingModal {
				viewModel.showPreVoyageEditingStopped = false
			}
		}
        .sheet(isPresented: $viewModel.showEditBooking) {
			if let bookingSheetViewModel = viewModel.bookingSheetViewModel {
				BookingSheetFlow(isPresented: $viewModel.showEditBooking, bookingSheetViewModel: bookingSheetViewModel)
			}
        }
        .ignoresSafeArea(edges: [.top])
        .background(Color(uiColor: .systemGray6))
	}

	private func toolbar() -> some View {
        HStack(alignment: .top) {
            BackButton({onBackClick?()})
                .padding(.leading, Spacing.space32)
                .padding(.top, Spacing.space32)
                .opacity(0.8)
            Spacer()
        }
	}
	
	private func receiptHeaderView() -> some View {
		HStack {
			VStack(alignment: .leading) {
				Text(viewModel.shoreThingReceipt.category)
					.fontStyle(.boldSectionTagline)
					.foregroundStyle(Color.squidInk)
				Text(viewModel.shoreThingReceipt.name)
					.fontStyle(.largeCaption)
					.foregroundStyle(.black)
			}
			Spacer()
			VStack {
				if let pictogramURL = URL(string: viewModel.shoreThingReceipt.pictogramUrl) {
					SVGImageView(url: pictogramURL)
						.frame(width: Sizes.defaultSize40, height: Sizes.defaultSize40)
				}
			}
		}
		.frame(alignment: .topLeading)
	}
	
	private func receiptDataLocationView() -> some View {
		VStack(alignment: .leading) {
			HStack {
				Image("Calendar")
					.frame(width: Sizes.defaultSize16, height: Sizes.defaultSize16)
				Text(viewModel.shoreThingReceipt.startDateTime.toDayMonthDayTime())
					.fontStyle(.largeTagline)
				Spacer()
			}
			HStack {
				Image("Location")
					.frame(width: Sizes.defaultSize16, height: Sizes.defaultSize16)
				Text(viewModel.shoreThingReceipt.location)
					.fontStyle(.largeTagline)
				Spacer()
			}
		}
		.frame(alignment: .leading)
	}
	
	private func receiptMoreInfo() -> some View {
		VStack(alignment: .leading, spacing: Spacing.space14) {
			VStack(alignment: .leading) {
				Text("Duration")
					.textCase(.uppercase)
					.font(.vvSmallBold)
					.foregroundColor(Color.slateGray)
				
				Text(viewModel.shoreThingReceipt.duration)
					.font(.vvBody)
					.foregroundColor(Color.slateGray)
			}
			
			VStack(alignment: .leading, spacing: Spacing.space0) {
				Text("Port of Call")
					.textCase(.uppercase)
					.font(.vvSmallBold)
					.foregroundColor(Color.slateGray)
				
				Text(viewModel.shoreThingReceipt.portCode)
					.font(.vvBody)
					.foregroundColor(Color.blackText)
			}
			
			if viewModel.shoreThingReceipt.types.count > 0 {
				VStack(alignment: .leading, spacing: Spacing.space0) {
					Text("Type")
						.textCase(.uppercase)
						.font(.vvSmallBold)
						.foregroundColor(Color.slateGray)
					
					Text(viewModel.shoreThingReceipt.types.joined(separator: ", "))
						.font(.vvBody)
						.foregroundColor(Color.slateGray)
				}
			}
		}
		.frame(maxWidth: .infinity, alignment: .leading)
	}
	
	private func receiptPurchaseForView() -> some View {
		VStack(alignment: .leading, spacing: Spacing.space16) {
			Text(viewModel.shoreThingReceipt.inventoryState.getInventoryStateTitleForLineUpReceipt())
				.fontStyle(.boldTagline)
				.foregroundStyle(Color.slateGray)

			ScrollView(.horizontal, showsIndicators: false) {
				HStack(spacing: Paddings.defaultPadding8) {
                    ForEach(viewModel.availableSailors) { sailor in
						AuthURLImageView(imageUrl: sailor.profileImageUrl ?? "", size: Spacing.space48, clipShape: .circle, defaultImage: "ProfilePlaceholder")
					}
				}
			}
		}
		.padding(Spacing.space8)
	}
	
	private func receiptDontForgetView() -> some View {
		VStack(alignment: .leading, spacing: Spacing.space16) {
			Text("DONT'T FORGET")
				.fontStyle(.boldTagline)
				.foregroundStyle(Color.slateGray)
			ForEach(viewModel.shoreThingReceipt.reminders, id: \.self) { item in
				HStack(alignment: .top, spacing: Spacing.space16) {
					Image("NeedToKnow")
						.resizable()
						.frame(width: Sizes.defaultSize24, height: Sizes.defaultSize24)
						.aspectRatio(contentMode: .fit)
					
					Text(item)
						.fontStyle(.lightBody)
						.foregroundColor(.lightGreyColor)
						.multilineTextAlignment(.leading)
				}
			}
		}
		.frame(maxWidth: .infinity, alignment: .leading)
		.padding(Spacing.space8)
	}
	
	private func receiptButtonView() -> some View {
		VStack(spacing: Spacing.space0) {
			if viewModel.shoreThingReceipt.isEditable {
				SecondaryButton("Edit/Cancel", action: {
					viewModel.onEditBookingTapped()
				}, font: .vvBody)
			}
			
			LinkButton("View all Shore Things", font: .vvBody, action: {
				viewModel.onViewAllTapped()
			})
		}
	}
}

#Preview("Shore thing receipt screen") {
	ShoreThingReceiptScreen(viewModel: ShoreThingReceiptScreenPreviewViewModel())
}

#Preview("Shore thing receipt screen with past slot") {
	@Previewable let details = ShoreThingReceiptDetails.sample()
		.copy(selectedSlot: Slot.sample().copy(status: .passed))
	
	ShoreThingReceiptScreen(viewModel: ShoreThingReceiptScreenPreviewViewModel(shoreThingReceipt: details))
}

class ShoreThingReceiptScreenPreviewViewModel: ShoreThingReceiptScreenViewModelProtocol {
    var screenState: ScreenState = .content
	var shoreThingReceipt: ShoreThingReceiptDetails = .empty()
	var showPreVoyageEditingStopped: Bool = false
	var showEditBooking: Bool = false
	var bookingSheetViewModel: BookingSheetViewModel? = nil
    var availableSailors: [SailorModel] = []
	
	init(shoreThingReceipt: ShoreThingReceiptDetails = .sample()) {
		self.shoreThingReceipt = shoreThingReceipt
	}
	
	func onAppear() {}
    
    func onDisappear() {}
    
	func onRefresh() {}
	
	func onEditBookingTapped() {}
	
	func onViewAllTapped() {}
}
