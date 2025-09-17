//
//  BroadcastService.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 9/10/25.
//

import Foundation
import CoreBluetooth
import CoreLocation

// MARK: - BroadcastServiceProtocol
protocol BroadcastServiceProtocol {
    var isAdvertising: Bool { get }
    var currentBeaconIdentifier: CLBeaconIdentityConstraint? { get }
    
    func startBroadcasting()
    func stopBroadcasting()
}

// MARK: - BroadcastService
class BroadcastService: NSObject, BroadcastServiceProtocol {
    
    static let shared = BroadcastService()
    
    // LAZY initialization - only created when first accessed
    private lazy var peripheralManager: CBPeripheralManager = {
        return CBPeripheralManager(delegate: self, queue: nil, options: nil)
    }()
    
    private let measuredPower: NSNumber = -56
    
    private override init() {
        super.init()
        
        configure()
    }
    
    // MARK: - Public Properties
    private(set) var isAdvertising: Bool = false
    private(set) var currentBeaconIdentifier: CLBeaconIdentityConstraint?
    private var broadcastDetectionNotificationService: BroadcastDetectionNotificationService?
    private var beaconRepository: BeaconRepositoryProtocol?
    
    // MARK: - Public Interface
    
    func startBroadcasting() {
        
        guard let beaconRepository = beaconRepository, !beaconRepository.getBeaconId().isEmpty else { return }
        
        let beaconId = beaconRepository.getBeaconId()
        
        guard let components = BroadcastService.parseBeaconId(beaconId) else {
            print("❌ BroadcastService: Invalid beacon ID format: \(beaconId)")
            return
        }
        
        startBroadcasting(uuid: components.uuid, major: components.major, minor: components.minor)
    }
    
    func stopBroadcasting() {

        guard isAdvertising else {
            print("🛑 BroadcastService: Not currently advertising, nothing to stop")
            return
        }
        
        peripheralManager.stopAdvertising()
        print("🛑 BroadcastService: Stopped broadcasting iBeacon")
        
        isAdvertising = false
        currentBeaconIdentifier = nil
    }
    
    // MARK: - Private Interface
    
    private func configure(broadcastDetectionNotificationService: BroadcastDetectionNotificationService = .shared,
                           beaconRepository: BeaconRepositoryProtocol = BeaconRepository()) {
        
        self.broadcastDetectionNotificationService = broadcastDetectionNotificationService
        self.beaconRepository = beaconRepository
    }
    
    private func startBroadcasting(uuid: String,
                                   major: CLBeaconMajorValue,
                                   minor: CLBeaconMinorValue) {
        
        guard let beaconIdentifier = BroadcastService.createBeaconIdentifier(uuid: uuid, major: major, minor: minor) else {
            print("❌ BroadcastService: Failed to create beacon identifier")
            return
        }
        
        startBroadcasting(with: beaconIdentifier)
    }
    
    private func startBroadcasting(with beaconIdentifier: CLBeaconIdentityConstraint) {
        
        if let current = currentBeaconIdentifier,
           isSameBeacon(current, beaconIdentifier) && isAdvertising {
            return
        }
        
        if isAdvertising {
            stopBroadcasting()
        }
        
        guard peripheralManager.state == .poweredOn else {
            print("❌ BroadcastService: Bluetooth not powered on (state: \(peripheralManager.state.rawValue))")
            return
        }
        
        let legacyRegion = CLBeaconRegion(
            beaconIdentityConstraint: beaconIdentifier,
            identifier: "guest"
        )
        
        let peripheralData = legacyRegion.peripheralData(withMeasuredPower: measuredPower)
        
        guard let advertisementData = peripheralData as? [String: Any] else {
            print("❌ BroadcastService: Failed to create advertisement data")
            return
        }
        
        peripheralManager.startAdvertising(advertisementData)
        currentBeaconIdentifier = beaconIdentifier
        
    }
    
    // MARK: - Helper Methods
    
    private func isSameBeacon(_ current: CLBeaconIdentityConstraint, _ new: CLBeaconIdentityConstraint) -> Bool {
        return current.uuid == new.uuid &&
               current.major == new.major &&
               current.minor == new.minor
    }
    
    // MARK: - Utility Methods
    
    /// Parse beacon ID from backend format: "uuid:major:minor"
    /// Example: "c55b7f82-3d35-11eb-6439-2242cc110001:44378:21199"
    static func parseBeaconId(_ beaconId: String) -> BeaconComponents? {
        let components = beaconId.components(separatedBy: ":")
        
        let uuidString = components[0]
        
        guard let major = CLBeaconMajorValue(components[1]),
              let minor = CLBeaconMinorValue(components[2])
        else {
            return nil
        }
        
        return BeaconComponents(uuid: uuidString, major: major, minor: minor)
    }
    
    /// Create a CLBeaconIdentityConstraint (iOS 13+)
    static func createBeaconIdentifier(uuid: String, major: CLBeaconMajorValue, minor: CLBeaconMinorValue) -> CLBeaconIdentityConstraint? {
        
        guard let proximityUUID = UUID(uuidString: uuid) else {
            print("❌ BroadcastService: Invalid UUID string provided: \(uuid)")
            return nil
        }
        
        return CLBeaconIdentityConstraint(uuid: proximityUUID, major: major, minor: minor)
    }
}

// MARK: - CBPeripheralManagerDelegate
extension BroadcastService: CBPeripheralManagerDelegate {
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        
        switch peripheral.state {
            
        case .poweredOn:
            print("✅ BroadcastService: Bluetooth is ready for advertising")
            broadcastDetectionNotificationService?.publish(.didDetectPeripheralPoweredOn)
            
        case .poweredOff, .unauthorized, .unsupported:
            if isAdvertising {
                isAdvertising = false
                currentBeaconIdentifier = nil
                print("❌ BroadcastService: Advertising stopped due to Bluetooth state change")
            }
            
        default:
            break
        }
    }
    
    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        
        if let error = error {
            print("❌ BroadcastService: Failed to start advertising - \(error.localizedDescription)")
            isAdvertising = false
            currentBeaconIdentifier = nil
        } else {
            print("✅ BroadcastService: Successfully started advertising")
            isAdvertising = true
        }
        
    }
    
}
