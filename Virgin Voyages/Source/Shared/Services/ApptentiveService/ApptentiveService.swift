//
//  ApptentiveService.swift
//  Virgin Voyages
//
//  Created by Codex on 9/5/25.
//

import Foundation
import ApptentiveKit

final class ApptentiveService: ApptentiveServiceProtocol {
    static let shared = ApptentiveService()

    private var isRegistered = false

    private init() {}

    func registerIfNeeded() {
        guard !isRegistered else { return }
        let appConfig = AppConfig.shared
        Apptentive.shared.register(with: .init(key: appConfig.apptentiveKey,
                                               signature: appConfig.apptentiveSignature))
        Apptentive.shared.engage(event: "app_launch")
        isRegistered = true
    }

    func setPersonData(bookingReference: String?, voyageNumber: String?) {
        if let bookingReference, !bookingReference.isEmpty {
            Apptentive.shared.personCustomData["booking_reference"] = bookingReference
        }
        if let voyageNumber, !voyageNumber.isEmpty {
            Apptentive.shared.personCustomData["voyage_number"] = voyageNumber
        }
    }
}
