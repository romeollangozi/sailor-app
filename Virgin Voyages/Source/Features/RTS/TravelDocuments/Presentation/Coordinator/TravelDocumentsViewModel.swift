//
//  TravelDocumentsViewModel.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 21.2.25.
//

import SwiftUI
import VVUIKit

extension TravelDocumentsViewModel {
    struct NavigationSharedViewData {
        var shouldDisplayWarningForPassportExpire: Bool = true
    }
}

@Observable class TravelDocumentsViewModel: @preconcurrency CoordinatorNavitationDestinationViewProvider {
    var onDismiss: () -> Void = {}
    
    var navigationSharedData: NavigationSharedViewData = .init()
    var didSelectCitizenship: Bool = false

    init(onDismiss: @escaping () -> Void) {
        self.onDismiss = onDismiss
    }
    
    private var navigationRouter: NavigationRouter<TravelDocumentsRoute> {
        return AppCoordinator.shared.homeTabBarCoordinator.travelDocumentsCoordinator.navigationRouter
    }

    var fullScreenRouter: TravelDocumentsFullScreenRoute? {
        get {
            return AppCoordinator.shared.homeTabBarCoordinator.travelDocumentsCoordinator.fullScreenRouter
        }
        set {
            AppCoordinator.shared.homeTabBarCoordinator.travelDocumentsCoordinator.fullScreenRouter = newValue
        }
    }

    var navigationPath: NavigationPath {
        get {
            return navigationRouter.navigationPath
        }
        set {
            navigationRouter.navigationPath = newValue
        }
    }

    func navigateBack() {
        navigationRouter.navigateBack()
    }
    
    @MainActor
    func destinationView(for navigationRoute: any BaseNavigationRoute) -> AnyView {
        guard let travelDocsNavigationRoute = navigationRoute as? TravelDocumentsRoute  else { return AnyView(Text("View not supported")) }
        switch travelDocsNavigationRoute {
        case .citizenshipCheck:
            return AnyView(
                CitizenshipCheckScreen()
            )
        case .citizenshipSelection:
            return AnyView(
                CitizenshipSelectionScreen(viewModel: CitizenshipSelectionViewModel())
                    .navigationBarBackButtonHidden(true)
            )
        case .documentTypeSelection(let canNavigateBack):
            return AnyView(
                DocumentTypeSelectionScreen(canNavigateBack: canNavigateBack)
                    .navigationBarBackButtonHidden(true)
            )
        case .documentScanPreparation(let document, let landing):
            return AnyView(
                DocumentScanPreparationScreen(document: document, landing: landing)
                    .navigationBarBackButtonHidden(true)
            )
        case .documentDeclarationPreparation(let document, let landing):
            return AnyView(
                DocumentDeclarationPreparationScreen(document: document, landing: landing)
                    .navigationBarBackButtonHidden(true)
            )
        case .confirmationAlert(let document, let landing):
            return AnyView(
                ConfirmOrReplaceDocumentScreen(document: document, landing: landing)
                    .navigationBarBackButtonHidden(true)
            )
        case .close:
            close()
            return AnyView(EmptyView().background(Color.softYellow))
        case .twoSideScan(let document, let firstSideDocumentPhotoId):
            return AnyView(
                TwoSideScanPreparationScreen(document: document, firstDocumentPhotoId: firstSideDocumentPhotoId ?? "")
                    .navigationBarBackButtonHidden(true)
            )
        case .documentDetails(let details, let input, let isEditing, let documentCode):
            return AnyView(
                DocumentConfirmScreen(shouldShowPassportExpire: navigationSharedData.shouldDisplayWarningForPassportExpire, document: details, input: input, isEditing: isEditing ?? false, documentCode: documentCode)
                    .navigationBarBackButtonHidden(true)
                )
        case .documentReview:
            return AnyView(
                DocumentReviewScreen()
                    .navigationBarBackButtonHidden(true)
            )
        case .warningMultiEntry(let document):
            return AnyView(
                WarningMultiEntryVisaScreen(document: document)
                    .navigationBarBackButtonHidden(true)
            )
        case .deleteDocument(let document, let isTypeVisa):
            return AnyView(
                DeleteDocumentScreen(document: document, isTypeVisa: isTypeVisa)
                    .navigationBarBackButtonHidden(true)
            )
        case .postVoyagePlanes:
            return AnyView(
                PostVoyagePlansScreen()
                    .navigationBarBackButtonHidden(true)
            )
        case .expireDateWarning(document: let document):
            return AnyView(
                WarningPassportExpireScreen(document: document, didTapImGoodToTravel: { [weak self] in
                    guard let self else { return }
                    navigationSharedData.shouldDisplayWarningForPassportExpire = false
                    navigateBack()
                })
                    .navigationBarBackButtonHidden(true)
            )
        }
    }

    func destinationView(for fullScreenRoute: any BaseFullScreenRoute) -> AnyView {
        guard let travelDocumentsFullScreenRoute = fullScreenRoute as? TravelDocumentsFullScreenRoute  else { return AnyView(Text("View route not supported")) }
        switch travelDocumentsFullScreenRoute {
        case .scanDocument(let document, let isSecondScan, let firstSideDocumentPhotoId):
            return AnyView(
                ScanDocumentScreen(document: document, isSecondScan: isSecondScan, firstSideDocumentPhotoId: firstSideDocumentPhotoId)
                    .navigationBarBackButtonHidden(true)
            )
        case .scanErrorAlert(let document, let isSecondScan, let input):
            return AnyView(
                self.showFailedScanModal(document: document, isSecondScan: isSecondScan, input: input)
            )
        }
    }

    func showFailedScanModal(document: TravelDocuments.Document, isSecondScan: Bool, input: ScanTravelDocumentInputModel) -> AnyView {
        return AnyView(
            VVSheetModal(
                title: "There was a problem with that image",
                subheadline: "We're excited too—but this image is too blurry for us to verify. Please try again with a clearer image.",
                primaryButtonText: "Try again",
                secondaryButtonText: "Fill in details manually",
                imageName: nil,
                primaryButtonAction: {
                    self.fullScreenRouter = nil
                    self.fullScreenRouter = .scanDocument(document: document, isSecondScan: isSecondScan)
                },
                secondaryButtonAction: {
                    self.fullScreenRouter = nil
                    
                    self.navigationRouter.navigateTo(.documentDetails(details: TravelDocumentDetails.empty(), input: input, documentCode: document.code))
                },
                dismiss: {
                    self.fullScreenRouter = nil
                },
                primaryButtonStyle: PrimaryButtonStyle(),
                secondaryButtonStyle: TertiaryButtonStyle()
            )
            .edgesIgnoringSafeArea(.all)
            .navigationBarBackButtonHidden(true)
            .background(.clear)
        )
    }

    func close() {
        onDismiss()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.navigationRouter.goToRoot()
        }
    }
}
