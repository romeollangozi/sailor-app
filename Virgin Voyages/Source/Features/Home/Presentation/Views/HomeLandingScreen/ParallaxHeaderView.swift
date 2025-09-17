//
//  ParallaxHeaderView.swift
//  Virgin Voyages
//
//  Created by TX on 13.3.25.
//

import SwiftUI

struct ParallaxHeaderView: View {
    let header: HomeHeader
    let sailingMode: SailingMode

    let yOffset: CGFloat
    @Binding var headerHeight: CGFloat

    var body: some View {
        GeometryReader { proxy in
            let minY = proxy.frame(in: .named("scroll")).minY
            let extraHeight = yOffset < 0 ? -yOffset : 0
            let opacity = opacityForHeaderView(from: yOffset)

            HomeHeaderView(
                viewModel: HomeHeaderViewModel(
                    header: header,
                    sailingMode: sailingMode),
                enlargeViewBy: extraHeight,
                contentOpacity: opacity
            )
            .offset(y: minY < 0 ? -minY * 0.5 : -minY)
            .background(TrackHeaderHeight(headerHeight: $headerHeight, extraHeight: extraHeight))
        }
        .frame(height: headerHeight)
    }

    private func opacityForHeaderView(from offsetY: CGFloat) -> CGFloat {
        offsetY > 0 ? 1 - (offsetY / headerHeight) : 1
    }
}
