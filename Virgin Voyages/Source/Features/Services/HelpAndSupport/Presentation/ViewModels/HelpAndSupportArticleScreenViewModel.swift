//
//  HelpAndSupportArticleScreenViewModel.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 23.4.25.
//

import Foundation

@Observable class HelpAndSupportArticleScreenViewModel : BaseViewModel, HelpAndSupportArticleScreenViewModelProtocol {
	private let getSailorShoreOrShipUseCase : GetSailorShoreOrShipUseCaseProtocol
	
	var screenState: ScreenState = .loading
	var article: HelpAndSupport.Article = .empty()
	var isOnShip: Bool = false
	
	init(article: HelpAndSupport.Article, getSailorShoreOrShipUseCase : GetSailorShoreOrShipUseCaseProtocol = GetSailorShoreOrShipUseCase()) {
		self.article = article
		self.getSailorShoreOrShipUseCase = getSailorShoreOrShipUseCase
	}
	
	func onAppear() {
		isOnShip = getSailorShoreOrShipUseCase.execute().isOnShip
		screenState = .content
	}
	
	func onRefresh() {
		isOnShip = getSailorShoreOrShipUseCase.execute().isOnShip
		screenState = .content
	}
	
	func onBackTapped() {
		executeNavigationCommand(ServiceCoordinator.ServiceBackCommand())
	}
}
