//
//  VenueCategoryLabel.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 1/30/24.
//

import SwiftUI
import VVUIKit

struct VenueCategoryLabel: View {
	var title: String
	var subheading: String
	
    var body: some View {
		VStack(spacing: 8) {
			Text(title)
				.fontStyle(.largeTitle)
				.multilineTextAlignment(.center)
            HTMLText(htmlString: subheading, fontType: .normal, fontSize: .size16, color: Color.slateGray)
		}
    }
}
