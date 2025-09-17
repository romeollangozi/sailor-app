//
//  MusterModeStatusRepository.swift
//  Virgin Voyages
//
//  Created by Pajtim on 25.8.25.
//

import Foundation

protocol MusterModeStatusRepositoryProtocol {
    func fetchMusterMode() -> MusterDrillContent.MusterDrillMode
    func updateMusterMode(_ sailorLocation: MusterDrillContent.MusterDrillMode) throws
}

extension UserDefaultsKey {
    static let lastKnownMusterModeKey = UserDefaultsKey("lastKnownMusterModeKey")
}

class MusterModeStatusRepository: MusterModeStatusRepositoryProtocol {
    private var userDefaultsRepository: KeyValueRepositoryProtocol

    init(userDefaultsRepository: KeyValueRepositoryProtocol = UserDefaultsKeyValueRepository()) {
        self.userDefaultsRepository = userDefaultsRepository
    }

    func fetchMusterMode() -> MusterDrillContent.MusterDrillMode {
        guard let rawValue: String = userDefaultsRepository.getObject(key: .lastKnownMusterModeKey),
              let mode = MusterDrillContent.MusterDrillMode(rawValue: rawValue) else {
            return .none
        }
        return mode
    }

    func updateMusterMode(_ musterDrillMode: MusterDrillContent.MusterDrillMode) throws {
        try? userDefaultsRepository.setObject(key: .lastKnownMusterModeKey, value: musterDrillMode.rawValue)
    }
}
