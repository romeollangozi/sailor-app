//
//  MultiLogger.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 5/7/25.
//

import Foundation

class MultiLogger: LoggerProtocol {
	private var loggers: [LoggerProtocol]

	init(loggers: [LoggerProtocol]) {
		self.loggers = loggers
	}

	func log(_ error: VVError) {
		for logger in loggers {
			logger.log(error)
		}
	}

	// Optional: Add a method to dynamically add new loggers
	func addLogger(_ logger: LoggerProtocol) {
		loggers.append(logger)
	}
}
