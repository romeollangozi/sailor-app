//
//  BiMap.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 1/30/25.
//

import Foundation

struct BiMap<Key: Hashable, Value: Hashable> {
	private var forwardMap: [Key: Value] = [:]
	private var reverseMap: [Value: Key] = [:]
	private var orderedKeys: [Key] = []
	private var keyIndexMap: [Key: Int] = [:]

	// MARK: - Public Access

	var allKeys: [Key] {
		orderedKeys
	}

	var allValues: [Value] {
		orderedKeys.compactMap { forwardMap[$0] }
	}

	func value(forKey key: Key) -> Value? {
		forwardMap[key]
	}

	func key(forValue value: Value) -> Key? {
		reverseMap[value]
	}

	func keys(where predicate: (Value) -> Bool) -> [Key] {
		// Example usage: bimap.keys(where: { $0.hasPrefix("Hello") })
		reverseMap.compactMap { predicate($0.key) ? $0.value : nil }
	}

	// MARK: - Insert & Remove

	/// Inserts or replaces a key-value pair, maintaining the 1-to-1 mapping.
	/// If `key` already existed, its old value is removed.
	/// If `value` was already used by a different key, that key is removed.
	mutating func insert(_ key: Key, value: Value) {
		// Remove old value->key if `key` is already in the map
		if let existingValue = forwardMap[key] {
			reverseMap.removeValue(forKey: existingValue)
		}

		// Remove the existing key that mapped to this value, if any
		if let existingKey = reverseMap[value], existingKey != key {
			forwardMap.removeValue(forKey: existingKey)
			if let index = keyIndexMap[existingKey] {
				orderedKeys.remove(at: index)
				keyIndexMap.removeValue(forKey: existingKey)
				rebuildIndexMap(from: index)
			}
		}

		// Insert the new pair
		forwardMap[key] = value
		reverseMap[value] = key

		// Update ordering
		if let index = keyIndexMap[key] {
			// If the key was already in orderedKeys, just replace at the same index
			orderedKeys[index] = key
		} else {
			// Otherwise append to the end
			keyIndexMap[key] = orderedKeys.count
			orderedKeys.append(key)
		}
	}

	/// Removes the given key and its associated value.
	mutating func removeKey(_ key: Key) {
		if let value = forwardMap.removeValue(forKey: key) {
			reverseMap.removeValue(forKey: value)
			if let index = keyIndexMap[key] {
				orderedKeys.remove(at: index)
				keyIndexMap.removeValue(forKey: key)
				rebuildIndexMap(from: index)
			}
		}
	}

	/// Removes the given value and its associated key.
	mutating func removeValue(_ value: Value) {
		if let key = reverseMap.removeValue(forKey: value) {
			forwardMap.removeValue(forKey: key)
			if let index = keyIndexMap[key] {
				orderedKeys.remove(at: index)
				keyIndexMap.removeValue(forKey: key)
				rebuildIndexMap(from: index)
			}
		}
	}

	/// Removes everything from the bimap.
	mutating func clear() {
		forwardMap.removeAll()
		reverseMap.removeAll()
		orderedKeys.removeAll()
		keyIndexMap.removeAll()
	}

	// MARK: - Updating Values

	/// Updates the value for `key` with the provided new `value`.
	/// If `value` is already used by a different key, that other key is removed first.
	mutating func updateValue(for key: Key, with value: Value) {
		// Remove oldValue->key
		if let oldValue = forwardMap[key] {
			reverseMap.removeValue(forKey: oldValue)
		}

		// Remove the existing key that owns this new value
		if let existingKey = reverseMap[value], existingKey != key {
			forwardMap.removeValue(forKey: existingKey)
			if let index = keyIndexMap[existingKey] {
				orderedKeys.remove(at: index)
				keyIndexMap.removeValue(forKey: existingKey)
				rebuildIndexMap(from: index)
			}
		}

		forwardMap[key] = value
		reverseMap[value] = key

		// Keep orderedKeys in sync
		if keyIndexMap[key] == nil {
			keyIndexMap[key] = orderedKeys.count
			orderedKeys.append(key)
		}
	}

	/// Finds any one value matching `predicate` and applies `update(...)`.
	mutating func updateValue(where predicate: (Value) -> Bool, using update: (inout Value) -> Void) {
		if let key = reverseMap.first(where: { predicate($0.key) })?.value {
			updateValue(for: key, using: update)
		}
	}

	/// Updates the value for `key` **in-place**, applying a closure that mutates
	/// the existing value. If the new value collides with a different key, that key is removed.
	mutating func updateValue(for key: Key, using update: (inout Value) -> Void) {
		guard var value = forwardMap[key] else { return }

		// Remove old value->key mapping
		reverseMap.removeValue(forKey: value)

		// Apply user-provided transformation
		update(&value)

		// Now remove any existing key that owns this new value
		if let existingKey = reverseMap[value], existingKey != key {
			forwardMap.removeValue(forKey: existingKey)
			if let index = keyIndexMap[existingKey] {
				orderedKeys.remove(at: index)
				keyIndexMap.removeValue(forKey: existingKey)
				rebuildIndexMap(from: index)
			}
		}

		// Reassign the updated value
		forwardMap[key] = value
		reverseMap[value] = key
	}

	// MARK: - Bulk Update

	/// Rebuilds the bimap from an array of keys, each transformed into a value.
	/// If multiple keys transform to the same value, the last one “wins.”
	mutating func update(with items: [Key], transform: (Key) -> Value) {
		var newForwardMap: [Key: Value] = [:]
		var newReverseMap: [Value: Key] = [:]
		var newOrderedKeys: [Key] = []
		var newKeyIndexMap: [Key: Int] = [:]

		for (index, key) in items.enumerated() {
			let value = transform(key)

			// Check if this value was already taken by a different key (in this new pass)
			if let existingKey = newReverseMap[value], existingKey != key {
				// Remove that old key so we preserve a 1-to-1 mapping,
				// letting the *last* key for that value "win."
				newForwardMap.removeValue(forKey: existingKey)

				// Also remove it from the ordering array
				if let existingIndex = newKeyIndexMap[existingKey] {
					newOrderedKeys.remove(at: existingIndex)
					newKeyIndexMap.removeValue(forKey: existingKey)
					// Rebuild indices after removal
					for index in existingIndex..<newOrderedKeys.count {
						newKeyIndexMap[newOrderedKeys[index]] = index
					}
				}
			}

			newForwardMap[key] = value
			newReverseMap[value] = key
			newOrderedKeys.append(key)
			newKeyIndexMap[key] = index
		}

		// Swap in new maps
		forwardMap = newForwardMap
		reverseMap = newReverseMap
		orderedKeys = newOrderedKeys
		keyIndexMap = newKeyIndexMap
	}

	// MARK: - Internal Index Rebuild

	/// Recomputes `keyIndexMap` from `startIndex` onward.
	private mutating func rebuildIndexMap(from startIndex: Int) {
		for index in startIndex..<orderedKeys.count {
			let key = orderedKeys[index]
			keyIndexMap[key] = index
		}
	}
}
