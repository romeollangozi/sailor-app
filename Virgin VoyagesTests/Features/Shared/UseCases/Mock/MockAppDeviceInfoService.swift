//
//  MockAppDeviceInfoService.swift
//  Virgin VoyagesTests
//
//  Created by TX on 26.5.25.
//

@testable import Virgin_Voyages

final class MockAppDeviceInfoService: AppDeviceInfoServiceProtocol {
    var mockVersion = ""
    
    func getVersion() -> String {
        mockVersion
    }
}


