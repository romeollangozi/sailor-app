//
//  ActivityEssentialSection.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 1/22/24.
//

import SwiftUI

struct ActivityEssentialSection: View {
	var instructions: [String]
    var body: some View {
		Section {
			ForEach(instructions, id: \.self) { highlight in
				Label(highlight, systemImage: "circle.circle")
					.fontStyle(.body)
			}
		} header: {
			Text("Need to know")
				.fontStyle(.title)
				.foregroundStyle(.primary)
		}
    }
}
