//
//  NoDataView.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 2/3/24.
//

import SwiftUI

struct NoDataView: View {
	var title: String = ""
	var action: () -> Void

	init(title: String = "", action: @escaping () -> Void) {
		self.title = title
		self.action = action
	}

    var body: some View {
		ZStack {
			VStack(spacing: 20) {
				Spacer()
				
				Text(title)
					.multilineTextAlignment(.center)
					.fontStyle(.largeTitle)
					.foregroundStyle(.white)
				
				Button("Reload", action: action)
					.buttonStyle(BorderedProminentButtonStyle())
					.fontStyle(.button)
					.clipShape(Capsule())
				
				Image("emptyResultNakedMan")
					.resizable()
					.aspectRatio(contentMode: .fit)
					.padding(40)
			}
		}
		.background(Color(red: 244.0 / 255.0, green: 186.0 / 255.0, blue: 176.0 / 255.0))
    }
}

#Preview {
	NoDataView(title: "Title") {
		
	}
}
