//
//  DocumentConfirmViewModel.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 4.3.25.
//

import SwiftUI
import Foundation
import VVUIKit

@Observable
class DocumentConfirmViewModel: BaseViewModel, DocumentConfirmScreenViewModelProtocol {
    private var coordinator: TravelDocumentsCoordinator
    private let saveTravelDocumentsUseCase: SaveTravelDocumentUseCaseProtocol
    private let getLookupUseCase: GetLookupUseCaseProtocol
    
	var document: TravelDocumentDetails = TravelDocumentDetails.empty()
    var fieldValues: [String: String] = [:]
    var fieldErrors: [String: String] = [:]
//    var draftFieldValues: [String: String] = [:]
    var savedDocument: SavedTravelDocument = SavedTravelDocument.empty()
    var lookupOptions: [String: [Option]] = [:]
    var screenState: ScreenState = .loading
    let isEditing: Bool
    var shouldShowPassportExpireWarning: Bool = true
    var scanTravelDocumentUseCase: ScanTravelDocumentUseCaseProtocol
    var input: ScanTravelDocumentInputModel
    var isReplaceImage: Bool = false
    var isConfirmReplace: Bool = false
    var isSecondScan: Bool = false
    var rejectionReasons: [String] = []
	var lookupSource: Lookup = .empty()
    var documentCode: String?
    
    // Multi-citizenship Variables
    var isShowingCitizenshipSelection: Bool = false
    var multiCitizenshipOptions: [String : String] = [:]
    var selectedCitizenship: String?
    var didConfirmCitizenship: Bool = false
    var multiCitizenshipTitle: String {
        "Which passport are you traveling under?"
    }
    var multiCitizenshipDescription: String {
        "We are asking so we can calculate any visa requirements."
    }
    var multiCitizenshipButtonTitle: String {
        "Done"
    }
        
    init(coordinator: TravelDocumentsCoordinator = AppCoordinator.shared.homeTabBarCoordinator.travelDocumentsCoordinator, document: TravelDocumentDetails, isEditing: Bool = false, saveTravelDocumentsUseCase: SaveTravelDocumentUseCaseProtocol = SaveTravelDocumentUseCase(), getLookupUseCase: GetLookupUseCaseProtocol = GetLookupUseCase(), scanTravelDocumentUseCase: ScanTravelDocumentUseCaseProtocol = ScanTravelDocumentUseCase(), input: ScanTravelDocumentInputModel, isReplaceImage: Bool = false, documentCode: String?, shouldDisplayWarning: Bool) {
        self.coordinator = coordinator
        self.document = document
        self.isEditing = isEditing
        self.saveTravelDocumentsUseCase = saveTravelDocumentsUseCase
        self.getLookupUseCase = getLookupUseCase
        self.scanTravelDocumentUseCase = scanTravelDocumentUseCase
        self.isReplaceImage = isReplaceImage
        self.rejectionReasons = document.moderationErrors
        self.documentCode = documentCode
        self.input = input
        self.shouldShowPassportExpireWarning = shouldDisplayWarning
        super.init()
        self.initializeFieldValues()
    }

    var scanDocumentScreenViewModel: ScanDocumentViewModelProtocol {
        return ScanDocumentViewModel(document: documentWithCode, isSecondScan: isSecondScan, isFromConfirmation: true, onCompletion: { url1, url2 in
            DispatchQueue.main.async {
                if !url1.isEmpty {
                    self.updateFieldValue(for: DocumentFields.documentPhotoUrl.rawValue, newValue: url1)
                }
                if !url2.isEmpty {
                    self.updateFieldValue(for: DocumentFields.backPhotoUrl.rawValue, newValue: url2)
                }
            }
            self.isReplaceImage = false
        })
    }
    
    func onReplaceDocument() {
        isConfirmReplace = true
    }

    func onConfirmReplaceDocument() {
        isConfirmReplace = false
        isReplaceImage = true
    }

    func onCancelReplaceDocument() {
        isConfirmReplace = false
    }

    var shouldShowBackButton: Bool {
        return isEditing
    }
    
    var primaryButtonText: String {
        return isEditing ? "Save changes" : "Save document"
    }
    
    var secondaryButtonText: String {
        return isEditing ? "Delete document" : "Cancel"
    }
    
    func secondayBttonAction(){
        if isEditing {
            var isTypeVisa = false
            if let documentTypeCode = fieldValues[DocumentFields.documentTypeCode.rawValue]{
                isTypeVisa = documentTypeCode == "V"
            }
            coordinator.navigationRouter.navigateTo(.deleteDocument(document: document, isTypeVisa: isTypeVisa))
        } else {
            onClose()
        }
    }
    
    private func initializeFieldValues() {
        for field in document.fields.filter({ !($0.value == "" && $0.hidden && !$0.required) }) {
            fieldValues[field.name] = field.value
        }
        //Static fields
        fieldValues[DocumentFields.isMultiCitizenshipCheck.rawValue] = "true"
        selectedCitizenship = fieldValues[DocumentFields.countryOfCitizenship.rawValue]
        fieldValues[DocumentFields.countryOfCitizenship.rawValue] = ""
    }
    
    func binding(for fieldName: String) -> Binding<String> {
        Binding(
            get: { self.fieldValues[fieldName] ?? "" },
            set: { self.fieldValues[fieldName] = $0 }
        )
    }
    
    func isInputValid() -> Bool {
        for field in document.fields {
            if field.required {
                let fieldValue = fieldValues[field.name] ?? ""
                if fieldValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    return false
                }
            }
        }
        return true
    }
    
    func saveTravelDocument() async {
        screenState = .loading
//        draftFieldValues = fieldValues
        do {
            let savedResult = try await UseCaseExecutor.execute({
                try await self.saveTravelDocumentsUseCase.execute(id: self.document.id, input: SaveTravelDocumentInput(fields: self.fieldValues, documentExpirationWarnConfig:  self.shouldShowPassportExpireWarning ? self.document.documentExpirationWarnConfig : nil, documentCombinedRules: self.document.documentCombinedRules))
            })
            self.savedDocument = savedResult
            await executeOnMain({
                screenState = .content
                self.coordinator.navigationRouter.goToRoot()
            })
        }  catch (let error) as VVDomainError {
            if case VVDomainError.validationError(let validationError) = error{
                if validationError.fieldErrors.contains(where: { $0.field == DocumentFields.expireDateWarning.rawValue }) {
                    self.onPassportExpireError()
                }
                if validationError.fieldErrors.contains(where: { $0.field == DocumentFields.visaEntries.rawValue }) {
                    self.onMultiEntryError()
                }
                if let multiCitizenField = validationError.fieldErrors.first(where: {
                    $0.field == DocumentFields.issueCountryCode.rawValue && ($0.isMultiCitizenshipError == true)
                }), let options = multiCitizenField.multiCitizenErrorDetails?.options {
                    self.multiCitizenshipOptions = options
                    self.isShowingCitizenshipSelection = true
                }
                
                if !validationError.fieldErrors.isEmpty{
                    for error in validationError.fieldErrors{
                        self.fieldErrors[error.field] = error.errorMessage
                    }
                }else if !validationError.errors.isEmpty{
                    self.rejectionReasons.append(contentsOf: validationError.errors)
                }else {
                    self.rejectionReasons.append(contentsOf: ["An unexpected error occurred. Please try again later."])
                }
            }else if case VVDomainError.unauthorized = error {
                super.handleError(error)
            } else {
                self.rejectionReasons.append(contentsOf: ["An unexpected error occurred. Please try again later."])
            }
            screenState = .content
        } catch {
            self.rejectionReasons.append(contentsOf: ["An unexpected error occurred. Please try again later."])
            if let error = error as? VVError {
                handleError(error)
            }
            screenState = .content
        }
    }
    
    func updateFieldValue(for fieldName: String, newValue: String) {
        fieldValues[fieldName] = newValue
    }
    
    func onProceed() async {
        if !isInputValid(){
            return
        }
        if selectedCitizenship != nil && didConfirmCitizenship{
            fieldValues[DocumentFields.countryOfCitizenship.rawValue] = selectedCitizenship
        }
        await saveTravelDocument()
    }
    
    func navigateBack() {
        coordinator.navigationRouter.navigateBack()
    }
    
    func onClose() {
        coordinator.navigationRouter.navigateBack()
    }
    
    func onMultiEntryError(){
        coordinator.navigationRouter.navigateTo(.warningMultiEntry(document: document))
    }
    
    func onPassportExpireError(){
        coordinator.navigationRouter.navigateTo(.expireDateWarning(document: document))
    }
    
    func loadLookupOptions() async {
        if let result = await executeUseCase({
            try await self.getLookupUseCase.execute()
        }) {
			self.lookupSource = result
            self.lookupOptions = result.toLookupOptionsDictionary()
        }
        screenState = .content
    }

    func onRefresh() {
        Task{
            if !isEditing{
                await loadDetails()
            }
            await loadLookupOptions()
            await executeOnMain {
                screenState = .content
            }
        }
    }
    
    func onAppear() {
        Task{
            if !isEditing{
                await loadDetails()
            }
            await loadLookupOptions()
            await executeOnMain {
                screenState = .content
            }
        }
    }
    
	func getDropdownOptions(for field: TravelDocumentDetails.Field) -> [VVUIKit.Option] {
        if (field.referenceName == DocumentFields.visaTypes.rawValue), let countryCode = fieldValues[DocumentFields.issueCountryCode.rawValue], !countryCode.isEmpty {
            let visaForCountry = lookupSource.visaTypes.filter { $0.countryCode == countryCode }
            return visaForCountry.map { Option(key: $0.code, value: "\($0.code) \($0.name)") }
		}
		return lookupOptions[field.referenceName] ?? []
	}

    func loadDetails() async {
        if input.ocrValidation { return }
        screenState = .loading
        if let result = await executeUseCase({
            try await self.scanTravelDocumentUseCase.execute(input: self.input)
        }) {
            self.document = result ?? TravelDocumentDetails.empty()
            self.initializeFieldValues()
        }
        screenState = .content
    }

    func confirmDocumentAfterExpiryWarning(){
        self.screenState = .loading
        self.shouldShowPassportExpireWarning = false
        Task {
            await self.executeOnMain {
                self.screenState = .loading
            }
            await Task.yield()
            try? await Task.sleep(nanoseconds: 200_000_000)

            await self.saveTravelDocument()

            await self.executeOnMain {
                self.screenState = .content
            }
        }

    }
    var replaceImagePopupTitle : String {
        "Replace \(document.title) Image"
    }

    var replaceImagePopupMessage : String {
        "Are you sure? this will replace the image associated with the information already entered. Please ensure the new image is in focus and matches the data entered"
    }

    var replaceImagenPopupConfirmTitle : String {
        "Yes, replace image"
    }

    var replaceImagePopupCancelTitle : String {
        "No, cancel"
    }
    
    var documentWithCode: TravelDocuments.Document{
        return TravelDocuments.Document(
            name: "",
            type: "",
            code: self.documentCode ?? "",
            categoryCode: nil,
            categoryId: nil,
            isScanable: self.document.isScanable,
            isCapturable: self.document.isCapturable,
            isTwiceSide: self.document.isTwiceSide,
            isAlreadyUploaded: false,
            scanFormatType: ScanFormatType(scanType: self.document.scanFormatType) ?? .passportOrVisa,
            documentId: "",
            mrzField: .front,
            isMultiCategoryDocument: nil,
            categoryDetails: nil
        )
    }
}
