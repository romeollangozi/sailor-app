//
//  GetAssetsResrourcesResponse+Mapping.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 3.5.25.
//

extension GetAssetsResrourcesResponse {
	func toDomain() -> [String: AssetResource] {
		return assets.reduce(into: [String: AssetResource]()) { result, asset in
			let (key, value) = asset
			if let width = Int(value.width), let height = Int(value.height) {
				result[key] = AssetResource(
					link: value.link,
					format: value.format,
					width: width,
					type: value.type,
					height: height
				)
			}
		}
	}
}
