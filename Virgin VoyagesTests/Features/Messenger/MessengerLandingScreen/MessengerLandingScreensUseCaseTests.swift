//
//  MessengerLandingScreensUseCaseTests.swift
//  Virgin VoyagesTests
//
//  Created by Timur Xhabiri on 25.10.24.
//

import XCTest
@testable import Virgin_Voyages

final class MessengerLandingScreensUseCaseTests: XCTestCase {

    var useCase: MessengerLandingScreensUseCaseProtocol!
    var localizationManager: MockLocalizationManager!
    var lastKnownRepo: MockLastKnownSailorConnectionLocationRepository!

    override func setUp() {
        super.setUp()

        localizationManager = MockLocalizationManager(preloaded: [
            .messengerScreenTitle: "Messages",
            .messengerContactAFriendButtonLabel: "Contact a Friend",
            .messengerEmptyWelcomeStateOnboard: "Welcome aboard! Connect with fellow sailors.",
            .messengerEmptyWelcomeStatePreCruise: "Welcome! Get ready for your voyage."
        ])

        lastKnownRepo = MockLastKnownSailorConnectionLocationRepository()
        // Default from your mock is `.shore`

        useCase = MessengerLandingScreensUseCase(
            localizationManagerService: localizationManager,
            lastKnownSailorConnectionLocationRepository: lastKnownRepo,
            currentSailorManager: MockCurrentSailorManager() // your existing mock
        )
    }

    override func tearDown() {
        useCase = nil
        lastKnownRepo = nil
        localizationManager = nil
        super.tearDown()
    }

    func testExecuteReturnsLocalizedTitleAndCTA() async {
        let result = await useCase.execute()

        switch result {
        case .success(let model):
            XCTAssertEqual(model.content.screenTitle, "Messages")
            XCTAssertEqual(model.content.addFriendText, "Contact a Friend")
        case .failure(let error):
            XCTFail("Expected success, got failure: \(error)")
        }
    }

    func testExecuteUsesPreCruiseWelcomeTextWhenLocationIsShore() async {
        // Given (default from mock is .shore)
        lastKnownRepo.lastSailorLocation = .shore

        let result = await useCase.execute()

        switch result {
        case .success(let model):
            XCTAssertEqual(model.content.welcomingText, "Welcome! Get ready for your voyage.")
        case .failure(let error):
            XCTFail("Expected success, got failure: \(error)")
        }
    }

    func testExecuteUsesOnboardWelcomeTextWhenLocationIsShip() async {
        // Given
        lastKnownRepo.lastSailorLocation = .ship

        let result = await useCase.execute()

        switch result {
        case .success(let model):
            XCTAssertEqual(model.content.welcomingText, "Welcome aboard! Connect with fellow sailors.")
        case .failure(let error):
            XCTFail("Expected success, got failure: \(error)")
        }
    }
}
