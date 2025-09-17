//
//  HomeMusterDrillView.swift
//  Virgin Voyages
//
//  Created by TX on 2.4.25.
//

import SwiftUI
import VVUIKit

protocol HomeMusterDrillViewModelProtocol {
    var backgroundImage: String { get }
    var title: String { get }
    var actionText: String { get }
    
    func onViewTap()
}

struct HomeMusterDrillView: View {
    @State private var viewModel: HomeMusterDrillViewModelProtocol
    
    init(viewModel: HomeMusterDrillViewModelProtocol = HomeMusterDrillViewModel()) {
        _viewModel = .init(wrappedValue: viewModel)
    }
    
    private let imageBannerHeight = 200.0

    var body: some View {
        Button {
            viewModel.onViewTap()
        } label: {
            VStack(spacing: 0) {
                ZStack(alignment: .topLeading) {
                    GeometryReader { proxy in
                        AuthURLImageView(imageUrl: viewModel.backgroundImage, height: imageBannerHeight)
                            .aspectRatio(contentMode: .fill)
                            .overlay(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.black.opacity(0.4), Color.black.opacity(0.4)]),
                                    startPoint: .bottom,
                                    endPoint: .top
                                )
                            )

                        Text(viewModel.title)
                            .multilineTextAlignment(.leading)
                            .font(.vvHeading4Bold)
                            .foregroundColor(.white)
                            .padding(Paddings.defaultVerticalPadding24)
                            .frame(width: proxy.size.width/1.8)
                    }

                }
                .frame(height: imageBannerHeight)

                HStack {
                    Text(viewModel.actionText)
                        .font(.vvSmallMedium)
                        .foregroundColor(.vvBlack)

                    Spacer()

                    Image("ForwardRed")
                        .resizable()
                        .frame(width: 24.0, height: 24.0)
                }
                .padding(Paddings.defaultVerticalPadding16)
                .background(Color.white)
                .onTapGesture {
                    viewModel.onViewTap()
                }
            }
        }
        .background(.white)
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 1)
        .shadow(color: Color.black.opacity(0.07), radius: 48, x: 0, y: 8)
        .padding(.horizontal, Paddings.defaultVerticalPadding16)
        .padding(.bottom, Paddings.defaultVerticalPadding16)
    }
}

#Preview {
    HomeMusterDrillView()
}
