//
//  ConfirmOrderChampagneViewModel.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 26.6.25.
//

import Foundation

@Observable
class ConfirmOrderChampagneViewModel: BaseViewModel, ConfirmOrderChampagneViewModelProtocol {
    
    let coordinator: ShakeForChampagneCoordinator
    var screenState: ScreenState = .loading
    var shakeForChampagne: ShakeForChampagne
    var isCancelSheetDisplayed: Bool = false
    let shouldShowCancelButton: Bool
    let descriptionText: String
    var onCloseAction: VoidCallback?

    init(coordinator: ShakeForChampagneCoordinator = AppCoordinator.shared.homeTabBarCoordinator.shakeForChampagneCoordinator,
         shakeForChampagne: ShakeForChampagne,
         onCloseAction: VoidCallback?
         ) {
        
        self.coordinator = coordinator
        self.shakeForChampagne = shakeForChampagne
        self.shouldShowCancelButton = shakeForChampagne.champagneState.state == .orderDelivered ? false : true
        self.descriptionText = shakeForChampagne.champagneState.state == .orderDelivered ? shakeForChampagne.confirmationDeliveryDescription.uppercased() : shakeForChampagne.confirmationDescription.uppercased()
        self.onCloseAction = onCloseAction
    }


    func displayCancelSheet() {
        isCancelSheetDisplayed = true
    }
    
    func dismissCancelSheet() {
        isCancelSheetDisplayed = false
    }

    func onClose() {
        onCloseAction?()
    }

    func onAppear() {
        screenState = .content
    }

    func onRefresh() {
        screenState = .content
    }
}
