//
//  ShipSpaceScreen.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 2.2.25.
//

import SwiftUI
import VVUIKit

protocol ShipSpaceDetailsScreenViewModelProtocol {
    var screenState: ScreenState { get set }
    var shipSpace: ShipSpaceDetails { get }

    func onAppear()
    func onRefresh()
}

struct ShipSpaceDetailsScreen: View {
    @State var viewModel: ShipSpaceDetailsScreenViewModelProtocol
    private let onBackClick: () -> Void
    private let onViewTreatmentClick: ((String) -> Void)?

    init(viewModel: ShipSpaceDetailsScreenViewModelProtocol, onBackClick: @escaping () -> Void, onViewTreatmentClick: ((String) -> Void)? = nil) {
        _viewModel = State(wrappedValue: viewModel)
        self.onBackClick = onBackClick
        self.onViewTreatmentClick = onViewTreatmentClick
    }

    // Initializer when passing a shipSpace
    init(shipSpace: ShipSpaceDetails, onBackClick: @escaping () -> Void, onViewTreatmentClick: ((String) -> Void)? = nil) {
        _viewModel = State(wrappedValue: ShipSpaceDetailsViewModel(shipSpace: shipSpace))
        self.onBackClick = onBackClick
        self.onViewTreatmentClick = onViewTreatmentClick
    }

    var body: some View {
        DefaultScreenView(state: $viewModel.screenState, toolBarOptions: ToolBarOption(
            onBackTapped: { onBackClick() }
        )) {
            VVUIKit.ContentView {
                ZStack(alignment: .topLeading) {
                    ScrollView(.vertical) {
                        VStack(spacing: .zero) {
                            header()
                            description()
                            treatmentCategories()
                            needToKnow()
                        }
                    }
                }
            }
            .ignoresSafeArea(edges: [.top])
            .background(Color(uiColor: .systemGray6))
        } onRefresh: {
            viewModel.onRefresh()
        }
        .onAppear {
            viewModel.onAppear()
        }
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - Private Subviews
extension ShipSpaceDetailsScreen {

    /// Header section with image, title, location, and opening times
    private func header() -> some View {
        VStack(alignment: .leading, spacing: .zero) {
            FlexibleProgressImage(url: URL(string: viewModel.shipSpace.landscapeThumbnailUrl))
                .frame(height: Sizes.defaultImageHeight390)
                .frame(maxWidth: .infinity)

            Text(viewModel.shipSpace.name)
                .fontStyle(.largeCaption)
                .foregroundStyle(.white)
                .padding(.leading, Spacing.space24)
                .padding(.top, Paddings.minus50)

            HStack {
                Image("Location")
                    .frame(width: Sizes.defaultSize16, height: Sizes.defaultSize16)
                Text(viewModel.shipSpace.location)
                    .fontStyle(.largeTagline)
                    .foregroundStyle(Color.blackText)
                Spacer()
            }
            .padding(.top, Spacing.space24)
            .padding(.leading, Spacing.space24)

            Divider()
                .padding(.top, Spacing.space24)
                .padding(.horizontal, Spacing.space24)

            if !viewModel.shipSpace.openingTimes.isEmpty {
                VStack {
                    ForEach(viewModel.shipSpace.openingTimes, id: \.self) { openingTime in
                        HStack {
                            Image("Time")
                                .frame(width: Sizes.defaultSize16, height: Sizes.defaultSize16)
                            Text(openingTime.fromToDay)
                                .fontStyle(.largeTagline)
                                .foregroundStyle(Color.blackText)

                            Spacer()
                            Text(openingTime.fromToTime)
                                .fontStyle(.largeTagline)
                                .foregroundStyle(Color.blackText)
                        }
                    }
                }
                .padding(Spacing.space24)
                .fontStyle(.headline)
            }
            DividerView()
        }
    }

    /// Description section
    private func description() -> some View {
        VStack(alignment: .leading, spacing: Spacing.space24) {
            if !viewModel.shipSpace.introduction.isEmpty {
                Text(viewModel.shipSpace.introduction.markdown)
                    .fontStyle(.lightTitle)
                    .foregroundColor(.slateGray)
                    .padding(.horizontal, Spacing.space24)
                    .padding(.top, Spacing.space24)
            }

            Text(viewModel.shipSpace.longDescription.markdown)
                .fontStyle(.body)
                .foregroundColor(.slateGray)
                .padding(.horizontal, Spacing.space24)

            DoubleDivider()
                .padding(.bottom, Spacing.space24)
        }
        .frame(maxWidth: .infinity)
        .background(.background)
    }

    /// Treatment categories section
    private func treatmentCategories() -> some View {
        VStack(alignment: .leading, spacing: Spacing.space24) {
            if !viewModel.shipSpace.treatmentCategories.isEmpty {
                ForEach(viewModel.shipSpace.treatmentCategories, id: \.name) { section in
                    Section(section.name) {
                        treatmentCategorySection(section)
                    }
                    .fontStyle(.largeCaption)
                    Spacer()
                }
            }
        }
        .padding(.horizontal, Spacing.space24)
        .background(.background)
    }

    /// Extracted logic for rendering a treatment category section
    private func treatmentCategorySection(_ section: ShipSpaceDetails.TreatmentCategory) -> some View {
        VStack(alignment: .leading, spacing: Spacing.space16) {

            if !section.subCategories.isEmpty {
                ForEach(section.subCategories, id: \.name) { category in
                    treatmentSubCategory(category)
                }
            }
        }
    }

    /// Extracted logic for rendering a treatment subcategory
    private func treatmentSubCategory(_ category: ShipSpaceDetails.TreatmentCategory.TreatmentSubCategory) -> some View {
        VStack(alignment: .leading, spacing: Spacing.space16) {
            if !category.treatments.isEmpty {
                Section(category.name) {
                    treatmentList(category.treatments)
                }
                .fontStyle(.smallTitle)
                Spacer()
            }
        }
    }

    /// Extracted logic for rendering a list of treatments
    private func treatmentList(_ treatments: [ShipSpaceDetails.TreatmentCategory.TreatmentSubCategory.Treatment]) -> some View {
        ForEach(treatments, id: \.id) { treatment in
            Card(title: treatment.name, titleFont: .vvBodyMedium, imageUrl: treatment.imageUrl, showArrow: true, onTap: {onViewTreatmentClick?(treatment.id)})
        }
    }

    /// Need to know section
    private func needToKnow() -> some View {
        VStack(alignment: .leading, spacing: Spacing.space16) {
            if !viewModel.shipSpace.needToKnows.isEmpty {
                Text("Need to know")
                    .fontStyle(.mediumTitle)

                ForEach(viewModel.shipSpace.needToKnows, id: \.self) { item in
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
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.space24)
    }

    /// Divider view
    private struct DividerView: View {
        var body: some View {
            Rectangle()
                .frame(height: 2)
                .foregroundStyle(.background)
        }
    }
}

// MARK: - Preview
struct ShipSpaceScreen_Previews: PreviewProvider {
    static var previews: some View {
        ShipSpaceDetailsScreen(viewModel: MockShipSpaceViewModel(), onBackClick: {})
    }
}

// MARK: - Mock ViewModel
private class MockShipSpaceViewModel: ShipSpaceDetailsScreenViewModelProtocol {
    var screenState: ScreenState = .content
    var shipSpace: ShipSpaceDetails = ShipSpaceDetails.sample()

    func onAppear() {}
    func onRefresh() {}
}

