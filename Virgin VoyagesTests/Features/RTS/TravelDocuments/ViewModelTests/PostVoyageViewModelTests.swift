//
//  PostVoyageViewModelTests.swift
//  Virgin VoyagesTests
//
//  Created by Enxhi Kondakciu on 5.6.25.
//

import XCTest
import VVUIKit
@testable import Virgin_Voyages

@MainActor
final class PostVoyageViewModelTests: XCTestCase {

    var sut: PostVoyageViewModel!

    override func setUp() {
        super.setUp()
        sut = PostVoyageViewModel()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_shouldShowHotelNameField_whenStayTypeIsHotel_returnsTrue() {
        sut.inputPostVoyagePlans.stayTypeCode = StayTypeCode.hotel.rawValue
        XCTAssertTrue(sut.shouldShowHotelNameField)
    }

    func test_shouldShowHotelNameField_whenStayTypeIsNotHotel_returnsFalse() {
        sut.inputPostVoyagePlans.stayTypeCode = StayTypeCode.home.rawValue
        XCTAssertFalse(sut.shouldShowHotelNameField)
    }

    func test_shouldShowFlightFields_whenTransportTypeIsAir_returnsTrue() {
        sut.inputPostVoyagePlans.transportationTypeCode = TransportationTypeCode.air.rawValue
        XCTAssertTrue(sut.shouldShowFlightFields)
    }

    func test_shouldShowFlightFields_whenTransportTypeIsNotAir_returnsFalse() {
        sut.inputPostVoyagePlans.transportationTypeCode = TransportationTypeCode.land.rawValue
        XCTAssertFalse(sut.shouldShowFlightFields)
    }

    func test_isInputValid_whenStayingInWithEmptyAddress_returnsFalse() {
        sut.inputPostVoyagePlans.isStayingIn = true
        sut.inputPostVoyagePlans.stayTypeCode = ""
        sut.inputPostVoyagePlans.addressInfo = nil

        XCTAssertFalse(sut.isInputValid)
    }

    func test_isInputValid_whenStayingInWithValidAddress_returnsTrue() {
        sut.inputPostVoyagePlans.isStayingIn = true
        sut.inputPostVoyagePlans.stayTypeCode = StayTypeCode.hotel.rawValue
        sut.inputPostVoyagePlans.addressInfo = .init(
            line1: "123 St",
            line2: "Apt 4",
            city: "New York",
            countryCode: "US",
            zipCode: "10001",
            stateCode: "NY"
        )

        XCTAssertTrue(sut.isInputValid)
    }

    func test_isInputValid_whenLeavingWithoutTransport_returnsFalse() {
        sut.inputPostVoyagePlans.isStayingIn = false
        sut.inputPostVoyagePlans.transportationTypeCode = ""

        XCTAssertFalse(sut.isInputValid)
    }

    func test_isInputValid_whenLeavingWithAirMissingFlight_returnsFalse() {
        sut.inputPostVoyagePlans.isStayingIn = false
        sut.inputPostVoyagePlans.transportationTypeCode = TransportationTypeCode.air.rawValue
        sut.inputPostVoyagePlans.flightDetails = nil

        XCTAssertFalse(sut.isInputValid)
    }

    func test_isInputValid_whenLeavingWithValidAirFlight_returnsTrue() {
        sut.inputPostVoyagePlans.isStayingIn = false
        sut.inputPostVoyagePlans.transportationTypeCode = TransportationTypeCode.air.rawValue
        sut.inputPostVoyagePlans.flightDetails = .init(
            airlineCode: "AA",
            departureAirportCode: "JFK",
            number: "100"
        )

        XCTAssertTrue(sut.isInputValid)
    }
    
    func test_usStatesOptions_filtersOnlyUSStates() {
        sut.lookupOptions = [
            "states": [
                Option(key: "NY|US", value: "New York"),
                Option(key: "CA|US", value: "California"),
                Option(key: "BC|CA", value: "British Columbia"),
                Option(key: "TX|US", value: "Texas"),
                Option(key: "ON|CA", value: "Ontario")
            ]
        ]

        let result = sut.usStatesOptions

        XCTAssertEqual(result.count, 3)
        XCTAssertTrue(result.contains(where: { $0.key == "NY|US" }))
        XCTAssertTrue(result.contains(where: { $0.key == "CA|US" }))
        XCTAssertTrue(result.contains(where: { $0.key == "TX|US" }))
        XCTAssertFalse(result.contains(where: { $0.key == "BC|CA" }))
        XCTAssertFalse(result.contains(where: { $0.key == "ON|CA" }))
    }
    
    func test_usStatesOptions_whenLookupMissingStates_returnsEmpty() {
        sut.lookupOptions = [:]
        XCTAssertTrue(sut.usStatesOptions.isEmpty)
    }
}
