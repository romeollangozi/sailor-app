//
//  ActivityPolicySection.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 1/22/24.
//

import SwiftUI

struct ActivityPolicySection: View {
    var body: some View {
		Section {
			Text(shoreThingsPolicy ?? "")
				.foregroundColor(.secondary)
				.fontStyle(.body)
			
			NavigationLink {
				if let url = URL(string: "https://www.virginvoyages.com/shore-things-terms-and-conditions") {
					WebLinkView(url: url) { url in
						return .allow
					}
				}
			} label: {
				Text("https://www.virginvoyages.com/shore-things-terms-and-conditions")
			}
		} header: {
			Text("Our Shore Things Policies")
				.foregroundStyle(.primary)
				.fontStyle(.title)
		}
    }
	
	var shoreThingsPolicy: String? {
		guard let asset = NSDataAsset(name: "Our Shore Things Policies") else {
			return nil
		}
		
		let data = asset.data as Data
		return String(data: data, encoding: .utf8)
	}
}

#Preview {
	NavigationStack {
		List {
			ActivityPolicySection()
		}
		.listStyle(.plain)
	}
}
