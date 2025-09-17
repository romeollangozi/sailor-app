//
//  CabinServiceRepositoryMock.swift
//  Virgin VoyagesTests
//
//  Created by Kevin Topollaj on 4/23/25.
//

import XCTest
@testable import Virgin_Voyages

final class CabinServiceRepositoryMock: CabinServiceRepositoryProtocol {
    var shouldThrowError = false
    var mockCabinService: CabinService? = CabinService.sample()
	var createCabinServiceRequestInput: Virgin_Voyages.CreateCabinServiceRequestInput? = nil
	var cancelCabinServiceRequestInput: Virgin_Voyages.CancelCabinServiceRequestInput? = nil
    var createMaintenanceServiceRequestInput: Virgin_Voyages.CreateMaintenanceServiceRequestInput? = nil
    var cancelMaintenanceServiceRequestInput: Virgin_Voyages.CancelMaintenanceServiceRequestInput? = nil
    
    func getCabinServiceContent(cabinNumber: String,
                                shipCode: String) async throws -> CabinService? {
        
        if shouldThrowError {
            throw VVDomainError.genericError
        }
        
        return mockCabinService
        
    }
	
	func createCabinServiceRequest(input: Virgin_Voyages.CreateCabinServiceRequestInput) async throws -> Virgin_Voyages.CreateCabinServiceRequestResult {
		if shouldThrowError {
			throw VVDomainError.genericError
		}
		
		createCabinServiceRequestInput = input
		
		return .init(requestId: UUID().uuidString)
	}
    
    func createMaintenanceServiceRequest(input: CreateMaintenanceServiceRequestInput, shipCode: String) async throws -> Virgin_Voyages.CreateCabinServiceRequestResult {
        
        if shouldThrowError {
            throw VVDomainError.genericError
        }
        
        createMaintenanceServiceRequestInput = input
        
        return .init(requestId: UUID().uuidString)
    }
    
    func cancelCabinServiceRequest(input: Virgin_Voyages.CancelCabinServiceRequestInput) async throws -> Virgin_Voyages.CancelCabinServiceRequestResult? {
        if shouldThrowError {
            throw VVDomainError.genericError
        }
        
        cancelCabinServiceRequestInput = input
        
        return .init()
    }
    
    func cancelMaintenanceServiceRequest(input: Virgin_Voyages.CancelMaintenanceServiceRequestInput, shipCode: String) async throws -> Virgin_Voyages.CancelCabinServiceRequestResult? {
        
        if shouldThrowError {
            throw VVDomainError.genericError
        }
        
        cancelMaintenanceServiceRequestInput = input
        
        return .init()
        
    }
    
}
