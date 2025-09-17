//
//  HealthCheckEntryPointViewModel.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 6/3/25.
//

import Foundation

@Observable class HealthCheckEntryPointViewModel: BaseViewModel, HealthCheckEntryPointViewModelProtocol {
    
    private let homeHealthCheckUseCase: GetHealthCheckUseCaseProtocol
    
    var screenState: ScreenState = .loading
    var homeHealthCheckDetail = HealthCheckDetail.empty()
    
    init(homeHealthCheckUseCase: GetHealthCheckUseCaseProtocol = GetHealthCheckUseCase()) {
        self.homeHealthCheckUseCase = homeHealthCheckUseCase
    }
    
    func onAppear() {
        loadHealthCheckDetails()
    }
    
    func onRefresh() {
        loadHealthCheckDetails()
    }
    
    private func loadHealthCheckDetails() {
                
        Task { [weak self] in
            
            guard let self else { return }
            
            if let result = await executeUseCase({
                
                try await self.homeHealthCheckUseCase.execute()
            }) {
                
                await executeOnMain {
                    self.homeHealthCheckDetail = result
                    self.screenState = .content
                }
                
            } else {
                
                await executeOnMain {
                    self.screenState = .error
                }
                
            }
            
        }
        
    }
    
    func dismissHealthCheck() {
        executeNavigationCommand(HomeDashboardCoordinator.DismissFullScreenCoverCommand(pathToDismiss: .healthCheckLanding))
    }
    
    func goToHealthCheckQuestions() {
        executeNavigationCommand(HealthCheckCoordinator.OpenHealthQuestion(healthCheckDetail: homeHealthCheckDetail))
    }
    
}
