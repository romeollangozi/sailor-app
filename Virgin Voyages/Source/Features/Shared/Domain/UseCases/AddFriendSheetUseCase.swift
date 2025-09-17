//
//  AddFriendSheetUseCase.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 27.1.25.
//

import Foundation

protocol AddFriendSheetUseCaseProtocol {
    func execute() async throws -> AddFriendSheetUseCaseModel
}

class AddFriendSheetUseCase: AddFriendSheetUseCaseProtocol {
    
    // MARK: - Properties
    private let currentSailorManager: CurrentSailorManagerProtocol
    private let userProfilesRepository: UserProfileRepositoryProtocol
    
    // MARK: - Init
    init(currentSailorManager: CurrentSailorManagerProtocol = CurrentSailorManager(),
         userProfilesRepository: UserProfileRepositoryProtocol = UserProfileRepository()) {
        self.currentSailorManager = currentSailorManager
        self.userProfilesRepository = userProfilesRepository
    }
    
    // MARK: - Execute
    func execute() async throws -> AddFriendSheetUseCaseModel {
		guard let currentSailor = currentSailorManager.getCurrentSailor() else {
			throw VVDomainError.unauthorized
		}

        guard let userProfile = try await userProfilesRepository.getUserProfile() else { throw VVDomainError.genericError }
        
        let deepLink = DeepLinkGenerator.generate(reservationGuestId: currentSailor.reservationGuestId, reservationId: currentSailor.reservationId, voyageNumber: currentSailor.voyageNumber, name: userProfile.firstName)
        let shareText = "\(userProfile.firstName) wants to add you as a friend on your voyage. Accept the request to start arranging activities together and messaging with on the ship with Ship chat"
        return AddFriendSheetUseCaseModel(qrCodeLink: deepLink, shareText: shareText)
    }
    
}

struct AddFriendSheetUseCaseModel {
    let qrCodeLink: String
    let shareText: String
    
    init(qrCodeLink: String, shareText: String) {
        self.qrCodeLink = qrCodeLink
        self.shareText = shareText
    }
}

