//
//  GetHelpAndSupportUseCase.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 22.4.25.
//

protocol GetHelpAndSupportUseCaseProtocol {
	func execute() async throws -> HelpAndSupport
}

final class GetHelpAndSupportUseCase: GetHelpAndSupportUseCaseProtocol {
	private let repository: HelpAndSupportRepositoryProtocol
	
	init(repository: HelpAndSupportRepositoryProtocol = HelpAndSupportRepository()) {
		self.repository = repository
	}
	
	func execute() async throws -> HelpAndSupport {
		guard let response = try await repository.fetchHelpAndSupport(cacheOption: .timedCache()) else {
			throw VVDomainError.genericError
		}
		
		return response
	}
}


