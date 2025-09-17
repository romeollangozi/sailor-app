//
//  ProtectYourAccountView.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 2.9.24.
//

import SwiftUI
import VVUIKit

extension ProtectYourAccountView {
    static func create(viewModel: ProtectYourAccountViewModelProtocol) -> ProtectYourAccountView {
        return ProtectYourAccountView(viewModel: viewModel)
    }
}

struct ProtectYourAccountView: View {
    // MARK: - State properties
    @State private var viewModel: ProtectYourAccountViewModelProtocol
    @State private var isPasswordFocused: Bool = false
        
    // MARK: - Init
    init(viewModel: ProtectYourAccountViewModelProtocol) {
        _viewModel = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        toolbar()
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 20) {
                AnchorView()
                Text("Protect your account")
                    .fontStyle(.largeTitle)
                    .multilineTextAlignment(.center)
                PasswordInputToggleField(placeholder: "Create password", text: $viewModel.password, focused: { state in
                    self.isPasswordFocused = state
                }, error: (!isPasswordFocused) ? viewModel.wrongPasswordText : nil)
                    
                validationView()
                nextButton()
                cancelButton()
            }
            .padding(.horizontal, Paddings.defaultHorizontalPadding)
        }
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Methods
    private func toolbar() -> some View {
        Toolbar(buttonStyle: .backButton) {
            viewModel.navigateBack()
        }
    }
    
    private func validationView() -> some View {
        VStack(alignment: .leading) {
            ForEach(0..<viewModel.criteria.count, id: \.self) { index in
                HStack {
                    Image(viewModel.validations[index] ? "ValidationCheckOk" : statusImage(isFocused: isPasswordFocused, isEmpty: viewModel.password.isEmpty))
                    Text(viewModel.criteria[index].message)
                        .foregroundColor(.secondary)
                        .fontStyle(.lightLink)
                    Spacer()
                }
            }
        }
        .padding(.bottom, Paddings.defaultVerticalPadding16)
    }
    
    private func nextButton() -> some View {
        Button("Next") {
            viewModel.navigateToProfileImageView()
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
    
    private func statusImage(isFocused: Bool, isEmpty: Bool) -> String {
        switch(isFocused, isEmpty) {
        //focused,empty
        case (true, true):
            return "ValidationCheckEmpty"
        case (true, false):
            return "ValidationCheckEmpty"
        case (false, true):
            return "ValidationCheckEmpty"
        case (false, false):
            return "ValidationCheckFail"
        }
    }
}
