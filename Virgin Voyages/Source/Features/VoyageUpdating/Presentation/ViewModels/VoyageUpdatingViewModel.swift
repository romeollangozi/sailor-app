//
//  VoyageUpdatingViewModel.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 7/14/25.
//

import Foundation

class VoyageUpdatingViewModel: BaseViewModel {
	private let logOutUseCase: LogoutUserUseCaseProtocol

	init(logOutUseCase: LogoutUserUseCaseProtocol = LogoutUserUseCase()) {
		self.logOutUseCase = logOutUseCase
	}

	func logOut() {
		Task {
			await executeUseCase({ [weak self] in
				await self?.logOutUseCase.execute()
			})
		}
	}
}
