//
//  ShipSpaceCategoryDetailsScreen.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 30.1.25.
//

import SwiftUI
import VVUIKit

protocol ShipSpaceCategoryDetailsScreenViewModelProtocol {
    var screenState: ScreenState { get set }
    var shipSpaceCategory: ShipSpaceCategoryDetails { get }
    var countdownTitle: String { get }

    func onAppear() async
    func onRefresh() async
    func subheader(from shipSpace: ShipSpaceDetails) -> String
}

struct ShipSpaceCategoryDetailsScreen: View {
    @State var viewModel: ShipSpaceCategoryDetailsScreenViewModelProtocol
    @State private var showEventEditView = false
    private let onBackClick: () -> Void
    private let onViewShipSpaceDetailsClick: (ShipSpaceDetails) -> Void
    private let categoryCode: String

    init(categoryCode: String,
         onViewShipSpaceDetailsClick: @escaping (ShipSpaceDetails) -> Void,
         onBackClick: @escaping () -> Void) {
        self.categoryCode = categoryCode
        _viewModel = State(wrappedValue: ShipSpaceCategoryDetailsViewModel(categoryCode: categoryCode))
        self.onViewShipSpaceDetailsClick = onViewShipSpaceDetailsClick
        self.onBackClick = onBackClick
    }

    init(viewModel: ShipSpaceCategoryDetailsScreenViewModelProtocol,
         categoryCode: String,
         onViewShipSpaceDetailsClick: @escaping (ShipSpaceDetails) -> Void,
         onBackClick: @escaping () -> Void) {
        _viewModel = State(wrappedValue: viewModel)
        self.categoryCode = categoryCode
        self.onViewShipSpaceDetailsClick = onViewShipSpaceDetailsClick
        self.onBackClick = onBackClick
    }

    var body: some View {
        DefaultScreenView(state: $viewModel.screenState, toolBarOptions: ToolBarOption(
            onBackTapped: { onBackClick() }
        )) {
            VStack{
                if viewModel.shipSpaceCategory.shipSpaces.isEmpty && !viewModel.shipSpaceCategory.leadTime.title.isEmpty{
                    openingTimeView()
                } else {
                    VVUIKit.ContentView {
                        ZStack(alignment: .topLeading) {
                            ScrollView(.vertical) {
                                VStack(spacing: .zero) {
                                    header()
                                    shipSpaces()
                                }
                            }
                        }
                    }
                    .ignoresSafeArea(edges: [.top])
                    .background(Color(uiColor: .systemGray6))
                }
            }
            } onRefresh: {
                Task {
                    await viewModel.onRefresh()
                }
            }
            .onAppear {
                Task {
                    await viewModel.onAppear()
                }
            }
            .navigationBarBackButtonHidden(true)
    }
}

// MARK: - Private Subviews
extension ShipSpaceCategoryDetailsScreen {

    /// Header section containing the category image, title, and subheading
    private func header() -> some View {
        VStack(spacing: .zero) {
            FlexibleProgressImage(url: URL(string: viewModel.shipSpaceCategory.imageUrl))
                .frame(height: Sizes.defaultImageHeight234)
                .frame(maxWidth: .infinity)

            VenueCategoryLabel(title: viewModel.shipSpaceCategory.header,
                               subheading: viewModel.shipSpaceCategory.subHeader)
                .padding(.top, Spacing.space32)
        }
    }

    /// Ship Spaces List
    private func shipSpaces() -> some View {
        VStack(spacing: Spacing.space16) {
            ForEach(viewModel.shipSpaceCategory.shipSpaces, id: \.id) { shipSpace in
                shipSpaceRow(shipSpace)
            }
        }
        .padding()
        .padding(.top, Spacing.space24)
    }

    /// Single Ship Space Row
    private func shipSpaceRow(_ shipSpace: ShipSpaceDetails) -> some View {
        VStack(alignment: .leading, spacing: Spacing.space0) {
            Card(title: shipSpace.name, imageUrl: shipSpace.imageUrl, subheading: viewModel.subheader(from: shipSpace)) {
                onViewShipSpaceDetailsClick(shipSpace)
            }
        }
    }
    
    private func openingTimeView() -> some View {
        ZStack(alignment: .top){
            let leadTime = viewModel.shipSpaceCategory.leadTime
            let titleText = leadTime.isCountdownStarted ? viewModel.countdownTitle : leadTime.title
            let action = leadTime.isCountdownStarted ? nil : {
                showEventEditView = !leadTime.isCountdownStarted
            }
            OpeningTimeView(
                imageURL: leadTime.imageUrl,
                title: titleText ,
                subtitle: leadTime.description,
                buttonTitle: "Add to my calendar",
                buttonAction: action
            )
            .sheet(isPresented: $showEventEditView) {
                let start = leadTime.date
                let end = leadTime.date
                EventCalendarEditView(
                    title: "Virgin Voyages - Spa Treatment booking opens",
                    startDate: start,
                    endDate: end
                )
            }
        }
    }

}

// MARK: - Preview
struct ShipSpaceCategoryScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ShipSpaceCategoryDetailsScreen(viewModel: ShipSpaceCategoryDetailsViewModel(categoryCode: "123",
                                                                         getShipSpaceCategoryUseCase: MockGetShipSpaceCategoryUseCase()),
                                    categoryCode: "Beauty---Body",
                                    onViewShipSpaceDetailsClick: { _ in },
                                    onBackClick: {})
        }
    }
}
