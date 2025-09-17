//
//  PortDestination.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 4/12/24.
//

import Foundation

typealias PortDestination = Endpoint.GetPorts.Response.DestinationCard

extension PortDestination: Identifiable {
	var id: Date {
		date
	}
	
	var arrivalDate: Date? {
		arrivalTime?.iso8601
	}
	
	var departureDate: Date? {
		departureTime?.iso8601
	}
	
	var date: Date {
		guard let portDate = arrivalDate ?? departureDate else {
			// "April 17th"
			let dateFormatter = DateFormatter()
			dateFormatter.locale = Locale(identifier: "en_US_POSIX") // Use a fixed locale
			dateFormatter.dateFormat = "MMMM' 'd'th"
			guard let arrival = dateFormatter.date(from: arrivalDateTime) else {
				return .now
			}
			
			var components = Calendar.current.dateComponents([.month, .day], from: arrival)
			components.year = Calendar.current.component(.year, from: .now)
			guard let arrival = Calendar.current.date(from: components) else {
				return .now
			}

			return arrival
		}
		
		return portDate
	}
	
	var timeText: String? {
		if let departure = departureDate, let arrival = arrivalDate {
			return "\(arrival.format(.time)) - \(departure.format(.time))"
		}
			
		if let departure = departureDate {
			return "Departing at \(departure.format(.time))"
		}
		
		if let arrival = arrivalDate {
			return "Arriving at \(arrival.format(.time))"
		}
		
		return nil
	}
}
