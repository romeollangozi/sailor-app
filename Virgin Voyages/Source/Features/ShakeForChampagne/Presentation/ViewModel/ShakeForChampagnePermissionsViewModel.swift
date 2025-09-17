//
//  ShakeForChampagnePermissionsViewModel.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 6/27/25.
//

import CoreBluetooth
import UIKit
import Foundation

@Observable class ShakeForChampagnePermissionsViewModel: BaseViewModelV2, ShakeForChampagnePermissionsViewModelProtocol {

    // MARK: - Properties
    private var locationService: LocationServiceProtocol
    private var bluetoothService: BluetoothServiceProtocol
    
    var shouldShowLocationRecoveryAlert: Bool = false
    var shouldShowBluetoothOffAlert: Bool = false
    var shouldShowBluetoothPermissionRecoveryAlert: Bool = false
    
    var onPermissionGranted: VoidCallback?
    
    // MARK: - Initialization
    init(locationService: LocationServiceProtocol = LocationService.shared,
         bluetoothService: BluetoothServiceProtocol = BluetoothService.shared,
         onPermissionGranted: VoidCallback? = nil) {
        
        self.locationService = locationService
        self.bluetoothService = bluetoothService
        self.onPermissionGranted = onPermissionGranted
        super.init()
    }
    
    // MARK: - Methods
    func dismiss() {
        navigationCoordinator.executeCommand(HomeTabBarCoordinator.DismissFullScreenOverlayCommand(pathToDismiss: .shakeForChampagneLanding(orderId: nil)))
    }
    
    func openAppSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(settingsUrl)
    }
    
    func openBluetoothSettings() {
        if let settingsUrl = URL(string: "App-Prefs:root=Bluetooth"),
           UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl)
        } else {
            openAppSettings()
        }
    }
    
    // MARK: - Permission Handling
    
    func checkPermissions() {
        checkLocationAuthorization()
    }
    
    private func checkLocationAuthorization() {
        let status = locationService.getLocationAuthorizationStatus()
        
        switch status {
        case .notDetermined:
            requestLocationPermissions()
        case .denied, .restricted:
            Task { [weak self] in
                guard let self else { return }
				self.shouldShowLocationRecoveryAlert = true
            }
        case .authorizedAlways, .authorizedWhenInUse:
            handleBluetoothPermissionsFlow()
        }
    }
    
    private func requestLocationPermissions() {
        Task { [weak self] in
            
            guard let self else { return }
            
            await self.locationService.requestLocationPermissions()
            self.checkLocationAuthorization()
        }
    }
    
    private func handleBluetoothPermissionsFlow() {
        Task { [weak self] in
            
            guard let self else { return }
            
            await self.bluetoothService.waitForBluetoothReady()
            
            let state = self.bluetoothService.checkBluetoothState()
            
            if state == .poweredOff {
				self.shouldShowBluetoothOffAlert = true
                return
            }
            
            let authStatus: CBManagerAuthorization
            if self.bluetoothService.authorizationStatus == .notDetermined {
                authStatus = await self.bluetoothService.initializeManagerAndRequestPermission()
            } else {
                authStatus = self.bluetoothService.authorizationStatus
            }
            
            switch authStatus {
            case .allowedAlways:
				self.onPermissionGranted?()
            case .denied, .restricted:
				self.shouldShowBluetoothPermissionRecoveryAlert = true
            case .notDetermined:
                break
                
            @unknown default:
                print("Unhandled Bluetooth auth status")
            }
        }
    }
    
}
