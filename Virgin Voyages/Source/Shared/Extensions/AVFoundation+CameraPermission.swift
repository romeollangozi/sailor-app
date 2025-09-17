//
//  AVFoundation+CameraPermission.swift
//  Virgin Voyages
//
//  Created by Pajtim on 1.11.24.
//

import Foundation
import AVFoundation

func checkCameraPermission() async -> Bool {
    let cameraStatus = AVCaptureDevice.authorizationStatus(for: .video)

    switch cameraStatus {
    case .authorized:
        return true
    case .notDetermined:
        return await withCheckedContinuation { continuation in
            AVCaptureDevice.requestAccess(for: .video) { granted in
                continuation.resume(returning: granted)
            }
        }
    case .denied, .restricted:
        return false
    @unknown default:
        return false
    }
}
