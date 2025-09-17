//
//  SignUpWithEmailView.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 26.8.24.
//

import SwiftUI
import VVUIKit

extension SignUpWithEmailView {
    static func create() -> SignUpWithEmailView {
        return SignUpWithEmailView(viewModel: SignUpWithEmailViewModel())
    }
}

struct SignUpWithEmailView: View {
    
    // MARK: - State properties
    @State var viewModel: SignUpWithEmailViewModelProtocol
    @FocusState private var isEmailFocused: Bool

    // MARK: - Init
    init(viewModel: SignUpWithEmailViewModelProtocol) {
        _viewModel = State(wrappedValue: viewModel)
    }

    var body: some View {
        toolbar()
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 20) {
                AnchorView()
                Text("What’s your email?")
                    .fontStyle(.largeTitle)
                    .multilineTextAlignment(.center)
                
                EmailInputField(placeholder: "name@domain.com",
                                text: $viewModel.email,
                                error: viewModel.errorMessage)
                .focused($isEmailFocused)
                .onChange(of: isEmailFocused) { oldValue, newValue in
                    viewModel.onEmailFieldFocusChanged(oldValue: oldValue, newValue: newValue)
                }
                .onChange(of: viewModel.email) { _, _ in
                    viewModel.resetErrorMessage()
                }
                
                Text("Virgin Voyages News")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .fontStyle(.headline)
                    .foregroundColor(.lightGreyColor)
                
                Text("Fun, ship puns and exclusive travel news are all yours with a simple check of the box. (Our privacy policy means your details stay safe.)")
                    .multilineTextStyle(.lightBody, alignment: .leading)
                    .foregroundColor(.lightGreyColor)
                
                CheckboxView(isChecked: $viewModel.isChecked, text: "Yes please I want to receive lovely email updates from Virgin Voyages")
                
                signUpButton()
                cancelButton()
                
                Spacer()
            }
            .padding(.horizontal, Paddings.defaultHorizontalPadding)
        }
        .frame(maxWidth: .infinity)
        .scrollDismissesKeyboard(.immediately)
    }
    
    // MARK: - Methods
    private func toolbar() -> some View {
        Toolbar(buttonStyle: .backButton) {
            viewModel.navigateBack()
        }
    }
    
    private func signUpButton() -> some View {
		LoadingButton(title: "Next", loading: viewModel.isLoading) {
            viewModel.nextButtonTapped(email: viewModel.email,
                                       receiveEmails: viewModel.isChecked)
        }
        .buttonStyle(PrimaryButtonStyle())
        .disabled(viewModel.nextButtonDisabled)
    }
    
    private func cancelButton() -> some View {
        Button("Cancel") {
            viewModel.navigateBackToRootView()
        }
        .buttonStyle(TertiaryButtonStyle())
    }
    
}
