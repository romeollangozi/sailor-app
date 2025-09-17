//
//  VipBenefitsRepository.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 4.3.25.
//

protocol VipBenefitsRepositoryProtocol {
	func fetchVipBenefits(guestTypeCode: String, shipCode: String) async throws -> VipBenefits?
}

final class VipBenefitsRepository: VipBenefitsRepositoryProtocol {

	private let networkService: NetworkServiceProtocol

	init(networkService: NetworkServiceProtocol = NetworkService.create()) {
		self.networkService = networkService
	}

	func fetchVipBenefits(guestTypeCode: String, shipCode: String) async throws -> VipBenefits? {
		guard let response = try await networkService.getVipBenefits(guestTypeCode: guestTypeCode, shipCode: shipCode) else {
			return nil
		}
		return response.toDomain()
	}
}
