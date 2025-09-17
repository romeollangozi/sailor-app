//
//  CountryCodePicker.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 5/29/24.
//

import SwiftUI

enum CountryCodePickerMode {
	case dialingCode
	case country
}

struct CountryCodePicker: View {
    @Bindable var viewModel: CountryCodePickerViewModel
    var mode: CountryCodePickerMode
    var action: (Endpoint.GetLookupData.Response.LookupData.Country) -> Void

    var body: some View {
        List {
            ForEach(viewModel.displayResults, id: \.code) { country in
                if let title = title(country: country) {
                    Button(title) {
                        action(country)
                    }
                }
            }
        }
        .navigationTitle(mode == .country ? "Country" : "Dialing Code")
        .navigationBarTitleDisplayMode(.inline)
        .fontStyle(.body)
        .listStyle(.plain)
        .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .always))
    }

    func title(country: Endpoint.GetLookupData.Response.LookupData.Country) -> String? {
        switch mode {
        case .dialingCode:
            guard let code = country.dialingCode else { return nil }
            return "\(country.name) (+\(code))"
        case .country:
            return "\(country.name) (\(country.code))"
        }
    }
}
