//
//  TermsAndConditionDetailsViewModel.swift
//  Virgin Voyages
//
//  Created by Timur Xhaniri on 31.10.24.
//

import Foundation


protocol TermsAndConditionViewModelProtocol {
    var screenModel: TermsAndConditionsScreenModel { get set }
    var screenState: ScreenState { get set }
    func refresh() async
}

@Observable class TermsAndConditionViewModel: TermsAndConditionViewModelProtocol {
    var screenModel: TermsAndConditionsScreenModel = .init()
    var screenState: ScreenState = .loading
    
    private var getContenUseCase: GetTermsAndConditionsContentUseCaseProtocol

    init(getContenUseCase: GetTermsAndConditionsContentUseCaseProtocol = GetTermsAndConditionsContentUseCase()) {
        self.getContenUseCase = getContenUseCase
    }
    
    // MARK: Public API
    
    func refresh() async {
        let result = await getContenUseCase.execute()
        switch result {
        case .success(let content):
            finishLoading(with: .content, content: content)
        case .failure(let failure):
            print("Error - failure : ", failure.localizedDescription)
            finishLoading(with: .error, content: screenModel)
        }
    }
    
    // MARK: Private Methods
    private func finishLoading(with state: ScreenState, content: TermsAndConditionsScreenModel) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.screenModel = content
            self.screenState = state
        }
    }
}

