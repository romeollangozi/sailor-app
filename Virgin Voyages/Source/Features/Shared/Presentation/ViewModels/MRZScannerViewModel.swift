//
//  MRZScannerViewModel.swift
//  Virgin Voyages
//
//  Created by Pajtim on 6.3.25.
//

import Foundation
import AVFoundation

protocol MRZScannerViewModelProtocol {
    func startSession()
    func stopSession()
    func capturePhoto(delegate: AVCapturePhotoCaptureDelegate)
    func switchCamera()
    var previewLayer: AVCaptureVideoPreviewLayer { get }
}

@Observable class MRZScannerViewModel: MRZScannerViewModelProtocol {
    var cameraController = MRZScannerController()

    func startSession() {
        cameraController.startSession()
    }

    func stopSession() {
        cameraController.stopSession()
    }

    func capturePhoto(delegate: AVCapturePhotoCaptureDelegate) {
        cameraController.capturePhoto(delegate: delegate)
    }

    func switchCamera() {
        cameraController.switchCamera()
    }

    var previewLayer: AVCaptureVideoPreviewLayer {
        return cameraController.previewLayer
    }
}
