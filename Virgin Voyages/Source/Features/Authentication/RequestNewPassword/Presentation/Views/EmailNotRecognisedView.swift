//
//  EmailNotRecognisedView.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 10.9.24.
//

import SwiftUI
import VVUIKit

extension EmailNotRecognisedView {
    static func create() -> EmailNotRecognisedView {
        return EmailNotRecognisedView(viewModel: .init())
    }
}

@Observable class EmailNotRecognisedViewModel {
    private var appCoordinator: CoordinatorProtocol = AppCoordinator.shared
    
    // MARK: Navigation
    func navigateBackToRootView() {
        appCoordinator.executeCommand(LoginSelectionCoordinator.GoBackToRootViewCommand())
    }
    
}

struct EmailNotRecognisedView: View {
    
    // MARK: - Properties
    @State private var showReason: Bool = false
    
    @State private var viewModel: EmailNotRecognisedViewModel

    init(viewModel: EmailNotRecognisedViewModel) {
        _viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
        toolbar()
        VStack(spacing: Paddings.defaultVerticalPadding) {
            headerView()
                .padding(.vertical, Paddings.defaultVerticalPadding)
            okButton()
            reasonButton()
            Spacer()
        }
        .padding(.horizontal, Paddings.defaultVerticalPadding24)
        .sheet(isPresented: $showReason, content: {
            EmailNotRecognisedReasonView.create {
                showReason = false
            }
            .presentationDetents([.fraction(0.85)])
        })
    }
    
    // MARK: - View builders
    private func toolbar() -> some View {
        Toolbar(buttonStyle: .backButton) {
            viewModel.navigateBackToRootView()
        }
    }
    
    private func headerView() -> some View {
        return VStack {
            Text("Email address not recognised")
                .fontStyle(.largeTitle)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, Paddings.defaultVerticalPadding)
            Text("We don’t seem to have an account registered with that email address. Please check for typos and make sure you enter the address you used to register your account.\n\nIf you are still having trouble your account may have been deactivated, please register a new account. Don’t worry, your existing and previous booking aren’t lost and can be reconnected.")
                .frame(maxWidth: .infinity, alignment: .leading)
                .fontStyle(.largeTagline)
                .foregroundColor(.gray)
        }
    }
    
    private func okButton() -> some View {
        Button("Ok, Got it") {
            viewModel.navigateBackToRootView()
        }
        .buttonStyle(PrimaryButtonStyle())
        .padding(.vertical, Paddings.defaultVerticalPadding32)
    }
    
    private func reasonButton() -> some View {
        Button("Why has this happened?") {
            showReason = true
        }
        .buttonStyle(TertiaryButtonStyle())
    }
}


#Preview {
    EmailNotRecognisedView.create()
}
