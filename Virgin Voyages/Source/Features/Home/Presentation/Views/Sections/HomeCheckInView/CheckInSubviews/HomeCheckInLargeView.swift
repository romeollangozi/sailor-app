//
//  HomeCheckInLargeView.swift
//  Virgin Voyages
//
//  Created by TX on 17.3.25.
//

import SwiftUI
import VVUIKit

struct HomeCheckInLargeView: View {
    @State var viewModel: HomeCheckInViewModelProtocol
    
    init(viewModel: HomeCheckInViewModelProtocol) {
        _viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: .zero) {
            HStack(alignment: .top, spacing: Paddings.defaultPadding8) {
                VStack(alignment: .leading, spacing: Paddings.smallVerticalPadding3) {
                    Text(viewModel.section.rts.title)
                        .font(.vvHeading3Bold)
                        .foregroundColor(.black)

                    HTMLText(htmlString: viewModel.section.rts.description, fontType: .normal, fontSize: .size16, color: .gray)
                }
                Spacer()
                AuthURLImageView(imageUrl: viewModel.section.rts.imageUrl, size: 96, clipShape: .circle)
            }

            if viewModel.shouldDisplayCTAInLargeCheckinSection {
                PrimaryButton(viewModel.section.rts.buttonLabel, font: .vvBodyMedium, padding: .zero) {
                    viewModel.ctaButtonTapped()
                }
                .padding(.top, Paddings.defaultVerticalPadding)
            }
        }
        .padding(.top, Paddings.defaultVerticalPadding24)
        .padding(.bottom, Paddings.defaultVerticalPadding24)
        .padding(.horizontal, Paddings.defaultVerticalPadding16)
        .background(gradientBackground)
    }

    private var gradientBackground: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(red: 252/255, green: 212/255, blue: 80/255, opacity: 0.15),
                Color(red: 132/255, green: 174/255, blue: 191/255, opacity: 0.30)
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
        .background(Color.white)
    }
}


#Preview {
    HomeCheckInLargeView(viewModel: HomeCheckInViewModel.mockViewModel())
}
