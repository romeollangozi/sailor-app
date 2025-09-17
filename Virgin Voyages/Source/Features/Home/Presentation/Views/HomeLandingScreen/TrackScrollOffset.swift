//
//  TrackScrollOffset.swift
//  Virgin Voyages
//
//  Created by TX on 13.3.25.
//

import SwiftUI

// Empty View used for calculating y offset of the scrollview
struct TrackScrollOffset: View {
    @Binding var yOffset: CGFloat

    var body: some View {
        GeometryReader { proxy in
            Color.clear
                .preference(key: ScrollOffsetPreferenceKey.self, value: -proxy.frame(in: .named("scroll")).origin.y)
        }
        .onPreferenceChange(ScrollOffsetPreferenceKey.self) { newValue in
            DispatchQueue.main.async {
                yOffset = newValue
            }
        }
    }
    
    struct ScrollOffsetPreferenceKey: PreferenceKey {
        static var defaultValue: CGFloat = 0
        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
            value = nextValue()
        }
    }
}
