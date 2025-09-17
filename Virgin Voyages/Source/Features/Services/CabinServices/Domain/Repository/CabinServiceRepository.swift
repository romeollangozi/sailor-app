//
//  CabinServiceRepository.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 4/23/25.
//

import Foundation

protocol CabinServiceRepositoryProtocol {
    func getCabinServiceContent(cabinNumber: String,
                                shipCode: String) async throws -> CabinService?
	func createCabinServiceRequest(input: CreateCabinServiceRequestInput) async throws -> CreateCabinServiceRequestResult
    func cancelCabinServiceRequest(input: CancelCabinServiceRequestInput) async throws -> CancelCabinServiceRequestResult?
    
    func createMaintenanceServiceRequest(input: CreateMaintenanceServiceRequestInput,
                                         shipCode: String) async throws -> CreateCabinServiceRequestResult
    func cancelMaintenanceServiceRequest(input: CancelMaintenanceServiceRequestInput,
                                         shipCode: String) async throws -> CancelCabinServiceRequestResult?
}

final class CabinServiceRepository: CabinServiceRepositoryProtocol {
	private var networkService: NetworkServiceProtocol
	
	init(networkService: NetworkServiceProtocol = NetworkService.create()) {
		self.networkService = networkService
	}
	
	func getCabinServiceContent(cabinNumber: String,
								shipCode: String) async throws -> CabinService? {
		
		let response = try await networkService.getCabinServiceContent(cabinNumber: cabinNumber,
																	   shipCode: shipCode)
		
		return response?.toDomain()
		
	}
	
	func createCabinServiceRequest(input: CreateCabinServiceRequestInput) async throws -> CreateCabinServiceRequestResult {
		let response = try await networkService.createCabinServiceRequest(request: input.toNetworkDto())
		return response.toDomain()
	}
	
	func cancelCabinServiceRequest(input: CancelCabinServiceRequestInput) async throws -> CancelCabinServiceRequestResult? {
		let response = try await networkService.cancelCabinService(request: input.toNetworkDto())
        return response?.toDomain()
	}
    
    func createMaintenanceServiceRequest(input: CreateMaintenanceServiceRequestInput,
                                         shipCode: String) async throws -> CreateCabinServiceRequestResult {
        
        let response = try await networkService.createMaintenanceServiceRequest(request: input.toNetworkDto(),
                                                                                shipCode: shipCode)
        return response.toDomain()
    }
    
    func cancelMaintenanceServiceRequest(input: CancelMaintenanceServiceRequestInput,
                                         shipCode: String) async throws -> CancelCabinServiceRequestResult? {
        
        let response = try await networkService.cancelMaintenanceService(request: input.toNetworkDto(),
                                                                         shipCode: shipCode)
        return response?.toDomain()
    }
}
