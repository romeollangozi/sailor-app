//
//  CreditCardPages.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 8/11/24.
//

import Foundation

class CreditCardPages {
	var existingCardModal: ExistingCardModal
	var deleteCardModal: DeleteCardModal

	init(existingCardModal: ExistingCardModal, deleteCardModal: DeleteCardModal) {
		self.existingCardModal = existingCardModal
		self.deleteCardModal = deleteCardModal
	}
}
