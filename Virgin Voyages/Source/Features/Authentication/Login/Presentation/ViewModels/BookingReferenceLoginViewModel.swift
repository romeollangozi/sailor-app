//
//  BookingReferenceLoginViewModel.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 8/22/24.
//

import Foundation
import SwiftUI

enum LoginErrorModalType {
    case ship
    case shore
    case none 
}

@Observable class BookingReferenceLoginViewModel: BaseViewModel, BookingReferenceLoginViewModelProtocol {
    
    private var appCoordinator: CoordinatorProtocol
    var bookingReferenceNumber: String = ""
    var cabinNumber: String = ""
    var lastName: String = ""
    var dateOfBirth: DateComponents = DateComponents(calendar: Calendar.current)
    var sailDate: DateComponents = DateComponents(calendar: Calendar.current)
    var isShipboard: Bool = false
    var userAttemptAValueForBookingReference: Bool = false // Boolean to validate field only after user has already attempted an input value.
    
    // MARK: - BookingReferenceLoginViewModelProtocol
    var reCaptchaRefreshID = UUID()
    var reCaptchaToken: String?
    var reCaptchaIsChecked: Bool = false
    var reCaptchaError: String?

    var dateOfBirthError: String? {
        guard dateOfBirth.dateIsOlderThan16Years else { return "" }
        
        if dateOfBirth.isFullySpecifiedDate() {
            return dateOfBirth.isValidDate() ? nil : ""
        }
        return nil
    }
    
    var sailDateError: String? {
        if sailDate.isFullySpecifiedDate() {
            return sailDate.isValidDate() ? nil : ""
        }
        return nil
    }
    
    var bookingReferenceFieldErrorText: String? {
        if userAttemptAValueForBookingReference && isInvalidValidBookingReferenceValue {
            return "Reservation number must be at least 6 digits"
        }
        return nil
    }
    
    var isInvalidValidBookingReferenceValue: Bool {
        bookingReferenceNumber.isEmpty ||
         bookingReferenceNumber.count < 6 ||
         bookingReferenceNumber.containsSpace ||
         !bookingReferenceNumber.isNumeric
    }
    
    var loginButtonDisabled: Bool {
        if isShipboard {
            return lastName.isEmpty || cabinNumber.isEmpty || !dateOfBirthFilledIn || dateOfBirthError != nil
        } else {
            return lastName.isEmpty || !dateOfBirthFilledIn || !sailDateFilledIn || dateOfBirthError != nil || sailDateError != nil || isInvalidValidBookingReferenceValue || !recaptchaPassed()
        }
    }
    
    var dateFieldErrorClarification: String {
        return "Accounts can only be established for sailors over the age of 13, so if you don’t remember a world without social media, we’re going to have to ask you to leave"
    }
    
    var showDateFieldErrorClarification: Bool {
        !dateOfBirth.dateIsOlderThan16Years    }
    
    var userInterfaceDisabled: Bool {
        return loggingIn
    }
    
    var loginTitle: String {
        return isShipboard ? "Login with your cabin number" : "Login with your booking reference"
    }
    
    private func resetReCaptcha() {
        reCaptchaRefreshID = UUID()
        reCaptchaToken = nil
        reCaptchaIsChecked = false
    }
    
    private func recaptchaPassed() -> Bool {
        if shouldDisplayRecaptcha, let reCaptchaToken, !reCaptchaToken.isEmpty {
            return true
        }
        return false
    }
    
    var shouldDisplayRecaptcha: Bool {
        if !isShipboard {
            true
        } else {
            false
        }
    }
    
    private var dateOfBirthFilledIn: Bool {
        return dateOfBirth.day != nil && dateOfBirth.year != nil && dateOfBirth.month != nil
    }
    
    private var sailDateFilledIn: Bool {
        return sailDate.day != nil && sailDate.year != nil && sailDate.month != nil
    }
    
    private var loggingIn: Bool = false
    private var getUserLocationShoresideOrShipsideLocationUseCase: GetUserShoresideOrShipsideLocationUseCaseProtocol
    private let loginUseCase: LoginUseCaseProtocol
    private var retrieveShoresideBookingReferenceDetailsWithBiometricsUseCase: RetrieveShoresideBookingReferenceDetailsWithBiometricsUseCase
    private var retrieveShipsideBookingReferenceDetailsWithBiometricsUseCase: RetrieveShipsideBookingReferenceDetailsWithBiometricsUseCase
	private let lastKnownSailorConnectionLocationRepository: LastKnownSailorConnectionLocationRepositoryProtocol
    
    init(appCoordinator: CoordinatorProtocol = AppCoordinator.shared,
         getUserLocationShoresideOrShipsideLocationUseCase: GetUserShoresideOrShipsideLocationUseCaseProtocol = GetUserShoresideOrShipsideLocationUseCase(),
         loginUseCase: LoginUseCaseProtocol = LoginUseCase(),
         retrieveShoresideBookingReferenceDetailsWithBiometricsUseCase: RetrieveShoresideBookingReferenceDetailsWithBiometricsUseCase = RetrieveShoresideBookingReferenceDetailsWithBiometricsUseCase(),
         retrieveShipsideBookingReferenceDetailsWithBiometricsUseCase: RetrieveShipsideBookingReferenceDetailsWithBiometricsUseCase = RetrieveShipsideBookingReferenceDetailsWithBiometricsUseCase(),
		 lastKnownSailorConnectionLocationRepository: LastKnownSailorConnectionLocationRepositoryProtocol = LastKnownSailorConnectionLocationRepository()) {

        self.appCoordinator = appCoordinator
        self.getUserLocationShoresideOrShipsideLocationUseCase = getUserLocationShoresideOrShipsideLocationUseCase
        self.loginUseCase = loginUseCase
        self.retrieveShoresideBookingReferenceDetailsWithBiometricsUseCase = retrieveShoresideBookingReferenceDetailsWithBiometricsUseCase
        self.retrieveShipsideBookingReferenceDetailsWithBiometricsUseCase = retrieveShipsideBookingReferenceDetailsWithBiometricsUseCase
        self.lastKnownSailorConnectionLocationRepository = lastKnownSailorConnectionLocationRepository
    }
    
    func loadBookingReferenceLoginView() {
        let sailorLocation = getUserLocationShoresideOrShipsideLocationUseCase.execute()
        self.isShipboard = sailorLocation == .ship ? true : false
        autofillLoginDetails()
    }
    
    private func autofillLoginDetails() {
        if isShipboard {
            Task {
                let result = await self.retrieveShipsideBookingReferenceDetailsWithBiometricsUseCase.execute()
                DispatchQueue.main.async { [weak self] in
                    
                    guard let self = self else {
                        return
                    }
                    
                    if case .success(let bookingReferenceDetails) = result {
                        let dateOfBirth = bookingReferenceDetails.dateOfBirth
                        let calendar = Calendar.current
                        let components: Set<Calendar.Component> = [.year, .month, .day]
                        let dateOfBirthDateComponents = calendar.dateComponents(components, from: dateOfBirth)
                        
                        self.lastName = bookingReferenceDetails.lastName
                        self.cabinNumber = bookingReferenceDetails.cabinNumber
                        self.dateOfBirth = dateOfBirthDateComponents
                    }
                }
            }
        } else {
            Task {
                let result = await self.retrieveShoresideBookingReferenceDetailsWithBiometricsUseCase.execute()
                DispatchQueue.main.async { [weak self] in
                    
                    guard let self = self else {
                        return
                    }
                    
                    if case .success(let shoresideBookingReferenceDetails) = result {
                        let dateOfBirth = shoresideBookingReferenceDetails.dateOfBirth
                        let sailDate = shoresideBookingReferenceDetails.sailDate
                        let calendar = Calendar.current
                        let components: Set<Calendar.Component> = [.year, .month, .day]
                        let dateOfBirthDateComponents = calendar.dateComponents(components, from: dateOfBirth)
                        let sailDateComponents = calendar.dateComponents(components, from: sailDate)
                        
                        self.lastName = shoresideBookingReferenceDetails.lastName
                        self.dateOfBirth = dateOfBirthDateComponents
                        self.bookingReferenceNumber = shoresideBookingReferenceDetails.bookingReferenceNumber
                        self.sailDate = sailDateComponents
                    }
                }
            }
        }
    }
    
    func login() {
        loggingIn = true
        
        Task { [weak self] in
            
            guard let self else { return }
            
            if isShipboard {
                await self.loginShipside()
            } else {
                await self.loginShoreside()
            }
            
            await executeOnMain {
                self.loggingIn = false
            }
            
        }
        
    }
    
    private func loginShipside() async {
        
        let calendar = Calendar.current
        print("BookingReferenceLoginViewModel - Loging in with cabin number (loginShipside)...")
        do {
            if let birthDate = calendar.date(from: self.dateOfBirth) {
                let result = try await UseCaseExecutor.execute {
                    try await self.loginUseCase.execute(.cabin(cabinNumber: self.cabinNumber, lastName: self.lastName, birthday: birthDate))
                }
                if case .guestConflict(let guestDetails) = result {
                    loginWithTwin(guestDetails: guestDetails, cabinNumber: self.cabinNumber)
                } else if case .success = result {
                    print("BookingReferenceLoginViewModel - Loging in with cabin number (loginShipside): SUCCESS \(true)")
                } else if case .bookingNotFound = result {
                    print("BookingReferenceLoginViewModel - Loging in with cabin number (loginShipside): SUCCESS \(false)")
                }
            }
            
        } catch (let error) as VVDomainError {
            print("BookingReferenceLoginViewModel - Loging in with cabin number (loginShipside): FAILED")
            if case VVDomainError.validationError(error: let vaildationError) = error {
                let errorMessage = vaildationError.errors.joined(separator: "")
                self.errorModal(errorMessage: errorMessage)
            }
            
        } catch {
            print("BookingReferenceLoginViewModel - Loging in with cabin number (loginShipside): FAILED")
            let errorMessage = "Something went wrong. Please try again later."
            self.errorModal(errorMessage: errorMessage)
        }
    }
    
    private func loginShoreside() async {
        
        let calendar = Calendar.current
        print("BookingReferenceLoginViewModel - Loging in with booking reference (reservation number) (loginShoreside)...")

        do {
            
            if let birthDate = calendar.date(from: self.dateOfBirth),
               let sailDate = calendar.date(from: self.sailDate) {
                let result = try await UseCaseExecutor.execute {
                    try await self.loginUseCase.execute(.reservation(
                        lastName: self.lastName,
                        reservationNumber: self.bookingReferenceNumber,
                        birthDate: birthDate,
                        sailDate: sailDate,
                        recaptchaToken: self.reCaptchaToken)
                    )
                }
                if case .guestConflict(let guestDetails) = result {
                    loginWithTwin(guestDetails: guestDetails, sailDate: sailDate)
                } else if case .success = result {
                    print("BookingReferenceLoginViewModel - Loging in with cabin number (loginShipside): SUCCESS \(true)")
                } else if case .bookingNotFound = result {
                    print("BookingReferenceLoginViewModel - Loging in with cabin number (loginShipside): SUCCESS \(false)")
                }
            }
        } catch (let error) as VVDomainError {
            print("BookingReferenceLoginViewModel - Loging in with cabin number (loginShoreside): FAILED")
            
            await executeOnMain {
                self.resetReCaptcha()
                if case VVDomainError.validationError(let validationError) = error {
                    
                    let errorMessage = validationError.errors.joined(separator: "")
                    self.errorModal(errorMessage: errorMessage)
                }
            }

        } catch {
            print("BookingReferenceLoginViewModel - Loging in with cabin number (loginShoreside): FAILED")
            await executeOnMain {
                self.resetReCaptcha()
                
                let errorMessage = "Something went wrong. Please try again later."
                self.errorModal(errorMessage: errorMessage)
            }
        }
       
    }
    
    // MARK: - Helper Method
    
    private func errorModal(errorMessage: String) {
        let errorModalType: LoginErrorModalType = isShipboard ? .ship : .shore
        showErrorModal(for: errorModalType, errorMessage: errorMessage)
    }
    
    // MARK: Navigation
    func goBack() {
        appCoordinator.executeCommand(LoginSelectionCoordinator.GoBackCommand())
    }
    
    func showErrorModal(for errorModalType: LoginErrorModalType, errorMessage: String) {
        appCoordinator.executeCommand(LoginSelectionCoordinator.ShowFullScreenLoginWithBookingReferenceError(errorModalType: errorModalType))
    }
    
    func loginWithTwin(guestDetails: [LoginGuestDetails], sailDate: Date? = nil, cabinNumber: String? = nil) {
        appCoordinator.executeCommand(LoginSelectionCoordinator.OpenLoginWithTwin(guestDetails: guestDetails, sailDate: sailDate, cabinNumber: cabinNumber))
    }
}
