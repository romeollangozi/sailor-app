//
//  TreatmentReceipt 2.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 5.2.25.
//

import SwiftUI
import VVUIKit

@MainActor
protocol TreatmentReceiptScreenViewModelProtocol {
	var screenState: ScreenState { get set }
	var treatmentReceiptModel: TreatmentReceiptModel { get }
	var showEditFlow: Bool { get set }
    var showPreVoyageBookingStopped: Bool { get set }
    var showEditButton: Bool { get }
	var bookingSheetViewModel: BookingSheetViewModel? {get}
    var availableSailors: [SailorModel] { get }
    
	func onAppear()
	func editBooking()
	func onViewAllTapped()
}

struct TreatmentReceiptScreen: View {
	@State var viewModel: TreatmentReceiptScreenViewModelProtocol
	private let onBackClick: VoidCallback?
	
	init(viewModel: TreatmentReceiptScreenViewModelProtocol, onBackClick: VoidCallback? = nil){
		_viewModel = State(wrappedValue: viewModel)
		self.onBackClick = onBackClick
	}

	init(
		appointmentId: String,
		onBackClick: VoidCallback? = nil) {
			self.init(viewModel: TreatmentReceiptScreenViewModel(appointmentId: appointmentId), onBackClick: onBackClick)
	}

	var body: some View {
		DefaultScreenView(state: $viewModel.screenState) {
            ZStack{
                VVUIKit.ContentView {
                    ZStack(alignment: .topLeading) {
                        ScrollView(.vertical) {
                            VStack(spacing: .zero) {
                                FlexibleProgressImage(url: URL(string: viewModel.treatmentReceiptModel.imageUrl))
                                    .frame(height: Sizes.receiptViewImageSize)
                                    .frame(maxWidth: .infinity)
                                
                                VStack(spacing: .zero) {
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
                                    TicketStubTearOffSection()
                                    
                                    if !viewModel.treatmentReceiptModel.shortDescription.isEmpty || !viewModel.treatmentReceiptModel.longDescription.isEmpty {
                                        TicketStubSection(position: .bottom) {
                                            receiptDescriptionView()
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
                .ignoresSafeArea(edges: [.top])
                .background(Color(uiColor: .systemGray6))
                toolbar()
            }

		} onRefresh: {
			viewModel.onAppear()
		}
		.onAppear {
			viewModel.onAppear()
		}
		.sheet(isPresented: $viewModel.showEditFlow) {
			if let bookingSheetViewModel = viewModel.bookingSheetViewModel {
				BookingSheetFlow(isPresented: $viewModel.showEditFlow, bookingSheetViewModel: bookingSheetViewModel)
			}
		}
        .sheet(isPresented: $viewModel.showPreVoyageBookingStopped) {
            PreVoyageEditingModal {
                viewModel.showPreVoyageBookingStopped = false
            }
        }
		.navigationBarBackButtonHidden(true)
	}

	private func toolbar() -> some View {
        VStack(alignment: .leading, spacing: Spacing.space32) {
			if viewModel.screenState == .content {
				BackButton({onBackClick?()})
                    .padding(.horizontal, Spacing.space24)
					.opacity(0.8)
                Spacer()
			}
		}
		.frame(maxWidth: .infinity, alignment: .leading)
	}

	private func receiptHeaderView() -> some View {
		HStack {
			VStack(alignment: .leading) {
				Text(viewModel.treatmentReceiptModel.category)
					.fontStyle(.boldSectionTagline)
					.foregroundStyle(Color.squidInk)
				Text(viewModel.treatmentReceiptModel.name)
					.fontStyle(.largeCaption)
					.foregroundStyle(.black)
			}
			Spacer()
			VStack {
				if let pictogramURL = URL(string: viewModel.treatmentReceiptModel.pictogramUrl) {
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
				Text(viewModel.treatmentReceiptModel.startDateTime.toDayMonthDayTime())
					.fontStyle(.largeTagline)
				Spacer()
			}
			HStack {
				Image("Time")
					.frame(width: Sizes.defaultSize16, height: Sizes.defaultSize16)
				Text(viewModel.treatmentReceiptModel.duration)
					.fontStyle(.largeTagline)
				Spacer()
			}
			HStack {
				Image("Location")
					.frame(width: Sizes.defaultSize16, height: Sizes.defaultSize16)
				Text(viewModel.treatmentReceiptModel.location)
					.fontStyle(.largeTagline)
				Spacer()
			}
		}
		.frame(alignment: .leading)
	}

	private func receiptPurchaseForView() -> some View {
		VStack(alignment: .leading, spacing: Spacing.space16) {
			Text(viewModel.treatmentReceiptModel.bookedForText.uppercased())
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

	private func receiptDescriptionView() -> some View {
		VStack(alignment: .leading, spacing: Spacing.space16) {
			Text(viewModel.treatmentReceiptModel.shortDescription)
				.fontStyle(.boldTagline)
				.foregroundStyle(Color.slateGray)
				.multilineTextAlignment(.leading)
			HTMLText(htmlString: viewModel.treatmentReceiptModel.longDescription,
					 fontType: .normal,
					 fontSize: FontSize.size16,
					 color: .lightGreyColor)
		}
		.frame(maxWidth: .infinity, alignment: .leading)
		.padding(Spacing.space8)
	}

	private func receiptButtonView() -> some View {
		VStack(spacing: Spacing.space24) {
            if viewModel.showEditButton {
                LoadingButton(title: viewModel.treatmentReceiptModel.editCancelTitle, loading: false) {
                    viewModel.editBooking()
                }
                .buttonStyle(AdaptiveButtonStyle())
                .padding()
                .frame(maxWidth: .infinity)
            }

			Button(viewModel.treatmentReceiptModel.viewAllTitle) {
				viewModel.onViewAllTapped()
			}
			.buttonStyle(TertiaryLinkStyle())
		}
		.padding()
	}
}

struct TreatmentReceiptScreen_Previews: PreviewProvider {
	static var previews: some View {
		NavigationStack {
			TreatmentReceiptScreen(viewModel: TreatmentReceiptScreenMockViewModel())
		}
	}
}

struct TreatmentReceiptScreenMockViewModel: TreatmentReceiptScreenViewModelProtocol {
    
	var showPreVoyageBookingStopped: Bool = false
	var showEditFlow: Bool = false
	var showcancellationFlow: Bool = false
	var screenState: ScreenState = .content
	var treatmentReceiptModel: TreatmentReceiptModel = TreatmentReceiptModel.sample()
    var showEditButton: Bool = false
	var bookingSheetViewModel: BookingSheetViewModel? = nil
    var isLoadingReceipt: Bool = false
    var availableSailors: [SailorModel] = []
    
	func editBooking() {}
	func onAppear() {}
	func onRefresh() {}
	func hideCancellation() {}
	func cancelAppointment(numberOfGuests: Int) async -> Bool {
		return false
	}
	
	func onViewAllTapped() {
		
	}
}
