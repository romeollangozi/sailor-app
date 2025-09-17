//
//  MyAgendaDBModel.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 4/9/25.
//

import SwiftData
import Foundation

@Model
public class MyAgendaDBModel {
	public var lastUpdated: Date
	public var bookings: [MyAgendaBookingDBModel] = []

	public init(lastUpdated: Date = Date(), bookings: [MyAgendaBookingDBModel] = []) {
		self.lastUpdated = lastUpdated
		self.bookings = bookings
	}
}
