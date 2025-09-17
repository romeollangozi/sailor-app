//
//  AddContactUseCaseTests.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 4.11.24.
//

 
import XCTest
@testable import Virgin_Voyages

class MockMessengerFriendsRepository: MessengerFriendsRepositoryProtocol {
    var addContactsResult: Result<EmptyModel, VVDomainError>?
    var addFriendToContactsResult: Result<EmptyModel, VVDomainError>?
    var removeFriendFromContactsResult: Result<EmptyModel, VVDomainError>?
    
    func addContacts(reservationId: String, personId: String, connectionPersonId: String, isEventVisibleCabinMates: Bool) async -> Result<EmptyModel, VVDomainError> {
        return addContactsResult ?? .failure(.genericError)
    }
    
    func addFriendToContacts(reservationId: String, reservationGuestId: String, connectionResevationId: String, connectionReservationGuestId: String) async throws {
        if addFriendToContactsResult == nil {
            throw VVDomainError.genericError
        }
    }
    
    func removeFriendFromContacts(reservationId: String, reservationGuestId: String, connectionResevationId: String, connectionReservationGuestId: String) async throws {
        if removeFriendFromContactsResult == nil {
            throw VVDomainError.genericError
        }
    }
}

final class AddContactUseCaseTests: XCTestCase {
    
    var useCase: AddContactUseCase!
    var mockRepository: MockMessengerFriendsRepository!
    
    override func setUp() {
        super.setUp()
        
        mockRepository = MockMessengerFriendsRepository()
        useCase = AddContactUseCase(repository: mockRepository, currentSailorManager: MockCurrentSailorManager())
    }
    
    override func tearDown() {
        useCase = nil
        mockRepository = nil
        super.tearDown()
    }
    
    func testAddContacts_Success() async {
        // Arrange
        mockRepository.addContactsResult = .success(EmptyModel())
        
        // Act
        let result = await useCase.execute(connectionPersonId: "testConnectionPersonId", isEventVisibleCabinMates: true)
        
        // Assert
        switch result {
        case .success:
            XCTAssertTrue(true, "Expected success")
        case .failure:
            XCTFail("Expected success, but got failure")
        }
    }
    
    func testAddContacts_Failure() async {
        // Arrange
        mockRepository.addContactsResult = .failure(.genericError)

        // Act
        let result = await useCase.execute(connectionPersonId: "testConnectionPersonId", isEventVisibleCabinMates: true)
        
        // Assert
        switch result {
        case .success:
            XCTFail("Expected failure, but got success")
        case .failure(let error):
            XCTAssertEqual(error, .genericError, "Expected network error")
        }
    }
}
