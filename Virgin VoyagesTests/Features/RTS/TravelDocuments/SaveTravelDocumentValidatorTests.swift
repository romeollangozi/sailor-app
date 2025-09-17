//
//  SaveTravelDocumentValidatorTests.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 26.5.25.
//

import XCTest
@testable import Virgin_Voyages

final class SaveTravelDocumentValidatorTests: XCTestCase {
    private var validator: SaveTravelDocumentValidator!

    override func setUp() {
        super.setUp()
        validator = SaveTravelDocumentValidator()
    }

    override func tearDown() {
        validator = nil
        super.tearDown()
    }

    func testValidateWithFutureIssueDateThrowsValidationError() {
        let futureYear = getYear(for: Date()) + 1
        let input = SaveTravelDocumentInput(
            fields: ["issueDate": "December 31 \(futureYear)"],
            documentExpirationWarnConfig: nil,
            documentCombinedRules: []
        )

        do {
            try validator.validate(input: input, debarkDate: "2025-12-31")
            XCTFail("Expected validation error")
        } catch let error as VVDomainError {
            switch error {
            case .validationError(let details):
                XCTAssertTrue(details.fieldErrors.contains {
                    $0.field == "issueDate" && $0.errorMessage == "Issue date must be in the past"
                })
            default:
                XCTFail("Expected validationError")
            }
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testValidateWithExpiryDateBeforeIssueDateThrowsValidationError() {
        let currentYear = getYear(for: Date())
        let input = SaveTravelDocumentInput(
            fields: [
                "issueDate": "January 01 \(currentYear + 1)",
                "expiryDate": "December 31 \(currentYear)"
            ],
            documentExpirationWarnConfig: nil,
            documentCombinedRules: []
        )

        do {
            try validator.validate(input: input, debarkDate: "2025-12-31")
            XCTFail("Expected validation error")
        } catch let error as VVDomainError {
            switch error {
            case .validationError(let details):
                XCTAssertTrue(details.fieldErrors.contains {
                    $0.field == "expiryDate" && $0.errorMessage == "Expiry date must be after issue date"
                })
            default:
                XCTFail("Expected validationError")
            }
        }catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testValidateWithValidDatesDoesNotThrow() {
        let currentYear = getYear(for: Date())
        let input = SaveTravelDocumentInput(
            fields: [
                "issueDate": "January 01 \(currentYear - 1)",
                "expiryDate": "January 01 \(currentYear + 1)"
            ],
            documentExpirationWarnConfig: nil,
            documentCombinedRules: []
        )

        XCTAssertNoThrow(try validator.validate(input: input, debarkDate: "2025-12-31"))
    }

    func testValidateWithInvalidDateFormatDoesNotThrow() {
        let input = SaveTravelDocumentInput(
            fields: ["issueDate": "Invalid Date"],
            documentExpirationWarnConfig: nil,
            documentCombinedRules: []
        )

        // Invalid date format is silently ignored, so no error is expected unless it's logically invalid
        XCTAssertNoThrow(try validator.validate(input: input, debarkDate: "2025-12-31"))
    }

    private func getYear(for date: Date) -> Int {
        return Calendar.current.component(.year, from: date)
    }
    
    func testValidateWithExpiryDateTooCloseToDebarkThrowsExpireDateWarning() {
        
        let input = SaveTravelDocumentInput(
            fields: [
                "issueDate": "January 01 2025",
                "expiryDate": "October 01 2025"
            ],
            documentExpirationWarnConfig: .init(documentExpirationInMonths: 3, title: "", description: ""),
            documentCombinedRules: []
        )

        let debarkDate = "2025-08-19"
        
        do {
            try validator.validate(input: input, debarkDate: debarkDate)
            XCTFail("Expected validation error")
        } catch let error as VVDomainError {
            switch error {
            case .validationError(let details):
                XCTAssertTrue(details.fieldErrors.contains {
                    $0.field == "expireDateWarning" && $0.errorMessage == ""
                })
            default:
                XCTFail("Expected validationError")
            }
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testValidateWithExpiryDateBeforeDebarkDateThrowsValidationError() {
        
        let input = SaveTravelDocumentInput(
            fields: [
                "issueDate": "January 01 2025",
                "expiryDate": "December 01 2025" // Expiry is before debark date
            ],
            documentExpirationWarnConfig: nil,
            documentCombinedRules: []
        )

        let debarkDate = "2025-12-31"

        do {
            try validator.validate(input: input, debarkDate: debarkDate)
            XCTFail("Expected validation error")
        } catch let error as VVDomainError {
            switch error {
            case .validationError(let details):
                XCTAssertTrue(details.fieldErrors.contains {
                    $0.field == "expiryDate" && $0.errorMessage == "The document expires before or during your voyage. Please provide a valid document."
                })
            default:
                XCTFail("Expected validationError")
            }
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
