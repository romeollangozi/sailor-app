//
//  BluetoothService.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 7/3/25.
//

import CoreBluetooth
import Foundation

protocol BluetoothServiceProtocol {
    var authorizationStatus: CBManagerAuthorization { get }
    func checkBluetoothState() -> CBManagerState
    func requestBluetoothPermission() async -> CBManagerAuthorization
    func waitForBluetoothReady() async
    func initializeManagerAndRequestPermission() async -> CBManagerAuthorization
}

class BluetoothService: NSObject, BluetoothServiceProtocol {
    
    static let shared = BluetoothService()
    
    private override init() {
        super.init()
    }
    
    private lazy var centralManager: CBCentralManager = {
        return CBCentralManager(delegate: self, queue: .main)
    }()
    
    private var permissionContinuation: CheckedContinuation<CBManagerAuthorization, Never>?
    private var initializationContinuation: CheckedContinuation<Void, Never>?
    
    // MARK: - Public Interface
    var authorizationStatus: CBManagerAuthorization {
        return CBCentralManager.authorization
    }
    
    func checkBluetoothState() -> CBManagerState {
        return centralManager.state
    }
    
    func waitForBluetoothReady() async {
        await waitForManagerInitialization()
    }
    
    func initializeManagerAndRequestPermission() async -> CBManagerAuthorization {
        // If already determined, return immediately
        guard authorizationStatus == .notDetermined else {
            return authorizationStatus
        }
        
        // Then request permission
        return await requestBluetoothPermission()
    }
    
    private func waitForManagerInitialization() async {
        // If manager is already powered on or off, it's initialized
        if centralManager.state != .unknown {
            return
        }
        
        await withCheckedContinuation { continuation in
            initializationContinuation = continuation
            // Access centralManager to trigger initialization
            _ = centralManager.state
        }
    }
    
    func requestBluetoothPermission() async -> CBManagerAuthorization {
        guard authorizationStatus == .notDetermined else {
            return authorizationStatus
        }
        
        return await withCheckedContinuation { continuation in
            permissionContinuation = continuation
            
            // Trigger permission dialog by scanning
            centralManager.scanForPeripherals(withServices: nil)
        }
    }
}

// MARK: - CBCentralManagerDelegate
extension BluetoothService: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        // Handle initialization completion
        if let continuation = initializationContinuation {
            continuation.resume()
            initializationContinuation = nil
        }
        
        // Handle permission completion
        if let continuation = permissionContinuation, authorizationStatus != .notDetermined {
            continuation.resume(returning: authorizationStatus)
            permissionContinuation = nil
        }
    }
    
    func centralManager(_ central: CBCentralManager,
                        didDiscover peripheral: CBPeripheral,
                        advertisementData: [String: Any],
                        rssi RSSI: NSNumber) {
        // Not needed for permission handling
    }
}
