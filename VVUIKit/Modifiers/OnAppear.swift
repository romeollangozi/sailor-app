//
//  OnAppear.swift
//  VVUIKit
//
//  Created by Enxhi Kondakciu on 15.4.25.
//

import SwiftUI

public extension View {
    func onAppear(
        onFirstAppear: (() -> Void)? = nil,
        onReAppear: (() -> Void)? = nil
    ) -> some View {
        self.modifier(
            FirstAndSubsequentAppearModifier(
                onFirstAppear: onFirstAppear,
                onReAppear: onReAppear
            )
        )
    }
}

public struct FirstAndSubsequentAppearModifier: ViewModifier {
    @State private var hasAppeared = false
    public let onFirstAppear: (() -> Void)?
    public let onReAppear: (() -> Void)?

    public init(
        onFirstAppear: (() -> Void)? = nil,
        onReAppear: (() -> Void)? = nil
    ) {
        self.onFirstAppear = onFirstAppear
        self.onReAppear = onReAppear
    }

    public func body(content: Content) -> some View {
        content.onAppear {
            if !hasAppeared {
                hasAppeared = true
                onFirstAppear?()
            } else {
                onReAppear?()
            }
        }
    }
}
