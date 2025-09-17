//
//  LineUpEventReceiptScreen.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 22.1.25.
//

import SwiftUI
import VVUIKit

@MainActor
protocol LineUpEventReceiptScreenViewModelProtocol {
	var screenState: ScreenState { get set }
	var lineUpReceipt: LineUpReceiptModel { get }
	var showPreVoyageBookingStopped: Bool { get set}
	var showEditFlow: Bool { get set}
	var bookingSheetViewModel: BookingSheetViewModel? { get }
	var showEditButton: Bool { get }
    var availableSailors: [SailorModel] { get }

	func onAppear() async
    func onDisappear()
	func onRefresh()
    func onEditBookingTapped()
    func onViewAllTapped()
}

struct LineUpEventReceiptScreen: View {
	@State var viewModel: LineUpEventReceiptScreenViewModelProtocol
	@State private var webContentHeight: CGFloat = .zero

	private let onBackClick: VoidCallback?

	init(appointmentId: String, onBackClick: @escaping (() -> Void)
	) {
		self.init(viewModel: LineUpEventReceiptViewModel(appointmentId: appointmentId), onBackClick: onBackClick)
	}
	
	init(
		viewModel: LineUpEventReceiptScreenViewModelProtocol,
		onBackClick: VoidCallback? = nil
	) {
		_viewModel = State(wrappedValue: viewModel)
		self.onBackClick = onBackClick
	}
    
	var body: some View {
		DefaultScreenView(state: $viewModel.screenState) {
            ZStack(alignment: .top) {
                VVUIKit.ContentView {
                        ScrollView(.vertical) {
                            VStack(spacing: .zero) {
                                FlexibleProgressImage(url: URL(string: viewModel.lineUpReceipt.imageUrl))
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
                                    TicketStubTearOffSection()
                                    if !viewModel.lineUpReceipt.shortDescription.isEmpty || !viewModel.lineUpReceipt.longDescription.isEmpty {
                                        TicketStubSection(position: .middle) {
                                            receiptDescriptionView()
                                        }
                                        TicketStubTearOffSection()
                                    }
                                    
                                    if !viewModel.lineUpReceipt.needToKnow.isEmpty {
                                        TicketStubSection(position: .bottom) {
                                            receiptDontForgetView()
                                        }
                                    }
                                    receiptEditorialBlocks()
                                        .padding(.top,	Spacing.space16)
                                }
                                .padding()
                                .padding(.top, Paddings.minus50)
                            }
                            
                            DoubleDivider()
                                .padding(.bottom, Spacing.space16)
                            
                            receiptButtonView()
                        }
                }
                toolbar()
                    .padding(.top, Spacing.space24)
            }
			.ignoresSafeArea(edges: [.top])
			.background(Color(uiColor: .systemGray6))
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
        .sheet(isPresented: $viewModel.showPreVoyageBookingStopped) {
            PreVoyageEditingModal {
                viewModel.showPreVoyageBookingStopped = false
            }
        }
        .sheet(isPresented: $viewModel.showEditFlow) {
			if let bookingSheetViewModel = viewModel.bookingSheetViewModel {
				BookingSheetFlow(isPresented: $viewModel.showEditFlow, bookingSheetViewModel: bookingSheetViewModel)
			}
        }
		.navigationBarBackButtonHidden(true)
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

	private func receiptHeaderView() -> some View {
		HStack {
			VStack(alignment: .leading) {
				Text(viewModel.lineUpReceipt.category)
					.fontStyle(.boldSectionTagline)
					.foregroundStyle(Color.squidInk)
				Text(viewModel.lineUpReceipt.name)
					.fontStyle(.largeCaption)
					.foregroundStyle(.black)
			}
			Spacer()
			VStack {
				if let pictogramURL = URL(string: viewModel.lineUpReceipt.pictogramUrl) {
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
				Text(viewModel.lineUpReceipt.startDateTime.toDayMonthDayTime())
					.fontStyle(.largeTagline)
				Spacer()
			}
			HStack {
				Image("Location")
					.frame(width: Sizes.defaultSize16, height: Sizes.defaultSize16)
				Text(viewModel.lineUpReceipt.location)
					.fontStyle(.largeTagline)
				Spacer()
			}
		}
		.frame(alignment: .leading)

	}

	private func receiptPurchaseForView() -> some View {
		VStack(alignment: .leading, spacing: Spacing.space16) {
			Text(viewModel.lineUpReceipt.inventoryState.getInventoryStateTitleForLineUpReceipt())
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
			Text(viewModel.lineUpReceipt.shortDescription)
				.fontStyle(.boldTagline)
				.foregroundStyle(Color.slateGray)
				.multilineTextAlignment(.leading)
			HTMLText(htmlString: viewModel.lineUpReceipt.longDescription,
					 fontType: .normal,
					 fontSize: FontSize.size16,
					 color: .lightGreyColor)
		}
		.frame(maxWidth: .infinity, alignment: .leading)
		.padding(Spacing.space8)
	}

	private func receiptDontForgetView() -> some View {
		VStack(alignment: .leading, spacing: Spacing.space16) {
			Text(viewModel.lineUpReceipt.needToKnowTitle)
				.fontStyle(.boldTagline)
				.foregroundStyle(Color.slateGray)
			ForEach(viewModel.lineUpReceipt.needToKnow, id: \.self) { item in
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
			if viewModel.showEditButton {
				SecondaryButton(viewModel.lineUpReceipt.editText, action: {
					viewModel.onEditBookingTapped()
				}, font: .vvBody)
			}
			
			LinkButton(viewModel.lineUpReceipt.viewAllText, font: .vvBody, action: {
				viewModel.onViewAllTapped()
			})
		}
		.padding(Spacing.space24)
	}
    
    private func receiptEditorialBlocks() -> some View {
        VStack {
            ForEach(viewModel.lineUpReceipt.editorialBlocksWithContent ?? [], id: \.self) { editorial in
                HTMLText(htmlString: editorial.html ?? "", fontType: .normal, fontSize: .size16, color: .slateGray, options: .init(strongOverride: .init(fontType: .bold, fontSize: .size24, color: .blackText), shouldInsertLineBreakAfterStrong: true, wrapInPre: false))
                    .padding(.horizontal, Paddings.defaultHorizontalPadding)
                    .padding(.vertical, Paddings.defaultVerticalPadding32)
            }
        }
    }

}

#Preview("Lineup Event Receipt Screen") {
	LineUpEventReceiptScreen(viewModel: LineUpEventReceiptScreenPreviewViewModel())
}

class LineUpEventReceiptScreenPreviewViewModel: LineUpEventReceiptScreenViewModelProtocol {
    
	var screenState: ScreenState = .content
	var lineUpReceipt: LineUpReceiptModel = .empty()
	var showPreVoyageBookingStopped: Bool = false
	var showEditFlow: Bool = false
	var bookingSheetViewModel: BookingSheetViewModel? = nil
	var showEditButton: Bool = true
    var availableSailors: [SailorModel] = []
	
	init(lineUpReceipt: LineUpReceiptModel = .sample()) {
		self.lineUpReceipt = lineUpReceipt
	}
	
	func onAppear() {
		
	}
	
	func onRefresh() {
		
	}
	
	func onEditBookingTapped() {
		
	}
	
	func onViewAllTapped() {
		
	}
    
    func onDisappear() {
        
    }
}
