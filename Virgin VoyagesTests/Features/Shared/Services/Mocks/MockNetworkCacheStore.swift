//
//  MockNetworkCacheStore.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 7.4.25.
//

import Foundation

@testable import Virgin_Voyages


final class MockNetworkCacheStore: NetworkCacheStoreProtocol {
	func getData(for key: String) -> Data? {
		return nil
	}
	
	func writeData(for key: String, data: Data, cacheExpiration: TimeInterval) -> Bool {
		return false
	}
	
	func removeAllData() {
		
	}
}
