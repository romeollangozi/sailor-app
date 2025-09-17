//
//  ToDoView.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 1/16/24.
//

import SwiftUI

struct ToDoView: View {
	var title: String
    var body: some View {
		VStack(spacing: 20) {
			Text(title)
				.fontStyle(.largeTitle)
			Text("This view is coming soon!")
				.fontStyle(.headline)
			Text("In the meantime, please use the existing Sailor App to manage this data.")
				.fontStyle(.body)
				.foregroundStyle(.secondary)
			
			Button("Open In App") {
				
			}
			.textCase(.uppercase)
			.fontStyle(.headline)
			.buttonStyle(BorderedProminentButtonStyle())
		}
		.multilineTextAlignment(.center)
		.padding()
    }
}

#Preview {
    ToDoView(title: "Bar Tab")
}
