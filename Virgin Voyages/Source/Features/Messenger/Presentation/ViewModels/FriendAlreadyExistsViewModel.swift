//
//  FriendAlreadyExistsViewModel.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 12.9.25.
//

import Observation

@MainActor
@Observable class FriendAlreadyExistsViewModel: BaseViewModelV2, FriendAlreadyExistsViewModelProtocol {

	private let getMySailorsUseCase: GetMySailorsUseCaseProtocol
	private	let localizationManager: LocalizationManagerProtocol
	var contact: AddContactData
	var profileImageUrl: String

	var labels: FriendAlreadyExistsSheet.Labels {
		.init(title: localizationManager.getString(for: .contactsScanQRCodeFriendAlreadyAdded), buttonText: localizationManager.getString(for: .gotIt))
	}

	
	init(contact: AddContactData, getMySailorsUseCase: GetMySailorsUseCaseProtocol = GetMySailorsUseCase(), profileImageUrl: String = "", localizationManager: LocalizationManagerProtocol = LocalizationManager.shared) {
		self.contact = contact
		self.profileImageUrl = profileImageUrl
		self.getMySailorsUseCase = getMySailorsUseCase
		self.localizationManager = localizationManager
	}

	func onAppear() async {
		await loadAvailableSailors()
	}

	private func loadAvailableSailors(useCache: Bool = true) async {
		if let result = await executeUseCase({
			try await self.getMySailorsUseCase.execute(useCache: useCache)
		}) {
			self.profileImageUrl = result.filter({$0.reservationGuestId == contact.reservationGuestId}).first?.profileImageUrl ?? ""
		}
	}
}
