//
//  FormDataHTTPRequestProtocol.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 20.2.25.
//

import Foundation

protocol FormDataHTTPRequestProtocol: AuthenticatedHTTPRequestProtocol {
	var parameters: [String: String] { get }
	var files: [FileData]? { get }
}

extension FormDataHTTPRequestProtocol {
	var files: [FileData]? {
		return nil
	}
}

struct FileData {
	let fieldName: String
	let fileName: String
	let mimeType: String
	let data: Data
}
