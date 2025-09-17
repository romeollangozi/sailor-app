//
//  PassportUploadWarningView.swift
//  Virgin Voyages
//
//  Created by TX on 6.12.24.
//

import SwiftUI


class PassportWarningAlertViewModel {
    
    let viewContent: PassportWarningAlertViewModel.Content
    
    init(viewContent: PassportWarningAlertViewModel.Content) {
        self.viewContent = viewContent
    }
}

extension PassportWarningAlertViewModel {
    struct Content {
        let pageTitle: String
        let pageBody: String
        let actionButtonTitle: String
        let cancelButtonTitle: String
    }
}

struct PassportUploadWarningView: View {
    let viewModel: PassportWarningAlertViewModel
    
    let onaAction: () -> Void
    let onCancelAction: () -> Void
    
    // There is a small delay untill the webview loads the html content with custom style
    @State private var didLoadContent: Bool = false

    var body: some View {
        ScrollView {
            VStack (alignment: .leading) {
                pageTitleText()
                pageBody()
                buttons()
            }
            .opacity(didLoadContent ? 1 : 0)
            .animation(.easeInOut(duration: 0.2), value: didLoadContent)
        }
        .padding(.horizontal, Paddings.defaultHorizontalPadding)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: VVBackButton(onDismiss: {
            onCancelAction()
        }))
    }
    
    private func pageTitleText() -> some View {
        // Header
        HStack(alignment: .top) {
            Text(viewModel.viewContent.pageTitle)
                .fontStyle(.largeTitle)
            Spacer()
        }
        .padding(.top, Paddings.defaultVerticalPadding32)
        .padding(.bottom, Paddings.defaultVerticalPadding16)

    }
    
    private func pageBody() -> some View {
        VVWebView(htmlString: viewModel.viewContent.pageBody) {
            withAnimation {
                didLoadContent = true
            }
        }
        .padding(.bottom, Paddings.defaultVerticalPadding)
    }
    
    private func buttons() -> some View {
        VStack(alignment: .center) {
            Button(viewModel.viewContent.actionButtonTitle) {
                onaAction()
            }.buttonStyle(SecondaryButtonStyle())
            
            Button(viewModel.viewContent.cancelButtonTitle) {
                onCancelAction()
            }.buttonStyle(TertiaryLinkStyle())
        }
    }
}


#Preview {
    let viewModel = PassportWarningAlertViewModel(viewContent: .init(pageTitle: "page title", pageBody: "page body", actionButtonTitle: "Action", cancelButtonTitle: "Cancel"))
    PassportUploadWarningView(viewModel: viewModel) {
        print("Test")
    } onCancelAction: {
        print("Test 2")
    }

}
