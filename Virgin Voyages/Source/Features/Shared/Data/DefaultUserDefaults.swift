//
//  DefaultUserDefaults.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 3/12/25.
//


import Foundation

class DefaultUserDefaults: UserDefaultsProtocol {

	func data(forKey defaultName: String) -> Data? {
		return UserDefaults.standard.data(forKey: defaultName)
	}
	
	func set(_ value: Any?, forKey defaultName: String) {
		UserDefaults.standard.set(value, forKey: defaultName)
	}
	
	func object(forKey defaultName: String) -> Any? {
		return UserDefaults.standard.object(forKey: defaultName)
	}

	func removeObject(forKey defaultName: String) {
		UserDefaults.standard.removeObject(forKey: defaultName)
	}
}
