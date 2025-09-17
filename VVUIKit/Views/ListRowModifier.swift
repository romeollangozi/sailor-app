//
//  ListRowModifier.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 10.7.25.
//

import SwiftUI

struct ListRowModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .background(.background)
            .clipShape(RoundedRectangle(cornerRadius: 6))
            .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 8)
    }
}

extension View {
    func listRowStyle() -> some View {
        self.modifier(ListRowModifier())
    }
}
