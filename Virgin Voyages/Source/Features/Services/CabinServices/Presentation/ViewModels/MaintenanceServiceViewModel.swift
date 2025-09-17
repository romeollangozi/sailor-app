//
//  MaintenanceServiceViewModel.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 4/29/25.
//

import Foundation

@Observable class MaintenanceServiceViewModel: BaseViewModelV2, MaintenanceServiceViewModelProtocol {

    private let cabinServiceUseCase: GetCabinServiceContentUseCaseProtocol
    private let createCabinServiceUseCase: CreateCabinServiceRequestUseCaseProtocol
    
    var screenState: ScreenState = .loading
    var cabinServiceItem: CabinService.CabinServiceItem = .empty()
    
    var didFailToActivateService: Bool = false
    var errorMessage: String?
    
    init(cabinServiceUseCase: GetCabinServiceContentUseCaseProtocol = GetCabinServiceContentUseCase(),
         createCabinServiceUseCase: CreateCabinServiceRequestUseCaseProtocol = CreateCabinServiceRequestUseCase(),
         cabinServiceItem: CabinService.CabinServiceItem) {
        
        self.cabinServiceUseCase = cabinServiceUseCase
        self.createCabinServiceUseCase = createCabinServiceUseCase
        self.cabinServiceItem = cabinServiceItem
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
    
    func onCabinConfirmationTapped(item: CabinService.CabinServiceItem,
                                   isMaintenance: Bool,
                                   optionId: String?) {
        
        executeNavigationCommand(ServiceCoordinator.CabinServiceConfirmationCommand(cabinServiceItem: item, isMaintenance: isMaintenance, optionId: optionId))
    }
    
    private func loadCabinService() {
        
        Task { [weak self] in
            
            guard let self else { return }
            
			self.screenState = .loading

            if let result = await executeUseCase({
                try await self.cabinServiceUseCase.execute()
            }) {
				self.updateCabinServiceItem(result: result)
				self.screenState = .content
            } else {
				self.screenState = .content
            }
            
        }
        
    }
    
    func createMaintenanceService(item: CabinService.CabinServiceItem, optionId: String) {
        
        Task { [weak self] in
            
            guard let self else { return }
            
			self.screenState = .loading

            do {
                
                let _ = try await UseCaseExecutor.execute {
                    try await self.createCabinServiceUseCase.execute(requestName: optionId,
                                                                     isMaintenance: true)
                }
                
				self.onCabinConfirmationTapped(item: item, isMaintenance: true, optionId: optionId)
				self.screenState = .content

            } catch {
				self.didFailToActivateService = true
				self.errorMessage = "Something went wrong. Please try again later."
				self.screenState = .content
            }
            
        }
        
    }
    
    private func updateCabinServiceItem(result: CabinService) {
        
        if let itemIndex = result.items.firstIndex(where: { item in
            item.id == self.cabinServiceItem.id
        }) {
            self.cabinServiceItem = result.items[itemIndex]
        }
        
    }
    
}
