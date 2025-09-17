//
//  BoardingPassViewModel.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 4/2/25.
//

import Foundation
import Observation

@Observable class BoardingPassViewModel: BaseViewModelV2, BoardingPassViewModelProtocol {

    // MARK: - Properties
    var screenState: ScreenState = .loading
    var sailorBoardingPass: SailorBoardingPass = .init(items: [])
    
    private var getBoardingPassUseCase: GetBoardingPassUseCaseProtocol
    
    // MARK: - Init
    init(getBoardingPassUseCase: GetBoardingPassUseCaseProtocol = GetBoardingPassUseCase()) {
        self.getBoardingPassUseCase = getBoardingPassUseCase
    }
    
    // MARK: - API
    
    func onApperar() {
        loadBoardingPass()
    }
    
    // MARK: - Private Methods
    
    private func loadBoardingPass() {
        
        Task { [weak self] in
            
            guard let self else { return }
            
			self.screenState = .loading

            if let result = await executeUseCase({
                try await self.getBoardingPassUseCase.execute()
            }) {
				self.sailorBoardingPass = result
				self.screenState = .content
            } else {
				self.sailorBoardingPass = .empty()
				self.screenState = .error
            }
            
        }
        
    }
    
}

// MARK: - Mock ViewModel

struct BoardingPassViewModelMock: BoardingPassViewModelProtocol {
    var screenState: ScreenState = .content
    var sailorBoardingPass: SailorBoardingPass = SailorBoardingPass.sample()
    
    func onApperar() { }
}
