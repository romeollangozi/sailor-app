//
//  AirlinePicker.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 6/25/24.
//

import SwiftUI

struct AirlinePicker: View {
	var airlines: [Endpoint.GetLookupData.Response.LookupData.Airline]
	var action: (Endpoint.GetLookupData.Response.LookupData.Airline) -> Void
	@State private var searchText = ""
	
	var displayResults: [Endpoint.GetLookupData.Response.LookupData.Airline] {
		if searchText == "" {
			return airlines
		}
		
		return airlines.filter {
			$0.name.localizedCaseInsensitiveContains(searchText) || $0.code == searchText
		}
	}
	
	var body: some View {
		List {
			ForEach(displayResults, id: \.code) { airline in
				Button(airline.name) {
					action(airline)
				}
			}
		}
		.navigationTitle("Airline")
		.navigationBarTitleDisplayMode(.inline)
		.fontStyle(.body)
		.listStyle(.plain)
		.searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
	}
}
