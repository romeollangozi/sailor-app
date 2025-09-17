//
//  TermsAndConditionsRepository.swift
//  Virgin Voyages
//
//  Created by Timur Xhabiri on 31.10.24.
//

import Foundation

protocol TermsAndConditionsRepositoryProtocol {
    func getTermsAndConditionsContent() async -> Result<TermsAndConditionsScreenModel, VVDomainError>
}

class TermsAndConditionsRepository: TermsAndConditionsRepositoryProtocol {
    
    private var networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService.create()) {
        self.networkService = networkService
    }
    
    func getTermsAndConditionsContent() async -> Result<TermsAndConditionsScreenModel, VVDomainError> {
        
        if let authentication = try? AuthenticationService.shared.currentSailor() {
        
            let reservation = authentication.reservation
            let result = await self.networkService.fetchSettingsTermsAndConditionsScreen(shipCode: reservation.shipCode.rawValue)
            
            if let networkError = result.error {
                let domainError = NetworkToVVDomainErrorMapper.map(from: networkError)
                return .failure(domainError)
            }
            
            if let apiResult = result.response  {
                let domainModel = TermsAndConditionsScreenModel.map(from: apiResult)
                return .success(domainModel)
            }
        }
        
        return .failure(.genericError)
    }
}
    

class PreviewMockTermsAndConditionsRepository: TermsAndConditionsRepositoryProtocol {
    
    func getTermsAndConditionsContent() async -> Result<TermsAndConditionsScreenModel, VVDomainError> {
        let dummyContent = [
            TermsAndConditionsListItemModel(
                id: "1",
                key: .general,
                heading: "General",
                content: [
                    TermsAndConditionsListItemModel.ContentModel(title: "General Terms", subtitle: "Overview of general terms", body: "These are the general terms and conditions...")
                ]
            ),
            TermsAndConditionsListItemModel(
                id: "2",
                key: .mobile,
                heading: "Mobile",
                content: [
                    TermsAndConditionsListItemModel.ContentModel(title: "Mobile Usage", subtitle: "Terms for mobile usage", body: "These are the terms for using our mobile services...")
                ]
            ),
            TermsAndConditionsListItemModel(
                id: "3",
                key: .privacy,
                heading: "Privacy",
                content: [
                    TermsAndConditionsListItemModel.ContentModel(title: "Privacy Policy", subtitle: "Overview of privacy policy", body: "Your privacy is important to us...")
                ]
            ),
            TermsAndConditionsListItemModel(
                id: "4",
                key: .cookie,
                heading: "Cookies",
                content: [
                    TermsAndConditionsListItemModel.ContentModel(title: "Cookies Policy", subtitle: "Usage of cookies", body: "We use cookies to enhance your experience...")
                ]
            )
        ]
        
        let dummyModel = TermsAndConditionsScreenModel(title: "Preview Terms and Conditions", menuItems: dummyContent)
        return .success(dummyModel)
    }
}
