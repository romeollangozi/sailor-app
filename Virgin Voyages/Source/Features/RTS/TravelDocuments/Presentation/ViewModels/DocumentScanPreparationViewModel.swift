//
//  DocumentScanPreparationViewModel.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 24.2.25.
//

import SwiftUI
import Foundation

@Observable
class DocumentScanPreparationViewModel: BaseViewModel, DocumentScanPreparationScreenViewModelProtocol {

    private var coordinator: TravelDocumentsCoordinator
    var document: TravelDocuments.Document = TravelDocuments.Document.empty()
    var landing: TravelDocuments
    var scanTravelDocumentUseCase: ScanTravelDocumentUseCaseProtocol
    var uploadMediaUseCase: UploadMediaUseCaseProtocol
    var shouldShowPhotoPicker = false
    var selectedImageData: Data?
    var documentPhotoId: String = ""
    var documentBackPhotoId: String?
    var documentName: String {
        if document.code == DocumentType.birthCertificate.rawValue {
            return "Birth Certificate"
        }
        if document.code == DocumentType.driverLicense.rawValue {
            return "Driver's License"
        }
        return document.name
    }
    var screenState: ScreenState = .loading

    init(coordinator: TravelDocumentsCoordinator = AppCoordinator.shared.homeTabBarCoordinator.travelDocumentsCoordinator, document: TravelDocuments.Document, landing: TravelDocuments, scanTravelDocumentUseCase: ScanTravelDocumentUseCaseProtocol = ScanTravelDocumentUseCase(), uploadMediaUseCase: UploadMediaUseCaseProtocol = UploadMediaUseCase()) {
        self.coordinator = coordinator
        self.document = document
        self.landing = landing
        self.scanTravelDocumentUseCase = scanTravelDocumentUseCase
        self.uploadMediaUseCase = uploadMediaUseCase
    }

    func onScanProceed() {
        coordinator.fullScreenRouter = .scanDocument(document: document)
    }

    func navigateBack() {
        coordinator.navigationRouter.navigateBack()
    }

    func onClose() {
        coordinator.navigationRouter.navigateTo(.close)
    }

    func onAppear() {
        screenState = .content
    }

    func onRefresh() {
        screenState = .content
    }
    
    func onUploadDocumentFromMedia() {
        shouldShowPhotoPicker = true
    }
    
    func uploadPhoto(imageData: Data) {
        Task {
            guard let photoUrl = await uploadMedia(imageData: imageData) else {
                showErrorAlert()
                return
            }
            
            documentPhotoId = photoUrl
            
            if document.isTwiceSide{
                coordinator.navigationRouter.navigateTo(.twoSideScan(document: document, firstSideDocumentPhotoId: documentPhotoId))
                return
            }

            if let details = await loadTravelDocumentDetails(imageData: imageData) {
                coordinator.navigationRouter.navigateTo(.documentDetails(details: details, input: ScanTravelDocumentInputModel.empty(), documentCode: document.code))
            }
        }
    }
    
    private func uploadMedia(imageData: Data) async -> String? {
        screenState = .loading
        if let result = await executeUseCase({
            try await self.uploadMediaUseCase.execute(imageData: imageData)
        }) {
            return result
        }
        screenState = .content
        return nil
    }

    fileprivate func loadTravelDocumentDetails(imageData: Data) async -> TravelDocumentDetails? {
        let input = ScanTravelDocumentInputModel(
            documentCode: document.code,
            categoryCode: document.categoryCode ?? "",
            documentType: document.type,
            ocrValidation: true,
            photoContent: document.isScanable ? imageData.base64EncodedString() : "",
            documentPhotoId: getImageId(from: documentPhotoId),
            documentBackPhotoId: getImageId(from: documentBackPhotoId),
            id: nil
        )

        await executeOnMain({
            screenState = .loading
        })
        do {
            let result = try await UseCaseExecutor.execute {
                try await self.scanTravelDocumentUseCase.execute(input: input)
            }
            await executeOnMain({
                screenState = .content
            })

            return result
        }catch {
            await executeOnMain({
                screenState = .content
            })
            switch error {
            case VVDomainError.unauthorized:
                super.handleError(error as! VVError)
            default:
                showErrorAlert()
            }
            return nil
        }
        
    }

    fileprivate func getImageId(from url: String?) -> String? {
        return url?.components(separatedBy: "/").last
    }

    override func handleError(_ error: VVError) {
        if let error = error as? VVDomainError {
            switch error {
            case .validationError, .genericError:
                showErrorAlert()
            default:
                super.handleError(error)
            }
        } else {
            super.handleError(error)
        }
    }
    
    private func showErrorAlert() {
        let input = ScanTravelDocumentInputModel(
            documentCode: document.code,
            categoryCode: document.categoryCode ?? "",
            documentType: document.type,
            ocrValidation: false,
            photoContent: "",
            documentPhotoId: getImageId(from: documentPhotoId),
            documentBackPhotoId: getImageId(from: documentBackPhotoId),
            id: nil
        )

        coordinator.fullScreenRouter = .scanErrorAlert(document: document, isSecondScan: false, input: input)
    }
}
