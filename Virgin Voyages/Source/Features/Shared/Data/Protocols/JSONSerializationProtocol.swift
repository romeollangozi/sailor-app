//
//  JSONSerializationProtocol.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 3/12/25.
//


import Foundation

protocol JSONSerializationProtocol {
	func decode<T>( _ type: T.Type, from data: Data) throws -> T where T : Decodable
	func encode<T>(_ value: T) throws -> Data where T : Encodable
}
