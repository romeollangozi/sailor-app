//
//  PreVoyageEditingViewModel.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 28.11.24.
//

import Observation

@Observable class PreVoyageEditingViewModel: BaseViewModel, PreVoyageEditingViewModelProtocol {
    
    var title: String { return preVoyageEditingModel.title }
    
    var descriptionText: String { return preVoyageEditingModel.descriptionText }
    
    var goItButtonText: String { return preVoyageEditingModel.goItButtonText }
    

    private let preVoyageEditingViewUseCase: PreVoyageEditingViewUseCaseProtocol
    private var preVoyageEditingModel: PreVoyageEditingModel
    
    init(preVoyageEditingViewUseCase: PreVoyageEditingViewUseCaseProtocol = PreVoyageEditingViewUseCase(), preVoyageEditingModel: PreVoyageEditingModel = PreVoyageEditingModel(title: "", descriptionText: "", goItButtonText: "")) {
        self.preVoyageEditingViewUseCase = preVoyageEditingViewUseCase
        self.preVoyageEditingModel = preVoyageEditingModel
    }
    
    func onAppear() {
        preVoyageEditingModel = self.preVoyageEditingViewUseCase.execute()
    }
}

