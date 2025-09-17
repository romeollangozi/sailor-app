//
//  AddOnDetailsView.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 26.9.24.
//

import SwiftUI
import VVUIKit

protocol AddOnDetailsViewModelProtocol {
	var addOn: AddOn { get }
	var isShowingPurchaseSheet: Bool { get set }
	var isShowingBookingSummary: Bool { get set }
	var screenState: ScreenState { get set }

	var bookingSheetViewModel: BookingSheetViewModel? {get}
	var summaryInputModel: BookingSummaryInputModel? { get }

	func onAppear()
	func onRefresh()
	func purchase()
}

struct AddOnDetailsScreen: View {
    // MARK: - State properties
    @State private var viewModel: AddOnDetailsViewModelProtocol
    
    // MARK: - Navigation
	let onBackClick: VoidCallback?
	let onViewReceiptClick: ((String) -> Void)?
    
	init(addOn: AddOn,
		 onBackClick: VoidCallback? = nil,
		 onViewReceiptClick: ((String) -> Void)? = nil
	) {
		self.init(viewModel: AddOnDetailsViewModel(addOn: addOn), onBackClick: onBackClick, onViewReceiptClick: onViewReceiptClick)
	}

    init(addOnCode: String,
         onBackClick: VoidCallback? = nil,
         onViewReceiptClick: ((String) -> Void)? = nil) {
        self.init(viewModel: AddOnDetailsViewModel(addOnCode: addOnCode), onBackClick: onBackClick, onViewReceiptClick: onViewReceiptClick)
    }
	
    init(viewModel: AddOnDetailsViewModelProtocol,
		 onBackClick: VoidCallback? = nil,
		 onViewReceiptClick: ((String) -> Void)? = nil) {
        _viewModel = State(wrappedValue: viewModel)
		
        self.onBackClick = onBackClick
        self.onViewReceiptClick = onViewReceiptClick
    }

    var body: some View {
		DefaultScreenView(state: $viewModel.screenState) {
			contentView()
		} onRefresh: {
			viewModel.onRefresh()
		}
		.onAppear() {
			viewModel.onAppear()
		}
		.ignoresSafeArea(edges: [.top])
		.sheet(isPresented: $viewModel.isShowingPurchaseSheet) {
            if let bookingSheetViewModel = viewModel.bookingSheetViewModel {
                BookingSheetFlow(isPresented: $viewModel.isShowingPurchaseSheet, bookingSheetViewModel: bookingSheetViewModel)
            }
		}
		.sheet(isPresented: $viewModel.isShowingBookingSummary) {
			if let purchaseSummaryInputModel = viewModel.summaryInputModel {
				BookingSheetFlow(isPresented: $viewModel.isShowingBookingSummary, summaryInput: purchaseSummaryInputModel)
			}
		}
    }
    
    // MARK: - View builders
    private func toolbar() -> some View {
        HStack(alignment: .top, spacing: Spacing.space32) {
			BackButton({onBackClick?()})
                .padding(.leading, Spacing.space32)
                .padding(.top, Spacing.space32)
                .opacity(0.8)
        }
    }
    
    private func contentView() -> some View {
        VStack(spacing: 0) {
            ZStack(alignment: .topLeading) {
                ScrollView(.vertical) {
                    VStack(spacing: 0){
						AddOnHeaderView(viewModel: AddOnHeaderViewModel(addOn: viewModel.addOn), imageHeight: 390.0, onViewReceiptClick: onViewReceiptClick)
                        purchaseView()
                        decriptionView()
                        needToKnow()
                    }
                }
                toolbar()
                    .padding(.top, Paddings.defaultVerticalPadding24)
            }
            Spacer()
            purchaseButton()
        }
    }

    private func purchaseView() -> some View {
        VStack(alignment: .leading, spacing: Paddings.defaultVerticalPadding16) {
			if let name = viewModel.addOn.name {
				Text(name)
					.fontStyle(.largeTitle)
					.foregroundColor(.black)
					.multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
			}
            giftView()
			purchasedWindowClosedView()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Paddings.defaultHorizontalPadding)
        .background(Color.addonSecondaryColor)
    }

    private func decriptionView() -> some View {
        VStack(alignment: .leading, spacing: Paddings.defaultVerticalPadding16) {
			if let shortDescription = viewModel.addOn.shortDescription {
                HTMLText(
                    htmlString: shortDescription,
                    fontType: .light, fontSize: .size24,
                    color: Color.slateGray
                )
			}
            if let longDescription = viewModel.addOn.longDescription {
                HTMLText(
                    htmlString: longDescription,
                    fontType: .normal, fontSize: .size16,
                    color: Color.slateGray
                )
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Paddings.defaultHorizontalPadding)
    }
    
    private func giftView() -> some View {
        HStack {
            Image("GiftIcon")
                .resizable()
                .frame(width: 18, height: 18)
                .aspectRatio(contentMode: .fit)
                .foregroundStyle(Color.squidInk)
			if let subtitle = viewModel.addOn.subtitle {
				Text(subtitle)
					.fontStyle(.headline)
					.foregroundColor(.lightGreyColor)
					.multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
			}
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func purchaseButton() -> some View {
        VStack(spacing: Spacing.space24) {
            LoadingButton(title: viewModel.addOn.purchaseButtonTitle, loading: false) {
                    viewModel.purchase()
                }
            .primaryButtonStyle(isDisabled: viewModel.addOn.isPurchaseButtonDisabled)
                .disabled(viewModel.addOn.isPurchaseButtonDisabled)
                .padding(.horizontal, Spacing.space24)
                .padding(.bottom, Spacing.space12)
                .padding(.top, Spacing.space4)
        }
    }
    
    private func purchasedWindowClosedView() -> some View {
        VStack(alignment: .leading) {
            if viewModel.addOn.isPurchaseButtonDisabled {
				if let explainer = viewModel.addOn.explainer {
					Text(explainer)
						.fontStyle(.subheadline)
						.foregroundColor(.lightGreyColor)
						.multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
				}
            }
        }
    }
    
    private func needToKnow() -> some View {
        VStack {
            if viewModel.addOn.needToKnows.count > 0 {
                VStack(alignment: .leading) {
                    Text("Need to know")
                        .frame(alignment: .leading)
                        .fontStyle(.largeCaption)
                        .foregroundColor(.black)
                        .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                    VStack(alignment: .leading, spacing: Paddings.defaultVerticalPadding16) {
                        ForEach(viewModel.addOn.needToKnows, id: \.self) { item in
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
}

