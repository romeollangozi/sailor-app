//
//  CredentialsService.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 8/22/24.
//

import Security
import Foundation

protocol CredentialsServiceProtocol {
	func saveCredentials(email: String, password: String)
	func retrieveCredentials() -> (email: String, password: String)?
	func deleteCredentials(email: String)
}

class CredentialsService: CredentialsServiceProtocol {

	private let serviceKey = "com.virginvoyages.credentials"

	func saveCredentials(email: String, password: String) {
		let deleteAllQuery: [String: Any] = [
			kSecClass as String: kSecClassGenericPassword,
			kSecAttrService as String: serviceKey
		]
		SecItemDelete(deleteAllQuery as CFDictionary)

		let newCredentials: [String: Any] = [
			kSecClass as String: kSecClassGenericPassword,
			kSecAttrAccount as String: email,
			kSecAttrService as String: serviceKey,
			kSecValueData as String: password.data(using: .utf8)!,
			kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked
		]
		SecItemAdd(newCredentials as CFDictionary, nil)
	}

	func retrieveCredentials() -> (email: String, password: String)? {
		let query: [String: Any] = [
			kSecClass as String: kSecClassGenericPassword,
			kSecAttrService as String: serviceKey,
			kSecReturnAttributes as String: true,
			kSecReturnData as String: true,
			kSecMatchLimit as String: kSecMatchLimitOne
		]

		var item: CFTypeRef?
		let status = SecItemCopyMatching(query as CFDictionary, &item)

		guard status == errSecSuccess, let existingItem = item as? [String: Any],
			  let email = existingItem[kSecAttrAccount as String] as? String, // Retrieve the email
			  let passwordData = existingItem[kSecValueData as String] as? Data,
			  let password = String(data: passwordData, encoding: .utf8) else {
			return nil
		}

		return (email: email, password: password)
	}

	func deleteCredentials(email: String) {
		let query: [String: Any] = [
			kSecClass as String: kSecClassGenericPassword,
			kSecAttrAccount as String: email, // Use email as the account key
			kSecAttrService as String: serviceKey
		]

		_ = SecItemDelete(query as CFDictionary)
	}
}
