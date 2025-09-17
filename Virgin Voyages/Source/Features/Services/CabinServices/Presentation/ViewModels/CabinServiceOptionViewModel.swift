//
//  CabinServiceOptionViewModel.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 4/24/25.
//

import Foundation

@Observable class CabinServiceOptionViewModel: BaseViewModel, CabinServiceOptionViewModelProtocol {
    
    private let createCabinServiceUseCase: CreateCabinServiceRequestUseCaseProtocol
    
    var screenState: ScreenState = .loading
    var cabinServiceItem: CabinService.CabinServiceItem = .empty()
    var createCabinServiceRequestResult: CreateCabinServiceRequestResult?
    
    var didFailToActivateService: Bool = false
    var errorMessage: String?
    
    init(createCabinServiceUseCase: CreateCabinServiceRequestUseCaseProtocol = CreateCabinServiceRequestUseCase(),
         cabinServiceItem: CabinService.CabinServiceItem) {
        
        self.createCabinServiceUseCase = createCabinServiceUseCase
        self.cabinServiceItem = cabinServiceItem
    }
    
    func onAppear() {
        screenState = .content
    }
    
    func onRefresh() {
        screenState = .content
    }
    
    func onBackTapped() {
        executeNavigationCommand(ServiceCoordinator.ServiceBackCommand())
    }
    
    func createCabinService(withRequestName name: String) {
        
        screenState = .loading
        
        Task { [weak self] in
            
            guard let self else { return }
            
            do {
                
                let result = try await UseCaseExecutor.execute {
                    try await self.createCabinServiceUseCase.execute(requestName: name, isMaintenance: false)
                }
                
                await executeOnMain {
                    self.createCabinServiceRequestResult = result
                    self.screenState = .content
                    self.onBackTapped()
                }
                
            } catch let error as VVDomainError {
                
                self.didFailToActivateService = true
                
                if case VVDomainError.validationError(let validationError) = error {
                    let errorMessage = validationError.errors.joined(separator: "")
                    self.errorMessage = errorMessage
                }
                
                self.screenState = .content
                
            } catch {
                
                self.didFailToActivateService = true
                self.errorMessage = "Something went wrong. Please try again later."
                self.screenState = .content
            }
            
        }
        
    }
    
}
