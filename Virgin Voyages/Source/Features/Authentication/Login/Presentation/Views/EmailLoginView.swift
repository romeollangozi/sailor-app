//
//  EmailLoginView.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 8/22/24.
//

import SwiftUI
import VVUIKit
import AuthenticationServices

extension EmailLoginView {
	static func create() -> EmailLoginView {
		return EmailLoginView(viewModel: EmailLoginViewModel())
	}
}

protocol EmailLoginViewModelProtocol {
    var shouldShowDeactivatedAccountSheet: Bool { get set }
    var email: String { get set }
    var password: String { get set }
    var errorMessage: String? { get set }
	var loggingIn: Bool { get set }

    var loginButtonDisabled: Bool { get }
    var userInterfaceDisabled: Bool { get }
    
    var isIncorrectEmailOrPassword: Bool { get set }
    
    func onAppear()
    func goToPreviousView()
    func loginButtonTapped()
    func cancelButtonTapped()
    func forgotPasswordButtonTapped()
}

struct EmailLoginView: View {
	@State var viewModel: EmailLoginViewModelProtocol
    
	init(viewModel: EmailLoginViewModelProtocol) {
		_viewModel = State(wrappedValue: viewModel)
	}

	var body: some View {
		toolbar()
		ScrollView {
			VStack(alignment: .center, spacing: 0.0) {
				header()
				emailPasswordView()
				loginActionButtonsView()
				forgotPasswordFooter()
				Spacer()
			}
			.padding([.leading, .trailing], 24.0)
			.fontStyle(.body)
			.disabled(viewModel.userInterfaceDisabled)
			.interactiveDismissDisabled(viewModel.userInterfaceDisabled)
		}
		.onAppear {
			viewModel.onAppear()
		}
	}

	func toolbar() -> some View {
		Toolbar(buttonStyle: .backButton) {
            viewModel.goToPreviousView()
		}
	}

	func header() -> some View {
		VStack(alignment: .center, spacing: 8.0) {
			VectorImage(name: "Anchor")
				.frame(width: 48, height: 48)
				.foregroundStyle(.white)

			Text("Ahoy there Sailor")
				.fontStyle(.largeTitle)
				.multilineTextAlignment(.center)

			Text("It's always nice to see a familiar face. Login and let's get back to it.")
				.multilineTextAlignment(.center)
		}.padding(.bottom, 8.0)
	}

	func emailPasswordView() -> some View {
		VStack(spacing: 16) {
			VVTextField(label: "Email", value: $viewModel.email, hasError: viewModel.isIncorrectEmailOrPassword)
				
			VStack(spacing: 8) {
				VVPasswordField(label: "Password", value: $viewModel.password, hasError: viewModel.isIncorrectEmailOrPassword)
				 
                if let error = viewModel.errorMessage {
                    incorrectCredentialsText(text: error)
                }
			}
		}
        .padding([.top, .bottom], 16.0)
	}

    func incorrectCredentialsText(text: String) -> some View {
		HStack(spacing: 0) {
            Text(text)
                .foregroundColor(Color.orangeDark)
				.fontWeight(.regular)
				.lineLimit(nil)
				.multilineTextAlignment(.leading)
				.fontStyle(.subheadline)
			Spacer()
		}
	}

	func loginActionButtonsView() -> some View {
		VStack(alignment: .center, spacing: 16) {
			LoadingButton(title: "Login", loading: viewModel.loggingIn) {
				viewModel.loginButtonTapped()
			}
			.buttonStyle(PrimaryButtonStyle())
			.disabled(viewModel.loginButtonDisabled)

			Button("Cancel") {
                viewModel.cancelButtonTapped()
			}
			.buttonStyle(SecondaryButtonStyle())
			.disabled(viewModel.userInterfaceDisabled)
		}.padding([.top, .bottom], 24.0)
	}

	func forgotPasswordFooter() -> some View {
		VStack(alignment: .center, spacing: 0.0) {
			Button("Did you forget your login details?") {
                viewModel.forgotPasswordButtonTapped()
			}
			.buttonStyle(TertiaryButtonStyle())
		}.padding([.top, .bottom], 38.0)
	}
}
