//
//  CacheOption.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 7.4.25.
//

import Foundation

struct CacheOption {
	let useCache: Bool
	let cacheExpiry: TimeInterval
	let alwaysRefreshCache: Bool
	let forceReload: Bool
	
	private init(useCache: Bool = false, cacheExpiry: TimeInterval = 900, alwaysRefreshCache: Bool = true, forceReload: Bool = false) {
		self.useCache = useCache
		self.cacheExpiry = cacheExpiry
		self.alwaysRefreshCache = alwaysRefreshCache
		self.forceReload = forceReload
	}
	
	static func noCache() -> CacheOption {
		self.init(useCache: false)
	}
	
	static func timedCache(cacheExpiry: TimeInterval = TimeIntervalDurations.oneMonth, alwaysRefreshCache: Bool = true, forceReload: Bool = false) -> CacheOption {
		self.init(useCache: true, cacheExpiry: cacheExpiry, alwaysRefreshCache: alwaysRefreshCache, forceReload: forceReload)
	}
}
