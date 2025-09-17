//
//  CountryCodePickerViewModel.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 4.7.25.
//

import SwiftUI

@Observable
final class CountryCodePickerViewModel {
    let countries: [Endpoint.GetLookupData.Response.LookupData.Country]
    let priorityCodes = ["GB", "US"]
    
    var searchText: String = ""

    init(countries: [Endpoint.GetLookupData.Response.LookupData.Country]) {
        self.countries = countries
    }

    var displayResults: [Endpoint.GetLookupData.Response.LookupData.Country] {
        let priorityCodes = ["GB", "US"]

        let filtered: [Endpoint.GetLookupData.Response.LookupData.Country]
        if searchText.isEmpty {
            filtered = countries
        } else {
            filtered = countries.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.dialingCode == searchText
            }
        }

        let prioritized = filtered.filter { priorityCodes.contains($0.code) }
        let remaining = filtered.filter { !priorityCodes.contains($0.code) }

        return prioritized + remaining
    }
}
