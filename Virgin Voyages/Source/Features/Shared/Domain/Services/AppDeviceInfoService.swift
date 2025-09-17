//
//  AppDeviceInfoService.swift
//  Virgin Voyages
//
//  Created by TX on 26.5.25.
//

import Foundation

protocol AppDeviceInfoServiceProtocol {
    func getVersion() -> String
}

class AppDeviceInfoService: AppDeviceInfoServiceProtocol {
    func getVersion() -> String  {
        let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0.0"
        return currentVersion
    }
}
