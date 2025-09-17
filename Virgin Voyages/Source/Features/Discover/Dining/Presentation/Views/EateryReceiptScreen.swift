//
//  EateryReceiptScreen.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 7.4.25.
//

import SwiftUI
import VVUIKit

protocol EateryReceiptScreenViewModelProtocol {
	var screenState: ScreenState {get set}
	var appointmentDetails: EateryAppointmentDetails {get}
	var showEditSlotBookSheet: Bool {get set}
	var editBookingViewModel: EditBookingSheetViewModel? {get}
	var eateryWithSlots: EateriesSlots.Restaurant? {get}
    var availableSailors: [SailorModel] { get }
	
	func onAppear()
	func onRefresh()
	func onEditBookingClick()
	func onBookingCompleted()
	func onBookingCanceled()
	func onEditBookingSheetDismiss()
	func onViewAllTapped()
}

struct EateryReceiptScreen: View {
	@State var viewModel: EateryReceiptScreenViewModelProtocol
	
	let onBackClick: VoidCallback?
	let onBookingCompleted: VoidCallback?
	let onBookingCanceled: VoidCallback?
	
	init(appointmentId: String,
		 onBackClick: VoidCallback? = nil,
		 onBookingCompleted: VoidCallback? = nil,
		 onBookingCanceled: VoidCallback? = nil) {
		self.init(viewModel: EateryReceiptScreenViewModel(appointmentId: appointmentId),
				  onBackClick: onBackClick,
				  onBookingCompleted: onBookingCompleted,
				  onBookingCanceled: onBookingCanceled)
	}
	
	init(viewModel: EateryReceiptScreenViewModelProtocol,
		 onBackClick: VoidCallback? = nil,
		 onBookingCompleted: VoidCallback? = nil,
		 onBookingCanceled: VoidCallback? = nil) {
		_viewModel = State(wrappedValue: viewModel)
		
		self.onBackClick = onBackClick
		self.onBookingCompleted = onBookingCompleted
		self.onBookingCanceled = onBookingCanceled
	}
	
	var body: some View {
		DefaultScreenView(state: $viewModel.screenState) {
            ZStack(alignment: .top) {
                VVUIKit.ContentView {
                    ZStack(alignment: .topLeading) {
                        ScrollView(.vertical) {
                            VStack(spacing: .zero) {
                                FlexibleProgressImage(url: URL(string: viewModel.appointmentDetails.imageUrl))
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
                                        receiptPurchaseForView()
                                    }
                                    
                                    if !viewModel.appointmentDetails.needToKnows.isEmpty {
                                        TicketStubTearOffSection()
                                        
                                        TicketStubSection(position: .bottom) {
                                            receiptNeedToKnowView()
                                        }
                                    }
                                }.padding(.horizontal, Spacing.space16)
                                    .offset(y: -30)
                            }
                            
                            DoubleDivider()
                            
                            receiptButtonView()
                        }
                    }
                }
                toolbar()
                    .padding(.top, Spacing.space24)
			}
			.ignoresSafeArea(edges: [.top])
			.navigationTitle("")
			.navigationBarBackButtonHidden(true)
			.background(Color(uiColor: .systemGray6))
		} onRefresh: {
			viewModel.onRefresh()
		}.onAppear {
			viewModel.onAppear()
		}.sheet(isPresented: $viewModel.showEditSlotBookSheet) {
			if viewModel.appointmentDetails.isPreVoyageBookingStopped {
				PreVoyageEditingModal {
					viewModel.onEditBookingSheetDismiss()
				}
			} else if let editBookingViewModel = viewModel.editBookingViewModel {
				EditEateryBookingSheet(viewModel: editBookingViewModel,
									   onBooked: {
					viewModel.onBookingCompleted()
				},
									   onDismiss: {
					viewModel.onEditBookingSheetDismiss()
				},
									   onCanceled: {
					viewModel.onBookingCanceled()
				})
			}
		}
	}
	
	private func receiptHeaderView() -> some View {
		HStack {
			VStack(alignment: .leading) {
				Text(viewModel.appointmentDetails.category)
					.font(.vvCaptionBold)
					.foregroundColor(Color.deepPurple)
				Text(viewModel.appointmentDetails.name)
					.font(.vvHeading3Bold)
					.foregroundColor(.blackText)
			}
			
			Spacer()
			
			VStack {
				if let pictogramURL = URL(string: viewModel.appointmentDetails.pictogramUrl) {
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
				Text(viewModel.appointmentDetails.startDateTime.toDayMonthDayTime())
					.font(.vvHeading5)
					.foregroundColor(.blackText)
				Spacer()
			}
			
			HStack {
				Image("Location")
					.frame(width: Sizes.defaultSize16, height: Sizes.defaultSize16)
				Text(viewModel.appointmentDetails.location)
					.font(.vvHeading5)
					.foregroundColor(.blackText)
				Spacer()
			}
		}
		.frame(alignment: .leading)
	}
	
	private func receiptPurchaseForView() -> some View {
		VStack(alignment: .leading, spacing: Spacing.space16) {
			Text(viewModel.appointmentDetails.inventoryState.getInventoryStateTitleForLineUpReceipt())
				.font(.vvSmallBold)
				.foregroundColor(Color.slateGray)
			
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
	
	private func receiptNeedToKnowView() -> some View {
		VStack(alignment: .leading, spacing: Spacing.space16) {
			Text("Need to know")
				.textCase(.uppercase)
				.fontStyle(.boldTagline)
				.foregroundStyle(Color.slateGray)
			ForEach(viewModel.appointmentDetails.needToKnows, id: \.self) { item in
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
		VStack(spacing: Spacing.space16) {
			if viewModel.appointmentDetails.isEditable {
				SecondaryButton("Edit/Cancel", action: {
					viewModel.onEditBookingClick()
				}, font: .vvBody)
			}
			
			LinkButton("View all Eateries", font: .vvBody, action: {
				viewModel.onViewAllTapped()
			})
		}
		.padding(Spacing.space24)
	}
	
	private func toolbar() -> some View {
		HStack(alignment: .top) {
			BackButton({
				onBackClick?()
			})
			.padding(.leading, Spacing.space32)
			.padding(.top, Spacing.space32)
			.opacity(0.8)
            Spacer()
		}
	}
	
}

#Preview("Eatery Receipt Screen") {
	EateryReceiptScreen(viewModel: EateryReceiptScreenPreviewViewModel())
}

struct EateryReceiptScreenPreviewViewModel : EateryReceiptScreenViewModelProtocol {
	var screenState: ScreenState = .content
	var appointmentDetails: EateryAppointmentDetails
	var showEditSlotBookSheet = false
	var showEditButton: Bool = true
	var editBookingViewModel: EditBookingSheetViewModel? = nil
	var eateryWithSlots: EateriesSlots.Restaurant? = nil
    var availableSailors: [SailorModel] = []
	
	init(appointmentDetails: EateryAppointmentDetails = EateryAppointmentDetails.sample()) {
		self.appointmentDetails = appointmentDetails
	}
	
	func onAppear() {
		
	}
	
	func onRefresh() {
		
	}
	
	func onEditBookingClick() {
		
	}
	
	func onBookingCompleted() {
		
	}
	
	func onBookingCanceled() {
		
	}
	
	func onEditBookingSheetDismiss() {
		
	}
	
	func onViewAllTapped() {
		
	}
}
