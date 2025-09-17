//
//  GetDiscoverLandingItemResponse+Mapping.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 21.5.25.
//

extension GetDiscoverLandingItemResponse {
	func toDomain() -> DiscoverLandingItem {
		.init(type: DiscoverType.from(string: self.type),
			  name: self.name.value,
			  imageUrl: self.imageUrl,
			  isLandscape: self.isLandscape.value)
	}
}
