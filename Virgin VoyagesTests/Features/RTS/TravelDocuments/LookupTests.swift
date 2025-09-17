//
//  LookupTests.swift
//  Virgin VoyagesTests
//
//  Created by Enxhi Kondakciu on 5.6.25.
//

import XCTest
@testable import Virgin_Voyages

final class LookupTests: XCTestCase {

    func testToLookupOptionsDictionary_keysExist() {
        let lookup = makeMockLookup()
        let result = lookup.toLookupOptionsDictionary()

        let expectedKeys = [
            "airlines", "airports", "cardTypes", "cities", "countries",
            "documentTypes", "genders", "languages", "paymentModes",
            "ports", "rejectionReasons", "relations", "states", "visaEntries",
            "visaTypes", "postCruiseAddressTypes", "postCruiseTransportationOptions",
            "documentCategories"
        ]

        for key in expectedKeys {
            XCTAssertNotNil(result[key], "Expected key '\(key)' to exist")
        }
    }

    func testToLookupOptionsDictionary_countryOrdering() {
        let lookup = makeMockLookup()
        let result = lookup.toLookupOptionsDictionary()

        let countries = result["countries"]?.map { $0.key }
        XCTAssertEqual(countries?.prefix(2), ["GB", "US"], "UK and US should be the first two countries")
    }

    // MARK: - Mocks

    private func makeMockLookup() -> Lookup {
        return Lookup(
            airlines: [Lookup.Airline(code: "AA", name: "American Airlines")],
            airports: [Lookup.Airport(name: "JFK Airport", code: "JFK", cityId: "1", cityName: "New York")],
            cardTypes: [Lookup.CardType(referenceId: "1", name: "Visa", image: .init(src: "visa.png", alt: "Visa"))],
            cities: [Lookup.City(name: "New York", id: "1", countryCode: "US")],
            countries: [
                Lookup.Country(name: "United Kingdom", code: "GB", threeLetterCode: "GBR", dialingCode: "44"),
                Lookup.Country(name: "United States", code: "US", threeLetterCode: "USA", dialingCode: "1"),
                Lookup.Country(name: "France", code: "FR", threeLetterCode: "FRA", dialingCode: "33")
            ],
            documentTypes: [Lookup.DocumentType(code: "P", name: "Passport")],
            genders: [Lookup.Gender(name: "Male", code: "M")],
            languages: [Lookup.Language(code: "en", name: "English")],
            paymentModes: [Lookup.PaymentMode(id: "1", name: "Credit Card")],
            ports: [Lookup.Port(code: "MIA", name: "Miami Port", countryCode: "US")],
            rejectionReasons: [Lookup.RejectionReason(rejectionReasonId: "1", name: "Invalid Document")],
            relations: [Lookup.Relation(code: "SP", name: "Spouse")],
            states: [Lookup.State(code: "NY", countryCode: "US", name: "New York")],
            visaEntries: [Lookup.VisaEntry(code: "M", name: "Multiple")],
            visaTypes: [Lookup.VisaType(code: "T1", name: "Tourist", countryCode: "US")],
            postCruiseAddressTypes: [Lookup.PostCruiseAddressType(name: "Home", code: "HOME")],
            postCruiseTransportationOptions: [Lookup.PostCruiseTransportationOption(name: "Taxi", code: "TAXI")],
            documentCategories: [Lookup.DocumentCategory(id: "1", code: "DOC", name: "General", typeCode: "G")]
        )
    }
}
