//
//  DefaultJSONDecoder.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 3/11/25.
//


import Foundation

class DefaultJSONSerializer: JSONSerializationProtocol {

    func decode<T>( _ type: T.Type, from data: Data) throws -> T where T : Decodable {
		return try JSONDecoder().decode(type, from: data)
	}

	func encode<T>(_ value: T) throws -> Data where T : Encodable {
		return try JSONEncoder().encode(value)
	}
}
