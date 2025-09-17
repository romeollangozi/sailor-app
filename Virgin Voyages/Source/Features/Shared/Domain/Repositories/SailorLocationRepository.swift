//
//  SailorLocationRepository.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 9/18/24.
//

import Foundation

protocol LastKnownSailorConnectionLocationRepositoryProtocol {
	func fetchLastKnownSailorConnectionLocation() -> SailorLocation
    func updateSailorConnectionLocation(_ sailorLocation: SailorLocation) throws
}

extension UserDefaultsKey {
	static let lastKnownSailorConnectionLocationKey = UserDefaultsKey("lastKnownSailorConnectionLocationKey")
}

class LastKnownSailorConnectionLocationRepository: LastKnownSailorConnectionLocationRepositoryProtocol {

	private var jsonSerializer: JSONSerializationProtocol
	private var userDefaultsRepository: KeyValueRepositoryProtocol

	init(jsonSerializer: JSONSerializationProtocol = DefaultJSONSerializer(),
		 userDefaultsRepository: KeyValueRepositoryProtocol = UserDefaultsKeyValueRepository()) {
		self.jsonSerializer = jsonSerializer
		self.userDefaultsRepository = userDefaultsRepository
	}

	func fetchLastKnownSailorConnectionLocation() -> SailorLocation {
		guard let sailorLocation: SailorLocation = userDefaultsRepository.getObject(key: .lastKnownSailorConnectionLocationKey) else {
			return .shore
		}
		return sailorLocation
	}

	func updateSailorConnectionLocation(_ sailorLocation: SailorLocation) throws {
		try? userDefaultsRepository.setObject(key: .lastKnownSailorConnectionLocationKey, value: sailorLocation)
    }
}
