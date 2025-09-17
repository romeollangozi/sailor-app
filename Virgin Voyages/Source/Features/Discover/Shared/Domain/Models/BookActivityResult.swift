//
//  BookActivityResult.swift
//  Virgin Voyages
//
//  Created by TX on 19.6.25.
//


struct BookActivityResult {
    let paymentStatus: String
    let message: String?
    let reason: Reasons?
    let isNoPaymentRequired: Bool?
    let appointmentId: String // Upon editing an existing booking, this appointment id will change

    static func empty() -> BookActivityResult {
        .init(paymentStatus: "", message: nil, reason: nil, isNoPaymentRequired: false, appointmentId: "")
    }
    
    enum Reasons: String {
        case undefined = "undefined"
        case refundAutoDistributed = "pending-refund-auto-distributed"
    }
}
