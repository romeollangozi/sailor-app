//
//  Cardify.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 7.2.25.
//

import SwiftUI

struct Cardify: ViewModifier {
    func body(content: Content) -> some View {
        content
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 1)
            .shadow(color: Color.black.opacity(0.07), radius: 48, x: 0, y: 8)
    }
}

extension View {
    public func cardify() -> some View {
        self.modifier(Cardify())
    }
}
