//
//  CheckmarkSquareOrOutline.swift
//  Virgin Voyages
//
//  Created by TX on 8.7.25.
//

import SwiftUI
import VVUIKit


// MARK: - Checkmark View
struct CheckmarkSquareOrOutline: View {
    let didPass: Bool

    private let size: CGFloat = 30
    private let lineWidth: CGFloat = 2
    private let cornerRadius: CGFloat = 4

    var body: some View {
        Group {
            if didPass {
                Image(systemName: "checkmark.square.fill")
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.green, .white)
                    .font(.system(size: size))
            } else {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Color.vvGray.opacity(0.5), lineWidth: lineWidth)
                    .frame(width: size, height: size)
            }
        }
    }
}
