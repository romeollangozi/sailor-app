//
//  VipBenefitsViewModel.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 4.3.25.
//

import Observation

@Observable class VipBenefitsViewModel: BaseViewModel, VipBenefitsViewModelProtocol {

	private var getVipBenefitsUseCase: GetVipBenefitsUseCaseProtocol
	var vipBenefits: VipBenefitsModel
	var screenState: ScreenState = .loading
	let appCoordinator = AppCoordinator.shared
	
	init(getVipBenefitsUseCase: GetVipBenefitsUseCaseProtocol = GetVipBenefitsUseCase(), vipBenefits: VipBenefitsModel = .empty()) {
		self.getVipBenefitsUseCase = getVipBenefitsUseCase
		self.vipBenefits = vipBenefits
	}

	func onAppear() {
		Task {
			screenState = .loading
			if let result = await executeUseCase({
				try await self.getVipBenefitsUseCase.execute()
			}) {
				self.vipBenefits = result
			}
			screenState = .content
		}
	}

	func contactAction() {
		switch vipBenefits.sailorLocation {
		case .ship:
			let thread = ChatThread.init(id: "", title: "", unreadCount: 0, isClosed: false, type: .sailorServices, description: "", lastMessageTime: nil, imageURL: nil)
			appCoordinator.executeCommand(MessengerCoordinator.OpenChatThreadsFromMeSectionCommand(chatThread: thread))
		case .shore:
			sendMail(to: vipBenefits.supportEmailAddress, subject: "", body: "")
		}
	}
}
