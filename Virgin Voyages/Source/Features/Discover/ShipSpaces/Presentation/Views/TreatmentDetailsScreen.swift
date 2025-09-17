//
//  TreatmentDetailsScreen.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 5.2.25.
//

import SwiftUI
import VVUIKit

enum TreatmentProductType {
	case noProduct
	case singleProduct
	case multipleProduct
}

protocol TreatmentDetailsScreenViewModelProtocol {
    var screenState: ScreenState { get set }
	var bookButtonLoading: Bool { get }

    var treatmentDetails: TreatmentDetails { get }
    var productType: TreatmentProductType { get }
    var isSoldOutPassedClosed: Bool { get }
	var isPurchaseSheetPresented: Bool { get set }
    var isAvailable: Bool { get }
    var grayscale: Double { get }
    var messageBarStyle: MessageBarStyle { get }
    var messageBarText: String { get }
    var messageBarFullWidth: Bool { get }
    var shouldScroll: Bool { get set }
    var showPreVoyageBookingStopped: Bool { get set }
	var bookingSheetViewModel: BookingSheetViewModel? { get}

    func optionButtonText(for option: TreatmentOption) -> String
    func onAppear()
    func onRefresh()
	func book()
	func book(treatmentOption: TreatmentOption)
}

struct TreatmentDetailsScreen: View {
    @State var viewModel: TreatmentDetailsScreenViewModelProtocol
    private let onBackClick: () -> Void
    private let onViewReceiptClick: (String) -> Void

    init(
		treatmentId: String,
		onBackClick: @escaping () -> Void,
		onViewReceiptClick: @escaping (String) -> Void
	) {
        _viewModel = State(wrappedValue: TreatmentDetailsScreenViewModel(treatmentId: treatmentId))
        self.onBackClick = onBackClick
        self.onViewReceiptClick = onViewReceiptClick
    }

    init(
		viewModel: TreatmentDetailsScreenViewModelProtocol,
		onBackClick: @escaping () -> Void,
		onViewReceiptClick: @escaping (String) -> Void
	) {
        _viewModel = State(wrappedValue: viewModel)
        self.onBackClick = onBackClick
        self.onViewReceiptClick = onViewReceiptClick
    }

    var body: some View {
        VStack {
            DefaultScreenView(state: $viewModel.screenState, toolBarOptions: ToolBarOption(
                onBackTapped: { onBackClick() }
            )) {
                VStack(spacing: 0) {
                    ZStack(alignment: .topLeading) {
                        ScrollViewReader { proxy in
                            ScrollView(.vertical) {
                                VStack(spacing: .zero) {
                                    header()
                                        .background(Color.lightGray)
                                    description()
                                        .padding(.bottom)
									DoubleDivider()
                                        .background(.background)
                                    VStack {
                                        if viewModel.productType == .multipleProduct {
                                            optionsView()
                                        }
                                    }
                                    .id("options")
                                }
                            }
                            .background(Color.white)
                            .onChange(of: viewModel.shouldScroll) {
                                DispatchQueue.main.async {
                                    withAnimation {
                                        proxy.scrollTo("options", anchor: .center)
                                    }
                                }
                            }
                        }
                    }
                    .ignoresSafeArea(edges: [.top])
                    .background(Color(uiColor: .systemGray6))
                    Spacer()
                    bottomBar()
                }
            } onRefresh: {
				viewModel.onRefresh()
            }
            .onAppear {
				viewModel.onAppear()
            }
			.sheet(isPresented: $viewModel.isPurchaseSheetPresented) {
				if let bookingSheetViewModel = viewModel.bookingSheetViewModel {
					BookingSheetFlow(isPresented: $viewModel.isPurchaseSheetPresented, bookingSheetViewModel: bookingSheetViewModel)
				}
			}
            .sheet(isPresented: $viewModel.showPreVoyageBookingStopped) {
                PreVoyageEditingModal {
                    viewModel.showPreVoyageBookingStopped = false
                }
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

// MARK: - Private Subviews
extension TreatmentDetailsScreen {
    private func header() -> some View {
        VStack(alignment: .leading, spacing: .zero) {
            ZStack(alignment: .bottom) {
                FlexibleProgressImage(url: URL(string: viewModel.treatmentDetails.imageUrl))
                    .frame(height: Sizes.defaultImageHeight292)
                    .frame(maxWidth: .infinity)
                    .grayscale(viewModel.grayscale)
                HStack {
                    if viewModel.treatmentDetails.status != .notAvailable {
                        MessageBar(
							style: viewModel.messageBarStyle,
							text: viewModel.messageBarText,
							fullWidht: viewModel.messageBarFullWidth
						)
                        if !viewModel.messageBarFullWidth {
                            Spacer()
                        }
                    }
                }
            }

            if let appointmentText = viewModel.treatmentDetails.appointments?.bannerText, !appointmentText.isEmpty {
                MessageBar(style: MessageBarStyle.Success, text: appointmentText)
                    .onTapGesture {
                        self.onViewReceiptClick(viewModel.treatmentDetails.firstAppointmentId)
                    }
                if let appointmentItems = viewModel.treatmentDetails.appointments?.items, appointmentItems.count > 1 {
                    ForEach(appointmentItems, id: \.id) { appointmentItem in
                        HStack {
                            MessageBar(style: MessageBarStyle.Success, text: appointmentItem.bannerText)
                                .onTapGesture {
                                    self.onViewReceiptClick(appointmentItem.id)
                                }
                        }
                    }
                }
            }

            Text(viewModel.treatmentDetails.name)
                .fontStyle(.largeCaption)
                .padding(Spacing.space24)
			
            if viewModel.productType == .multipleProduct {
                CustomBorderedButton(title: "Choose a treatment", action: {
                    viewModel.shouldScroll.toggle()
                })
                .padding(.horizontal, Spacing.space24)
                .padding(.bottom, Spacing.space24)
            }
        }
    }

    private func description() -> some View {
        VStack(alignment: .leading, spacing: Spacing.space24) {
            if !viewModel.treatmentDetails.introduction.isEmpty {
                Text(viewModel.treatmentDetails.introduction.markdown)
                    .fontStyle(.lightTitle)
                    .foregroundColor(.slateGray)
                    .padding(.horizontal, Spacing.space24)
                    .padding(.top, Spacing.space24)
            }

            Text(viewModel.treatmentDetails.longDescription.markdown)
                .fontStyle(.body)
                .foregroundColor(.slateGray)
                .padding(.horizontal, Spacing.space24)
        }
        .frame(maxWidth: .infinity)
        .background(.background)
    }

    private func bottomBar() -> some View {
        VStack {
            if viewModel.productType == .singleProduct && viewModel.isAvailable {
				LoadingButton(title: viewModel.treatmentDetails.bookButtonText,
							  loading: viewModel.bookButtonLoading) {
					viewModel.book()
                }
                .buttonStyle(PrimaryButtonStyle())
                .padding()
				.disabled(viewModel.bookButtonLoading)
            } else if viewModel.productType == .singleProduct {
                LoadingButton(title: viewModel.treatmentDetails.bookButtonText,
							  loading: viewModel.bookButtonLoading) {

				}
                .buttonStyle(PrimaryDisabledButtonStyle())
                .disabled(true)
                .padding()
            }
        }
    }

    private func optionsView() -> some View {
        ForEach(viewModel.treatmentDetails.options, id: \.id) { option in
            VStack {
                HStack(spacing: 0) {
                    Text(option.duration)
                        .font(.vvHeading5)
                        .foregroundColor(Color.blackText)
                    Spacer()
                    Button(action: {
						viewModel.book(treatmentOption: option)
                    }) {
                        Text(viewModel.optionButtonText(for: option))
                            .lineLimit(1)
                            .font(.vvSmall)
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .disabled(option.status != .available)
                    .opacity(option.status == .available ? 1 : 0.5)
                    .frame(maxWidth: 150, maxHeight: 32)
                    .padding(.vertical, 32)
                }
                .padding(.horizontal, Spacing.space24)
                Divider()
            }
        }
        .background(.background)

    }

    struct DoubleDivider: View {
        var body: some View {
            VStack(spacing: Spacing.space4) {
                Rectangle()
                    .frame(height: Spacing.space4)

                Rectangle()
                    .frame(height: Spacing.space4)
            }
            .foregroundStyle(Color.lightMist)
            .opacity(0.3)
        }
    }
}

// MARK: - Preview
struct TreatmentDetailsScreen_Previews: PreviewProvider {

	class MockTreatmentDetailsViewModel: TreatmentDetailsScreenViewModelProtocol {
		var bookingSheetViewModel: BookingSheetViewModel? = nil
		

		var shouldScroll: Bool = false

		var bookButtonLoading: Bool = false

		var isPurchaseSheetPresented: Bool = false

		func book() {}
		func book(treatmentOption: TreatmentOption) {}

		func optionButtonText(for option: TreatmentOption) -> String {
			return ""
		}

		var messageBarFullWidth: Bool = false

		var grayscale: Double = 1.0

		var messageBarStyle: VVUIKit.MessageBarStyle = .Dark

		var messageBarText: String = "Sold out"

		var productType: TreatmentProductType = .multipleProduct

		var screenState: ScreenState = .content
		var treatmentDetails: TreatmentDetails = TreatmentDetails.sample()

		var isSoldOutPassedClosed: Bool { false }
		var isAvailable: Bool { true }
		var shouldShowPriceMessageBar: Bool { true }
		var shouldShowStatusMessageBar: Bool { false }
        var showPreVoyageBookingStopped = false

		func onAppear() {}
		func onRefresh() {}
	}

    static var previews: some View {
        TreatmentDetailsScreen(viewModel: MockTreatmentDetailsViewModel(),
							   onBackClick: {},
							   onViewReceiptClick: {_ in })
    }
}
