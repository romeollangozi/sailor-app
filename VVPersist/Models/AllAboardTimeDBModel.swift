//
//  AllAboardTimeDBModel.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 4/9/25.
//

import SwiftData
import Foundation

@Model
public class AllAboardTimeDBModel {
	public var date: Date

	public init(date: Date) {
		self.date = date
	}
}
