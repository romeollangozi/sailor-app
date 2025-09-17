//
//  ConditionalFrame.swift
//  VVUIKit
//
//  Created by TX on 14.3.25.
//

import SwiftUI

public struct ConditionalFrame: ViewModifier {
    let size: CGFloat?

    public init(size: CGFloat?) {
        self.size = size
    }
    
    public func body(content: Content) -> some View {
        if let size = size {
            content.frame(width: size, height: size)
        } else {
            content
        }
    }
}
