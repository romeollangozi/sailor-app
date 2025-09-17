//
//  GetAddOnsUseCase.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 27.9.24.
//

import Foundation

protocol GetAddOnsUseCaseProtocol {
    func getAddOns(code: String?) async -> Result<AddOnDetails, Error>
}

class GetAddOnsUseCase: GetAddOnsUseCaseProtocol {

    // MARK: - GetAddonsService
    let addOnsService: AddOnRepositoryProtocol

    // MARK: - Init
    init(addOnsService: AddOnRepositoryProtocol = AddOnRepository()) {
        self.addOnsService = addOnsService
    }
    
    // MARK: - Get addons
	func getAddOns(code: String? = nil) async -> Result<AddOnDetails, Error> {
        do {
            return try await addOnsService.getAddOns(code: code)
        }catch(let error) {
            return .failure(error)
        }
    }
}
