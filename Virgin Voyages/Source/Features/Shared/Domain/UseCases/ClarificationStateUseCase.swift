//
//  ClarificationStateUseCase.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 21.3.25.
//

import Foundation

protocol ClarificationStateUseCaseProtocol {
	func execute() -> ClarificationStateModel
}

typealias ConflictSailorInfo = (name: String, photoURL: String)

class ClarificationStateUseCase: ClarificationStateUseCaseProtocol {

	private let conficts: [BookableConflicts]
	private let sailors: [ActivitiesGuest]
	private let currentSailorManager: CurrentSailorManagerProtocol

	init(conficts: [BookableConflicts],
		 sailors: [ActivitiesGuest],
		 currentSailorManager: CurrentSailorManagerProtocol = CurrentSailorManager()) {
		self.conficts = conficts
		self.sailors = sailors
		self.currentSailorManager = currentSailorManager
	}

	private var currentSailorHasHardClash: Bool {
		guard let currentSailor = currentSailorManager.getCurrentSailor() else {
			return false
		}

		let currentReservationGuestId = currentSailor.reservationGuestId

		guard sailors.contains(where: { $0.reservationGuestId == currentReservationGuestId }) else {
			return false
		}

		return conficts.contains { conflict in
			conflict.sailors.contains {
				$0.reservationGuestId == currentReservationGuestId && $0.status == .hard
			}
		}
	}

	private func hardConflictSailorNames(currentSailorOnly: Bool) -> [String] {
		guard let currentSailor = currentSailorManager.getCurrentSailor() else {
			return []
		}

		let currentGuestId = currentSailor.reservationGuestId

		if currentSailorOnly {
			if let match = sailors.first(where: { $0.reservationGuestId == currentGuestId }) {
				return [match.guestName]
			} else {
				return []
			}
		}

		let conflictingIds: Set<String> = Set(
			conficts.flatMap { conflict in
				conflict.sailors.compactMap { sailor in
					guard sailor.status == .hard else { return nil }
					return sailor.reservationGuestId != currentGuestId ? sailor.reservationGuestId : nil
				}
			}
		)

		return sailors
			.filter { conflictingIds.contains($0.reservationGuestId) }
			.map { $0.guestName }
	}

	private func hardConflictSailorPhotoURLs(currentSailorOnly: Bool) -> [String] {
		guard let currentSailor = currentSailorManager.getCurrentSailor() else {
			return []
		}

		let currentGuestId = currentSailor.reservationGuestId

		if currentSailorOnly {
			if let match = sailors.first(where: { $0.reservationGuestId == currentGuestId }) {
				return [match.profileImageUrl]
			} else {
				return []
			}
		}

		let conflictingIds: Set<String> = Set(
			conficts.flatMap { conflict in
				conflict.sailors.compactMap { sailor in
					guard sailor.status == .hard else { return nil }
					return sailor.reservationGuestId != currentGuestId ? sailor.reservationGuestId : nil
				}
			}
		)

		return sailors
			.filter { conflictingIds.contains($0.reservationGuestId) }
			.map { $0.profileImageUrl }
	}

	func execute() -> ClarificationStateModel {
		let name = hardConflictSailorNames(currentSailorOnly: true).first.value
		if currentSailorHasHardClash {
			return ClarificationStateModel(
				clarificationTitle: "Hold Up",
				clarificationText: "\(name) already have something booked at this time. You can’t double book.",
				sailorPhotos: hardConflictSailorPhotoURLs(currentSailorOnly: true),
				sailorNames: [name],
				isCurrentSailorConfict: true,
				viewExistingBookingText: "View existing booking",
				bookingType: ""
			)
		}else {
			let names = hardConflictSailorNames(currentSailorOnly: false)
			return ClarificationStateModel(
				clarificationTitle: "Hold Up",
				clarificationText: "\(names.joined(separator: ",")) already have something booked at this time. You can’t double book them.",
				sailorPhotos: hardConflictSailorPhotoURLs(currentSailorOnly: false),
				sailorNames: names,
				isCurrentSailorConfict: false,
				viewExistingBookingText: "View existing booking",
				bookingType: "")
		}
	}
}
