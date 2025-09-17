//
//  MockLogoutUserUseCase.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 28.5.25.
//

import XCTest
@testable import Virgin_Voyages

final class MockLogoutUserUseCase: LogoutUserUseCaseProtocol {
	var isExecuted = false
	
	func execute() async {
		isExecuted = true
	}
}

