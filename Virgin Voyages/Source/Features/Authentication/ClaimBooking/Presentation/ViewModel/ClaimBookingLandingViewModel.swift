//
//  ClaimBookingLandingViewModel.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 9/4/24.
//

import UIKit

@Observable class ClaimBookingLandingViewModel: BaseViewModel, ClaimBookingLandingViewModelProtocol {
    
    private let profileRepository: SailorProfileRepositoryProtocol
	private let logoutUserUseCase: LogoutUserUseCaseProtocol

    init(
		profileRepository: SailorProfileRepositoryProtocol = SailorProfileRepository(),
		logoutUserUseCase: LogoutUserUseCaseProtocol = LogoutUserUseCase()
	) {
        self.profileRepository = profileRepository
		self.logoutUserUseCase = logoutUserUseCase
    }

	var sailorFullName: String? {
        guard let userProfile = profileRepository.profile() else {
			return nil
		}

		let firstName = userProfile.firstName
		let lastName = userProfile.lastName

		return "\(firstName) \(lastName)"
	}

	var sailorPhotoURL: URL? {
		guard let photoURLString = profileRepository.profile()?.photoURL, !photoURLString.isEmpty else {
			return nil
		}
		return URL(string: photoURLString)
	}

	func tappedLogout() {
		Task {
			await logoutUserUseCase.execute()
		}
	}

    func tappedBookVoyage() {
		let bookVoyageURL = "https://virginvoyages.com/book/voyage-planner/find-a-voyage?utm_source=sailor_%5B%E2%80%A6%5Dss_platform%257Cios-web&utm_content=login%257Chome_screen"
        if let url = URL(string: bookVoyageURL) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    // MARK: Navigation
    func claimABookingTapped(){
        navigationCoordinator.executeCommand(ClaimABookingCoordinator.OpenBookingDetailsCommand())
    }
}
