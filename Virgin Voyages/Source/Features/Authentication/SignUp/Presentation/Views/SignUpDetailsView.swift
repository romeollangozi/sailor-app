//
//  SignUpDetailsView.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 27.8.24.
//

import SwiftUI
import VVUIKit

extension SignUpDetailsView {
    static func create(viewModel: SignUpDetailsViewModelProtocol) -> SignUpDetailsView {
        return SignUpDetailsView(viewModel: viewModel)
    }
}

struct SignUpDetailsView: View {

    // MARK: - State
    @State private var viewModel: SignUpDetailsViewModelProtocol
    @FocusState private var isFirstNameFocused: Bool
    @FocusState private var isLastNameFocused: Bool

    init(viewModel: SignUpDetailsViewModelProtocol) {
        _viewModel = State(wrappedValue: viewModel)
    }

    var body: some View {
        toolbar()
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 20) {
                AnchorView()
                Text("Lets have your deets")
                    .fontStyle(.largeTitle)
                    .multilineTextAlignment(.center)

                VStack(alignment: .leading, spacing: Sizes.defaultSize8) {
                    
                    VStack(spacing: 0.0) {
                        // First name
                        GroupInputField(
                            placeholder: "First name",
                            type: .top,
                            error: viewModel.firstNameError,
                            shouldHideErrorText: true,
                            text: $viewModel.signUpInputModel.firstName
                        )
                        .focused($isFirstNameFocused)
                        .onChange(of: isFirstNameFocused) { oldValue, newValue in
                            viewModel.onFirstNameFocusChanged(oldValue: oldValue, newValue: newValue)
                        }
                        .onChange(of: viewModel.signUpInputModel.firstName) { _, _ in
                            viewModel.resetFirstNameError()
                        }

                        // Last name
                        GroupInputField(
                            placeholder: "Last name",
                            type: .bottom,
                            error: viewModel.lastNameError,
                            shouldHideErrorText: true,
                            text: $viewModel.signUpInputModel.lastName
                        )
                        .focused($isLastNameFocused)
                        .onChange(of: isLastNameFocused) { oldValue, newValue in
                            viewModel.onLastNameFocusChanged(oldValue: oldValue, newValue: newValue)
                        }
                        .onChange(of: viewModel.signUpInputModel.lastName) { _, _ in
                            viewModel.resetLastNameError()
                        }
                    }
                    
                    if let msg = viewModel.nameError {
                        errorMessage(message: msg)
                    }
                    
                    Text("Your name has to exactly match what is on your passport.")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.lightGreyColor)
                        .fontStyle(.lightLink)
                        

                    // Preferred name (no validation)
                    GroupInputField(
                        placeholder: "Preferred name",
                        optionalText: "optional",
                        text: $viewModel.signUpInputModel.preferredName
                    )
                    .padding(.top, Paddings.defaultVerticalPadding)

                    Text("Let us know if you have a name you’d prefer to be called day-to-day")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.lightGreyColor)
                        .fontStyle(.lightLink)

                    DatePickerView(
                        headerText: "Date of Birth",
                        selectedDateComponents: $viewModel.signUpInputModel.dateOfBirth,
                        error: viewModel.dateOfBirthError
                    )
                    .padding(.top, Paddings.defaultVerticalPadding)
                    .padding(.bottom, Paddings.defaultVerticalPadding16)

                    if viewModel.showClarification {
                        errorMessage(message: viewModel.clarification)
                    }

                    VStack(spacing: Paddings.defaultVerticalPadding16) {
                        signUpButton()
                        cancelButton()
                    }
                    .padding(.vertical, (Paddings.defaultVerticalPadding24))
                }

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
        Button("Next") {
            viewModel.openProtectYourAccount(signUpMethodModel: viewModel.signUpInputModel)
        }
        .buttonStyle(PrimaryButtonStyle())
        .disabled(viewModel.nextButtonDisabled)
    }
    
    private func cancelButton() -> some View {
        Button("Cancel") {
            viewModel.navigateBackToRoot()
        }
        .buttonStyle(TertiaryButtonStyle())
    }
        
    private func errorMessage(message: String) -> some View {
        Text(message)
            .fontStyle(.caption)
            .foregroundStyle(Color.orangeDark)
    }
}
