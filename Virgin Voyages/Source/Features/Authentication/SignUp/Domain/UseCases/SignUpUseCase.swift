//
//  SignUpUseCase.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 6.9.24.
//

import Foundation

protocol SignUpUseCaseProtocol {
    func execute(signUpUser: SignUpInputModel) async throws
}

class SignUpUseCase: SignUpUseCaseProtocol {

    // MARK: - Private properties
    private let authenticationEventNotificationService: AuthenticationEventNotificationService
    private var tokenRepository: TokenRepositoryProtocol
	private var authenticationService: AuthenticationServiceProtocol
    private var credentialsService: CredentialsServiceProtocol
    private var uploadPhotoUseCase: UploadPhotoUseCase
    private var updateProfileUseCase: UpdateProfileUseCase

    // MARK: - Init
    init(authenticationEventNotificationService: AuthenticationEventNotificationService = .shared,
         tokenRepository: TokenRepositoryProtocol = TokenRepository(),
         authenticationService: AuthenticationServiceProtocol = AuthenticationService.shared,
         credentialsService: CredentialsServiceProtocol = CredentialsService(),
         uploadPhotoUseCase: UploadPhotoUseCase = UploadPhotoUseCase(),
         updateProfileUseCase: UpdateProfileUseCase = UpdateProfileUseCase()) {
        self.authenticationEventNotificationService = authenticationEventNotificationService
        self.tokenRepository = tokenRepository
        self.authenticationService = authenticationService
        self.credentialsService = credentialsService
        self.uploadPhotoUseCase = uploadPhotoUseCase
        self.updateProfileUseCase = updateProfileUseCase
    }
    
    // MARK: - Execute
    func execute(signUpUser: SignUpInputModel) async throws {
        guard let dateOfBirth = signUpUser.dateOfBirth.toFormattedString() else {
            print("SignUpUseCase error - signup failed")
            throw VVDomainError.validationError(error: .init(fieldErrors: [], errors: ["Signup failed"]))
        }
        
        // Step 1: Signup user
        if let userCredentialsDetails = await authenticationService.signUp(email: signUpUser.email,
                                             firstName: signUpUser.firstName,
                                             lastName: signUpUser.lastName,
                                             password: signUpUser.password,
                                             preferredName: signUpUser.preferredName,
                                             birthDate: dateOfBirth,
                                             userType: "guest",
                                             enableEmailNewsOffer: signUpUser.receiveEmails,
                                             isVerificationRequired: false) {
    
            // Store token
            let userToken = userCredentialsDetails.signUpCredentialsDetails.toDomain()
            tokenRepository.storeToken(userToken)
            
            // Step 2: Upload photo
            let token = userCredentialsDetails.signUpCredentialsDetails.accessToken // Needs to be changed: No need for token to be passed as we do have AuthenticatedHTTPRequestProtocol
            print("Will try to upload photo")
            let uploadPhoto = await uploadPhotoUseCase.execute(model: signUpUser, token: token)
            if let photo = uploadPhoto.photoURL {
                print("Did upload photo")

                print("Will try to update profile with profile picture")
                // Step 3: Update Profile
                let didUpdateProfileWithProfilePicture = await updateProfileUseCase.execute(forProfilePicture: photo)
                print("Did update profile with profile picture: \(didUpdateProfileWithProfilePicture)")
            }

            // Step 4: Reload the reservation data
            authenticationService.currentAccount = userCredentialsDetails.signUpCredentialsDetails.toDomain()

            // Step 5: Reload the reservation data
            try await authenticationService.reloadReservation(reservationNumber: nil, displayLoadingFlow: true)
            
            // Step 6: Register device token // TODO: needs more refactoring
            let deviceTokenRegistration = await RegisterDeviceTokenUseCase().execute()
            print("Did register device token: \(deviceTokenRegistration)")

           
            authenticationEventNotificationService.publish(.userDidRegister)
            
        } else {
            print("SignUpUseCase error - signup failed")
            throw VVDomainError.validationError(error: .init(fieldErrors: [], errors: ["Signup failed"]))
        }
    }
}
