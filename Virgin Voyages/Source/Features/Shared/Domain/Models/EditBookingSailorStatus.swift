//
//  EditBookingSailorStatus.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 28.4.25.
//

enum EditBookingSailorStatus: String {
	case new = ""
	case confirmed = "CONFIRMED"
	case cancelled = "CANCELLED"
}


final class EditBookingSailorStatusCalculator {
	static func caclulate(previousBookedSailorsIds: [String], newBookedSailorsIds: [String]) -> [String: EditBookingSailorStatus] {
		var statusMap: [String: EditBookingSailorStatus] = [:]
		
		for sailorId in previousBookedSailorsIds {
			if !newBookedSailorsIds.contains(sailorId) {
				statusMap[sailorId] = .cancelled
			}
		}
		
		for sailorId in newBookedSailorsIds {
			if !previousBookedSailorsIds.contains(sailorId) {
				statusMap[sailorId] = .new
			} else {
				statusMap[sailorId] = .confirmed
			}
		}
		
		return statusMap
	}
	
	static func caclulate(previousBookedSailors: [SailorModel], newBookedSailors: [SailorModel]) -> [SailorModel: EditBookingSailorStatus] {
		var statusMap: [SailorModel: EditBookingSailorStatus] = [:]
		
		for sailor in previousBookedSailors {
			if !newBookedSailors.contains(sailor) {
				statusMap[sailor] = .cancelled
			}
		}
		
		for sailor in newBookedSailors {
			if !previousBookedSailors.contains(sailor) {
				statusMap[sailor] = .new
			} else {
				statusMap[sailor] = .confirmed
			}
		}
		
		return statusMap
	}
}
