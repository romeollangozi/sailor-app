//
//  ShipMapViewModel.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 19.5.25.
//

import Observation
import SwiftUI

@Observable
class ShipMapViewModel: BaseViewModel, ShipMapViewModelProtocol {
    var screenState: ScreenState = .loading
    let getsailorProfileUseCase: GetSailorProfileV2UseCasePotocol
    var deckPlanUrl: String = ""
    
    init(getsailorProfileUseCase: GetSailorProfileV2UseCasePotocol = GetSailorProfileV2UseCase()) {
        self.getsailorProfileUseCase = getsailorProfileUseCase
    }
    
    func onAppear() {
        Task{
			guard let fetchedReservation = await getsailorProfileUseCase.execute(reservationNumber: nil)?.activeReservation() else {
                await executeOnMain {
                    screenState = .content
                }
                return
            }
            await executeOnMain {
                deckPlanUrl = fetchedReservation.deckPlanUrl
                screenState = .content
            }
            
        }
    }
}
