//
//  Optional+Unwrap.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 14.9.24.
//

import Foundation

extension Optional where Wrapped == String {
    var value: String {
        return self ?? ""
    }
}

extension Optional where Wrapped == Double {
    var value: Double {
        return self ?? 0.0
    }
}

extension Optional where Wrapped == Bool {
    var value: Bool {
        return self ?? false
    }
}

extension Optional where Wrapped == Int {
    var value: Int {
        return self ?? 0
    }
}

extension Optional where Wrapped == Data {
    var value: Data {
        return self ?? Data()
    }
}

extension Optional where Wrapped == Date {
    var value: Date {
        return self ?? Date()
    }
}

extension Optional where Wrapped == Array<Any> {
	var value: Array<Any> {
		return self ?? []
	}
}
