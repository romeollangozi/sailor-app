//
//  ShakeForChampagneCancellationConfitmationViewModel.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 7/10/25.
//

import Foundation

@Observable
class ShakeForChampagneCancellationConfitmationViewModel: BaseViewModel, ShakeForChampagneCancellationConfitmationViewModelProtocol {
    
    var screenState: ScreenState = .loading
    var shakeForChampagneCancellation: ShakeForChampagne.Cancellation
    var onCancelAction: VoidCallback?
    
    init(shakeForChampagne: ShakeForChampagne, onCancelAction: VoidCallback?) {
        self.shakeForChampagneCancellation = shakeForChampagne.cancellation
        self.onCancelAction = onCancelAction
    }
    
    func onButtonTap() {
        onCancelAction?()
    }
    
    func onClose() {
        onCancelAction?()
    }
    
    func onAppear() {
        screenState = .content
    }
    
    func onRefresh() {
        screenState = .content
    }
    
}
