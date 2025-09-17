//
//  ClarificationStateViewModel.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 21.3.25.
//

import Observation

@Observable class ClarificationStateViewModel: ClarificationStateViewModelProtocol {
	private let clarificationStateUseCase: ClarificationStateUseCaseProtocol
	var clarificationStateModel: ClarificationStateModel = .empty

	init(clarificationStateUseCase: ClarificationStateUseCaseProtocol = ClarificationStateUseCase(conficts: [], sailors: [])) {
		self.clarificationStateUseCase = clarificationStateUseCase
		self.clarificationStateModel = clarificationStateModel
	}

	func onAppear() {
		clarificationStateModel = clarificationStateUseCase.execute()
	}
}
