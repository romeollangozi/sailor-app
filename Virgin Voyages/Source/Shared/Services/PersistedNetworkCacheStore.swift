//
//  PersistedNetworkCacheStore.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 7.4.25.
//

import VVPersist

final class PersistedNetworkCacheStore : NetworkCacheStoreProtocol {
	static let shared = PersistedNetworkCacheStore()
	
	func getData(for key: String) -> Data? {
		let session = VVDatabase.shared.createSession()
		let results: [CacheDataDbModel] = session.fetchAll()

		if let cachedDataModel = results.first(where: { $0.key == key }) {
			let currentTime = Date()
			if currentTime < cachedDataModel.expiresAt {
				return cachedDataModel.data
			}
		}
		return nil
	}
	
	func writeData(for key: String, data: Data, cacheExpiration: TimeInterval = 900) -> Bool {
		do {
			let session = VVDatabase.shared.createSession()

			let cacheData = CacheDataDbModel(key: key, data: data, expiresAt: Date().addingTimeInterval(cacheExpiration))
			
			session.insert(cacheData)

			try session.save()

			return true
			
		} catch {
			return false
		}
	}
	
	func removeAllData() {
		let session = VVDatabase.shared.createSession()
		let results: [CacheDataDbModel] = session.fetchAll()

		for result in results {
			session.delete(result)
		}
	}
}
