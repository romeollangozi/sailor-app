//
//  CancelAddonUseCaseTests.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 9.3.25.
//

import XCTest
@testable import Virgin_Voyages

final class CancelAddonUseCaseTests: XCTestCase {
    private var mockCancelAddonRepository: MockCancelAddonRepository!
    private var useCase: CancelAddonUseCase!
    
    override func setUp() {
        super.setUp()
        mockCancelAddonRepository = MockCancelAddonRepository()
        useCase = CancelAddonUseCase(cancelAddonRepository: mockCancelAddonRepository)
    }
    
    override func tearDown() {
        useCase = nil
        mockCancelAddonRepository = nil
        super.tearDown()
    }
    
    func testCancelAddon_Success() async {
        mockCancelAddonRepository.expectedResult = .success(true)
        
        let result = await useCase.cancelAddon(guests: ["John", "Steve"], code: "1234", quantity: 2)
        
        switch result {
        case .success(let success):
            XCTAssertTrue(success, "Expected success to be true")
        case .failure:
            XCTFail("Expected success but got failure")
        }
    }
    
    func testCancelAddon_Error() async {
		mockCancelAddonRepository.expectedResult = .failure(.genericError)

        let result = await useCase.cancelAddon(guests: ["John", "Steve"], code: "1234", quantity: 2)
        
        switch result {
        case .success:
            XCTFail("Expected failure but got success")
        case .failure(let error):
            XCTAssertEqual(error, .genericError, "Expected badRequest error")
        }
    }
}
