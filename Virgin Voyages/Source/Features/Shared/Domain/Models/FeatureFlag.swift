//
//  FeatureFlag.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 14.8.25.
//

struct FeatureFlag {
	let feature: String
	let description: String
	let platforms: Platforms
	let restrictions: Restrictions

	struct Platforms {
		let android: PlatformDetails
		let ios: PlatformDetails

		struct PlatformDetails {
			let enabled: Bool
		}
	}

	struct Restrictions {
		let ships: [String]
		let userIds: [String]
	}
}

struct FeatureFlags {
	let featureFlags: [FeatureFlag]
}

extension FeatureFlags {
	func isFeatureEnabled(for feature: String, reservationGuestId: String, shipCode: String) -> Bool {
		guard let featureFlag = featureFlags.first(where: { $0.feature == feature }) else {
			return false
		}
		
		let isShipAllowed = featureFlag.restrictions.ships.isEmpty || featureFlag.restrictions.ships.contains(shipCode)
		let isUserAllowed = featureFlag.restrictions.userIds.isEmpty || featureFlag.restrictions.userIds.contains(reservationGuestId)
		
		return featureFlag.platforms.ios.enabled && isShipAllowed && isUserAllowed
	}
}
