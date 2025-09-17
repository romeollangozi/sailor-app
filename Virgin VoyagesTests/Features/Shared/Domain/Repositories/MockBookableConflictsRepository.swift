//
//  MockBookableConflictsRepository.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 7.5.25.
//
import Foundation
@testable import Virgin_Voyages

class MockBookableConflictsRepository: BookableConflictsRepositoryProtocol {
	var result: [Virgin_Voyages.BookableConflicts] = []
	
	func fetchBookableConflicts(input: Virgin_Voyages.BookableConflictsInput) async throws -> [Virgin_Voyages.BookableConflicts] {
		return result
	}
}
