//
//  TwoSideScanPreparationViewModel.swift
//  Virgin Voyages
//
//  Created by Pajtim on 10.3.25.
//

import Foundation

@Observable
class TwoSideScanPreparationViewModel: BaseViewModel, TwoSideScanPreparationViewModelProtocol {

    private var coordinator: TravelDocumentsCoordinator
    private var scanTravelDocumentUseCase: ScanTravelDocumentUseCaseProtocol
    private var uploadMediaUseCase: UploadMediaUseCaseProtocol

    var document: TravelDocuments.Document = TravelDocuments.Document.empty()
    var isSecondScan: Bool = true

    var shouldShowPhotoPicker = false
    var selectedImageData: Data?
    var documentPhotoId: String
    var documentBackPhotoId: String?

    var screenState: ScreenState = .loading

    init(
        coordinator: TravelDocumentsCoordinator = AppCoordinator.shared.homeTabBarCoordinator.travelDocumentsCoordinator,
        document: TravelDocuments.Document,
        scanTravelDocumentUseCase: ScanTravelDocumentUseCaseProtocol = ScanTravelDocumentUseCase(),
        uploadMediaUseCase: UploadMediaUseCaseProtocol = UploadMediaUseCase(),
        documentPhotoId: String = ""
    ) {
        self.coordinator = coordinator
        self.document = document
        self.scanTravelDocumentUseCase = scanTravelDocumentUseCase
        self.uploadMediaUseCase = uploadMediaUseCase
        self.documentPhotoId = documentPhotoId
    }

    func onScanProceed() {
        coordinator.fullScreenRouter = .scanDocument(document: document, isSecondScan: isSecondScan, firstSideDocumentPhotoId: documentPhotoId)
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
            documentBackPhotoId = photoUrl

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

    private func loadTravelDocumentDetails(imageData: Data) async -> TravelDocumentDetails? {
        let input = ScanTravelDocumentInputModel(
            documentCode: document.code,
            categoryCode: document.categoryCode ?? "",
            documentType: document.type,
            ocrValidation: true,
            photoContent: imageData.base64EncodedString(),
            documentPhotoId: getImageId(from: documentPhotoId),
            documentBackPhotoId: getImageId(from: documentBackPhotoId),
            id: nil
        )

        screenState = .loading
        if let result = await executeUseCase({
            try await self.scanTravelDocumentUseCase.execute(input: input)
        }) {
            return result
        }
        screenState = .content
        return nil
    }

    private func getImageId(from url: String?) -> String? {
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
            categoryCode: "",
            documentType: document.type,
            ocrValidation: false,
            photoContent: "",
            documentPhotoId: documentPhotoId,
            documentBackPhotoId: documentBackPhotoId,
            id: nil
        )

        coordinator.fullScreenRouter = .scanErrorAlert(document: document, isSecondScan: true, input: input)
    }
}
