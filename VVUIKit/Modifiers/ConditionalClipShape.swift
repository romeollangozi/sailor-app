//
//  ConditionalClipShape.swift
//  VVUIKit
//
//  Created by TX on 14.3.25.
//

import SwiftUI

public struct ConditionalClipShape: ViewModifier {
    let shape: CustomAnyShape?

    public init(shape: (any Shape)?) {
        if let shape = shape {
            self.shape = CustomAnyShape(shape)
        } else {
            self.shape = nil
        }
    }

    public func body(content: Content) -> some View {
        if let shape = shape {
            content.clipShape(shape)
        } else {
            content
        }
    }
}

@preconcurrency
public struct CustomAnyShape: Shape {
    private let _path: @Sendable (CGRect) -> Path

    public init<S: Shape>(_ shape: S) {
        self._path = { rect in shape.path(in: rect) }
    }

    public func path(in rect: CGRect) -> Path {
        _path(rect)
    }
}
