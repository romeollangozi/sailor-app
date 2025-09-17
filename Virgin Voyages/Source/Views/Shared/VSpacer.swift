//
//  VSpacer.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 1/5/24.
//

import SwiftUI

struct VSpacer: View {
	private var height: CGFloat
	
	init(_ space: CGFloat) {
		height = space
	}
	
	var body: some View {
		Spacer()
			.frame(height: height)
	}
}

#Preview {
	VSpacer(10)
}
