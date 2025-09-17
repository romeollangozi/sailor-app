//
//  RejectionReasonView.swift
//  Virgin Voyages
//
//  Created by Pajtim on 4.10.24.
//

import SwiftUI

struct RejectionReasonView: View {
    let title: String
    let reasons: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .fontStyle(.boldTagline)
            ForEach(reasons, id: \.self) { reasonText in
                HStack {
                    Text(" • ")
                        .fontStyle(.subheadline)
                    Text(reasonText)
                        .fontStyle(.subheadline)
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .background(Color.lightYellow)
        .foregroundStyle(Color.lightGreyColor)
        .cornerRadius(8)
    }
}
