//
//  DefaultLogger.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 5/7/25.
//

import Foundation

class DefaultLogger: LoggerProtocol {

	private let multiLogger: MultiLogger

	init() {
		self.multiLogger = MultiLogger(loggers: [
			DynatraceLogger(),
			ConsoleLogger()
		])
	}

	func log(_ error: any VVError) {
		multiLogger.log(error)
	}
}

