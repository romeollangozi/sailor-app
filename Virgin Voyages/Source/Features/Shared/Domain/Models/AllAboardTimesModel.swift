//
//  AllAboardTimesModel.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 4/3/25.
//

import Foundation

class AllAboardTimesModel {
	var lastUpdated: Date
	var allAboardTimes: [Date]

	init(lastUpdated: Date, allAboardTimes: [Date]) {
		self.lastUpdated = lastUpdated
		self.allAboardTimes = allAboardTimes
	}
}
