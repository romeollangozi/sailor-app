//
//  AddAFriendViewModel.swift
//  Virgin Voyages
//
//  Created by TX on 24.2.25.
//

import Foundation
import SwiftUI

class AddAFriendViewModel: AddAFriendViewModelProtocol {
    var appCoordinator: CoordinatorProtocol
    
    init(appCoordinator: CoordinatorProtocol = AppCoordinator.shared) {
        self.appCoordinator = appCoordinator
    }
    
    // MARK: Coordinator
    func destinationView(for navigationRoute: any BaseNavigationRoute) -> AnyView {
        guard let navigationRoute = navigationRoute as? AddAFriendNavigationRoute  else { return AnyView(Text("Navigation Path Not Implemented")) }
        switch navigationRoute {
        case .landing:
            return AnyView(
                AddFriendSheet {
                    self.closeAction()
                } shareAction: {
                    self.shareAction()
                } scanAction: {
                    self.scanAction()
                } searchAction: {
                    self.searchAction()
                }
            )
        case .contactDetails(let sailorMateLink):
            return AnyView(
				AddContactSheet(contact: AddContactData.from(sailorLink: sailorMateLink), isFromDeepLink: false, onDismiss: {
					self.dismissSheetFromParrent()
				})
				.navigationBarBackButtonHidden()
            )
        case .confirmAddContact(sailorMateLink: let sailorMateLink):
            return AnyView(
                Text("TODO: Implement Contact Confirmation View here")
            )
        }
    }
    
    func destinationView(for fullScreenRoute: any BaseFullScreenRoute) -> AnyView {
        guard let addAFriendFullScreenRoute = fullScreenRoute as? AddAFriendFullScreenRoute  else { return AnyView(Text("View route not implemented")) }
        switch addAFriendFullScreenRoute {
        case .scanCode:
            return AnyView(
                ContactsScanView(displaysViewOnSuccess: false, back: {
                    self.dismissFullScreenCover()
                }, action: { code in
                    // On success.
                    self.dismissFullScreenCover()
                    self.showFriendAddedSuccessScreen(link: code)
                }, viewModel: ContactsScanViewModel(
                    selectedOption: .scanCode,
                    yourCodeText: "Your code",
                    scanCodeText: "Scan code",
                    showScanerSegmentControl: false
                ))
                .presentationBackground(.clear)
            )
        }
    }
    
    func closeAction() {
        dismissSheetFromParrent()
    }
    
    func shareAction() {}
    
    func searchAction() {}
    
    func scanAction() {
        appCoordinator.executeCommand(AddAFriendCoordinator.ShowCameraScanFullScreenCoverCommand())
    }
    
    private func dismissFullScreenCover() {
        appCoordinator.executeCommand(AddAFriendCoordinator.DismissFullScreenCoverCommand())
    }
    
    private func showFriendAddedSuccessScreen(link: String) {
        appCoordinator.executeCommand(AddAFriendCoordinator.OpenSailorDetailsCommand(sailorMateLink: link))
    }
    
    private func dismissSheetFromParrent() {
        appCoordinator.executeCommand(AddAFriendCoordinator.DismissAddFriendSheetIfVisibleCommand())
        // Note: remove from any other coordinator if presented.
    }
}
