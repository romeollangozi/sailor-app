//
//  SignUpWithSocialUseCase.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 18.9.24.
//

import Foundation

protocol SignUpWithSocialUseCaseProtocol {
    func execute(signUpUser: SignUpInputModel) async throws
}

class SignUpWithSocialUseCase: SignUpWithSocialUseCaseProtocol {

    // MARK: - Private properties
    private let authenticationEventNotificationService: AuthenticationEventNotificationService
    private var tokenRepository: TokenRepositoryProtocol
    private var authenticationService: AuthenticationServiceProtocol
    private var uploadPhotoUseCase: UploadPhotoUseCase
    private var updateProfileUseCase: UpdateProfileUseCase
    private var networkService: NetworkServiceProtocol

    // MARK: - Init
    init(authenticationEventNotificationService: AuthenticationEventNotificationService = .shared,
         tokenRepository: TokenRepositoryProtocol = TokenRepository(),
         authenticationService: AuthenticationServiceProtocol = AuthenticationService.shared,
         uploadPhotoUseCase: UploadPhotoUseCase = UploadPhotoUseCase(),
         updateProfileUseCase: UpdateProfileUseCase = UpdateProfileUseCase(),
         networkService: NetworkServiceProtocol = NetworkService.create()) {
        self.authenticationEventNotificationService = authenticationEventNotificationService
        self.tokenRepository = tokenRepository
        self.authenticationService = authenticationService
        self.uploadPhotoUseCase = uploadPhotoUseCase
        self.updateProfileUseCase = updateProfileUseCase
        self.networkService = networkService
    }
    
    // MARK: - Execute
    func execute(signUpUser: SignUpInputModel) async throws {
        
        // Validate social input fields
        guard let dateOfBirth = signUpUser.dateOfBirth.toFormattedString() else {
            print("SignUpWithSocialUseCase error - dateOfBirth")
            throw VVDomainError.validationError(error: .init(fieldErrors: [], errors: ["Missing social signup data"]))
        }
        guard let socialMediaType = signUpUser.socialMediaType?.rawValue else {
            print("SignUpWithSocialUseCase error - socialMediaType")
            throw VVDomainError.validationError(error: .init(fieldErrors: [], errors: ["Missing social signup data"]))
        }
        guard let socialMediaId = signUpUser.socialMediaId else {
            print("SignUpWithSocialUseCase error - socialMediaId")
            throw VVDomainError.validationError(error: .init(fieldErrors: [], errors: ["Missing social signup data"]))
        }
        
        
        // Step 1: Signup user with social
        guard let tokenDTO = await networkService.signUpWithSocial(
            type: socialMediaType,
            socialMediaId: socialMediaId,
            email: signUpUser.email,
            firstName: signUpUser.firstName,
            lastName: signUpUser.lastName,
            password: signUpUser.password,
            preferredName: signUpUser.preferredName,
            birthDate: dateOfBirth,
            userType: "guest",
            enableEmailNewsOffer: signUpUser.receiveEmails,
            isVerificationRequired: false
        ) else {
            // Currently no error is returned nor thrown, it comes as nil if anything fails.
            print("SignUpWithSocialUseCase error - signup failed")
            throw VVDomainError.validationError(error: .init(fieldErrors: [], errors: ["Signup failed"]))
        }
        
        // Step 2: Set currentAccount
        tokenRepository.storeToken(tokenDTO.toDomain())

        // Step 3: Set currentAccount
        authenticationService.currentAccount = tokenDTO.toDomain()
        
        // Step 5: Upload photo if needed
        let token = tokenDTO.accessToken
        if let imageData = signUpUser.imageData {
            let uploadPhoto = await uploadPhotoUseCase.execute(model: signUpUser, token: token)
            if let photo = uploadPhoto.photoURL {
                // Step 4: Update Profile
                _ = await updateProfileUseCase.execute(forProfilePicture: photo)
            }
        }
        
        // Step 6: Register device token (if needed)
        let _ = await RegisterDeviceTokenUseCase().execute()

        authenticationEventNotificationService.publish(.userDidRegister)
    }
}
