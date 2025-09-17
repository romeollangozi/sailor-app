//
//  LastUpdatedView.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 3/19/25.
//

import SwiftUI

struct LastUpdatedView: View {

	private var lastUpdatedText: String

    var body: some View {
		HStack(spacing: Spacing.space6) {
            // Clock icon
            Image(systemName: "clock")
                .foregroundColor(.gray)
            
            // Last updated text
			Text(lastUpdatedText)
				.foregroundColor(.darkGray)
				.font(.vvSmall)
        }
		.padding(.vertical, Spacing.space8)
		.padding(.horizontal, Spacing.space12)
		.background(Color.softGray)
        .cornerRadius(100)
    }

	init(lastUpdatedText: String) {
		self.lastUpdatedText = lastUpdatedText
	}
}

struct LastUpdatedView_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			LastUpdatedView(lastUpdatedText: "Last updated 5 minutes ago")
				.previewLayout(.sizeThatFits)
				.padding()
		}
	}
}
