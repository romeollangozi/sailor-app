//
//  Double+Date.swift
//  Virgin Voyages
//
//  Created by Timur Xhabiri on 21.10.24.
//

import Foundation

extension Double {
    func toDateFromMilliseconds() -> Date {
        return Date(timeIntervalSince1970: self / 1000.0)
    }
}
