//
//  BookableConflictsRepository.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 11.3.25.
//

protocol BookableConflictsRepositoryProtocol {
	func fetchBookableConflicts(input: BookableConflictsInput) async throws -> [BookableConflicts]
}

class BookableConflictsRepository: BookableConflictsRepositoryProtocol {

	let networkService: NetworkServiceProtocol

	init(networkService: NetworkServiceProtocol = NetworkService.create()) {
		self.networkService = networkService
	}

	func fetchBookableConflicts(input: BookableConflictsInput) async throws -> [BookableConflicts] {
		let response = try await networkService.getBookableConflicts(input: input.toNetworkDTO())
		return response?.toDomain() ?? []
	}
}
