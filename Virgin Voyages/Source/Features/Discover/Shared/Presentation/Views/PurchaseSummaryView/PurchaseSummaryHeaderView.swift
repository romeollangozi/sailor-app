//
//  PurchaseSummaryHeaderView.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 10/17/24.
//

import SwiftUI
import VVUIKit

struct PurchaseSummaryHeaderView: View {
	var body: some View {
		HStack {
			Text("Summary")
				.fontStyle(.largeTitle)
				.foregroundColor(.blackText)
			Spacer()
		}
		.padding(EdgeInsets(top: 16, leading: 24, bottom: 16, trailing: 24))
	}
}
