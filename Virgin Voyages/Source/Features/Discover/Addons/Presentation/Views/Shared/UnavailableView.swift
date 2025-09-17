//
//  UnavailableView.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 10/10/24.
//

import SwiftUI

struct UnavailableView: View {
	var text: String
    var isClosed: Bool

	var body: some View {
		HStack(spacing: Paddings.zero) {
            if isClosed {
                Rectangle()
                    .frame(width: 2, height: 20)
                    .background(.white)
            }
			Text(text)
				.frame(height: 40)
				.frame(maxWidth: .infinity, alignment: .leading)
				.fontStyle(.boldTagline)
				.foregroundColor(.white)
                .padding(.horizontal, 12)
				.background(Color.black)
			Spacer()
		}
		.frame(maxWidth: .infinity, alignment: .trailing)
	}
}
