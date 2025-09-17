//
//  UserDefaults.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 3/12/25.
//

import Foundation

protocol UserDefaultsProtocol {
	func data(forKey defaultName: String) -> Data?
	func set(_ value: Any?, forKey defaultName: String)
	func object(forKey defaultName: String) -> Any?
	func removeObject(forKey defaultName: String)
}
