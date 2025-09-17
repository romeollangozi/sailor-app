//
//  SendMessageResponse+Mapping.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 15.2.25.
//

extension SendMessageResponse {
	func toDomain() -> SendMessage {
		return SendMessage(
			id: self.id.value,
			result: self.result.value,
			msg: self.msg.value,
			varName: self.varName.value,
			code: self.code.value
		)
	}
}
