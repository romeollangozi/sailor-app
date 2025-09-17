//
//  OrderChampagneViewModel.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 24.6.25.
//

import Foundation

@Observable
class OrderChampagneViewModel: BaseViewModel, OrderChampagneViewModelProtocol {
    
    let coordinator: ShakeForChampagneCoordinator
    var screenState: ScreenState = .loading
    var quantity: Int
    var title: String
    var description: String
    var champagneInfo: String
    var taxExplanationText: String
    let price: Double
    let currency: String
    let minQuantity: Int
    let maxQuantity: Int
    var onCancelAction: VoidCallback?
    
    init(coordinator: ShakeForChampagneCoordinator = AppCoordinator.shared.homeTabBarCoordinator.shakeForChampagneCoordinator,
         shakeForChampagne: ShakeForChampagne,
         onCancelAction: VoidCallback?) {
        
        self.coordinator = coordinator
        self.quantity = shakeForChampagne.champagne.minQuantity
        self.title = shakeForChampagne.title
        self.description = shakeForChampagne.description
        self.champagneInfo = shakeForChampagne.champagne.name
        self.price = shakeForChampagne.champagne.price
        self.currency = shakeForChampagne.champagne.currency
        self.taxExplanationText = shakeForChampagne.taxExplanationText
        self.minQuantity = shakeForChampagne.champagne.minQuantity
        self.maxQuantity = shakeForChampagne.champagne.maxQuantity
        self.onCancelAction = onCancelAction
    }
    
    var totalPriceText: String {
        return quantity > minQuantity ? "\(quantity) bottles \(currency)\(Double(quantity) * price)" : "\(quantity) bottle \(currency)\(Double(quantity) * price)"
    }

    var isMinusDisabled: Bool { quantity == minQuantity }
    var isPlusDisabled: Bool { quantity == maxQuantity }

    func increaseQuantity() {
        if quantity < maxQuantity {
            quantity += 1
        }
    }

    func decreaseQuantity() {
        if quantity > minQuantity {
            quantity -= 1
        }
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
