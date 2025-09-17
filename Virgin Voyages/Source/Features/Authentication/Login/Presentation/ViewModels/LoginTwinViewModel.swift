//
//  LoginTwinViewModel.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 7.8.25.
//

import Foundation

@Observable class LoginTwinViewModel: BaseViewModelV2, LoginTwinViewViewModelProtocol {

    let guestDetails: [LoginGuestDetails]
    let sailDate: Date?
    let cabinNumber: String?
    var selectedGuest: LoginGuestDetails?
    
    private var isShipboard: Bool = false
    private var loggingIn: Bool = false
    private let getUserLocationShoresideOrShipsideLocationUseCase: GetUserShoresideOrShipsideLocationUseCaseProtocol
    private let loginUseCase: LoginUseCaseProtocol
    
    init(
		getUserLocationShoresideOrShipsideLocationUseCase: GetUserShoresideOrShipsideLocationUseCaseProtocol = GetUserShoresideOrShipsideLocationUseCase(),
		loginUseCase: LoginUseCaseProtocol = LoginUseCase(),
		guestDetails: [LoginGuestDetails],
		sailDate: Date? = nil,
		cabinNumber: String? = nil
    ) {
        self.getUserLocationShoresideOrShipsideLocationUseCase = getUserLocationShoresideOrShipsideLocationUseCase
        self.loginUseCase = loginUseCase
        self.guestDetails = guestDetails
        self.sailDate = sailDate
        self.cabinNumber = cabinNumber
    }
    
    var isNextButtonDisabled: Bool {
        return selectedGuest == nil
    }
    
    var userInterfaceDisabled: Bool {
        return loggingIn
    }
    
    func onAppear() {
        loadSailorLocation()
    }
    
    func login()  {
        loggingIn = true
        
        Task { [weak self] in
            
            guard let self else { return }
            
            if isShipboard {
                await self.loginShipside()
            } else {
                await self.loginShoreside()
            }

			self.loggingIn = false
        }
    }
    
    private func loadSailorLocation() {
        let sailorLocation = getUserLocationShoresideOrShipsideLocationUseCase.execute()
        self.isShipboard = sailorLocation == .ship ? true : false
    }
    
    private func loginShipside() async {
        guard let selectedGuest else { return }
        do {
            if let birthDate = selectedGuest.birthDate, let cabinNumber = self.cabinNumber  {
                let result = try await UseCaseExecutor.execute {
                    try await self.loginUseCase.execute(.cabin(
                        cabinNumber: cabinNumber,
                        lastName: selectedGuest.lastName,
                        birthday: birthDate,
                        reservationGuestId: selectedGuest.reservationGuestID)
                    )
                }
				handleLoginResult(result)
            }
            
        } catch (let error) as VVDomainError {
			if case VVDomainError.validationError(error: _) = error {
                showErrorModal()
            }
            
        } catch {
			showErrorModal()
        }
    }
    
    private func loginShoreside() async {
        guard let selectedGuest else { return }
        do {
            if let birthDate = selectedGuest.birthDate, let sailDate = self.sailDate {
                let result = try await UseCaseExecutor.execute {
                    try await self.loginUseCase.execute(.reservation(
                        lastName: selectedGuest.lastName,
                        reservationNumber: selectedGuest.reservationNumber,
                        birthDate: birthDate,
                        sailDate: sailDate,
                        reservationGuestId: selectedGuest.reservationGuestID)
                    )
                }
				handleLoginResult(result)
            }
            
        } catch (let error) as VVDomainError {
			if case VVDomainError.validationError(_) = error {
				showErrorModal()
            }
        } catch {
			showErrorModal()
        }
    }
    
    private func handleLoginResult(_ result: LoginResult) {
        if result == .success {
            navigateToRootView()
        }
    }
    
    // MARK: - Helper Method
    
    private func showErrorModal() {
        let errorModalType: LoginErrorModalType = isShipboard ? .ship : .shore
        showErrorModal(for: errorModalType)
    }
    
    func showErrorModal(for errorModalType: LoginErrorModalType) {
		navigationCoordinator.executeCommand(LoginSelectionCoordinator.ShowFullScreenLoginWithBookingReferenceError(errorModalType: errorModalType))
    }
    
    // MARK: Navigation
    func navigateBack() {
        navigationCoordinator.executeCommand(LoginSelectionCoordinator.GoBackCommand())
    }
    
    func cancel() {
        navigateToRootView()
    }
    
    private func navigateToRootView() {
		navigationCoordinator.executeCommand(LoginSelectionCoordinator.GoBackToRootViewCommand())
    }
}
