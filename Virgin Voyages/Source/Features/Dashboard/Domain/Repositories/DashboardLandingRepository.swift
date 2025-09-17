//
//  DashboardLandingRepository.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 10/24/24.
//

protocol DashboardLandingRepositoryProtocol {
	func fetchDashboardLanding(reservationNumber: String,
							   guestId: String) async -> DashboardLanding?
}

class DashboardLandingMemoryCachingRepository: DashboardLandingRepositoryProtocol {

	static let shared = DashboardLandingMemoryCachingRepository()

	private init() {}

	private var dashboardLanding: DashboardLanding?

	func fetchDashboardLanding(reservationNumber: String,
							   guestId: String) async -> DashboardLanding? {
        
		guard let dashboardLanding = dashboardLanding else {
			let dashboardLandingResponse = await NetworkService.create().fetchDashboardLanding(
                reservationNumber: reservationNumber,
                guestId: guestId)
            
			dashboardLanding = dashboardLandingResponse?.toModel()

			return dashboardLanding
		}

		return dashboardLanding
	}
}
