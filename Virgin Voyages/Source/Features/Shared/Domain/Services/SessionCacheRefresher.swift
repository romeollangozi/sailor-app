//
//  SessionCacheRefresher.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 21.5.25.
//

protocol SessionCacheRefresherProtocol {
	func refresh() async
}


final class SessionCacheRefresher: SessionCacheRefresherProtocol {
	private let authenticationService: AuthenticationServiceProtocol
	private let mySailorsUseCase: GetMySailorsUseCaseProtocol
	private let eateriesListUseCase : GetEateriesListUseCaseProtocol
	private let getMyVoyageAgendaUseCase: GetMyVoyageAgendaUseCaseProtocol
	private let discoverLandingUseCase: GetDiscoverLandingUseCaseProtocol
	private let getLineUpUseCase: GetLineUpUseCaseProtocol
	private let getShoreThingPortsUseCase: GetShoreThingPortsUseCaseProtocol
	private let getShipSpacesUseCase: GetShipSpacesCategoriesUseCaseProtocol
	private let getMyVoyageHeaderUseCase: GetMyVoyageHeaderUseCaseProtocol
	private let getResourcesUseCase: GetResourcesUseCaseProtocol
	private let componentSettingsUseCase: ComponentSettingsUseCaseProtocol
	
	init(
		authenticationService: AuthenticationServiceProtocol = AuthenticationService.shared,
		mySailorsUseCase: GetMySailorsUseCaseProtocol = GetMySailorsUseCase(),
		eateriesListUseCase: GetEateriesListUseCaseProtocol = GetEateriesListUseCase(),
		getMyVoyageAgendaUseCase: GetMyVoyageAgendaUseCaseProtocol = GetMyVoyageAgendaUseCase(),
		discoverLandingUseCase: GetDiscoverLandingUseCaseProtocol = GetDiscoverLandingUseCase(),
		getLineUpUseCase: GetLineUpUseCaseProtocol = GetLineUpUseCase(),
		getShoreThingPortsUseCase: GetShoreThingPortsUseCaseProtocol = GetShoreThingPortsUseCase(),
		getShipSpacesUseCase: GetShipSpacesCategoriesUseCaseProtocol = GetShipSpacesCategoriesUseCase(),
		getMyVoyageHeaderUseCase:GetMyVoyageHeaderUseCaseProtocol = GetMyVoyageHeaderUseCase(),
		getResourcesUseCase: GetResourcesUseCaseProtocol = GetResourcesUseCase(),
		componentSettingsUseCase: ComponentSettingsUseCaseProtocol = ComponentSettingsUseCase()
	) {
		self.authenticationService = authenticationService
		self.mySailorsUseCase = mySailorsUseCase
		self.eateriesListUseCase = eateriesListUseCase
		self.getMyVoyageAgendaUseCase = getMyVoyageAgendaUseCase
		self.discoverLandingUseCase = discoverLandingUseCase
		self.getLineUpUseCase = getLineUpUseCase
		self.getShoreThingPortsUseCase = getShoreThingPortsUseCase
		self.getShipSpacesUseCase = getShipSpacesUseCase
		self.getMyVoyageHeaderUseCase = getMyVoyageHeaderUseCase
		self.getResourcesUseCase = getResourcesUseCase
		self.componentSettingsUseCase = componentSettingsUseCase
	}
	
	func refresh() async {
		guard authenticationService.isLoggedIn() else { return }

		Task {
			try? await mySailorsUseCase.execute(useCache: false)
		}
		
		Task {
			try? await eateriesListUseCase.execute(includePortsName: true, useCache: false)
		}
		
		Task {
			try? await getMyVoyageAgendaUseCase.execute(useCache: false)
		}
		
		Task {
			try? await discoverLandingUseCase.execute(useCache: false)
		}
		
		Task {
			try? await getLineUpUseCase.execute(useCache: false)
		}
		
		Task {
			try? await getShoreThingPortsUseCase.execute(useCache: false)
		}
		
		Task {
			try? await getShipSpacesUseCase.execute(useCache: false)
		}
		
		Task {
			try? await getMyVoyageHeaderUseCase.execute(useCache: false)
		}
		
		Task {
			_ = try? await getResourcesUseCase.getStringResources(useCache: false)
			_ = try? await getResourcesUseCase.getAssetResources(useCache: false)
		}
		
		Task {
			try? await componentSettingsUseCase.execute(useCache: false)
		}
	}
}
