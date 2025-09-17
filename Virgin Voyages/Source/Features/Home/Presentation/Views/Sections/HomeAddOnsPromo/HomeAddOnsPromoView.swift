//
//  HomeAddOnsPromoView.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 18.3.25.
//

import SwiftUI
import VVUIKit

struct HomeAddOnsPromoView: View {
    
    @State private var viewModel: HomeAddOnsPromoViewModelProtocol
    @State private var imageHeight: CGFloat = 0
    let addOnCardPadding: CGFloat = 28

    init(viewModel: HomeAddOnsPromoViewModelProtocol = HomeAddOnsPromoViewModel()) {
        _viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            VectorImage(name: "Wavy", mode: .fill)
                .frame(maxHeight: Sizes.defaultSize80)
            
            addOnsCard()
        }
        .padding(.bottom, Spacing.space16)
    }
    
    private func addOnsCard() -> some View {
        HStack {
            HStack(spacing: Spacing.space16) {
                ImageViewer(url: viewModel.homeAddOnsPromo.imageUrl, width: Sizes.defaultSize90, height: imageHeight, contentMode: .fit)
                VStack(alignment: .leading) {
                    Text(viewModel.homeAddOnsPromo.title)
                        .font(.vvHeading3Bold)
                        .foregroundColor(.vvRed)
                    HStack(spacing: Spacing.space8) {
                        Text(viewModel.homeAddOnsPromo.description)
                            .font(.vvSmallBold)
                            .foregroundColor(.black)
                        Image("ForwardRed")
                    }
                    .onTapGesture {
                        viewModel.didTapAddOns()
                    }
                    .padding(.vertical, Spacing.space16)
                }
                .background(GeometryReader { geometry in
                    Color.clear
                        .onAppear {
                            imageHeight = geometry.size.height
                        }
                })
            }
            .padding(.vertical, addOnCardPadding)
            .padding(.leading, addOnCardPadding)
            .padding(.trailing, Spacing.space16)
        }
        .frame(maxWidth: .infinity)
        .background(Color.lightYellow)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 1, x: 0, y: 1)
        .shadow(color: Color.black.opacity(0.07), radius: 8, x: 0, y: 8)
        .padding(Spacing.space16)
        .offset(y: Spacing.space16)
    }
}

#Preview {
    let viewModel = HomeAddOnsPromoViewModel(homeAddOnsPromo: HomeAddOnsPromoSection.sample())
    HomeAddOnsPromoView(viewModel: viewModel)
}
