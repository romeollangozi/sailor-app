//
//  MockSailorChatDataRepository.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 21.2.25.
//

import Foundation
@testable import Virgin_Voyages

final class MockSailorChatDataRepository: SailorChatDataRepositoryProtocol {
	var mockSailorChatData: SailorChatData?
	var shouldThrowError: Bool = false
	var errorToThrow: Error = VVDomainError.genericError

	func getSailorChatData(voyageNumber: String) async throws -> SailorChatData? {
		if shouldThrowError {
			throw errorToThrow
		}
        return mockSailorChatData
	}
    
}
