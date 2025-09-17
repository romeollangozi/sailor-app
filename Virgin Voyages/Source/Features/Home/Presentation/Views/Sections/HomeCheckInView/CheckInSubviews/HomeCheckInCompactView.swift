//
//  HomeCheckInCompactView.swift
//  Virgin Voyages
//
//  Created by TX on 17.3.25.
//

import SwiftUI
import VVUIKit

struct HomeCheckInCompactView: View {
    @State var viewModel: HomeCheckInViewModelProtocol
    
    init(viewModel: HomeCheckInViewModelProtocol) {
        _viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
        Button(action: {
            viewModel.ctaButtonTapped()
        }) {
            HStack(spacing: Paddings.defaultVerticalPadding16) {
                profileImageWithStatus

                VStack(alignment: .leading, spacing: 4) {
                    Text(viewModel.section.rts.title)
                        .font(.vvBodyBold)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading)

                    Text(viewModel.section.rts.description)
                        .font(.vvSmall)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                }
                Spacer()

                Image(systemName: "arrow.right")
                    .foregroundColor(.vvRed)
                    .font(.system(size: 14, weight: .semibold))
            }
        }
        .padding(.vertical, Paddings.defaultVerticalPadding16)
        .padding(.horizontal, Paddings.defaultVerticalPadding16)
        .background(Color.white)
    }

    private var profileImageWithStatus: some View {
        ZStack(alignment: .bottomTrailing) {
            AuthURLImageView(imageUrl: viewModel.section.rts.imageUrl, size: 64, clipShape: .circle)

            Image(systemName: viewModel.shouldShowErrorIcon ? "exclamationmark.circle.fill" : "checkmark.circle.fill")
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(viewModel.shouldShowErrorIcon ? Color.vvRed : .green)
                .background(Circle().fill(Color.white))
                .offset(x: 2, y: 2)
        }
    }
}

#Preview {
    HomeCheckInCompactView(viewModel: HomeCheckInViewModel.mockViewModel())
}
