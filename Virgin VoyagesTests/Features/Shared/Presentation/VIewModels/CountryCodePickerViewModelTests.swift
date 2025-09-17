//
//  CountryCodePickerViewModelTests.swift
//  Virgin VoyagesTests
//
//  Created by Enxhi Kondakciu on 1.7.25.
//

import XCTest
@testable import Virgin_Voyages

final class CountryCodePickerViewModelTests: XCTestCase {

    func testDisplayResults_withEmptySearch_showsUKAndUSOnTop() {
        let countries = [
            Endpoint.GetLookupData.Response.LookupData.Country(name: "Germany", code: "DE", threeLetterCode: "DEU", dialingCode: "49"),
            Endpoint.GetLookupData.Response.LookupData.Country(name: "United Kingdom", code: "GB", threeLetterCode: "GBR", dialingCode: "44"),
            Endpoint.GetLookupData.Response.LookupData.Country(name: "United States", code: "US", threeLetterCode: "USA", dialingCode: "1"),
            Endpoint.GetLookupData.Response.LookupData.Country(name: "France", code: "FR", threeLetterCode: "FRA", dialingCode: "33")
        ]
        let viewModel = CountryCodePickerViewModel(countries: countries)

        let results = viewModel.displayResults

        XCTAssertEqual(results.first?.code, "GB")
        XCTAssertEqual(results.dropFirst().first?.code, "US")
        XCTAssertEqual(results.count, 4)
    }

    func testDisplayResults_withSearchText_filtersCorrectly() {
        let countries = [
            Endpoint.GetLookupData.Response.LookupData.Country(name: "Germany", code: "DE", threeLetterCode: "DEU", dialingCode: "49"),
            Endpoint.GetLookupData.Response.LookupData.Country(name: "United States", code: "US", threeLetterCode: "USA", dialingCode: "1")
        ]
        let viewModel = CountryCodePickerViewModel(countries: countries)
        viewModel.searchText = "Ger"

        let results = viewModel.displayResults
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first?.code, "DE")
    }
    
    func testDisplayResults_withSearchTextMatchingUKUS_showsThemOnTop() {
        let countries = [
            Endpoint.GetLookupData.Response.LookupData.Country(name: "Germany", code: "DE", threeLetterCode: "DEU", dialingCode: "49"),
            Endpoint.GetLookupData.Response.LookupData.Country(name: "United Kingdom", code: "GB", threeLetterCode: "GBR", dialingCode: "44"),
            Endpoint.GetLookupData.Response.LookupData.Country(name: "United States", code: "US", threeLetterCode: "USA", dialingCode: "1"),
            Endpoint.GetLookupData.Response.LookupData.Country(name: "Uganda", code: "UG", threeLetterCode: "UGA", dialingCode: "256")
        ]
        
        let viewModel = CountryCodePickerViewModel(countries: countries)
        viewModel.searchText = "U"

        let results = viewModel.displayResults

        XCTAssertEqual(results.count, 3)
        XCTAssertEqual(results[0].code, "GB")
        XCTAssertEqual(results[1].code, "US")
        XCTAssertEqual(results[2].code, "UG")
    }
}
