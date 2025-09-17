//
//  ErrorChampagneViewModel.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 3.7.25.
//

import Foundation

@Observable
class ErrorChampagneViewModel: BaseViewModel, ErrorChampagneViewModelProtocol {
    let coordinator: ShakeForChampagneCoordinator
    var screenState: ScreenState = .loading

    let state: ShakeForChampagne.Status
    let headerText: String
    let messageText: String
    let buttonText: String
    let onCloseAction: VoidCallback?

    init(
        coordinator: ShakeForChampagneCoordinator = AppCoordinator.shared.homeTabBarCoordinator.shakeForChampagneCoordinator,
        shakeForChampagne: ShakeForChampagne,
        onCloseAction: VoidCallback?
    ) {
        self.coordinator = coordinator
        self.state = shakeForChampagne.champagneState.state
        self.headerText = "HEY SAILOR"
        self.messageText = shakeForChampagne.champagneState.message
        self.buttonText = shakeForChampagne.champagneState.actionText
        self.onCloseAction = onCloseAction
    }

    func onButtonTap() {
        if state == .closed {
            navigateToBarsAndClubs()
        }else{
            onClose()
        }
    }

    func onClose() {
        coordinator.fullScreenRouter = nil
        navigationCoordinator.executeCommand(HomeTabBarCoordinator.DismissFullScreenOverlayCommand(pathToDismiss: .shakeForChampagneLanding(orderId: nil)))
    }

    func onAppear() {
        screenState = .content
    }

    func onRefresh() {
        screenState = .content
    }

    func navigateToBarsAndClubs(){
        let code = "Bars---Clubs"
        onCloseAction?()
        navigationCoordinator.executeCommand(ShakeForChampagneCoordinator.OpenShipSpaceScreenCommand(shipSpaceCode: code))
    }
}
