//
//  SendMessage.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 15.2.25.
//

struct SendMessage: Equatable {
	let id: Int
	let result: String
	let msg: String
	let varName: String
	let code: String

	static func empty() -> SendMessage {
		return SendMessage(id: 0, result: "", msg: "", varName: "", code: "")
	}
}
