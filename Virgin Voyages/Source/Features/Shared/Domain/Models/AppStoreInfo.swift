//
//  AppStoreInfo.swift
//  Virgin Voyages
//
//  Created by TX on 23.5.25.
//

import Foundation

struct AppStoreInfo {
    var appID: String
    var hasUpdates: Bool
    var appStoreVersion: String
    
    init(appID: String, hasUpdates: Bool, appStoreVersion: String) {
        self.appID = appID
        self.hasUpdates = hasUpdates
        self.appStoreVersion = appStoreVersion
    }
    
}

extension AppStoreInfo {
    static let appID: String = "1478112097"
    static let empty: AppStoreInfo = .init(appID: "", hasUpdates: false, appStoreVersion: "0.0.0")
    static let mockReactNative: AppStoreInfo = .init(appID: "6741017368", hasUpdates: true, appStoreVersion: "1.0.1")
    static let mockAppStoreInfo: AppStoreInfo = .init(appID: appID, hasUpdates: true, appStoreVersion: "1.0.1")
}
