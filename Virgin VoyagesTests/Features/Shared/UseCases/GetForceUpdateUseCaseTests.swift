//
//  GetForceUpdateUseCaseTests.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 23.5.25.
//

import XCTest
@testable import Virgin_Voyages


final class GetForceUpdateUseCaseTests: XCTestCase {
	var useCase: GetForceUpdateUseCaseProtocol!
	var mockComponentSettingsRepository: MockComponentSettingsRepository!
    var mockAppDeviceInfoService: MockAppDeviceInfoService!

	override func setUp() {
		super.setUp()
		mockComponentSettingsRepository = MockComponentSettingsRepository()
        mockAppDeviceInfoService = MockAppDeviceInfoService()
        useCase = GetForceUpdateUseCase(
            componentSettingsRepositoryProtocol: mockComponentSettingsRepository,
            appDeviceInfoServiceProtocol: mockAppDeviceInfoService
        )
	}

	override func tearDown() {
		useCase = nil
		mockComponentSettingsRepository = nil
		super.tearDown()
	}

	func testExecuteWhenForceUpdateConfifgIsFalseShouldReturnFalse() async throws {
		mockComponentSettingsRepository.mockResponse = [
			.sampleWithForceUdpate()
			.copy(value: "false")
		]
		
		let result = try await useCase.execute()
		
		XCTAssertFalse(result.hasUpdates)
	}
    
    func testExecuteWhenAppStoreVersionIsHigherThenInstalledAppVersion() async throws {
        mockComponentSettingsRepository.mockResponse = [
            .sampleWithForceUdpate()
            .copy(value: "true"),
            .sampleWithMinVersion()
            .copy(value: "2.0.1")
        ]
        
        mockAppDeviceInfoService.mockVersion = "1.0.1"
        
        let result = try await useCase.execute()
        
        XCTAssertTrue(result.hasUpdates)
    }
    
    func testExecuteWhenAppStoreVersionIsSameWithInstalledAppVersion() async throws {
        mockComponentSettingsRepository.mockResponse = [
            .sampleWithForceUdpate()
            .copy(value: "true"),
            .sampleWithMinVersion()
            .copy(value: "1.0.1")
        ]
        
        mockAppDeviceInfoService.mockVersion = "1.0.1"
        
        let result = try await useCase.execute()
        
        XCTAssertFalse(result.hasUpdates)
    }
    
}
