//
//  HelpAndSupportRepositoryProtocolMock.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 22.4.25.
//
import Foundation

@testable import Virgin_Voyages

final class HelpAndSupportRepositoryProtocolMock: HelpAndSupportRepositoryProtocol {
	var result: HelpAndSupport?
	
	func fetchHelpAndSupport(cacheOption: Virgin_Voyages.CacheOption) async throws -> Virgin_Voyages.HelpAndSupport? {
		return result
	}
}
