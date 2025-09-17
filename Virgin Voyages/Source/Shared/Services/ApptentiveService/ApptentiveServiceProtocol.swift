//
//  ApptentiveServiceProtocol.swift
//  Virgin Voyages
//
//  Created by Codex on 9/5/25.
//

import Foundation

protocol ApptentiveServiceProtocol {
    func registerIfNeeded()
    func setPersonData(bookingReference: String?, voyageNumber: String?)
}
