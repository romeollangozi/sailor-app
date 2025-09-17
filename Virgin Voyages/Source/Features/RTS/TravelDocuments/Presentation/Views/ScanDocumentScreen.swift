//
//  ScanDocumentScreen.swift
//  Virgin Voyages
//
//  Created by Pajtim on 5.3.25.
//

import SwiftUI
import VVUIKit

protocol ScanDocumentViewModelProtocol {
    func uploadPhoto(imageData: Data)
    var document: TravelDocuments.Document { get }
    var overlayFrame: CGRect { get set }
    func descriptionText() -> String
    func dottedFrameHeight() -> CGFloat
    func frameHeight()->CGFloat
    func onScanDismiss()
    var screenState: ScreenState { get set }
    func onAppear()
}

struct ScanDocumentScreen: View {
    @State var viewModel: ScanDocumentViewModelProtocol
    @State var showSettingsAlert: Bool = false
    var onCancel: (() -> Void)?
    
    init(document: TravelDocuments.Document, isSecondScan: Bool = false, isFromConfirmation: Bool = false, firstSideDocumentPhotoId: String? = "") {
        _viewModel = State(wrappedValue: ScanDocumentViewModel(document: document, isSecondScan: isSecondScan, isFromConfirmation: isFromConfirmation, documentPhotoId: firstSideDocumentPhotoId))
    }

    init(viewModel: ScanDocumentViewModelProtocol, onCancel: (() -> Void)? = nil) {
        _viewModel = State(wrappedValue: viewModel)
        self.onCancel = onCancel
    }

    var body: some View {
        DefaultScreenView(state: $viewModel.screenState) {
            ZStack {
                MRZScannerView(viewModel: MRZScannerViewModel()) { image, previewFrame in
                    guard let image = image else { return }
                    if let previewFrame = previewFrame {
                        let croppedImage = cropImageToOverlay(image.normalized(), overlayFrame: viewModel.overlayFrame, previewFrame: previewFrame )
                        guard let imageData = croppedImage.jpegData(compressionQuality: 0.6) else { return }
                        viewModel.uploadPhoto(imageData: imageData)
                    }else{
                        guard let imageData = image.jpegData(compressionQuality: 0.6) else { return }
                        viewModel.uploadPhoto(imageData: imageData)
                    }
                   

                } onCancel: {
                    viewModel.onScanDismiss()
                    onCancel?()
                }
                .overlay {
                    CameraDocumentOverlayView(
                        overlayHeight: viewModel.frameHeight(),
                        description: viewModel.descriptionText(),
                        dottedFrameHeight: viewModel.dottedFrameHeight(),
                        onFrameUpdate: { rect in
                            viewModel.overlayFrame = rect
                        }
                    )
                    .padding(.top, Paddings.defaultVerticalPadding128)
                       
                }
            }
        } onRefresh: {

        }
        .onAppear {
            viewModel.onAppear()
            Task {
                let granted = await checkCameraPermission()
                guard granted else {
                    showSettingsAlert = true
                    return
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .alert("Permission not granted", isPresented: $showSettingsAlert) {
            Button("OK") {
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsURL)
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Hey Sailor! To use this, permission required for camera. Do you wish to open the app's settings?")
        }
    }
}

#Preview {
    ScanDocumentScreen(viewModel: ScanDocumentViewModel(document: TravelDocuments.sample().documentStages.last!.documents.first!))
        .background(.gray)
}
