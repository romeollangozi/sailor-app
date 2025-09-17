//
//  DiscoverLandingViewModel.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 10.1.25.
//
import SwiftUI

@Observable class DiscoverLandingViewModel: BaseViewModel, DiscoverLandingViewModelProtocol {
	private let discoverLandingUseCase: GetDiscoverLandingUseCaseProtocol
	private var discoverItems:[DiscoverLandingItem] = []
	
	var screenState: ScreenState = .loading

	init(discoverLandingUseCase: GetDiscoverLandingUseCaseProtocol = GetDiscoverLandingUseCase()) {
		self.discoverLandingUseCase = discoverLandingUseCase
	}
	
	var eventLineUpCard: DiscoverCardViewModel? {
		if let item = discoverItems.first(where: { $0.type == .lineUps }) {
			return DiscoverCardViewModel(title: item.name,
										 imageURL: URL(string: item.imageUrl ?? ""))
		}
		return nil
	}

	var shoreThingsCard: DiscoverCardViewModel? {
		if let item = discoverItems.first(where: { $0.type == .shoreExcursions }) {
			return DiscoverCardViewModel(title: item.name,
										 imageURL: URL(string: item.imageUrl ?? ""))
		}
		return nil
	}

	var shipSpacesCard: DiscoverCardViewModel? {
		if let item = discoverItems.first(where: { $0.type == .shipSpace }) {
			return DiscoverCardViewModel(title: item.name,
										 imageURL: URL(string: item.imageUrl ?? ""))
		}
		return nil
	}

	var addOnsCard: DiscoverCardViewModel? {
		if let item = discoverItems.first(where: { $0.type == .addOns }) {
			return DiscoverCardViewModel(title: item.name,
										 imageURL: URL(string: item.imageUrl ?? ""))
		}
		return nil
	}
	
	func onFirstAppear() {
		Task {
			await loadDiscoverLandingItems(useCache: true)
		}
	}
	
	func onReAppear() {
		Task {
			await loadDiscoverLandingItems(useCache: true)
		}
	}
	
	func onRefresh() {
		Task {
			await loadDiscoverLandingItems(useCache: true)
		}
	}
	
	private func loadDiscoverLandingItems(useCache: Bool = true) async {
		if let result = await executeUseCase({
			try await self.discoverLandingUseCase.execute(useCache: useCache)
		}) {
			await executeOnMain({
				self.discoverItems = result
				self.screenState = .content
			})
		} else {
			await executeOnMain({
				self.screenState = .error
			})
		}
	}
}
