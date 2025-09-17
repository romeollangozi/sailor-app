//
//  FadeFullScreenCover.swift
//  VVUIKit
//
//  Created by Enxhi Kondakciu on 29.4.25.
//

import SwiftUI

extension View {
    public func fadeFullScreenCover<Item: Identifiable & Equatable, Content: View>(
        item: Binding<Item?>,
        @ViewBuilder content: @escaping (Item) -> Content
    ) -> some View {
        ZStack {
            self

            if let unwrappedItem = item.wrappedValue {
                content(unwrappedItem)
                    .transition(.opacity)
                    .zIndex(1)
                    .background(
                        Color.black.opacity(0.5)
                            .ignoresSafeArea()
                            .onTapGesture {
                                withAnimation {
                                    item.wrappedValue = nil
                                }
                            }
                    )
            }
        }
        .animation(.easeOut(duration: 0.3), value: item.wrappedValue)
    }
}
