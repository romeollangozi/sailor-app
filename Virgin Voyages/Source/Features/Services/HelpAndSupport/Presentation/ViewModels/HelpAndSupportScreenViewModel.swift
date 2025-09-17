//
//  HelpAndSupportScreenViewModel.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 23.4.25.
//

import Foundation

@Observable class HelpAndSupportScreenViewModel : BaseViewModel, HelpAndSupportScreenViewModelProtocol {
	private let helpAndSupportUseCase : GetHelpAndSupportUseCaseProtocol
	private let getSailorShoreOrShipUseCase : GetSailorShoreOrShipUseCaseProtocol
	
	var screenState: ScreenState = .loading
	var helpAndSupport: HelpAndSupport = .empty()
	var searchableCategories: [HelpAndSupport.Category] = []
	var categoriesForFilter: [HelpAndSupport.Category] = []
	var searchText: String = ""
	var isOnShip: Bool = false
	var selectedCategory: HelpAndSupport.Category? = nil
	
	init(helpAndSupportUseCase: GetHelpAndSupportUseCaseProtocol = GetHelpAndSupportUseCase(),
		 getSailorShoreOrShipUseCase : GetSailorShoreOrShipUseCaseProtocol = GetSailorShoreOrShipUseCase()) {
		self.helpAndSupportUseCase = helpAndSupportUseCase
		self.getSailorShoreOrShipUseCase = getSailorShoreOrShipUseCase
	}
	
	func onAppear() {
		Task {
			await executeOnMain({
				isOnShip = getSailorShoreOrShipUseCase.execute().isOnShip
			})
			
			await loadHelpAndSupport()
		}
	}
	
	func onRefresh() {
		Task {
			await executeOnMain({
				isOnShip = getSailorShoreOrShipUseCase.execute().isOnShip
			})
			
			await loadHelpAndSupport()
		}
	}
	
	func onBackTapped() {
		executeNavigationCommand(ServiceCoordinator.ServiceBackCommand())
	}
	
	func onArticleTapped(article: HelpAndSupport.Article) {
		executeNavigationCommand(ServiceCoordinator.HelpAndSupportArticleCommand(article: article))
	}
	
	private func loadHelpAndSupport() async {
		if let result = await executeUseCase({
			try await self.helpAndSupportUseCase.execute()
		}) {
			await executeOnMain({
				self.helpAndSupport = result
				self.searchableCategories = result.categories.withArticles()
				self.categoriesForFilter = result.categories.withArticles()
				self.screenState = .content
			})
		}
	}
	
	func onSearchTextChanged() {
		filterCategories()
	}
	
	func onCategoryTapped(category: HelpAndSupport.Category) {
		if selectedCategory == category {
			selectedCategory = nil
		} else {
			selectedCategory = category
		}
		
		filterCategories()
	}
	
	private func filterCategories() {
		searchableCategories = helpAndSupport.categories.withArticles(searchString: searchText, categoryId: selectedCategory?.sequenceNumber)
	}
}
