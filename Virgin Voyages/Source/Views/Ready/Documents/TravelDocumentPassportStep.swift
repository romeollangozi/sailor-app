//
//  TravelDocumentPassportStep.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 6/5/24.
//

import SwiftUI
import PhotosUI

struct TravelDocumentPassportStep: View {
	var authenticationService: AuthenticationServiceProtocol = AuthenticationService.shared
    @Environment(TravelDocumentTask.self) var travel
    @Environment(\.contentSpacing) var spacing
    @State var passport: TravelDocumentTask.Passport
    @State private var saveTask = ScreenTask()
    @State private var deleteTask = ScreenTask()
    @State private var cameraTask = ScreenTask()
    
    @State private var showWarningAlert = false
    @State private var warning: PassportWarning = .none

    
    var body: some View {
        SailableReviewStepScrollable(imageUrl: URL(string: travel.assets.travelDocuments.passport.reviewPage.imageURL)) {
            VStack(alignment: .leading, spacing: spacing * 2) {
                Text(travel.assets.travelDocuments.passport.reviewPage.subTitle)
                    .fontStyle(.largeTitle)
                Text(travel.assets.travelDocuments.passport.reviewPage.description)
                    .fontStyle(.body)
                
                if let sailTask = travel.sailTask, sailTask.isRejected(documentType: passport.type.id) {
                    let rejectedReasonsIds = sailTask.rejectedReasonIds(documentType: passport.type.id)
                    let reasonsText = travel.rejectedReasonsText(from: rejectedReasonsIds)
                    
                    RejectionReasonView(title: sailTask.reasonRejectionText ?? "Reason for rejection", reasons: reasonsText)
                }
                
                ImageCaptureView(task: cameraTask, cameraDevice: .rear) { data in
                    let scan = try await authenticationService.currentSailor().scan(photo: data, documentType: .passport)
                    travel.step = .passport(.init(scan))
                } label: {
                    TravelDocumentPhoto(photo: passport.photo)
                } overlay: {
                    CameraDocumentOverlayView()
                }
                
                VStack(alignment: .leading, spacing: spacing) {
                    buildPassportForms()
                }
                
                VStack(alignment: .leading, spacing: spacing) {
                    Text(travel.assets.travelDocuments.passport.additionalInformationHeader)
                    CountryField(placeholder: "Country of permanent residence", error: travel.fieldErrors[.countryOfResidenceCode], text: Binding(
                        get: { travel.countryName(from: passport.countryOfResidenceCode) },
                        set: { newName in passport.countryOfResidenceCode = travel.countryCode(from: newName) }
                    ), countries: travel.countries)
                    .onChange(of: passport.countryOfResidenceCode) { oldValue, newValue in
                        validateRequiredField(.countryOfResidenceCode, value: newValue, errorMessage: "Country of permanent residence is required")
                    }
                }
                
                VStack(alignment: .leading, spacing: spacing) {
                    TaskButton(title: "Save document", task: saveTask) {
                        if try validatePassportExpiryDate() {
                            warning = .passportExpiresInLessThanSixMonthsFromDebarkation
                        } else {
                            try await 	uploadPassport()
                        }
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .disabled((try? authenticationService.currentSailor().passportSaveDisabled(passport: passport)) == true)

                    if passport.photo.isSaved {
                        TaskButton(title: "Delete document", underline: true, task: deleteTask) {
                            try await authenticationService.currentSailor().delete(passport: passport)
                            // travel.remove(document: passport)
                            try await authenticationService.currentSailor().reload(task: travel)
                            travel.startInterview()
                        }
                        .buttonStyle(TertiaryButtonStyle())
                    } else {
                        Button("Cancel") {
                            travel.startInterview()
                        }
                        .buttonStyle(TertiaryButtonStyle())
                    }
                }
            }
            .disabled(saveTask.disabled || deleteTask.disabled || cameraTask.disabled)
            .navigationDestination(isPresented: $showWarningAlert, destination: {
                displayWarningPage(for: warning)
            })
            .onChange(of: warning, { oldValue, newValue in
                DispatchQueue.main.async {
                    showWarningAlert = newValue != .none
                }
            })
        }
    }
    
    private func uploadPassport() async throws {
        let mediaUrl = try await uploadPassportPhoto(passport)
        let isValid = try await validatePassport(passport, mediaUrl: mediaUrl)
        guard isValid else { return }

        try await savePassport(passport, mediaUrl: mediaUrl)
        travel.step = .saving("Updating", 2.0 / 3.0)
        try await authenticationService.currentSailor().reload(task: travel)
    }
}

//MARK: Passport Warnings
extension TravelDocumentPassportStep {
    private func validatePassportExpiryDate() throws -> Bool {
        let embarkationDate = try authenticationService.currentSailor().reservation.embarkDate
        let isWithin6Months = passport.expiryDate.isWithinMonths(6, of: embarkationDate)
        return isWithin6Months
    }
    
    private func displayWarningPage(for warning: PassportWarning) -> some View {
        switch warning {
        case .passportExpiresInLessThanSixMonthsFromDebarkation:
            return AnyView(displayPassportExpiresWithin6MonthsWarningPage())
        case .none:
            print("Warnign - Attempt to display passport warning while passport warning is .none")
            DispatchQueue.main.async {
                self.warning = .none
            }
            return AnyView(EmptyView())
        }
    }
    
    private func displayPassportExpiresWithin6MonthsWarningPage() -> PassportUploadWarningView {
        
        // Country Name ({DebarkationCountry})
        let asset = travel.assets.travelDocuments.documentExpirationPages
        let debarkPortCode = try? authenticationService.currentSailor().reservation.debarkPortCode
        let debarkPort = travel.lookup.ports.first { $0.code == debarkPortCode }
        let debarkPortCountryCode = debarkPort?.countryCode
        let debarkPortCountry = travel.lookup.countries.first { $0.code == debarkPortCountryCode }
        let debarkCountryName = debarkPortCountry?.name
        
        // Passport link ({CountrysWebsite})
        let linkAsset = travel.assets.portPassportRulesLinks.first { $0.code == debarkPortCode }
        var htmlLink = ""
        if let linkHref = linkAsset?.passportRulesLink, let linkText = linkAsset?.name {
            htmlLink = "<a href=\"\(linkHref)\">\(linkText)</a>"
        }
        
        // Body text with placeholders
        let htmlBody = asset.passport.content
        
        // Body text with replaced parameters
        // Change parameters with optional values, empty string if none found.
        var htmlBodyWithParameters = htmlBody.replacingPlaceholder("DebarkationCountry", with: debarkCountryName.value)
        htmlBodyWithParameters = htmlBodyWithParameters.replacingPlaceholder("CountrysWebsite", with: htmlLink)
        
        let content: PassportWarningAlertViewModel.Content = .init(
            pageTitle: asset.passport.title,
            pageBody: htmlBodyWithParameters,
            actionButtonTitle: asset.goodToTravelText,
            cancelButtonTitle: asset.cancelText)
        let viewModel: PassportWarningAlertViewModel = .init(viewContent: content)
        
        return .init(viewModel: viewModel) {
            warning = .none
            uploadPassport(after: 1.0)
        } onCancelAction: {
            warning = .none
        }
    }
    
    private func uploadPassport(after delay: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            Task {
                try await uploadPassport()
            }
        }
    }
}

extension TravelDocumentPassportStep {
    func buildPassportForms() -> some View {
        VStack(alignment: .leading, spacing: spacing) {
            TextInputField(placeholder: "Given name", error: travel.fieldErrors[.givenName], text: $passport.givenName)
                .textContentType(.givenName)
                .onChange(of: passport.givenName) { _, newValue in
                    validateRequiredField(.givenName, value: newValue, errorMessage: "Given name is required")
                }
            TextInputField(placeholder: "Last name", error: travel.fieldErrors[.surname], text: $passport.surname)
                .textContentType(.familyName)
                .onChange(of: passport.surname) { _, newValue in
                    validateRequiredField(.surname, value: newValue, errorMessage: "Last name is required")
                }
            GenderField(placeholder: "Gender", error: travel.fieldErrors[.gender], text: Binding(
                get: { travel.genderName(from: passport.gender) },
                set: { newValue in passport.gender = travel.genderCode(from: newValue) }
            ), genders: travel.lookup.genders)
            .onChange(of: passport.issueCountryCode) { _, newValue in
                validateRequiredField(.gender, value: newValue, errorMessage: "Gender is required")
            }
            TextInputField(placeholder: "Passport No.", error: travel.fieldErrors[.number], text: $passport.number)
                .keyboardType(.numberPad)
                .onChange(of: passport.number) { _, newValue in
                    validateRequiredField(.number, value: newValue, errorMessage: "Passport no. is required")
                }

            CountryField(placeholder: "Nationality", text: Binding(
                get: { travel.countryName(from: passport.birthCountryCode) },
                set: { newName in passport.birthCountryCode = travel.countryCode(from: newName) }
            ), countries: travel.countries)
            CountryField(placeholder: "Country of issue", error: travel.fieldErrors[.issueCountryCode], text: Binding(
                get: { travel.countryName(from: passport.issueCountryCode) },
                set: { newName in passport.issueCountryCode = travel.countryCode(from: newName) }
            ), countries: travel.countries)
                .onChange(of: passport.issueCountryCode) { _, newValue in
                    validateRequiredField(.issueCountryCode, value: newValue, errorMessage: "Country of issue is required")
                }

            DateInputField(placeholder: "Date of birth", error: try? authenticationService.currentSailor().isFutureDate(date: passport.birthDate) ?? travel.fieldErrors[.birthDate], date: $passport.birthDate)
                .onChange(of: passport.birthDate, {
                    travel.fieldErrors[.birthDate] = nil
                })
            DateInputField(placeholder: "Date of issue", error: try? authenticationService.currentSailor().isFutureDate(date: passport.issueDate) ?? travel.fieldErrors[.issueDate], date: $passport.issueDate)
                .onChange(of: passport.issueDate, {
                    travel.fieldErrors[.issueDate] = nil
                })
            DateInputField(placeholder: "Date of expiry", error: try? authenticationService.currentSailor().expiryDateError(date: passport.expiryDate) ?? travel.fieldErrors[.expiryDate], date: $passport.expiryDate)
                .onChange(of: passport.expiryDate, {
                    travel.fieldErrors[.expiryDate] = nil
                })
        }
    }

    func validateRequiredField(_ field: TravelDocumentTask.PassportField, value: String, errorMessage: String) {
        if value.isEmptyOrWhitespace {
            travel.fieldErrors[field] = errorMessage
            return
        }
        travel.fieldErrors[field] = nil
    }
}

extension TravelDocumentPassportStep {
    func uploadPassportPhoto(_ passport: TravelDocumentTask.Passport) async throws -> URL {
        travel.step = .saving("Uploading", 0)
        return try await authenticationService.currentSailor().fetchMediaUrl(photo: passport.photo)
    }

    func validatePassport(_ passport: TravelDocumentTask.Passport, mediaUrl: URL) async throws -> Bool {
        travel.step = .saving("Validating", 0.5 / 3.0)
        do {
            try await authenticationService.currentSailor().validate(passport: passport, mediaUrl: mediaUrl)
            return true
        } catch {
            travel.step = .passport(passport)
            if let validationError = error as? Endpoint.FieldsValidationError {
                handleFieldErrors(for: passport, fieldErrors: validationError.fieldErrors)
            }
            return false
        }
    }

    func savePassport(_ passport: TravelDocumentTask.Passport, mediaUrl: URL) async throws {
        travel.step = .saving("Saving", 1.0 / 3.0)
        try await authenticationService.currentSailor().save(passport: passport, mediaUrl: mediaUrl)
    }

    func handleFieldErrors(for passport: TravelDocumentTask.Passport, fieldErrors: [Endpoint.FieldsValidationError.FieldError]) {
        for fieldError in fieldErrors {
            if let field = TravelDocumentTask.PassportField(rawValue: fieldError.field) {
                travel.fieldErrors[field] = fieldError.errorMessage
            }
        }
    }
}
