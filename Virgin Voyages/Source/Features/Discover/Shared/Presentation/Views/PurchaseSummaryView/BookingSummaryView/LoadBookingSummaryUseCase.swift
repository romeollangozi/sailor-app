//
//  LoadDataForBookingSummaryUseCase.swift
//  Virgin Voyages
//
//  Created by TX on 12.5.25.
//

import Foundation

// MARK: - Protocol
protocol LoadDataForBookingSummaryUseCaseProtocol {
    func execute() async throws -> LoadDataForBookingSummaryUseCaseModel
}

// MARK: - Return Type
struct LoadDataForBookingSummaryUseCaseModel  {
    let savedCards: [SavedCard]
    let isShipSide: Bool
}

extension LoadDataForBookingSummaryUseCaseModel {
    static func empty() -> Self {
        .init(savedCards: [], isShipSide: false)
    }
}


// MARK: - Protocol Implementation
class LoadDataForBookingSummaryUseCase: LoadDataForBookingSummaryUseCaseProtocol {

    private let lastKnownSailorConnectionLocationRepository: LastKnownSailorConnectionLocationRepositoryProtocol
    private var paymentRepository: PaymentRepositoryProtocol

    init(lastKnownSailorConnectionLocationRepository: LastKnownSailorConnectionLocationRepositoryProtocol = LastKnownSailorConnectionLocationRepository(),
         paymentRepository: PaymentRepositoryProtocol = PaymentRepository()
    ) {
        self.lastKnownSailorConnectionLocationRepository = lastKnownSailorConnectionLocationRepository
        self.paymentRepository = paymentRepository
    }

    func execute() async throws -> LoadDataForBookingSummaryUseCaseModel {
        let sailorLocation = lastKnownSailorConnectionLocationRepository.fetchLastKnownSailorConnectionLocation()
        let isShipside = sailorLocation == .ship

        return LoadDataForBookingSummaryUseCaseModel(
            savedCards: await fetchSavedCards(),
            isShipSide: isShipside)
    }

    private func fetchSavedCards() async -> [SavedCard] {
        return await paymentRepository.fetchSavedCards()
    }
}
