//
//  MaterialLoadingSquare.swift
//  Virgin Voyages
//
//  Created by TX on 8.7.25.
//

import SwiftUI
import VVUIKit

// MARK: - Loading View
struct MaterialLoadingSquare: View {
    @State private var angle: Double = 0

    private let size: CGFloat = 30
    private let lineWidth: CGFloat = 3
    private let cornerRadius: CGFloat = 4

    private let primaryColor = Color(red: 33/255, green: 150/255, blue: 243/255)
    private let secondaryColor = Color(red: 224/255, green: 224/255, blue: 224/255)

    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .stroke(
                AngularGradient(
                    gradient: Gradient(colors: [primaryColor, secondaryColor, primaryColor]),
                    center: .center,
                    angle: .degrees(angle)
                ),
                lineWidth: lineWidth
            )
            .frame(width: size, height: size)
            .onAppear {
                withAnimation(.linear(duration: 1).repeatForever(autoreverses: false)) {
                    angle = 360
                }
            }
    }
}
