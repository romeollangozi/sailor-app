//
//  BookableConflictsModel.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 2.5.25.
//

struct BookableConflictsModel: Hashable {
	let slotId: String
	let slotStatus: ConflictState
	let sailors: [Sailor]
	
	init(slotId: String,
		 slotStatus: ConflictState,
		 sailors: [Sailor]) {
		self.slotId = slotId
		self.slotStatus = slotStatus
		self.sailors = sailors
	}
	
	func getHardConflictDetails(sailorIds: [String]) -> HardConflictDetails? {
		let conflictedSailors = sailors.filter { $0.status == .hard && sailorIds.contains($0.reservationGuestId) }

		guard !conflictedSailors.isEmpty else { return nil }

		let title = "Hold Up"
		let names = conflictedSailors.map { $0.name }
		let count = names.count

		var description: String

		switch count {
		case 1:
			let name = names[0]
			description = name == "You"
				? "You already have something booked at this time. You can't double book."
				: "\(name) already has something booked at this time. You can't double book them."
		case 2:
			description = "\(names[0]) and \(names[1]) already have something booked at this time. You can't double book them."
		case 3:
			description = "\(names[0]), \(names[1]) and \(names[2]) already have something booked at this time. You can't double book them."
		default:
			let displayedNames = names.prefix(3)
			let othersCount = count - 3
			let othersLabel = othersCount == 1 ? "other" : "others"
			description = "\(displayedNames[0]), \(displayedNames[1]), \(displayedNames[2]) and \(othersCount) \(othersLabel) already have something booked at this time. You can't double book them."
		}

		let buttonText: String = {
			if count == 1 {
				return names[0] == "You"
					? "You have a clash"
					: "\(names[0]) has a clash"
			} else {
				return "\(count) sailors have clashes"
			}
		}()

		return .init(
			title: title,
			description: description,
			sailorsNames: names,
			sailorsPhotos: conflictedSailors.map { $0.profileImageUrl ?? "" },
			sailorIds: conflictedSailors.map { $0.reservationGuestId },
			buttonText: buttonText
		)
	}

	struct Sailor: Hashable {
		let reservationGuestId: String
		let status: ConflictState
		let name: String
		let bookableType: BookableType
		let appointmentId: String?
		let profileImageUrl: String?
		
		init(reservationGuestId: String,
			 status: ConflictState,
			 name: String,
			 bookableType: BookableType,
			 profileImageUrl: String? = nil,
			 appointmentId: String? = nil) {
			self.reservationGuestId = reservationGuestId
			self.status = status
			self.name = name
			self.profileImageUrl = profileImageUrl
			self.bookableType = bookableType
			self.appointmentId = appointmentId
		}
	}
	
	struct HardConflictDetails: Hashable {
		let title: String
		let description: String
		let sailorsNames: [String]
		let sailorsPhotos: [String]
		let sailorIds: [String]
		let buttonText: String
	}
	
	struct ConflictDetails: Hashable {
		let description: String
	}
	
	static func == (lhs: BookableConflictsModel, rhs: BookableConflictsModel) -> Bool {
		return lhs.slotId == rhs.slotId
	}
}

extension BookableConflictsModel {
	func getSailorsIdsInBookedConflict() -> [String] {
		return sailors
			.filter { $0.status == .booked }
			.map({ $0.reservationGuestId })
	}
}

extension BookableConflictsModel {
	func getSailorsIdsInHardConflict() -> [String] {
		return sailors
			.filter { $0.status == .hard }
			.map({ $0.reservationGuestId })
	}
}

extension BookableConflictsModel {
	func hasAtLeatOneSailorInHardConflict() -> Bool {
		return getSailorsIdsInHardConflict().count > 0
	}
}

extension BookableConflictsModel {
	static func sampleHardConflict() -> BookableConflictsModel {
		return BookableConflictsModel(
			slotId: "1",
			slotStatus: .hard,
			sailors: [ Sailor.sample().copy(status: .hard)]
		)
	}
}

extension BookableConflictsModel {
	func copy(
		slotId: String? = nil,
		slotStatus: ConflictState? = nil,
		sailors: [Sailor]? = nil
	) -> BookableConflictsModel {
		return BookableConflictsModel(
			slotId: slotId ?? self.slotId,
			slotStatus: slotStatus ?? self.slotStatus,
			sailors: sailors ?? self.sailors
		)
	}
}

extension BookableConflictsModel.Sailor {
	func copy(
		reservationGuestId: String? = nil,
		status: ConflictState? = nil,
		bookableType: BookableType? = nil,
		name: String? = nil,
		profileImageUrl: String? = nil,
		appointmentId: String? = nil
	) -> BookableConflictsModel.Sailor {
		return BookableConflictsModel.Sailor(
			reservationGuestId: reservationGuestId ?? self.reservationGuestId,
			status: status ?? self.status,
			name: name ?? self.name,
			bookableType: bookableType ?? self.bookableType,
			profileImageUrl: profileImageUrl ?? self.profileImageUrl,
			appointmentId: appointmentId ?? self.appointmentId
		)
	}
}

extension BookableConflictsModel.Sailor {
	static func sample() -> BookableConflictsModel.Sailor {
		return BookableConflictsModel.Sailor(
			reservationGuestId: "12345",
			status: .hard,
			name: "Sample Sailor",
			bookableType: .entertainment,
			profileImageUrl: "https://example.com/profile.jpg",
			appointmentId: nil
		)
	}
}

