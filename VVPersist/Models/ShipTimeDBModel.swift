//
//  ShipTimeDBModel.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 4/1/25.
//

import SwiftData
import Foundation

@Model
public class ShipTimeDBModel {
	public var cachedAt: Date
	public var fromUTCDate: String
	public var fromDateOffset: Int

	public init(
		cachedAt: Date,
		fromUTCDate: String,
		fromDateOffset: Int
	) {
		self.cachedAt = cachedAt
		self.fromUTCDate = fromUTCDate
		self.fromDateOffset = fromDateOffset
	}
}
