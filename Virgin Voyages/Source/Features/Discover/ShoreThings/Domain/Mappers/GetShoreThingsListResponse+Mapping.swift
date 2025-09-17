//
//  GetShoreThingsListResponse+Mapping.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 14.5.25.
//

import Foundation

extension GetShoreThingsListResponse {
	func toDomain() -> ShoreThingsList {
		.init(types: self.types?.map({$0.toDomain()}) ?? [],
			  items: self.items?.map({$0.toDomain()}) ?? [],
			  title: self.title.value,
			  description: self.description.value)
	}
}

extension ShoreThingsListTypeResponse {
	func toDomain() -> ShoreThingsListType {
		.init(code: self.code.value, name: self.name.value)
	}
}
