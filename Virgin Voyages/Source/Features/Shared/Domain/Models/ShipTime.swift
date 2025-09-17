//
//  ShipTime.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 4/2/25.
//


class ShipTime {
	let fromUTCDate: String
	let fromDateOffset: Int

	init(fromUTCDate: String, fromDateOffset: Int) {
		self.fromUTCDate = fromUTCDate
		self.fromDateOffset = fromDateOffset
	}
}