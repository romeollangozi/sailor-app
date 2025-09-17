//
//  DashboardHeader.swift
//  Voyages
//
//  Created by Chris DeSalvo on 1/2/24.
//

import SwiftUI

struct SectionLabel: View {
	var name: ImageName?
	var title: String
	var caption: String
    var body: some View {
		VStack(alignment: .center, spacing: 15) {
			if let name {
				VectorImage(name: name.imageName)
					.frame(height: 50)
			}
			Text(title)
				.fontStyle(.largeTitle)
				.multilineTextAlignment(.center)
			Text(caption)
				.fontStyle(.headline)
				.multilineTextAlignment(.center)
				.opacity(name != nil ? 0.5 : 1.0)
				.lineSpacing(6)
		}
    }
	
	enum ImageName {
		case anchor
		case seashell
		
		var imageName: String {
			switch self {
			case .anchor: "Anchor"
			case .seashell: "Seashell"
			}
		}
	}
}

#Preview {
	SectionLabel(name: .anchor, title: "Before You Sail", caption: "Complete these lil’ tasks now to earn your stripes and breeze into voyage day.")
		.padding()
}
