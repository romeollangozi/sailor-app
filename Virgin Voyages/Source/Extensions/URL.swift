//
//  URL.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 6/11/23.
//

import Foundation

extension URL {
	private var hashName: String {
		var hashValue: UInt64 = 5381
		let prime: UInt64 = 31
		let string = self.absoluteString
		
		for character in string.utf8 {
			hashValue = (hashValue &* prime) &+ UInt64(character)
		}
		
		return String(hashValue)
	}
	
	func cacheFileURL(with fileExtension: String? = nil) -> URL? {
		let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		guard let documentsDirectory = paths.first else {
			return nil
		}
		
		let name = self.hashName
		var path = documentsDirectory
		try? FileManager().createDirectory(at: path, withIntermediateDirectories: false)
		path.append(component: name)
		if let fileExtension { path.appendPathExtension(fileExtension) }
		return path
	}
}

extension URLRequest {
	var cURL: String {
		var components = ["curl -v"]

		if let method = httpMethod {
			components.append("-X \(method)")
		}

		if let url = url {
			components.append("\"\(url.absoluteString)\"")
		}

		if let headers = allHTTPHeaderFields {
			for (header, value) in headers {
				components.append("-H \"\(header): \(value)\"")
			}
		}

		if let httpBody, httpBody.count > 0, let body = String(data: httpBody, encoding: .utf8), body != "null" {
			components.append("-d '\(body)'")
		}

		return components.joined(separator: " ")
	}
}

