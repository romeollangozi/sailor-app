//
//  Uploadable.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 5/11/24.
//

import Foundation

protocol Uploadable: Requestable {
	var formData: Data { get set }
	var mimeType: MimeType { get set }
}

enum MimeType: String {
	case jpeg = "image/jpeg"
	case png = "image/png"
}

enum ImageType {
	case jpeg
	case png
	
	var mimeType: MimeType {
		switch self {
		case .jpeg: .jpeg
		case .png: .png
		}
	}
}

extension Data {
	mutating func appendNewLine() {
		let newLine = "\r\n" // CRLF
		if let data = newLine.data(using: .utf8) {
			append(data)
		}
	}
	
	mutating func appendLine(_ string: String) {
		if let data = string.data(using: .utf8) {
			append(data)
			appendNewLine()
		}
	}
	
	mutating func appendFormData(_ data: Data) {
		appendNewLine()
		append(data)
		appendNewLine()
	}
}

extension Uploadable {
	func urlMultipartRequest(host: Endpoint.Host, authorization: String) throws -> URLRequest {
		let url = try url(host: host)
		var request = URLRequest(url: url)
		request.httpMethod = method.description
		request.addValue(authorization, forHTTPHeaderField: "Authorization")
		
		// Set boundry
		let boundary = UUID().uuidString
		request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

		// Request body
		var body = Data()
		body.appendLine("--\(boundary)")
		body.appendLine("Content-Disposition: form-data; name=\"file\"; filename=\"blob\"")
		body.appendLine("Content-Type: \(mimeType.rawValue)")
		body.appendFormData(formData)
		body.appendLine("--\(boundary)--")
		request.httpBody = body
		return request
	}
}
