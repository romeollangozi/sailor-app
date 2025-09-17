//
//  CheckIfAccountIsDeactivatedUseCase.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 8/11/25.
//

import Foundation

class CheckIfAccountIsDeactivatedUseCase {
	func execute() -> Bool {
		if let currentAccount = AuthenticationService.shared.currentAccount {
			return currentAccount.status != .active
		}
		return false
	}
}
