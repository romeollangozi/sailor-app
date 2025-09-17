//
//  PreVoyageEditingViewUseCaseProtocol.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 28.11.24.
//


protocol PreVoyageEditingViewUseCaseProtocol {
    func execute() -> PreVoyageEditingModel
}

class PreVoyageEditingViewUseCase: PreVoyageEditingViewUseCaseProtocol {
    
    private var localizationManager: LocalizationManagerProtocol
    private let currentSailorManager: CurrentSailorManagerProtocol
    var model: PreVoyageEditingModel

    init(currentSailorManager: CurrentSailorManagerProtocol = CurrentSailorManager.init(), localizationManager: LocalizationManagerProtocol = LocalizationManager.shared, model: PreVoyageEditingModel =  PreVoyageEditingModel()) {
        self.localizationManager = localizationManager
        self.currentSailorManager = currentSailorManager
        self.model = model
    }
    
    func execute() -> PreVoyageEditingModel {
        let shipName = currentSailorManager.getCurrentSailor()?.shipName ?? ""
        let descriptionText = localizationManager.getString(for: .preVoyageBookingStoppedDescription).replacingPlaceholder("ShipName", with: shipName)
        return PreVoyageEditingModel(title: localizationManager.getString(for: .movingBookingsAndBags), descriptionText:  descriptionText, goItButtonText: localizationManager.getString(for: .gotIt))
    }
}

class PreVoyageEditingModel {
    var title: String
    var descriptionText: String
    var goItButtonText: String
    
    init(title: String = "", descriptionText: String = "", goItButtonText: String = "") {
        self.title = title
        self.descriptionText = descriptionText
        self.goItButtonText = goItButtonText
    }
}
