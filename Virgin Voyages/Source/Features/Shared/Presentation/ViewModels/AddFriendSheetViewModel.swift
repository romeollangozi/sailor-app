//
//  AddFriendSheetViewModel.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 27.1.25.
//


import Foundation

protocol AddFriendSheetViewModelProtocol {
    func share() async
    var showSettingsAlert: Bool { get set }
    func checkPermission() async -> Bool
}

@Observable class AddFriendSheetViewModel: BaseViewModel, AddFriendSheetViewModelProtocol {
    
    private var addFriendUseCase: AddFriendSheetUseCaseProtocol
    private var socialShareUseCase: SocialShareUseCaseProtocol
    var showSettingsAlert: Bool = false

    init(
		addFriendUseCase: AddFriendSheetUseCaseProtocol = AddFriendSheetUseCase(),
		socialShareUseCase: SocialShareUseCaseProtocol = SocialShareUseCase()
	) {
        self.addFriendUseCase = addFriendUseCase
        self.socialShareUseCase = socialShareUseCase
    }
    
    func execute() async -> AddFriendSheetUseCaseModel? {
		let result = await executeUseCase {
			return try await self.addFriendUseCase.execute()
		}

		return result
    }
    
    func share() async {
        guard let model = await execute() else { return }
        socialShareUseCase.shareCustomData([model.shareText, model.qrCodeLink])
    }

    @MainActor
    func checkPermission() async -> Bool {
        let granted = await checkCameraPermission()
        if !granted {
            showSettingsAlert = true
        }
        return granted
    }
}
