//
//  ScanFormatType.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 17.7.25.
//

import Foundation

extension ScanFormatType {
    init?(scanType: ScanType) {
        self.init(rawValue: scanType.rawValue)
    }
}
