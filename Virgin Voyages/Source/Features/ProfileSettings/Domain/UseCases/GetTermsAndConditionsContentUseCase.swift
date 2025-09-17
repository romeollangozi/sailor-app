//
//  GetTermsAndConditionsContentUseCase.swift
//  Virgin Voyages
//
//  Created by Timur Xhabiri on 31.10.24.
//

import Foundation

protocol GetTermsAndConditionsContentUseCaseProtocol: AnyObject {
    func execute() async -> Result<TermsAndConditionsScreenModel, VVDomainError>
}

class GetTermsAndConditionsContentUseCase: GetTermsAndConditionsContentUseCaseProtocol {
    
    private var termsAndConditionsRepository: TermsAndConditionsRepositoryProtocol

    // MARK: - Init
    init(termsAndConditionsRepository: TermsAndConditionsRepositoryProtocol = TermsAndConditionsRepository()) {
        self.termsAndConditionsRepository = termsAndConditionsRepository
    }
        
    // MARK: - Execute
    func execute() async -> Result<TermsAndConditionsScreenModel, VVDomainError> {

        let result = await termsAndConditionsRepository.getTermsAndConditionsContent()
        switch result {
        case .success(let content):
            return .success(content)
        case .failure(let error):
            return .failure(error)
        }
    }
}
