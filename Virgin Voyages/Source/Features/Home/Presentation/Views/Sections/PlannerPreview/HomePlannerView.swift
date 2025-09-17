//
//  HomePlannerView.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 20.3.25.
//

import SwiftUI
import VVUIKit

struct HomePlannerView: View {
    
    @State private var viewModel: HomePlannerViewModelProtocol
    
    init(viewModel: HomePlannerViewModelProtocol = HomePlannerViewModel()) {
        _viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(viewModel.homePlanner.title)
                .font(.vvHeading4Bold)
                .multilineTextAlignment(.center)
                .padding(.top, Spacing.space24)
                .padding(.bottom, Spacing.space8)
                .padding(.horizontal, Spacing.space32)
            FlexibleProgressImage(url: URL(string: viewModel.homePlanner.thumbnailImageUrl))
                .frame(height: 90)
            HStack {
                Text(viewModel.homePlanner.description)
                    .font(.vvSmall)
                Spacer()
                Image("ForwardRed")
            }
            .padding(Spacing.space16)
            .onTapGesture {
                viewModel.didTapPlannerPreview()
            }
        }
        .background(Color.white)
        .cornerRadius(CornerRadiusValues.defaultCornerRadius)
        .shadow(color: Color.black.opacity(0.05), radius: 1, x: 0, y: 1)
        .shadow(color: Color.black.opacity(0.07), radius: 8, x: 0, y: 8)
        .padding(.horizontal , Spacing.space16)
        .padding(.vertical, Spacing.space24)
    }
}

#Preview {
    HomePlannerView(viewModel: HomePlannerViewModel(homePlanner: .sample()))
}
