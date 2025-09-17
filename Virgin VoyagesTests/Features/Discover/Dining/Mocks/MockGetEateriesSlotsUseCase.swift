//
//  MockGetEateriesSlotsUseCase.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 10.4.25.
//

import Foundation

@testable import Virgin_Voyages

final class MockGetEateriesSlotsUseCase: GetEateriesSlotsUseCaseProtocol {
	var result: EateriesSlots?
	
	func execute(input: EateriesSlotsInputModel) async throws -> EateriesSlots {
		return result ?? EateriesSlots.empty()
	}
}
