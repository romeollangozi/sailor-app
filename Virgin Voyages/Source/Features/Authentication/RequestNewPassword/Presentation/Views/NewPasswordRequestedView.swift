//
//  NewPasswordRequestedView.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 10.9.24.
//

import SwiftUI
import VVUIKit

extension NewPasswordRequestedView {
    static func create() -> NewPasswordRequestedView {
        return NewPasswordRequestedView(viewModel: .init())
    }
}

@Observable class NewPasswordRequestedViewModel {
    var appCoordinator: CoordinatorProtocol = AppCoordinator.shared
    
    // MARK: Navigation
    func navigateBackToRootView() {
        appCoordinator.executeCommand(LoginSelectionCoordinator.GoBackToRootViewCommand())
    }
    
}

struct NewPasswordRequestedView: View {
        
    @State private var viewModel: NewPasswordRequestedViewModel
    
    init(viewModel: NewPasswordRequestedViewModel) {
        _viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
        toolbar()
        VStack(spacing: Paddings.defaultVerticalPadding16) {
            Text("New password requested")
                .fontStyle(.largeTitle)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, Paddings.defaultVerticalPadding)
            Text("Check your email (and that pesky junk filter) and click the link. If nothing’s arrived, get in touch and we’ll sort it.\n\nIf you haven’t received the email within 10 minutes please try again.")
                .frame(maxWidth: .infinity, alignment: .leading)
                .fontStyle(.largeTagline)
                .foregroundColor(.gray)
            okButton()
                .padding(.vertical, Paddings.defaultVerticalPadding32)
            
            Spacer()
        }
        .padding(.horizontal, Paddings.defaultVerticalPadding24)
    }
    
    // MARK: - View builders
    private func toolbar() -> some View {
        Toolbar(buttonStyle: .closeButton) {
            viewModel.navigateBackToRootView()
        }
    }
    
    private func okButton() -> some View {
        Button("Ok, Got it") {
            viewModel.navigateBackToRootView()
        }
        .buttonStyle(PrimaryButtonStyle())
    }
}


#Preview {
    NewPasswordRequestedView.create()
}
