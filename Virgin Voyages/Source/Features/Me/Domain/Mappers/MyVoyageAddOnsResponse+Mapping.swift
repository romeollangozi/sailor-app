//
//  MyVoyageAddOnsResponse+Mapping.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 7.3.25.
//

extension MyVoyageAddOnsResponse {
	func toDomain() -> MyVoyageAddOns {
		return MyVoyageAddOns(
			addOns: (self.addOns ?? []).map { addon in
				MyVoyageAddOns.Addon(
					id: addon.id.value,
					imageUrl: addon.imageUrl.value,
					name: addon.name.value,
					description: addon.description.value,
					isViewable: addon.isViewable.value
				)
			},
			emptyStatePictogramUrl: self.emptyStatePictogramUrl.value,
			emptyStateText: self.emptyStateText.value,
			title: self.title.value
		)
	}
}
