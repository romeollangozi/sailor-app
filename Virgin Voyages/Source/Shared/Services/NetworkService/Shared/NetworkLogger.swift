//
//  NetworkLogger.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 4/30/25.
//


import Dynatrace
import Foundation

final class NetworkLogger {
    func logRequest(_ request: URLRequest) {
        #if DEBUG
        request.printRequest()
        #endif
    }

    func logResponse(_ response: HTTPURLResponse, data: Data) {
        #if DEBUG
        response.printResponse(from: data)
        #endif
    }

	func reportDecodingError(_ error: Error, data: Data?, modelName: String) {

		if let action = DTXAction.enter(withName: "JSONDecodingError") {
			action.reportError(withName: "JSONDecodingError", error: error)
			action.reportValue(withName: "ModelName", stringValue: "\(modelName)")
			action.reportValue(withName: "dataSample", stringValue: data.flatMap { String(data: $0.prefix(1024), encoding: .utf8) } ?? "nil")
			action.leave()
		}
	}
}
