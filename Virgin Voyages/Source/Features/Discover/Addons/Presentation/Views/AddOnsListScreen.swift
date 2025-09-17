//
//  AddOnsListScreen.swift
//  Virgin Voyages
//
//  Created by Darko trpevski on 9/24/24.
//

import SwiftUI
import VVUIKit

extension AddOnsListScreen {
    static func create(
        selectedAddOnCode: String? = nil,
        back: @escaping (() -> Void),
        details: @escaping ((AddOn) -> Void),
        goToPurchasedAddOns: @escaping () -> Void,
        hideBackButton: Bool = false) -> AddOnsListScreen {
        
            let viewModel = AddOnsListScreenViewModel(
                selectedAddOnCode: selectedAddOnCode,
                addOnsUseCase: GetAddOnsUseCase(),
                addons: [])
            
            return AddOnsListScreen(viewModel: viewModel, back: back, details: details, goToPurchasedAddOns: goToPurchasedAddOns, hideBackButton: hideBackButton)
    }
}

protocol AddOnsListScreenViewModelProtocol {
	var addOnsUseCase: GetAddOnsUseCase { get set }
	var addOns: [AddOn] { get set }
	var addOnsText: String { get set }
	var addOnsSubtitle: String { get set }
	var viewAddOnsText: String { get set }
	var screenState: ScreenState { get set }
	func onAppear()
	func onReAppear()
	func onViewAddOnsTapped()
}


struct AddOnsListScreen: View {
    // MARK: - State properties
    @State var viewModel: AddOnsListScreenViewModelProtocol

    // MARK: - Init
    init(
		viewModel: AddOnsListScreenViewModelProtocol,
		back: @escaping () -> Void,
		details: @escaping (AddOn) -> Void,
		goToPurchasedAddOns: @escaping () -> Void,
		hideBackButton: Bool
	) {
        _viewModel = State(wrappedValue:viewModel)
        self.back = back
        self.details = details
        self.goToPurchasedAddOns = goToPurchasedAddOns
        self.hideBackButton = hideBackButton
    }
    
    // MARK: - Navigation actions
    let back: (() -> Void)
    let details: ((AddOn) -> Void)
    let goToPurchasedAddOns: (() -> Void)
    var hideBackButton: Bool
    
    // MARK: - View body
    var body: some View {
        VirginScreenView(state: $viewModel.screenState) {
            VStack(spacing: 0) {
                toolbar()
                ScrollView(.vertical) {
                    headerView()
                    listView()
                }
            }
        } loadingView: {
            ProgressView("Loading Add-ons")
                .fontStyle(.headline)
        } errorView: {
            NoDataView {
				viewModel.onAppear()
            }
        }
		.onAppear(onFirstAppear: {
			viewModel.onAppear()
		}, onReAppear: {
			viewModel.onReAppear()
		})
    }
    
    // MARK: - View builders
    private func toolbar() -> some View {
        VStack{
            if !hideBackButton {
                Toolbar(buttonStyle: .backButton) {
                    back()
                }
            }
        }
    }

    private func listView() -> some View {
        Section {
            ForEach(viewModel.addOns, id: \.id) { addOn in
                AddOnRowView(addOn: addOn)
                    .onTapGesture {
                        details(addOn)
                    }
            }
        }
        .padding(.horizontal, Paddings.defaultVerticalPadding16)
        .padding(.bottom, Paddings.defaultVerticalPadding16)
        .fontStyle(.headline)
        .foregroundStyle(.secondary)
    }
    
    private func headerView() -> some View {
        VStack(spacing: 0) {
            Text(viewModel.addOnsText)
                .fontStyle(.largeTitle)
                .padding(.vertical)
            Text(viewModel.addOnsSubtitle)
                .multilineTextAlignment(.center)
                .fontStyle(.largeTagline)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 60)
                .lineLimit(2)
            Button(viewModel.viewAddOnsText) {
				viewModel.onViewAddOnsTapped()
            }
            .buttonStyle(PrimaryRedButtonStyle())
            .padding(.vertical, Paddings.defaultVerticalPadding32)

        }
    }
}
