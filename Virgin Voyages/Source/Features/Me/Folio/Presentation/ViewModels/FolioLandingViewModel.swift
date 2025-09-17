//
//  FolioLandingViewModel.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 29.8.25.
//

import VVUIKit

@Observable
class FolioLandingViewModel: BaseViewModelV2, FolioLandingViewModelProtocol {
    
    private let dependentSailor: Folio.Shipboard.Dependent
    private let folioImageUseCase: FolioImageUseCaseProtocol
    
    init(
        dependentSailor: Folio.Shipboard.Dependent,
        folioImageUseCase: FolioImageUseCaseProtocol = FolioImageUseCase()
    ) {
        self.dependentSailor = dependentSailor
        self.folioImageUseCase = folioImageUseCase
    }
    
    var sailor: FolioDependentSailor {
        FolioDependentSailor(
            name: dependentSailor.name,
            status: dependentSailor.status,
            description: dependentSailor.description,
            instructions: dependentSailor.instructions,
            imageURL: folioImageUseCase.authenticatedImageURL(from: dependentSailor.imageUrl)
        )
    }
}
