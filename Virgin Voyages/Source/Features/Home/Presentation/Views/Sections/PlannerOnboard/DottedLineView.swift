//
//  Untitled.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 23.3.25.
//

import SwiftUI

struct DottedLineView: View {
    var height: CGFloat

    var body: some View {
        VStack(spacing: 1) {
            Circle()
                .fill(Color.black)
                .frame(width: 6, height: 6)

            let dotHeight: CGFloat = 6
            let spacing: CGFloat = 3
            let numberOfDots = Int(height / (dotHeight + spacing))

            VStack(spacing: spacing) {
                Capsule()
                    .fill(Color.black)
                    .frame(width: 2, height: dotHeight / 2)

                ForEach(1..<numberOfDots, id: \.self) { index in
                    Capsule()
                        .fill(Color.black.opacity(1.0 - Double(index) / Double(numberOfDots)))
                        .frame(width: 2, height: dotHeight)
                }
            }
            .frame(height: height)
            .padding(.horizontal, 4)
        }
    }
}

#Preview {
    DottedLineView(height: 200)
}
