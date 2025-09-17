//
//  DynatraceLogger.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 5/7/25.
//

import Foundation
import Dynatrace

class DynatraceLogger: LoggerProtocol {
	func log(_ error: any VVError) {
		if let action = DTXAction.enter(withName: "AppException") {
			action.reportError(withName: "Exception: \(error.localizedDescription)", errorValue: 1)
			action.reportValue(withName: "text", stringValue: "\(error)")
			action.reportValue(withName: "exception_type", stringValue: "\(type(of: error))")
			action.reportValue(withName: "stack_trace", stringValue: Thread.callStackSymbols.joined(separator: "\n"))
			action.leave()
		}
	}
}
