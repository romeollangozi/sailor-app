//
//  CabinServicesScreenViewModel.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 4/24/25.
//

import Foundation

@Observable class CabinServicesScreenViewModel: BaseViewModel, CabinServicesScreenViewModelProtocol {
    
    private let cabinServiceUseCase: GetCabinServiceContentUseCaseProtocol
    private let createCabinServiceUseCase: CreateCabinServiceRequestUseCaseProtocol
    
    var screenState: ScreenState = .loading
    var cabinService: CabinService = .empty()
    
    var didFailToActivateService: Bool = false
    var errorMessage: String?
    
    init(cabinServiceUseCase: GetCabinServiceContentUseCaseProtocol = GetCabinServiceContentUseCase(),
         createCabinServiceUseCase: CreateCabinServiceRequestUseCaseProtocol = CreateCabinServiceRequestUseCase()) {
        
        self.cabinServiceUseCase = cabinServiceUseCase
        self.createCabinServiceUseCase = createCabinServiceUseCase
    }
    
    func onAppear() {
        loadCabinService()
    }
    
    func onRefresh() {
        loadCabinService()
    }
    
    func onBackTapped() {
        executeNavigationCommand(ServiceCoordinator.ServiceBackCommand())
    }
    
    func onCabinOptionTapped(item: CabinService.CabinServiceItem) {
        executeNavigationCommand(ServiceCoordinator.CabinOptionCommand(cabinServiceItem: item))
    }
    
    func onCabinConfirmationTapped(item: CabinService.CabinServiceItem,
                                   isMaintenance: Bool,
                                   optionId: String?) {
        
        executeNavigationCommand(ServiceCoordinator.CabinServiceConfirmationCommand(cabinServiceItem: item, isMaintenance: isMaintenance, optionId: optionId))
    }
    
    func onMaintenanceServiceTapped(item: CabinService.CabinServiceItem) {
        executeNavigationCommand(ServiceCoordinator.MaintenanceConfirmationCommand(cabinServiceItem: item))
    }
    
    private func loadCabinService() {
        
        screenState = .loading
        
        Task { [weak self] in
            
            guard let self else { return }
            
            if let result = await executeUseCase({
                try await self.cabinServiceUseCase.execute()
            }) {
                await executeOnMain ({
                    self.cabinService = result
                    self.screenState = .content
                })
            } else {
                await executeOnMain {
                    self.screenState = .content
                }
            }
            
        }
        
    }
    
    func createCabinService(item: CabinService.CabinServiceItem) {
        
        screenState = .loading
        
        Task { [weak self] in
            
            guard let self else { return }
            
            do {
                
                let _ = try await UseCaseExecutor.execute {
                    try await self.createCabinServiceUseCase.execute(requestName: item.id, isMaintenance: false)
                }
                
                await executeOnMain {
                    self.onCabinConfirmationTapped(item: item,
                                                   isMaintenance: false,
                                                   optionId: nil)
                    self.screenState = .content
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
