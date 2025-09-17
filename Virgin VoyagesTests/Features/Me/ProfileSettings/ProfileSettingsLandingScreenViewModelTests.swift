//
//  ProfileSettingsLandingScreenViewModelTests.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 28.5.25.
//

import XCTest
@testable import Virgin_Voyages

final class ProfileSettingsLandingScreenViewModelTests: XCTestCase {
	private var mockGetProfileSettingsLandingScreenUseCase: MockGetProfileSettingsLandingScreenUseCase!
	private var mockLogoutUserUseCase: MockLogoutUserUseCase!
	private var mockWebUrlLauncher: MockWebUrlLauncher!
	private var viewModel: ProfileSettingsLandingScreenViewModelProtocol!
	
	override func setUp() {
		super.setUp()
		
		mockGetProfileSettingsLandingScreenUseCase = MockGetProfileSettingsLandingScreenUseCase()
		mockLogoutUserUseCase = MockLogoutUserUseCase()
		mockWebUrlLauncher = MockWebUrlLauncher()
		
		viewModel = ProfileSettingsLandingScreenViewModel(
			getProfileSettingsLandingScreenUseCase: mockGetProfileSettingsLandingScreenUseCase,
			logoutUseCase: mockLogoutUserUseCase,
			webUrlLauncher: mockWebUrlLauncher
		)
	}
	
	override func tearDown() {
		mockGetProfileSettingsLandingScreenUseCase = nil
		mockLogoutUserUseCase = nil
		mockWebUrlLauncher = nil
		
		super.tearDown()
	}
	
	func testOnDeleteAcconutTapShouldRedirectToDelteAccountWebPage() {
		viewModel.onDeleteAcconutTap()
		
		mockWebUrlLauncher.lastOpenedUrl = URL(string: "https://virginvoyages.my.salesforce-sites.com/submitaccountdelete")!
	}
}
