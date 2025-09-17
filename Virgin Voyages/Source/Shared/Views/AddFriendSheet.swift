//
//  AddFriendSheet.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 21.1.25.
//

import SwiftUI
import VVUIKit

struct AddFriendSheet: View {
    
    // MARK: - Constants
    let toolbarButtonStyle: ToolbarButtonStyle
    
    // MARK: - Actions
    let closeAction: () -> Void
    let scanAction: () -> Void
    let shareAction: () -> Void
    let searchAction: () -> Void
    
    @State var viewModel: AddFriendSheetViewModelProtocol

    // MARK: - Init
    init(viewModel: AddFriendSheetViewModelProtocol = AddFriendSheetViewModel(),
         toolbarButtonStyle: ToolbarButtonStyle = .closeButton,
         closeAction: @escaping () -> Void,
         shareAction: @escaping () -> Void,
         scanAction: @escaping () -> Void,
         searchAction: @escaping () -> Void) {
        
        self.toolbarButtonStyle = toolbarButtonStyle
        self.closeAction = closeAction
        self.scanAction = scanAction
        self.searchAction = searchAction
        self.shareAction = shareAction
        _viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            toolbar()
                .padding(.bottom)
            
            ProfilePlaceholderView()
            
            titleText("Add a friend")
                .padding(.vertical)
            
            subtitleText("Choose one of the following ways to add a friend")
                .padding(.horizontal)
            
            actionButtons()
                .padding()
            
            Spacer()
        }
        .alert("Virgin Voyages” Would Like to Access the Camera", isPresented: $viewModel.showSettingsAlert) {
            Button("Cancel") {}

            Button("Open app settings", role: .cancel) {
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsURL)
                }
            }
        } message: {
            Text("We need to use your camera to scan your friend’s QR code. Please give permission in App settings")
        }
        .padding()
        .background(.white)
    }
    
    // MARK: - UI elements
    private func toolbar() -> some View {
        Toolbar(buttonStyle: toolbarButtonStyle) {
            closeAction()
        }
    }
    
    private func titleText(_ text: String) -> some View {
        Text(text)
            .font(.vvHeading1Bold)
            .multilineTextAlignment(.center)
    }
    
    private func subtitleText(_ text: String) -> some View {
        Text(text)
            .font(.vvBody)
            .foregroundStyle(Color.slateGray)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity, alignment: .center)
    }
    
    private func actionButtons() -> some View {
        HStack(spacing: Paddings.defaultHorizontalPadding20) {
            
            VerticalCapsuleButton(imageName: "QrCodeButton", title: "Scan or load a QR code", action: {
                Task {
                    let hasPermission = await viewModel.checkPermission()
                    if hasPermission {
                        scanAction()
                    }
                }
            })
            
            VerticalCapsuleButton(imageName: "ShareButton", title: "Send an invite", action: {
                shareAction()
                Task {
                    await viewModel.share()
                }
            })
        }
    }
}

#Preview {
    AddFriendSheet(closeAction: {
        
    }, shareAction: {}, scanAction: {
        
    }, searchAction: {})
}
