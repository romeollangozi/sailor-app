//
//  CabinServiceConfirmationViewModel.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 4/25/25.
//

import Foundation

@Observable class CabinServiceConfirmationViewModel: BaseViewModel, CabinServiceConfirmationViewModelProtocol {
    
    private let cancelCabinServiceUseCase: CancelCabinServiceRequestUseCaseProtocol
    
    var screenState: ScreenState = .loading
    var cabinServiceItem: CabinService.CabinServiceItem = .empty()
    
    var didFailToCancelService: Bool = false
    var errorMessage: String?
    
    var isMaintenance: Bool
    var optionId: String?
    
    init(cancelCabinServiceUseCase: CancelCabinServiceRequestUseCaseProtocol = CancelCabinServiceRequestUseCase(),
         cabinServiceItem: CabinService.CabinServiceItem,
         isMaintenance: Bool,
         optionId: String?) {
        
        self.cancelCabinServiceUseCase = cancelCabinServiceUseCase
        self.cabinServiceItem = cabinServiceItem
        self.isMaintenance = isMaintenance
        self.optionId = optionId
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
    
    func cancelCabinService(cabinServiceItem: CabinService.CabinServiceItem, isMaintenance: Bool) {
        
        screenState = .loading
        
        Task { [weak self] in
            
            guard let self else { return }
            
            do {
                
                if let optionId = self.optionId,
                   let optionItem = cabinServiceItem.options.first(where: { $0.id == optionId }) {
                    
                    let _ = try await self.cancelCabinServiceUseCase.execute(requestId: optionItem.requestId,
                                                                             requestName: optionItem.id,
                                                                                  isMaintenance: isMaintenance)
                } else {
                    let _ = try await self.cancelCabinServiceUseCase.execute(requestId: cabinServiceItem.requestId,
                                                                                  requestName: cabinServiceItem.id,
                                                                                  isMaintenance: isMaintenance)
                }
                
                await executeOnMain {
                    self.screenState = .content
                    self.onBackTapped()
                }
                
            } catch let error as VVDomainError {
                
                self.didFailToCancelService = true
                
                if case VVDomainError.validationError(let validationError) = error {
                    let errorMessage = validationError.errors.joined(separator: "")
                    self.errorMessage = errorMessage
                }
                
                self.screenState = .content
                
            } catch {
                
                self.didFailToCancelService = true
                self.errorMessage = "Something went wrong. Please try again later."
                self.screenState = .content
            }
        }
        
    }
    
    
    
}
