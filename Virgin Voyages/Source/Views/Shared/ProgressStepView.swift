//
//  ProgressStepView.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 6/24/23.
//

import SwiftUI

struct ProgressStepView: View {
	var value: Double
	var text: String
    var body: some View {
		VStack {
			ProgressView(text)
			ProgressView(value: value)
				.padding()
		}
		.fontStyle(.body)
    }
}

#Preview {
	ProgressStepView(value: 0.5, text: "Events")
		.padding()
}
