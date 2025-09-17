//
//  TransactionResponse+ToDomain.swift
//  Virgin Voyages
//
//  Created by TX on 19.6.25.
//


extension TransactionResponse {
    func toDomain() -> BookActivityResult {
        .init(paymentStatus: self.paymentStatus.value, message: message.value, reason: .init(rawValue: reason.value), isNoPaymentRequired: isNoPaymentRequired ?? false, appointmentId: self.appointmentId.value)
    }
}
