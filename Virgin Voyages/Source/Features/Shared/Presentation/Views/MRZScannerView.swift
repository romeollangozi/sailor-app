//
//  MRZScannerView.swift
//  Virgin Voyages
//
//  Created by Pajtim on 5.3.25.
//

import SwiftUI
import AVFoundation

// MARK: - DocumentScanner View

struct MRZScannerView: UIViewControllerRepresentable {
    var viewModel: MRZScannerViewModelProtocol
    var captureCompletion: (UIImage?, CGRect?) -> Void
    var onCancel: () -> Void

    // MARK: - Coordinator

    class Coordinator: NSObject, AVCapturePhotoCaptureDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var captureCompletion: ((UIImage?, CGRect?) -> Void)?
        var parent: MRZScannerView

        init(parent: MRZScannerView, captureCompletion: @escaping (UIImage?, CGRect?) -> Void) {
            self.parent = parent
            self.captureCompletion = captureCompletion
        }

        func photoOutput(_ output: AVCapturePhotoOutput,
                         didFinishProcessingPhoto photo: AVCapturePhoto,
                         error: Error?) {
            guard let data = photo.fileDataRepresentation(),
                  let image = UIImage(data: data) else {
                captureCompletion?(nil, parent.viewModel.previewLayer.frame)
                return
            }
            
            Task {
                let scaledImage = image
                captureCompletion?(scaledImage, parent.viewModel.previewLayer.frame)
            }
        }

        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            picker.dismiss(animated: true, completion: nil)
            guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
                captureCompletion?(nil, nil)
                return
            }
            captureCompletion?(image, nil)
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self, captureCompletion: captureCompletion)
    }

    // MARK: - Make UIViewController

    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        let previewLayer = viewModel.previewLayer
        previewLayer.frame = viewController.view.frame
        viewController.view.layer.addSublayer(previewLayer)

        let overlay = UIHostingController(rootView: MRZScannerOverlayView(
            onCancel: { onCancel() },
            onCapture: { viewModel.capturePhoto(delegate: context.coordinator) },
            onSwitchCamera: { viewModel.switchCamera() },
            onGallery: { openGallery(from: viewController, coordinator: context.coordinator) }
        ))

        overlay.view.backgroundColor = .clear
        overlay.view.translatesAutoresizingMaskIntoConstraints = false
        viewController.view.addSubview(overlay.view)

        NSLayoutConstraint.activate([
            overlay.view.topAnchor.constraint(equalTo: viewController.view.topAnchor),
            overlay.view.bottomAnchor.constraint(equalTo: viewController.view.bottomAnchor),
            overlay.view.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor),
            overlay.view.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor)
        ])

        viewModel.startSession()
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

    // MARK: - Open Gallery

    private func openGallery(from viewController: UIViewController, coordinator: MRZScannerView.Coordinator) {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = coordinator
        viewController.present(picker, animated: true)
    }
}

// MARK: - DocumentScanner Controller

class MRZScannerController: NSObject, AVCapturePhotoCaptureDelegate {
    private var session: AVCaptureSession
    private var output: AVCapturePhotoOutput
    var previewLayer: AVCaptureVideoPreviewLayer
    private var currentCameraPosition: AVCaptureDevice.Position = .back
    var captureCompletion: ((UIImage?) -> Void)?

    override init() {
        self.session = AVCaptureSession()
        self.output = AVCapturePhotoOutput()
        self.previewLayer = AVCaptureVideoPreviewLayer(session: session)
        super.init()
        setupCamera()
    }

    private func setupCamera() {
        session.beginConfiguration()
        configureInput(for: currentCameraPosition)

        if session.canAddOutput(output) {
            session.addOutput(output)
        }

        session.commitConfiguration()
    }

    private func configureInput(for position: AVCaptureDevice.Position) {
        session.inputs.forEach { session.removeInput($0) }

        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: position),
           let input = try? AVCaptureDeviceInput(device: device) {
            if session.canAddInput(input) {
                session.addInput(input)
            }
        }
    }

    func startSession() {
        DispatchQueue.global(qos: .background).async {
            self.session.startRunning()
        }
    }

    func stopSession() {
        session.stopRunning()
    }

    func capturePhoto(delegate: AVCapturePhotoCaptureDelegate) {
        let settings = AVCapturePhotoSettings()
        output.capturePhoto(with: settings, delegate: delegate)
    }

    func switchCamera() {
        currentCameraPosition = (currentCameraPosition == .back) ? .front : .back
        session.beginConfiguration()
        configureInput(for: currentCameraPosition)
        session.commitConfiguration()
    }

    deinit {
        stopSession()
    }
}
