//
//  HomeMerchandiseView.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 16.3.25.
//

import SwiftUI
import VVUIKit

struct HomeMerchandiseView: View {
    @State private var viewModel: HomeMerchandiseViewModelProtocol
    private var dragOffset: CGFloat = 0
    
    init(viewModel: HomeMerchandiseViewModelProtocol = HomeMerchandiseViewModel()) {
        _viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: Spacing.space8) {
           
            carouselView()

            indicatorDots()
        }
        .padding(.bottom, Spacing.space24)
        .background(.white)
        .onAppear {
            viewModel.onAppear()
        }
    }
    
    private func carouselView() -> some View{
        GeometryReader { geometry in
            let cardWidth = geometry.size.width * 0.75  + Spacing.space16
            let sidePadding: CGFloat = (geometry.size.width - cardWidth) / 2
            let totalWidth = cardWidth + Spacing.space16

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Spacing.space16) {
                    carouselItems(cardWidth: cardWidth)
                }
                .padding(.horizontal, sidePadding)
                .gesture(
                    DragGesture()
                        .onEnded { value in
                            viewModel.onDragGestureEnded(value: value.translation.width)
                        }
                )
            }
            .content.offset(x: -CGFloat(viewModel.currentIndex) * totalWidth + dragOffset)
            .animation(.easeInOut, value: viewModel.currentIndex)
        }
        .frame(height: 115)
    }
    
    private func carouselItems(cardWidth: CGFloat) -> some View {
        ForEach(viewModel.homeMerchandise.items.prefix(6).indices, id: \.self) { index in
            CarouselCardView(
                title: viewModel.homeMerchandise.items[index].title,
                imageURL: viewModel.homeMerchandise.items[index].imageUrl,
                color: viewModel.homeMerchandise.items[index].color.isEmpty ? .lightErrorBackground : Color(hex: viewModel.homeMerchandise.items[index].color),
                action: { viewModel.didTapMerchandise(item: viewModel.homeMerchandise.items[index])}
            )
            .frame(width: cardWidth)
            .scaleEffect(viewModel.currentIndex == index ? 1.0 : 0.9)
            .animation(.spring(), value: viewModel.currentIndex)
        }
    }
    
    private func indicatorDots() -> some View {
        HStack(spacing: Spacing.space8) {
            ForEach(0..<min(viewModel.homeMerchandise.items.count, 6), id: \.self) { index in
                Circle()
                    .fill(viewModel.currentIndex == index ? .black : .borderGray)
                    .frame(width: Spacing.space8, height: Spacing.space8)
            }
        }
        .padding(.vertical, Spacing.space12)
    }
}

#Preview {
    let viewModel = HomeMerchandiseViewModel(homeMerchandise: HomeMerchandise.sample())
    HomeMerchandiseView(viewModel: viewModel)
}
        
