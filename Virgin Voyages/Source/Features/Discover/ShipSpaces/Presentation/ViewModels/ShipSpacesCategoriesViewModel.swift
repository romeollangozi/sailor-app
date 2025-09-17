//
//  ShipSpacesViewModel.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 29.1.25.
//

import SwiftUI
import VVUIKit

@Observable class ShipSpacesCategoriesViewModel: BaseViewModel, ShipSpacesCategoriesScreenViewModelProtocol {
    private let getShipSpacesUseCase: GetShipSpacesCategoriesUseCaseProtocol
    
    var shipSpaces: ShipSpacesCategories = ShipSpacesCategories.empty()
    var screenState: ScreenState = .loading
    
    init(getShipSpacesUseCase: GetShipSpacesCategoriesUseCaseProtocol = GetShipSpacesCategoriesUseCase()) {
        self.getShipSpacesUseCase = getShipSpacesUseCase
    }
    
    func onAppear() async {
        await loadShipSpaces()
        screenState = .content
    }
    
    func onRefresh() async {
        await loadShipSpaces(useCache: false)
        screenState = .content
    }
    
	private func loadShipSpaces(useCache: Bool = true) async {
        if let result = await executeUseCase({
			try await self.getShipSpacesUseCase.execute(useCache: useCache)
        }) {
            self.shipSpaces = result
        }
    }
}
