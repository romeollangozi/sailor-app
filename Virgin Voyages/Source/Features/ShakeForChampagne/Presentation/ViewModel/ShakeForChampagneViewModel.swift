//
//  ShakeForChampagneViewModel.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 6/26/25.
//

import SwiftUI

@Observable
final class ShakeForChampagneViewModel: BaseViewModel, ShakeForChampagneViewModelProtocol {
    
    var isLoading = false
    var errorMessage: String?
    
    // MARK: - Properties
    private var motionDetectionService: MotionDetectionServiceProtocol
    private var locationService: LocationServiceProtocol
    private var bluetoothService: BluetoothServiceProtocol
    private var getShakeForChampagneLandingUseCase: GetShakeForChampagneLandingUseCaseProtocol
    private var createShakeForChampagneOrderUseCase: CreateShakeForChampagneOrderUseCaseProtocol
    private var cancelShakeForChampagneOrderUseCase: CancelShakeForChampagneOrderUseCaseProtocol
    
    // Info:
    // initialOrderId: is the initialOrderId that we get when we enter the flow
    // orderId: is the new order that is updated when we call createShakeForChampagneOrder
    var initialOrderId: String?
    private var orderId: String = ""
    
    var currentScreen: ShakeForChampagneScreenType?
    
    var shakeForChampagne = ShakeForChampagne.empty()
    
    // MARK: - Initialization
    init(motionDetectionService: MotionDetectionServiceProtocol = MotionDetectionService.shared,
         locationService: LocationServiceProtocol = LocationService.shared,
         bluetoothService: BluetoothServiceProtocol = BluetoothService.shared,
         getShakeForChampagneLandingUseCase: GetShakeForChampagneLandingUseCaseProtocol = GetShakeForChampagneLandingUseCase(),
         createShakeForChampagneOrderUseCase: CreateShakeForChampagneOrderUseCaseProtocol = CreateShakeForChampagneOrderUseCase(),
         cancelShakeForChampagneOrderUseCase: CancelShakeForChampagneOrderUseCaseProtocol = CancelShakeForChampagneOrderUseCase(),
         orderId: String?
    ) {
        
        self.motionDetectionService = motionDetectionService
        self.locationService = locationService
        self.bluetoothService = bluetoothService
        self.getShakeForChampagneLandingUseCase = getShakeForChampagneLandingUseCase
        self.createShakeForChampagneOrderUseCase = createShakeForChampagneOrderUseCase
        self.cancelShakeForChampagneOrderUseCase = cancelShakeForChampagneOrderUseCase
        self.initialOrderId = orderId
        
        super.init()
        
        if initialOrderId == nil {
            currentScreen = .bubbleVideo
        } else {
            self.loadShakeForChampagneLanding()
        }
    }
    
    // MARK: - Private Methods
    
    private func loadShakeForChampagneLanding() {
        
        Task { [weak self] in
            
            guard let self else { return }
            
            if let result = await executeUseCase({
                
                try await self.getShakeForChampagneLandingUseCase.execute(orderId: self.initialOrderId)
                
            }) {
                
                await executeOnMain {
                    self.shakeForChampagne = result
                    
                    if self.initialOrderId != nil {
                        switch result.champagneState.state {
                        case .orderCancelled:
                            self.currentScreen = .cancelConfirmation
                        case .orderDelivered:
                            self.currentScreen = .confirmation
                        case .orderInProgress:
                            self.currentScreen = .confirmation
                        case .available:
                            self.currentScreen = .bubbleVideo
                        case .locationNotFound:
                            self.currentScreen = .permissions
                        default:
                            self.currentScreen = .error
                        }
                    }
                    
                }
                
            } else {
                
                await executeOnMain {
                    self.currentScreen = .error
                }
            }
            
        }
    }
    
    private func createShakeForChampagneOrder(quantity: Int) {
        
        Task { [weak self] in
            
            guard let self else { return }
            
            do {
                
                let result = try await UseCaseExecutor.execute {
                    try await self.createShakeForChampagneOrderUseCase.execute(quantity: quantity)
                }
                
                await executeOnMain {
                    self.orderId = result.orderId
                    self.currentScreen = .confirmation
                }
                
            } catch {
                
                await executeOnMain {
                    self.currentScreen = .orderError
                }
            }
            
        }
    }
    
    private func cancelShakeForChampagneOrder() {
        
        isLoading = true
        
        Task { [weak self] in
            
            guard let self else { return }
            
            do {
                
                let _ = try await UseCaseExecutor.execute {
                    try await self.cancelShakeForChampagneOrderUseCase.execute(orderId: self.initialOrderId ?? self.orderId)
                }
                
                await executeOnMain {
                    self.isLoading = false
                    self.currentScreen = .cancelConfirmation
                }
                
            } catch let error as VVDomainError {
                
                await executeOnMain {
                    self.isLoading = false
                    if case VVDomainError.validationError(let validationError) = error {
                        let errorMessage = validationError.errors.joined(separator: "")
                        self.errorMessage = errorMessage
                    } else {
                        self.errorMessage = "Something went wrong. Please try again later."
                    }
                }
                
            } catch {
                
                await executeOnMain {
                    self.isLoading = false
                    self.errorMessage = "Something went wrong. Please try again later."
                }
                
            }
            
        }
    }
    
    private func isLocationEnabled() -> Bool {
        let status = locationService.getLocationAuthorizationStatus()
        return status == .authorizedAlways || status == .authorizedWhenInUse
    }
    
    func isBluetoothEnabled(completion: @escaping (Bool) -> Void) {
        Task {
            await bluetoothService.waitForBluetoothReady()

            let status = bluetoothService.authorizationStatus
            let state = bluetoothService.checkBluetoothState()

            let isEnabled = status == .allowedAlways && state == .poweredOn
            completion(isEnabled)
        }
    }

    // MARK: - Public Interface
    
    func onAppear() {
        motionDetectionService.stopMotionDetection()
        
        if initialOrderId == nil {
            loadShakeForChampagneLanding()
        }
        
    }
    
    func onDisappear() {
        motionDetectionService.startMotionDetection()
    }
    
    func onVideoFinished() {
        
        if shakeForChampagne.champagneState.state != .available {
            currentScreen = .error
            
        } else if isLocationEnabled() {
            
            isBluetoothEnabled { [weak self] isEnabled in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    if isEnabled {
                        self.currentScreen = .order
                    } else {
                        self.currentScreen = .permissions
                    }
                }
            }
            
        } else {
            self.currentScreen = .permissions
        }
        
    }
    
    func onConfirmOrder(quantity: Int) {
        self.createShakeForChampagneOrder(quantity: quantity)
    }
    
    func onPermissionGranted() {
        currentScreen = .bubbleVideo
        loadShakeForChampagneLanding()
    }
    
    func onCancelChampagne() {
        cancelShakeForChampagneOrder()
    }
    
    func onTryAgain() {
        currentScreen = .order
    }
    
    func dismiss() {
        navigationCoordinator.executeCommand(HomeTabBarCoordinator.DismissFullScreenOverlayCommand(pathToDismiss: .shakeForChampagneLanding(orderId: self.initialOrderId)))
    }
    
}
