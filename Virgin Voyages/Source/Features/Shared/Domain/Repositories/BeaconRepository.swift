//
//  BeaconRepository.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 9/8/25.
//

import Foundation

protocol BeaconRepositoryProtocol {
    
    func createBeacon(input: CreateBeaconRequestInput) async throws -> Bool
    func getBeaconId() -> String
    func clearBeaconId()
}

enum BeaconRepositoryKeys {
    static let beaconIdKey = "beaconIdKey"
}

final class BeaconRepository: BeaconRepositoryProtocol {
    
    private var networkService: NetworkServiceProtocol
    private let keyValueRepository: KeyValueRepositoryProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService.create(),
         keyValueRepository: KeyValueRepositoryProtocol = UserDefaultsKeyValueRepository()) {
        
        self.networkService = networkService
        self.keyValueRepository = keyValueRepository
    }
    
    func createBeacon(input: CreateBeaconRequestInput) async throws -> Bool {
        
        do {
            
            let response = try await networkService.createBeacon(request: input.toNetworkDto())
            let result = response.toDomain()
            setBeaconId(id: result.beaconId)
            return true
            
        } catch {
            
            print("Create Beacon - Domain error: ", error)
            return false
        }
        
    }
    
    func getBeaconId() -> String {
        guard let beaconId: String = keyValueRepository.get(key: BeaconRepositoryKeys.beaconIdKey) else { return "" }
        return beaconId
    }
    
    private func setBeaconId(id: String) {
        keyValueRepository.set(key: BeaconRepositoryKeys.beaconIdKey, value: id)
    }
    
    func clearBeaconId() {
        keyValueRepository.remove(key: BeaconRepositoryKeys.beaconIdKey)
    }
    
}
