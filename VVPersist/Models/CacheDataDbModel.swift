//
//  CacheDataDbModel.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 7.4.25.
//

import SwiftData
import Foundation

@Model
public class CacheDataDbModel {
	@Attribute(.unique) public var key: String
	public var data: Data
	public var expiresAt: Date
	
	public init(
		key: String,
		data: Data,
		expiresAt: Date
	) {
		self.key = key
		self.data = data
		self.expiresAt = expiresAt
	}
}
