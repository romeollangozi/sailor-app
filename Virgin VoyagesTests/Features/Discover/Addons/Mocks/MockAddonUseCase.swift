//
//  MockAddonUseCase.swift
//  Virgin VoyagesTests
//
//  Created by Darko Trpevski on 30.9.24.
//


import XCTest
@testable import Virgin_Voyages

// MARK: - Mock AddonUseCase
class MockAddonUseCase: GetAddOnsUseCase {

    var result: Result<AddOnDetails, Error>!
    
	override func getAddOns(code: String?) async -> Result<AddOnDetails, Error> {
        return result
    }
}
