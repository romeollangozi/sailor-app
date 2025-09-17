//
//  TrackHeaderHeight.swift
//  Virgin Voyages
//
//  Created by TX on 13.3.25.
//

import SwiftUI

// View used for calculating height of the view
struct TrackHeaderHeight: View {
    @Binding var headerHeight: CGFloat
    let extraHeight: CGFloat

    var body: some View {
        GeometryReader { geometry in
            Color.clear
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                        headerHeight = geometry.size.height + extraHeight
                    })
                }
        }
    }
}
