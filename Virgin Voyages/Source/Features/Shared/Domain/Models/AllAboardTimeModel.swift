//
//  AllAboardTimeModel.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 4/3/25.
//


import Foundation

class AllAboardTimeModel {
	var lastUpdated: Date
	var allAboardTime: Date

	init(lastUpdated: Date, allAboardTime: Date) {
		self.lastUpdated = lastUpdated
		self.allAboardTime = allAboardTime
	}
}
