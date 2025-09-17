//
//  LoginUseCase.swift
//  Virgin Voyages
//
//  Created by TX on 22.7.25.
//

enum LoginResult: Equatable {
    case success
    case guestConflict(guestDetails: [LoginGuestDetails])
    case bookingNotFound
}

protocol LoginUseCaseProtocol {
    @discardableResult func execute(_ type: LoginType) async throws -> LoginResult
}

class LoginUseCase: LoginUseCaseProtocol {

    private var credentialsService: CredentialsServiceProtocol
    private var authenticationService: AuthenticationServiceProtocol
    private let authenticationEventNotificationService: AuthenticationEventNotificationService

    private var shoresideBookingReferenceDetailsRepository: ShoresideBookingReferenceDetailsRepositoryProtocol
    private var shipsideBookingReferenceDetailsRepository: ShipsideBookingReferenceDetailsRepositoryProtocol

    init(credentialsService: CredentialsServiceProtocol = CredentialsService(),
         authenticationService: AuthenticationServiceProtocol = AuthenticationService.shared,
         authenticationEventNotificationService: AuthenticationEventNotificationService = .shared,
         shoresideBookingReferenceDetailsRepository: ShoresideBookingReferenceDetailsRepositoryProtocol = ShoresideBookingReferenceDetailsRepository(),
         shipsideBookingReferenceDetailsRepository: ShipsideBookingReferenceDetailsRepositoryProtocol = ShipsideBookingReferenceDetailsRepository()) {

        self.credentialsService = credentialsService
        self.authenticationService = authenticationService
        self.authenticationEventNotificationService = authenticationEventNotificationService

        self.shoresideBookingReferenceDetailsRepository = shoresideBookingReferenceDetailsRepository
        self.shipsideBookingReferenceDetailsRepository = shipsideBookingReferenceDetailsRepository
    }
    
    func execute(_ type: LoginType) async throws -> LoginResult {
        
        do {
            let result = try await authenticationService.login(type)
            if case .success = result {
                saveCredentials(type)
                
                // Emit event
                self.authenticationEventNotificationService.publish(.userDidLogIn)
            }
            return result
           
        } catch let error as Endpoint.FieldsValidationError {
            deleteCredentials(type)
            let validationError = ValidationError(fieldErrors: [], errors: [error.errors.joined(separator: "")])
            throw VVDomainError.validationError(error: validationError)
        }
    }
}

// MARK: CredentialsServiceProtocol - Save & Delete Crenedtials
extension LoginUseCase {
    private func saveCredentials(_ type: LoginType) {
        
        switch type {
            
        case .email(email: let email, password: let password):
            // Save email & password only if login type is email
            credentialsService.saveCredentials(email: email, password: password)
            
        case .cabin(cabinNumber: let cabinNumber, lastName: let lastName, birthday: let birthDate, _):
            // Save shipside login with cabin number details
            shipsideBookingReferenceDetailsRepository.save(ShipsideBookingReferenceDetails(lastName: lastName,
                                                                                           cabinNumber: cabinNumber,
                                                                                           dateOfBirth: birthDate))
            
        case .reservation(lastName: let lastName, reservationNumber: let reservationNumber, birthDate: let birthDate, sailDate: let sailDate, _, _):
            // Save shoreside login with booking reference (reservation number) details

            shoresideBookingReferenceDetailsRepository.save(ShoresideBookingReferenceDetails(lastName: lastName,
                                                                                             bookingReferenceNumber: reservationNumber,
                                                                                             dateOfBirth: birthDate,
                                                                                             sailDate: sailDate))
            default: break
        }
        
    }

    
    private func deleteCredentials(_ type: LoginType) {
        switch type {
        case .email(email: let email, password: _):
            // Delete credentials only if login type is email
            credentialsService.deleteCredentials(email: email)
        default: break
        }
    }
}
