//
//  SaveTravelDocumentUseCase.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 12.3.25.
//

import Foundation

protocol SaveTravelDocumentUseCaseProtocol {
    func execute(id: String, input: SaveTravelDocumentInput) async throws -> SavedTravelDocument
}

final class SaveTravelDocumentUseCase: SaveTravelDocumentUseCaseProtocol {
    private let saveTravelDocumentRepository: SaveTravelDocumentRepositoryProtocol
    private let rtsCurrentSailorService: RtsCurrentSailorProtocol
	private let currentSailorManager: CurrentSailorManagerProtocol
	private let validator: SaveTravelDocumentValidatorProtocol
	
    init(
        rtsCurrentSailorService: RtsCurrentSailorProtocol = RtsCurrentSailorService.shared,
        saveTravelDocumentRepository: SaveTravelDocumentRepositoryProtocol = SaveTravelDocumentRepository(),
		currentSailorManager: CurrentSailorManagerProtocol = CurrentSailorManager(),
		validator: SaveTravelDocumentValidatorProtocol = SaveTravelDocumentValidator()
    ) {
        self.rtsCurrentSailorService = rtsCurrentSailorService
        self.saveTravelDocumentRepository = saveTravelDocumentRepository
		self.currentSailorManager = currentSailorManager
		self.validator = validator
    }
    
    func execute(id: String, input: SaveTravelDocumentInput) async throws -> SavedTravelDocument {
        let currentRtsSailor = rtsCurrentSailorService.getCurrentSailor()
		guard let currentSailor = currentSailorManager.getCurrentSailor() else {
			throw VVDomainError.unauthorized
		}

        try validator.validate(input: input, debarkDate: currentSailor.debarkDate)
        
        guard let response = try await saveTravelDocumentRepository.saveTravelDocument(reservationGuestId: currentRtsSailor.reservationGuestId, id: id, embarkDate: currentSailor.embarkDate, debarkDate: currentSailor.debarkDate, input: input) else {
            throw VVDomainError.genericError
        }
        
		return response
    }
}

protocol SaveTravelDocumentValidatorProtocol {
	func validate(input: SaveTravelDocumentInput, debarkDate: String) throws
}

final class SaveTravelDocumentValidator: SaveTravelDocumentValidatorProtocol {
	private let dateSubmitFormat = "MMMM dd yyyy"
	private let issueDateFieldName = "issueDate"
	private let expiryDateFieldName = "expiryDate"
    private let expireDateWarning = "expireDateWarning"
	
	func validate(input: SaveTravelDocumentInput, debarkDate: String) throws {
		var fieldErrors: [FieldError] = []
		let fields = input.fields
		if let issueDate = getDateValue(input: fields, fieldName: issueDateFieldName){
			if (isFutureDay(issueDate)) {
				fieldErrors.append(.init(field: issueDateFieldName, errorMessage: "Issue date must be in the past"))
			}
		}
		
		if let expiryDate = getDateValue(input: fields, fieldName: expiryDateFieldName) {
			if isPastDate(expiryDate) {
				fieldErrors.append(.init(field: expiryDateFieldName, errorMessage: "Expiry date must be in the future"))
			} else if let issueDate = getDateValue(input: fields, fieldName: issueDateFieldName), expiryDate < issueDate {
					fieldErrors.append(.init(field: expiryDateFieldName, errorMessage: "Expiry date must be after issue date"))
            } else if let debarkDate = debarkDate.iso8601, expiryDate < debarkDate {
                    fieldErrors.append(.init(field: expiryDateFieldName, errorMessage: "The document expires before or during your voyage. Please provide a valid document."))
            }else if let documentExpire = input.documentExpirationWarnConfig, let monthOffset = documentExpire.documentExpirationInMonths, let debarkDate = Date.fromStringWithFormat(string: debarkDate, format: "yyyy-MM-dd"), isDateEarlierThanOffset(expiryDate, months: monthOffset, from: debarkDate){
                fieldErrors.append(.init(field: expireDateWarning, errorMessage: ""))
                fieldErrors.removeAll { $0.field == expiryDateFieldName }
            }
		}
		
		if !fieldErrors.isEmpty {
			throw VVDomainError.validationError(error: ValidationError(fieldErrors: fieldErrors, errors: []))
		}
	}
	
	private func getDateValue(input: [String:String], fieldName: String) -> Date? {
		if let value = input[fieldName] {
			if let parsedDate = Date.fromStringWithFormat(string: value, format: dateSubmitFormat) {
				return parsedDate
			}
		}
		
		return nil
	}
}

