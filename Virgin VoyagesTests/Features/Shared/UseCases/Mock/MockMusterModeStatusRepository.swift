//
//  MockMusterModeStatusRepository.swift
//  Virgin VoyagesTests
//
//  Created by Pajtim on 25.8.25.
//

import Foundation
@testable import Virgin_Voyages

final class MockMusterModeStatusRepository: MusterModeStatusRepositoryProtocol {
    var musterDrillMode: MusterDrillContent.MusterDrillMode
    var didFetch = false
    var updateCalledWith: MusterDrillContent.MusterDrillMode = .none

    init(musterDrillMode: MusterDrillContent.MusterDrillMode = .none) {
        self.musterDrillMode = musterDrillMode
    }

    func fetchMusterMode() -> MusterDrillContent.MusterDrillMode {
        didFetch = true
        return musterDrillMode
    }

    func updateMusterMode(_ musterDrillMode: MusterDrillContent.MusterDrillMode) throws {
        updateCalledWith = musterDrillMode
        self.musterDrillMode = musterDrillMode
    }
}
