//
//  QRCodeScannerView.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 30.10.24.
//

import SwiftUI
import AVFoundation

struct QRCodeScannerView: UIViewControllerRepresentable {
    
    // MARK: - Properties
    var onCodeScanned: (String) -> Void
    @Binding var isScanning: Bool
    
    func makeUIViewController(context: Context) -> ScannerViewController {
        let viewController = ScannerViewController()
        viewController.delegate = context.coordinator
        viewController.isScanning = isScanning  // Initial scanning state
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: ScannerViewController, context: Context) {
        if uiViewController.isScanning != isScanning {
            uiViewController.isScanning = isScanning
            context.coordinator.hasScanned = false
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, onCodeScanned: onCodeScanned)
    }
    
    class Coordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {
        var parent: QRCodeScannerView
        var onCodeScanned: (String) -> Void
        var hasScanned = false
        
        init(_ parent: QRCodeScannerView, onCodeScanned: @escaping (String) -> Void) {
            self.parent = parent
            self.onCodeScanned = onCodeScanned
        }
        
        func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
			
            guard parent.isScanning,
                  !hasScanned,
                  let metadataObject = metadataObjects.first,
                  let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject,
                  let code = readableObject.stringValue else {
                return
            }
            
            hasScanned = true
            
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            
            DispatchQueue.main.async {
                self.parent.isScanning = false
                self.onCodeScanned(code)
            }
        }
    }
}

class ScannerViewController: UIViewController {

    var captureSession: AVCaptureSession?
    var previewLayer: AVCaptureVideoPreviewLayer!
    var delegate: AVCaptureMetadataOutputObjectsDelegate?
    let supportedCodeTypes: [AVMetadataObject.ObjectType] = [.qr]

    var isScanning: Bool = true {
        didSet {
            // Toggle metadata output connection based on scanning state
            if let metadataOutput = captureSession?.outputs.first as? AVCaptureMetadataOutput,
               let connection = metadataOutput.connections.first {
                connection.isEnabled = isScanning
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let session = AVCaptureSession()
        self.captureSession = session

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }

        if session.canAddInput(videoInput) {
            session.addInput(videoInput)
        } else {
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if session.canAddOutput(metadataOutput) {
            session.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(delegate, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = supportedCodeTypes
        } else {
            return
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)

        // Start the camera session on a background thread
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.captureSession?.startRunning()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Stop the capture session when the view disappears
        if captureSession?.isRunning == true {
            captureSession?.stopRunning()
        }
    }
}
