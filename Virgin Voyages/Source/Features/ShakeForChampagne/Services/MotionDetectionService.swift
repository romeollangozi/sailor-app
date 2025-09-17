//
//  MotionDetectionService.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 6/23/25.
//

import CoreMotion
import Foundation

protocol MotionDetectionServiceProtocol {
    func startMotionDetection()
    func stopMotionDetection()
}

final class MotionDetectionService: MotionDetectionServiceProtocol {
    
    static let shared = MotionDetectionService()
    
    private init() {
        configure()
    }
    
    private let motion = CMMotionManager()
    private var shouldDetectUseCase: GetShouldDetectMotionUseCaseProtocol?
    private var motionDetectionNotificationService: MotionDetectionNotificationService?
    
    // MARK: - Configuration
    private let updateFrequency: Double = 7.0
    private let motionThreshold: Double = 5.3
    private let requiredShakes = 3
    private let shakeTimeout: TimeInterval = 2.0
    
    // MARK: - Shake Detection State
    private var shakeCount = 0
    private var shakeTimer: Timer?
    
    func startMotionDetection() {
        guard let shouldDetectUseCase else {
            print("❌ Missing shouldDetectUseCase dependency.")
            return
        }
        
        if shouldDetectUseCase.execute() {
            startAccelerometer()
        }
    }
    
    func stopMotionDetection() {
        guard motion.isAccelerometerActive else { return }
        
        motion.stopAccelerometerUpdates()
        resetShakeDetection()
       
    }
    
    private func configure(shouldDetectUseCase: GetShouldDetectMotionUseCaseProtocol = GetShouldDetectMotionUseCase(),
                   motionDetectionNotificationService: MotionDetectionNotificationService = .shared) {
        
        self.shouldDetectUseCase = shouldDetectUseCase
        self.motionDetectionNotificationService = motionDetectionNotificationService
        
    }
    
    private func startAccelerometer() {
        
        guard motion.isAccelerometerAvailable else {
            print("❌ Accelerometer is not available on this device")
            return
        }
        
        guard !motion.isAccelerometerActive else {
            print("✅ Accelerometer updates are already active")
            return
        }
        
        motion.accelerometerUpdateInterval = 1.0 / updateFrequency
        
        motion.startAccelerometerUpdates(to: .main) { [weak self] data, error in
            guard let self, let data else { return }
            
            let magnitude = sqrt(
                data.acceleration.x * data.acceleration.x +
                data.acceleration.y * data.acceleration.y +
                data.acceleration.z * data.acceleration.z
            )
            
            if magnitude > self.motionThreshold {
                self.handleShakeDetected()
            }
        }
        
        print("▶️ Started accelerometer updates")
    }
    
    private func handleShakeDetected() {
        guard let motionDetectionNotificationService else {
            print("❌ motionDetectionNotificationService not initialized")
            return
        }
        
        shakeCount += 1
        print("🔁 Shake detected — count: \(shakeCount)")
        
        // Reset the timer on each shake
        shakeTimer?.invalidate()
        shakeTimer = Timer.scheduledTimer(withTimeInterval: shakeTimeout, repeats: false) { [weak self] _ in
            guard let self else { return }
            print("⏱️ Shake timeout reached – resetting count")
            self.resetShakeDetection()
        }
        
        if shakeCount >= requiredShakes {
            print("🎉 Detected \(requiredShakes) shakes! Triggering motion event")
            motionDetectionNotificationService.publish(.didDetectMotion)
            resetShakeDetection()
        }
    }
    
    private func resetShakeDetection() {
        shakeTimer?.invalidate()
        shakeTimer = nil
        shakeCount = 0
        print("♻️ Shake detection state reset")
    }
}
