//
//  ClaimBookingRepositoryProtocol.swift
//  Virgin Voyages
//
//  Created by TX on 14.7.25.
//

protocol ClaimBookingRepositoryProtocol {
	func claimBooking(request: ClaimBookingRequestBody) async throws -> ClaimBooking
}

final class ClaimBookingRepository: ClaimBookingRepositoryProtocol {
	private let networkService: NetworkServiceProtocol

	init(
		networkService: NetworkServiceProtocol = NetworkService.create()
	) {
		self.networkService = networkService
	}

	func claimBooking(request: ClaimBookingRequestBody) async throws -> ClaimBooking {
        guard let details = try await networkService.claimBooking(request: request) else {
            throw VVDomainError.notFound
        }
        return details.toDomain()
	}
}
