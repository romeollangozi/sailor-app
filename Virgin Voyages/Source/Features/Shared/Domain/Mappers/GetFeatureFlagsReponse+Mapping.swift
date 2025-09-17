//
//  GetFeatureFlagsReponse+Mapping.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 14.8.25.
//

import Foundation

extension GetFeatureFlagsResponse {
	func toDomain() -> FeatureFlags {
		return FeatureFlags(featureFlags: self.featureFlags.map { $0.toDomain() })
	}
}

extension FeatureFlagResponse {
	func toDomain() -> FeatureFlag {
		return FeatureFlag(
			feature: self.feature ?? "",
			description: self.description ?? "",
			platforms: FeatureFlag.Platforms(
				android: FeatureFlag.Platforms.PlatformDetails(
					enabled: self.platforms?.android?.enabled ?? false
				),
				ios: FeatureFlag.Platforms.PlatformDetails(
					enabled: self.platforms?.ios?.enabled ?? false
				)
			),
			restrictions: FeatureFlag.Restrictions(
				ships: self.restrictions?.ships ?? [],
				userIds: self.restrictions?.userIds ?? []
			)
		)
	}
}
