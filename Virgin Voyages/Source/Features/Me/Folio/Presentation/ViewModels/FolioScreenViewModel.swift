//
//  FolioScreenViewModel.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 14.5.25.
//

import Foundation

@Observable
class FolioScreenViewModel: BaseViewModel, FolioScreenViewModelProtocol {
    // MARK: - Dependencies
    private let getFolioUseCase: GetFolioUseCaseProtocol
	private let getSailingModeUseCase: GetSailingModeUseCaseProtocol
	
    // MARK: - State
	var screenState: ScreenState = .loading
	var folio: Folio = .empty()

    // MARK: - Init
    init(getFolioUseCase: GetFolioUseCaseProtocol = GetFolioUseCase(),
		 getSailingModeUseCase: GetSailingModeUseCaseProtocol = GetSailingModeUseCase()) {
        self.getFolioUseCase = getFolioUseCase
		self.getSailingModeUseCase = getSailingModeUseCase
    }

	// MARK: - ViewModel Lifecycle
    func onAppear() {
		Task {
			await loadScreenData()
		}
    }
	
	func onRefresh() {
		Task {
			await loadScreenData()
		}
	}
	
	// MARK: - Private Methods
    private func loadScreenData() async {
        await loadFolio()
        
        await executeOnMain({
            self.screenState = .content
        })
    }
	
	private func loadFolio() async {
		if let result = await executeUseCase ({
			try await self.getFolioUseCase.execute()
		}) {
            await executeOnMain({
                self.folio = result
            })
		}
	}
	
	private func loadSailingMode() async -> SailingMode? {
		if let result = await executeUseCase({
			try await self.getSailingModeUseCase.execute()
		}) {
			return result
		}
		return nil
	}
}
