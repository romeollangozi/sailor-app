//
//  AllAboardTimesRepository.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 4/2/25.
//

import VVPersist
import Foundation

protocol AllAboardTimesRepositoryProtocol {
	func updateAllAboardTimes(_ allAboardTimes: [Date]) async
	func fetchAllAboardTimes() async -> AllAboardTimesModel?
}

class AllAboardTimesRepository: AllAboardTimesRepositoryProtocol {

	func updateAllAboardTimes(_ allAboardTimes: [Date]) async {
		let session = VVDatabase.shared.createSession()
		let allAboardTimesDBModel: [AllAboardTimesDBModel] = session.fetchAll()
		if let existingAllAboardTimes = allAboardTimesDBModel.first {
			existingAllAboardTimes.lastUpdated = Date()
			existingAllAboardTimes.allAboardTimes = allAboardTimes.compactMap({ AllAboardTimeDBModel(date: $0) })
		} else {
			let allAboardTimesDBModel = AllAboardTimesDBModel(
				lastUpdated: Date(),
				allAboardTimes: allAboardTimes.compactMap({ AllAboardTimeDBModel(date: $0) })
			)
			session.insert(allAboardTimesDBModel)
		}

		do {
			try session.save()
		} catch {
			print("Failed to save all aboard times: \(error)")
		}
	}

	func fetchAllAboardTimes() async -> AllAboardTimesModel? {
		let session = VVDatabase.shared.createSession()
		let allAboardTimes: [AllAboardTimesDBModel] = session.fetchAll()
		if let existingAllAboardTimes = allAboardTimes.first {
			return AllAboardTimesModel(
				lastUpdated: existingAllAboardTimes.lastUpdated,
				allAboardTimes: existingAllAboardTimes.allAboardTimes.compactMap({ $0.date })
			)
		} else {
			return nil
		}
	}
}
