//
//  AllAboardTimesDBModel.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 4/2/25.
//

import SwiftData
import Foundation

@Model
public class AllAboardTimesDBModel {
	public var lastUpdated: Date
	public var allAboardTimes: [AllAboardTimeDBModel] = []

	public init(lastUpdated: Date = Date(), allAboardTimes: [AllAboardTimeDBModel] = []) {
		self.lastUpdated = lastUpdated
		self.allAboardTimes = allAboardTimes
	}
}
