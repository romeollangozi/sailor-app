//
//  HomeScrollView.swift
//  Virgin Voyages
//
//  Created by TX on 13.3.25.
//

import SwiftUI

struct HomeScrollView: View {
    
    let viewModel: HomeLandingScreenViewModelProtocol

    @State private var appearanceOpacity: CGFloat = 0.0
    @State private var displaySections: Bool = false

    @Binding var yOffset: CGFloat
    @Binding var headerHeight: CGFloat
    
    var body: some View {
        ScrollView {
            VStack(spacing: .zero) {

                if let header = viewModel.sections.first as? HomeHeader {
                    ParallaxHeaderView(
                        header: header,
                        sailingMode: viewModel.sailingMode,
                        yOffset: yOffset,
                        headerHeight: $headerHeight
                    )
                    .zIndex(0)
                }
                if displaySections {
                    VStack(spacing: 16) {
                        Spacer().frame(height: Paddings.defaultPadding8)
                        let sectionContainers = viewModel.sections.map { HomeSectionContainer($0) }
                        ForEach(sectionContainers) { sectionContainer in
                            let section = sectionContainer.homeSection

                            if !(section is HomeHeader) {
                                SectionView(viewModel: viewModel, sectionContainer: sectionContainer)
                                    .id(sectionContainer.id)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .background(.white)
                    .cornerRadius(Sizes.defaultSize24, corners: [.topLeft, .topRight])
                    .offset(y: -24.0)
                    .zIndex(1)
                }
            }
            .background(.white)
            .background(TrackScrollOffset(yOffset: $yOffset))
            .noTopBounceWithinScrollView()
        }
        .opacity(appearanceOpacity)
        .coordinateSpace(name: "scroll")
        .scrollIndicators(.hidden)
        .ignoresSafeArea(edges: .top)
        .onAppear {
            withAnimation(.easeInOut) {
                appearanceOpacity = 1
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                displaySections = true
            }
        }
    }
}


#Preview {
    HomeScrollView(
        viewModel: HomeLandingScreenPreviewViewModel(),
        yOffset: .constant(0.0),
        headerHeight: .constant(50.0)
    )
}
