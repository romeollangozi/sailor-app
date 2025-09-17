//
//  VVToDoView.swift
//  Virgin Voyages
//
//  Created by TX on 11.12.24.
//

import SwiftUI

struct VVToDoView: View {
    @State private var viewModel: ToDoViewModel
    
    let buttonAction: (() -> Void)?
    
    init(viewModel: ToDoViewModel, buttonAction: (() -> Void)? = nil) {
        self.viewModel = viewModel
        self.buttonAction = buttonAction
    }
    
    init(title: String) {
        self.viewModel = .init(title: title)
        self.buttonAction = nil
    }
    
    init(title: String, deepLink: DeepLinkType) {
        self.viewModel = .init(title: title, deepLink: deepLink)
        self.buttonAction = nil
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: Paddings.defaultVerticalPadding16) {
            Text(viewModel.data.title)
                .fontStyle(.largeTitle)
                .multilineTextAlignment(.center)
            
            Text(viewModel.data.message)
                .fontStyle(.headline)
                .multilineTextAlignment(.center)
            
            Text(viewModel.data.alternativeMessage)
                .fontStyle(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            
            if viewModel.data.deepLink != nil {
                Button(viewModel.data.actionTitle) {
                    if let buttonAction {
                        buttonAction()
                    } else {
                        viewModel.handleDeepLink()
                    }
                }
                .textCase(.uppercase)
                .fontStyle(.headline)
                .buttonStyle(BorderedProminentButtonStyle())
            }
        }
        .padding()
    }

}

#Preview {
    let mockViewModel = ToDoViewModel(data: .init(title: "Entertainment", message: "This functionality is coming soon!", alternativeMessage: "In the meantime, please use the existing Sailor App to manage this data", actionTitle: "Open In App", deepLink: .reactNativeApp))
    
    VVToDoView(viewModel: mockViewModel)
}
