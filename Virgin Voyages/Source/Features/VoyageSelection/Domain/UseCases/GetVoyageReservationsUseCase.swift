//
//  GetVoyageReservationsUseCase.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 1.6.25.
//

protocol GetVoyageReservationsUseCaseProtocol {
    func execute(useCache: Bool) async throws -> VoyageReservations
}

final class GetVoyageReservationsUseCase: GetVoyageReservationsUseCaseProtocol {

    private let voyageReservations: VoyageReservationsRepositoryProtocol

    init(voyageReservations: VoyageReservationsRepositoryProtocol = VoyageReservationsRepository()) {
        self.voyageReservations = voyageReservations
    }

    func execute(useCache: Bool = false) async throws -> VoyageReservations {
        guard let response = try await voyageReservations.fetchVoyageReservations() else {
            throw VVDomainError.genericError
        }
        return response
    }
}
