//
//  Sailor.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 22.1.25.
//

import Foundation

struct SailorModel: Identifiable, Hashable, Equatable {
	var id: String
	let guestId: String
	let reservationGuestId: String
	let reservationNumber: String
	let name: String
	let profileImageUrl: String?
	let isCabinMate: Bool
	let isLoggedInSailor: Bool
	
	static func == (lhs: SailorModel, rhs: SailorModel) -> Bool {
		return lhs.reservationGuestId == rhs.reservationGuestId
	}
}

extension Array where Element == SailorModel {
	func onlyCabinMates() -> [SailorModel] {
		return self.filter({ x  in x.isCabinMate == true})
	}
}

extension Array where Element == SailorModel {
	func onlyLoggedInSailor() -> [SailorModel] {
		let result = self.loggedInSailor()
		return result != nil ? [result!] : []
	}
}


extension Array where Element == SailorModel {
	func loggedInSailor() -> SailorModel? {
		return self.first(where: { x  in x.isLoggedInSailor == true})
	}
}

extension SailorModel {
	static func empty() -> SailorModel {
		return SailorModel(id: "",
						   guestId: "",
						   reservationGuestId: "",
						   reservationNumber: "",
						   name: "",
						   profileImageUrl: nil,
						   isCabinMate: true,
						   isLoggedInSailor: false
		)
	}
	
	static func sample() -> SailorModel  {
		return SailorModel(id: "659e9fb8-e897-4f59-aa08-99d8913a3b75",
						   guestId: "659e9fb8-e897-4f59-aa08-99d8913a3b75",
						   reservationGuestId: "659e9fb8-e897-4f59-aa08-99d8913a3b75",
						   reservationNumber: "11111",
						   name: "John",
						   profileImageUrl: nil,
						   isCabinMate: true,
						   isLoggedInSailor: false
		)
	}
	
	static func samples() -> [SailorModel]  {
		return [
			SailorModel(id: "659e9fb8-e897-4f59-aa08-99d8913a3b75",
						guestId: "659e9fb8-e897-4f59-aa08-99d8913a3b75",
						reservationGuestId: "659e9fb8-e897-4f59-aa08-99d8913a3b75",
						reservationNumber: "11111",
						name: "JohnHasVeryLongFirsName",
						profileImageUrl: nil,
						isCabinMate: true,
						isLoggedInSailor: false
					   ),
			
			SailorModel(
				id: "179d3cd1-4fd6-4fe8-9946-caf9de5bb698",
				guestId: "179d3cd1-4fd6-4fe8-9946-caf9de5bb698",
				reservationGuestId: "179d3cd1-4fd6-4fe8-9946-caf9de5bb698",
				reservationNumber: "11111",
				name: "Anna",
				profileImageUrl: nil,
				isCabinMate: true,
				isLoggedInSailor: false)
		]
	}
	
	func copy(
		id: String? = nil,
		guestId: String? = nil,
		reservationGuestId: String? = nil,
		reservationNumber: String? = nil,
		name: String? = nil,
		profileImageUrl: String?? = nil,
		isCabinMate: Bool? = nil,
		isLoggedInSailor: Bool? = nil
	) -> SailorModel {
		return SailorModel(
			id: id ?? self.id,
			guestId: guestId ?? self.guestId,
			reservationGuestId: reservationGuestId ?? self.reservationGuestId,
			reservationNumber: reservationNumber ?? self.reservationNumber,
			name: name ?? self.name,
			profileImageUrl: profileImageUrl ?? self.profileImageUrl,
			isCabinMate: isCabinMate ?? self.isCabinMate,
			isLoggedInSailor: isLoggedInSailor ?? self.isLoggedInSailor
		)
	}
}

extension Array where Element == SailorModel {
	/// Filters the array of `SailorModel` based on the provided reservationGuestIds.
	/// - Parameter ids: An array of `String` containing `reservationGuestId` values to filter by.
	/// - Returns: A filtered array of `SimpleSailorModel` containing only the elements whose `reservationGuestId` matches any value in the provided array.
	func filterByReservationGuestIds(_ ids: [String]) -> [SailorModel] {
		return self.filter { ids.contains($0.reservationGuestId) }
	}
	
	func getOnlyReservationGuestIds() -> [String] {
		return self.map({x in x.reservationGuestId})
	}
	
	func exclude(_ sailors: [SailorModel]) -> [SailorModel] {
		return self.filter { sailor in
			!sailors.contains(where: { $0.reservationGuestId == sailor.reservationGuestId })
		}
	}
}


