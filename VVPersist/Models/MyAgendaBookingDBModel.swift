//
//  MyAgendaBookingDBModel.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 4/9/25.
//

import SwiftData
import Foundation

@Model
public class MyAgendaBookingDBModel {
	public var sortIndex: Int?
	public var name: String
	public var location: String
	public var timePeriod: String
	public var date: Date?

	public init(sortIndex: Int? = 0, name: String, location: String, timePeriod: String, date: Date? = nil) {
		self.sortIndex = sortIndex
		self.name = name
		self.location = location
		self.timePeriod = timePeriod
		self.date = date
	}
}
