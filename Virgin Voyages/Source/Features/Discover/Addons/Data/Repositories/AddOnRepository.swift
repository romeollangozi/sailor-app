//
//  AddOnRepository.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 29.9.24.
//

import Foundation

final class AddOnRepository: AddOnRepositoryProtocol {

	private let authenticationService: AuthenticationServiceProtocol
    private let networkService: NetworkServiceProtocol
    
	init(
		authenticationService: AuthenticationServiceProtocol = AuthenticationService.shared,
		networkService: NetworkServiceProtocol = NetworkService.create()
	) {
		self.authenticationService = authenticationService
        self.networkService = networkService
    }
    
    func getAddOnDetails(code: String) async throws -> GetAddonsDetailsResponse? {
        guard let authentication = try? authenticationService.currentSailor() else { return nil }

        let reservation = authentication.reservation
        return try await networkService.getAddonDetails(
            addonCode: code,
            reservatioNumber: reservation.reservationNumber,
            guestId: reservation.guestId,
            shipCode: reservation.shipCode.rawValue
        )
    }
    
    
    func getAddOns(code: String? = nil) async throws -> Result<AddOnDetails, Error> {
        guard let authentication = try? authenticationService.currentSailor() else {
			return .failure(VVDomainError.genericError)
        }

        do {
            let reservation = authentication.reservation
            let response = try await authentication.fetch(Endpoint.GetAddonDetails(reservation: reservation, code: code))
			return .success(response.toModel())
        } catch {
            return .failure(error)
        }
    }
}
