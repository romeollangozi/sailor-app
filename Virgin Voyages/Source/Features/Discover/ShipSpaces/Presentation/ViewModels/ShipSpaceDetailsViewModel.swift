//
//  ShipSpaceDetailsViewModel.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 2.2.25.
//

import SwiftUI
import Foundation

@Observable class ShipSpaceDetailsViewModel: BaseViewModel, ShipSpaceDetailsScreenViewModelProtocol {
    var shipSpace: ShipSpaceDetails
    
    var screenState: ScreenState = .loading
    
    init(shipSpace: ShipSpaceDetails = ShipSpaceDetails.empty()) {
        self.shipSpace = shipSpace
    }
    
    func onAppear() {
        screenState = .content
    }
    
    func onRefresh() {
        screenState = .content
    }
    
    
}
