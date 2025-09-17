//
//  MockGetEateriesListUseCase.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 10.4.25.
//

import Foundation

@testable import Virgin_Voyages

final class MockGetEateriesListUseCase: GetEateriesListUseCaseProtocol {	
	var result: EateriesList?
	func execute(includePortsName: Bool, useCache: Bool) async throws -> EateriesList {
		return result ?? EateriesList.empty()
	}
}
