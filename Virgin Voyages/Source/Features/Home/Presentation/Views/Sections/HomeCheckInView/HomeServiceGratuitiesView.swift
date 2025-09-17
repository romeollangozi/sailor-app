//
//  HomeServiceGratuitiesView.swift
//  Virgin Voyages
//
//  Created by Codex on 9/5/25.
//

import SwiftUI
import VVUIKit

struct HomeServiceGratuitiesView: View {

    @State var viewModel: HomeCheckInViewModelProtocol
    @State private var isLoading = false

    init(viewModel: HomeCheckInViewModelProtocol) {
        _viewModel = .init(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 1)
                .shadow(color: .black.opacity(0.07), radius: 24, x: 0, y: 8)

            HStack(spacing: Spacing.space16) {
                if let url = URL(string: viewModel.getServiceGratuitiesImageURL) {
                    DynamicSVGImageLoader(url: url, isLoading: $isLoading)
                        .frame(width: Sizes.defaultSize64, height: Sizes.defaultSize64)
                }

                VStack(alignment: .leading, spacing: Spacing.space8) {
                    Text(viewModel.section.serviceGratuitiesSection.title ?? "")
                        .font(.vvBodyBold)
                        .foregroundStyle(Color.charcoalBlack)

                    Text(viewModel.section.serviceGratuitiesSection.description ?? "")
                        .font(.vvSmall)
                        .foregroundStyle(Color.coolGray)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                if viewModel.isServiceGratuitiesAvailable {
                    Image("ForwardRed")
                }
            }
            .padding(Spacing.space16)
        }
        .frame(minHeight: 96)
        .padding(.horizontal, Spacing.space16)
    }
}

#Preview {
    VStack(spacing: 20) {
        HomeServiceGratuitiesView(viewModel: HomeCheckInViewModel.mockViewModel())
    }
}
