//
//  ScanDocumentViewModel.swift
//  Virgin Voyages
//
//  Created by Pajtim on 7.3.25.
//

import Foundation

@Observable
class ScanDocumentViewModel: BaseViewModel, ScanDocumentViewModelProtocol {

	private var coordinator: TravelDocumentsCoordinator
	var document: TravelDocuments.Document = TravelDocuments.Document.empty()
	var screenState: ScreenState = .loading
	var scanTravelDocumentUseCase: ScanTravelDocumentUseCaseProtocol
	var documentPhotoId: String?
	var documentBackPhotoId: String?
	var isSecondScan: Bool = false
	var uploadMediaUseCase: UploadMediaUseCaseProtocol
    var isFromConfirmation: Bool = false
    var onCompletion: ((String, String) -> Void)?
    var overlayFrame: CGRect = .zero

    init(coordinator: TravelDocumentsCoordinator = AppCoordinator.shared.homeTabBarCoordinator.travelDocumentsCoordinator, scanTravelDocumentUseCase: ScanTravelDocumentUseCaseProtocol = ScanTravelDocumentUseCase(), document: TravelDocuments.Document, isSecondScan: Bool = false, uploadMediaUseCase: UploadMediaUseCaseProtocol = UploadMediaUseCase(), isFromConfirmation: Bool = false, documentPhotoId: String? = nil, onCompletion: ((String, String) -> Void)? = nil) {
        self.coordinator = coordinator
        self.scanTravelDocumentUseCase = scanTravelDocumentUseCase
        self.document = document
        self.isSecondScan = isSecondScan
        self.uploadMediaUseCase = uploadMediaUseCase
        self.isFromConfirmation = isFromConfirmation
        self.onCompletion = onCompletion
        self.documentPhotoId = documentPhotoId
    }


	func onAppear() {
		screenState = .content
	}

	private func uploadMedia(imageData: Data) async -> String? {
        await executeOnMain {
            screenState = .loading
        }
		if let result = await executeUseCase({
			try await self.uploadMediaUseCase.execute(imageData: imageData)
		}) {
            await executeOnMain {
                screenState = .content
            }
			return result
		}
        await executeOnMain {
            screenState = .content
        }
		return nil
	}

    func uploadPhoto(imageData: Data) {
        Task {
            guard let photoUrl = await uploadMedia(imageData: imageData) else {
                onScanDismiss()
                showErrorAlert()
                return
            }
            await handlePostUploadNavigation(photoUrl: photoUrl, imageData: imageData)
        }
    }

    func handlePostUploadNavigation(photoUrl: String, imageData: Data) async {
        isSecondScan ? (self.documentBackPhotoId = photoUrl) : (self.documentPhotoId = photoUrl)

        if isFromConfirmation {
            onScanDismiss()
            onCompletion?(documentPhotoId ?? "", documentBackPhotoId ?? "")
            return
        }
        
        if document.isTwiceSide, !isSecondScan {
            onScanDismiss()
            coordinator.navigationRouter.navigateTo(.twoSideScan(document: document, firstSideDocumentPhotoId: documentPhotoId))
            return
        }

        if let details = await loadTravelDocumentDetails(imageData: imageData) {
            onScanDismiss()
            coordinator.navigationRouter.navigateTo(.documentDetails(details: details, input: ScanTravelDocumentInputModel.empty(), documentCode: document.code))
        }
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
                onScanDismiss()
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

	func dottedFrameHeight() -> CGFloat {
        
        if document.scanFormatType == .capturable || document.scanFormatType == .nonScanabled{
            return 0
        }
        
		if document.scanFormatType == .cardFormatTwoSides, !isSecondScan {
			return 0
		}
        
		return document.scanFormatType == .passportOrVisa ? 50 : 80
	}
    
    func frameHeight() -> CGFloat {
        if document.code == DocumentType.birthCertificate.rawValue {
            return 500
        }
        return 250
    }

	func descriptionText() -> String {
       
        if document.code == DocumentType.driverLicense.rawValue{
            return "Take a photo of the front of your licence ensuring it fits within the box."
        }
        
		if document.scanFormatType == .cardFormatTwoSides, !isSecondScan {
			return "Scan the front of your document"
		}

		if isSecondScan {
			return "Please scan the back of your document"
		}
        
        if document.scanFormatType == .capturable || document.scanFormatType == .nonScanabled{
            return "Position your document within the box"
        }
        
		return "Position your document within the box with the code within the dotted area."
	}

	func onScanDismiss() {
		coordinator.fullScreenRouter = nil
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

        coordinator.fullScreenRouter = .scanErrorAlert(document: document, isSecondScan: isSecondScan, input: input)
	}
}
