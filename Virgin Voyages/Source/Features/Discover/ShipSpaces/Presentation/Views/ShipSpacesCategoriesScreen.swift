//
//  ShipSpacesCategoriesScreen.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 29.1.25.
//

import SwiftUI
import VVUIKit

protocol ShipSpacesCategoriesScreenViewModelProtocol {
    var screenState: ScreenState { get set }
    var shipSpaces: ShipSpacesCategories { get }

    func onAppear() async
    func onRefresh() async
}

struct ShipSpacesCategoriesScreen: View {
    @State var viewModel: ShipSpacesCategoriesScreenViewModelProtocol
    private let onBackClick: () -> Void
    private let onViewShipSpaceCategoryClick: (String) -> Void

    init(viewModel: ShipSpacesCategoriesScreenViewModelProtocol = ShipSpacesCategoriesViewModel(),          onViewShipSpaceCategoryClick:  @escaping (String) -> Void,
         onBackClick: @escaping () -> Void) {
        _viewModel = State(wrappedValue: viewModel)
        self.onBackClick = onBackClick
        self.onViewShipSpaceCategoryClick = onViewShipSpaceCategoryClick
    }

    var body: some View {

        DefaultScreenView(state: $viewModel.screenState, toolBarOptions: ToolBarOption(
            onBackTapped: { onBackClick() }
        )) {
            VVUIKit.ContentView {
                ScrollView {
                    VStack(alignment: .center, spacing: Spacing.space24) {
                        Text(viewModel.shipSpaces.header)
                            .fontStyle(.largeTitle)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, Spacing.space24)
                            .padding(.top, Spacing.space48)

                        Text(viewModel.shipSpaces.subHeader)
                            .fontStyle(.body)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, Spacing.space48)
                        let categories = viewModel.shipSpaces.categories
                        ForEach(categories, id: \ .code) { space in
                            ShipSpaceRow(title: space.name, imageUrl: URL(string: space.imageUrl))
                                .clipShape(RoundedRectangle(cornerRadius: Spacing.space8))
                                .padding(.horizontal, Spacing.space24)
                                .onTapGesture {
                                    onViewShipSpaceCategoryClick(space.code)
                                }
                        }
                    }
                }
            }
            .background(Color(uiColor: .systemGray6))
        } onRefresh: {
            viewModel.screenState = .content
            Task {
                await viewModel.onRefresh()
            }
        }
        .onAppear {
            viewModel.screenState = .content
            Task {
                await viewModel.onAppear()
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle("")
    }

    struct ShipSpaceRow: View {
        var title: String
        var imageUrl: URL?
        var body: some View {
            ZStack(alignment: .bottom) {
                FlexibleProgressImage(url: imageUrl, heightRatio: 0.5)

                Text(title)
                    .padding(20)
                    .fontStyle(.title)
                    .foregroundStyle(.white)
                    .shadow(color: .black, radius: 6)
            }
            .background(.black)
        }
    }
}

struct ShipSpacesScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ShipSpacesCategoriesScreen(viewModel: MockShipSpacesViewModel(), onViewShipSpaceCategoryClick: {_ in }, onBackClick: {})
        }
    }
}

private class MockShipSpacesViewModel: ShipSpacesCategoriesScreenViewModelProtocol {
    var screenState: ScreenState = .content
    var shipSpaces: ShipSpacesCategories = ShipSpacesCategories.sample()

    func onAppear() async { }
    func onRefresh() async { }
}
