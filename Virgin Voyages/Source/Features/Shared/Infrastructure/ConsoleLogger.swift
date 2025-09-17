//
//  ConsoleLogger.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 5/7/25.
//

import Foundation

class ConsoleLogger: LoggerProtocol {
	func log(_ error: any VVError) {
		print("ConsoleLog: \(error)")
	}
}
