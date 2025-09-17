//
//  TravelDocumentsCoordinator.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 21.2.25.
//
import SwiftUI
import Foundation
import Combine

enum TravelDocumentsRoute: BaseNavigationRoute {
    case citizenshipCheck
    case citizenshipSelection
    case documentTypeSelection(canNavigateBack: Bool = true)
    case documentScanPreparation(document: TravelDocuments.Document, landing: TravelDocuments)
    case documentDeclarationPreparation(document: TravelDocuments.Document, landing: TravelDocuments)
    case confirmationAlert(document: TravelDocuments.Document, landing: TravelDocuments)
    case twoSideScan(document: TravelDocuments.Document, firstSideDocumentPhotoId: String? = "")
    case documentDetails(details: TravelDocumentDetails, input: ScanTravelDocumentInputModel, isEditing: Bool? = false, documentCode: String)
    case close
    case documentReview
    case postVoyagePlanes
    case warningMultiEntry(document: TravelDocumentDetails)
    case deleteDocument(document: TravelDocumentDetails, isTypeVisa: Bool)
    case expireDateWarning(document: TravelDocumentDetails)
}

enum TravelDocumentsFullScreenRoute: BaseFullScreenRoute {
    case scanDocument(document: TravelDocuments.Document, isSecondScan: Bool = false, firstSideDocumentPhotoId: String? = "")
    case scanErrorAlert(document: TravelDocuments.Document, isSecondScan: Bool = false, input: ScanTravelDocumentInputModel)
    var id: String {
        switch self {
        case .scanDocument:
            return "scanDocument"
        case .scanErrorAlert:
            return "scanErrorAlert"
        }
    }
}

@Observable class TravelDocumentsCoordinator {

    var navigationRouter: NavigationRouter<TravelDocumentsRoute>
    var fullScreenRouter: TravelDocumentsFullScreenRoute?

    init(navigationRouter: NavigationRouter<TravelDocumentsRoute> = .init(), fullScreenRouter: TravelDocumentsFullScreenRoute? = nil) {
        self.navigationRouter = navigationRouter
        self.fullScreenRouter = fullScreenRouter
    }
}
