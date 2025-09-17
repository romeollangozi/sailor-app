//
//  MockSendMessageRepository.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 21.2.25.
//

import Foundation
@testable import Virgin_Voyages

final class MockSendMessageRepository: SendMessageRepositoryProtocol {
	var mockSendMessage: SendMessage?
	var shouldThrowError: Bool = false
	var errorToThrow: Error = VVDomainError.genericError

	func sendMessage(queueId: String, voyageNumber: String, message: String) async throws -> SendMessage? {
		if shouldThrowError {
			throw errorToThrow
		}
		return mockSendMessage
	}
    
    func sendCrewMessage(to: String, voyageNumber: String, message: String) async throws -> SendMessage? {
        if shouldThrowError {
            throw errorToThrow
        }
        return mockSendMessage
    }
}
