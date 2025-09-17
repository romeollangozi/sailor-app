//
//  KeyValueRepository.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 15.11.24.
//

import Foundation

enum KeyValueRepositoryError: Error {
	case errorSettingObject
}

protocol KeyValueRepositoryProtocol {
    func get<T>(key: String) -> T?
    func set<T>(key: String, value: T)
    func getObject<T>(key: String) -> T? where T: Codable
    func setObject<T>(key: String, value: T) throws where T: Codable
    func remove(key: String)
}

struct UserDefaultsKey {
	var value: String

	init(_ value: String) {
		self.value = value
	}
}

extension KeyValueRepositoryProtocol {
	func get<T>(key: UserDefaultsKey) -> T? {
		return get(key: key.value)
	}

	func set<T>(key: UserDefaultsKey, value: T) {
		set(key: key.value, value: value)
	}

	func getObject<T>(key: UserDefaultsKey) -> T? where T: Codable {
		return getObject(key: key.value)
	}

	func setObject<T>(key: UserDefaultsKey, value: T) throws where T: Codable {
		return try setObject(key: key.value, value: value)
	}

	func remove(key: UserDefaultsKey) {
		remove(key: key.value)
	}
}

class UserDefaultsKeyValueRepository: KeyValueRepositoryProtocol {

	let userDefaults: UserDefaultsProtocol
	let jsonSerializer: JSONSerializationProtocol

	init(
		userDefaults: UserDefaultsProtocol = DefaultUserDefaults(),
		jsonSerializer: JSONSerializationProtocol = DefaultJSONSerializer()
	) {
		self.userDefaults = userDefaults
		self.jsonSerializer = jsonSerializer
	}

    func get<T>(key: String) -> T? {
        return userDefaults.object(forKey: key) as? T
    }
    
    func set<T>(key: String, value: T) {
		userDefaults.set(value, forKey: key)
    }
    
    func getObject<T>(key: String) -> T? where T: Codable {
        guard let data = userDefaults.data(forKey: key) else {
            return nil
        }
        do {
            return try jsonSerializer.decode(T.self, from: data)
        } catch {
            return nil
        }
    }

    func setObject<T>(key: String, value: T) throws where T: Codable {
        do {
            let data = try jsonSerializer.encode(value)
			userDefaults.set(data, forKey: key)
        } catch {
			throw KeyValueRepositoryError.errorSettingObject
        }
    }
    
    func remove(key: String) {
		userDefaults.removeObject(forKey: key)
    }
}
