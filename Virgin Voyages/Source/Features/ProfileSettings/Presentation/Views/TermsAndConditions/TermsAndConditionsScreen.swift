//
//  TermsAndConditions.swift
//  Virgin Voyages
//
//  Created by Timur Xhabiri on 31.10.24.
//

import SwiftUI

struct TermsAndConditionsScreen: View {

    @State private var viewModel: TermsAndConditionViewModelProtocol
    let initiallySelectedKey: TermsAndConditionListItemIdentifierKey?
    let onBack: (() -> Void)?

    init(
        viewModel: TermsAndConditionViewModelProtocol = TermsAndConditionViewModel(),
        initiallySelectedKey: TermsAndConditionListItemIdentifierKey? = nil,
        onBack: (() -> Void)? = nil
    ) {
        _viewModel = State(wrappedValue: viewModel)
        self.initiallySelectedKey = initiallySelectedKey
        self.onBack = onBack
    }

    var body: some View {

        Group {

            if let key = initiallySelectedKey,
               let detailsItem = viewModel.screenModel.menuItems.first(where: { $0.keyIdentifier == key }) {
                // details screen per initiallySelectedKey
                TermsAndConditionsDetailsView(detailsItem: detailsItem)
                    .navigationBarBackButtonHidden(true)
            } else {
                termsAndConditionsListView()
            }
        }
        .task {
            await viewModel.refresh()
        }
    }

    private func termsAndConditionsListView() -> some View {
        ScrollView {
            // Header
            HStack(alignment: .top) {
                // Title
                Text(viewModel.screenModel.title)
                    .fontStyle(.largeTitle)
                Spacer()
            }
            .padding(.top, Paddings.defaultVerticalPadding32)
            .padding(.bottom, Paddings.defaultVerticalPadding16)

            // List
            TermsAndConditionsListView(menuItems: viewModel.screenModel.menuItems)
        }

        .padding(.horizontal)
        .scrollIndicators(.hidden)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: VVBackButton(onDismiss: onBack))
    }
}


#Preview {
    NavigationStack {
        let mockRepository = PreviewMockTermsAndConditionsRepository()
        let mockUseCase = GetTermsAndConditionsContentUseCase(termsAndConditionsRepository: mockRepository)
        let mockModel = TermsAndConditionViewModel(getContenUseCase: mockUseCase)
        TermsAndConditionsScreen(viewModel: mockModel)
    }
}
