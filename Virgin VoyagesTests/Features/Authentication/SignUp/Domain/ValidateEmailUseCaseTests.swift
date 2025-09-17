//
//  ValidateEmailUseCaseTests.swift
//  Virgin VoyagesTests
//
//  Created by Kevin Topollaj on 5/5/25.
//

import XCTest
@testable import Virgin_Voyages

final class ValidateEmailUseCaseTests: XCTestCase {
    
    var mockRepository: SignUpRepositoryMock!
    var useCase: ValidateEmailUseCase!
    
    override func setUp() {
        super.setUp()
        
        mockRepository = SignUpRepositoryMock()
        useCase = ValidateEmailUseCase(signUpRepository: mockRepository)
    }
    
    override func tearDown() {
        mockRepository = nil
        useCase = nil
        
        super.tearDown()
    }
    
    func testExecute_Success() async throws {
        
        let mockValidateEmail = ValidateEmail.sample()
        mockRepository.mockValidateEmail = mockValidateEmail
        
        let validateError = try await useCase.execute(email: "mohammad.jilanikmdrty@yopmail.com", clientToken: "")
        
        XCTAssertEqual(mockValidateEmail.isEmailExist, validateError.isEmailExist)
    }
    
    func testExecute_Error() async {
        mockRepository.shouldThrowError = true
        
        do {
            _ = try await useCase.execute(email: "mohammad.jilanikmdrty@yopmail.com", clientToken: "")
        } catch {
            XCTAssertTrue(error is VVDomainError)
            XCTAssertEqual(error as? VVDomainError, .genericError)
        }
    }
    
}
