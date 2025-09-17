//
//  GetForceUpdateUseCase.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 23.5.25.
//

import Foundation

protocol GetForceUpdateUseCaseProtocol {
    func execute() async throws -> AppStoreInfo
}

final class GetForceUpdateUseCase: GetForceUpdateUseCaseProtocol {
	private let componentSettingsRepositoryProtocol: ComponentSettingsRepositoryProtocol
    private let appDeviceInfoService: AppDeviceInfoServiceProtocol
    
	init(componentSettingsRepositoryProtocol: ComponentSettingsRepositoryProtocol = ComponentSettingsRepository(),
         appDeviceInfoServiceProtocol: AppDeviceInfoServiceProtocol = AppDeviceInfoService()) {
		self.componentSettingsRepositoryProtocol = componentSettingsRepositoryProtocol
        self.appDeviceInfoService = appDeviceInfoServiceProtocol
	}
	
	func execute() async throws -> AppStoreInfo {
        let appID = AppStoreInfo.appID
		let response = try await componentSettingsRepositoryProtocol.fetchComponentSettings(useCache: false)
		
		if let forceUpdateConfig = response.findByName("globals.forceUpdateRequiredForNewSailorApp") {
			if (forceUpdateConfig.value == "false") {
                return .init(appID: appID, hasUpdates: false, appStoreVersion: "")
			}
			
			if let minVersion = response.findByName("globals.minimumVersionForNewSailorAppiOS")?.value {
                let hasUpdates: Bool = isCurrentVersionLessThan(minVersion: minVersion)
                return .init(appID: appID, hasUpdates: hasUpdates, appStoreVersion: minVersion)
			}
		}
		
        return .init(appID: appID, hasUpdates: false, appStoreVersion: "")
	}
	
	private func isCurrentVersionLessThan(minVersion: String) -> Bool {
        let appVersion = appDeviceInfoService.getVersion()
		let currentVersionComponents = appVersion.split(separator: ".").compactMap { Int($0) }
		let minVersionComponents = minVersion.split(separator: ".").compactMap { Int($0) }
		
		for (current, minimum) in zip(currentVersionComponents, minVersionComponents) {
			if current < minimum {
				return true
			} else if current > minimum {
				return false
			}
		}
		
		return currentVersionComponents.count < minVersionComponents.count
	}
}
