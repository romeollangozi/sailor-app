//
//  RequestNewPasswordView.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 10.9.24.
//

import SwiftUI
import VVUIKit

extension RequestNewPasswordView {
    static func create(viewModel: RequestNewPasswordViewModelProtocol = RequestNewPasswordViewModel()) -> RequestNewPasswordView {
        return RequestNewPasswordView(viewModel: viewModel)
    }
}


struct RequestNewPasswordView: View {
    
    // MARK: - State properties
    @State private var viewModel: RequestNewPasswordViewModelProtocol
    @State private var showNoAccessView: Bool
    @FocusState private var textFieldFocused: Bool

    // MARK: - Init
    init(viewModel: RequestNewPasswordViewModelProtocol, showNoAccessView: Bool = false) {
        
        _viewModel = State(wrappedValue: viewModel)
        self.showNoAccessView = showNoAccessView
    }
    
    var body: some View {
        toolbar()
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: Paddings.defaultVerticalPadding16) {
                headerView()
                forgottenButton()
                emailInput()
                reCaptchaView()
                requestPasswordButton()
                cancelButton()
                Spacer()
            }
            .padding(.horizontal, Paddings.defaultVerticalPadding24)
            .sheet(isPresented: $showNoAccessView, content: {
                NoAccessView.create {
                    self.showNoAccessView = false
                }
                .presentationDetents([.fraction(0.85)])
            })
        }
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - View builders
    private func toolbar() -> some View {
        Toolbar(buttonStyle: .backButton) {
            viewModel.navigateToPreviousView()
        }
    }
    
    private func headerView() -> some View {
        return VStack {
            Text("Request a new password")
                .fontStyle(.largeTitle)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, Paddings.defaultVerticalPadding)
            Text("Apparently forgetful people are actually smarter according to science (maybe). Pop your email in and we’ll get a new password sorted. ")
                .frame(maxWidth: .infinity, alignment: .leading)
                .fontStyle(.largeTagline)
                .foregroundColor(.gray)
        }
    }
    
    private func emailInput() -> some View {
        EmailInputField(text: $viewModel.email, error: viewModel.error)
            .padding(.vertical, Paddings.defaultVerticalPadding)
            .focused($textFieldFocused)
            .onTapGesture {
                textFieldFocused = true
            }
            .onChange(of: textFieldFocused) { oldValue, newValue in
                if oldValue == true && newValue == false {
                    viewModel.validate()
                }
            }
    }
    
    private func reCaptchaView() -> some View {
        ReCaptchaView(viewModel: ReCaptchaViewModel(action: ReCaptchaActions.requestNewPassword.key) ,confirmed: { status, token in
            viewModel.reCaptchaToken = token
            viewModel.reCaptchaIsChecked = status
            viewModel.validate()
        })
        .padding(.trailing)
    }
    
    private func forgottenButton() -> some View {
        Button("Forgotten, or no longer have access to your email? click here. ") {
            self.showNoAccessView = true
        }
        .buttonStyle(LinkButtonStyle())
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, Paddings.defaultVerticalPadding)
    }
    
    private func requestPasswordButton() -> some View {
        
        LoadingButton(title: "Reset my password", loading: viewModel.isLoadingResetMyPassword) {
            Task {
                viewModel.validate()
                let result = await viewModel.requestNewPassword()
                if result.isEmailSent {
                    viewModel.navigateToNewPasswordRequestedScreen()
                }
                
                if !result.isEmailExist {
                    viewModel.navigateToEmailNotRecognisedScreen()
                }
            }
        }
        .buttonStyle(PrimaryButtonStyle())
        .disabled(!viewModel.isValid)
        .padding(.top, Paddings.defaultVerticalPadding16)
    }
    
    private func cancelButton() -> some View {
        Button("Cancel") {
            viewModel.navigateBackToRootView()
        }
        .buttonStyle(TertiaryButtonStyle())
    }
    
}

//Preview
struct RequestNewPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        RequestNewPasswordView.create()
    }
}
