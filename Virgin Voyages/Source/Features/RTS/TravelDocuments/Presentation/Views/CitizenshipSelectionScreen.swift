//
//  CitizenshipSelectionScreen.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 8.9.25.
//

import SwiftUI
import VVUIKit

// MARK: - ViewModel Protocol

protocol CitizenshipSelectionScreenViewModelProtocol {
    var screenState: ScreenState { get set }

    // UI content
    var title: String { get }
    var subtitle: String { get }
    var actionText: String { get }
    var placeholder: String { get }
    var buttonTitle: String { get }

    // Data
    var countries: [Option] { get }
    var selectedCountryCode: String? { get set }
    var selectedCountryBinding: Binding<String?> { get }
    
    // Actions
    func onProceed()
    func onBack()
    func onAppear() async
    func onRefresh() async
}


// MARK: - Screen

struct CitizenshipSelectionScreen: View {
    @State var viewModel: CitizenshipSelectionScreenViewModelProtocol
    @State private var searchText: String = ""

    init(viewModel: CitizenshipSelectionScreenViewModelProtocol) {
        _viewModel = State(wrappedValue: viewModel)
    }

    var body: some View {
        DefaultScreenView(state: $viewModel.screenState, toolBarOptions: ToolBarOption(onBackTapped: viewModel.onBack)) {
            VStack(spacing: 0) {
                VStack(alignment: .leading, spacing: Spacing.space40) {
                    Text(viewModel.title)
                        .font(.vvHeading1Bold)
                        .multilineTextAlignment(.leading)

                    Text(viewModel.subtitle)
                        .font(.vvHeading5Light)
                        .multilineTextAlignment(.leading)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.top, Spacing.space64)
              
                Spacer()

                VStack(alignment: .leading, spacing: Spacing.space28) {
                    Text(viewModel.actionText)
                        .font(.vvHeading5Medium)
                        .multilineTextAlignment(.leading)
                    
                    VVPickerField(label: viewModel.placeholder, options: viewModel.countries, selected:  viewModel.selectedCountryBinding)
                    .background(Color.white)
                    
                    Button(viewModel.buttonTitle) {
                        viewModel.onProceed()
                    }
                    .primaryButtonStyle(isDisabled: viewModel.selectedCountryCode?.isEmpty ?? true)
                    .disabled(viewModel.selectedCountryCode?.isEmpty ?? true)
                }
            }
            .padding(.horizontal, Spacing.space24)
            .padding(.vertical, Spacing.space24)
            .background(Color.softYellow)
        } onRefresh: {
            Task { await viewModel.onRefresh() }
        }
        .onAppear {
            Task { await viewModel.onAppear() }
        }
    }
}

// MARK: - Preview (Mock)

struct CitizenshipSelectionScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            CitizenshipSelectionScreen(viewModel: CitizenshipSelectionViewModel())
        }
    }
}
