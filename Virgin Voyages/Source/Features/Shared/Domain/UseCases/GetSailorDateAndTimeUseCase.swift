//
//  GetSailorDateAndTimeUseCase.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 8.5.25.
//

import Foundation

protocol GetSailorDateAndTimeUseCaseProtocol {
    func execute() async -> Date
}

class GetSailorDateAndTimeUseCase: GetSailorDateAndTimeUseCaseProtocol {
    private let dateTimeRepository: DateTimeRepositoryProtocol

    init(dateTimeRepository: DateTimeRepositoryProtocol = DateTimeRepository()) {
        self.dateTimeRepository = dateTimeRepository
    }

    func execute() async -> Date {
        return await dateTimeRepository.fetchDateTime().getCurrentDateTime()
    }
}
