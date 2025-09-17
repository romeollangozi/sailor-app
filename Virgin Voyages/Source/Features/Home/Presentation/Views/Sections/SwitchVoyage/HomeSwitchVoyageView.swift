//
//  HomeSwitchVoyageView.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 26.3.25.
//

import SwiftUI
import VVUIKit

struct HomeSwitchVoyageView: View {
    @State private var viewModel: HomeSwitchVoyageViewModelProtocol
    
    init(viewModel: HomeSwitchVoyageViewModelProtocol) {
        _viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: Spacing.space8) {
            if viewModel.sailingMode == .postCruise {
                VStack(spacing: Spacing.space16) {
                    Button("Switch voyages") {
                        viewModel.didTapSwitchVoyages()
                    }
                    .buttonStyle(SecondaryButtonStyle())
                    
                    Button("Book your next adventure") {
                        viewModel.didTapNextAdventure()
                    }
                    .buttonStyle(PrimaryButtonStyle())
                }
                .padding([.horizontal, .bottom], Spacing.space24)
                .padding(.top, Spacing.space8)
            }
        }
        .padding(.bottom, Spacing.space16)
    }
}

#Preview {
    HomeSwitchVoyageView(viewModel: HomeSwitchVoyageViewModel(sailingMode: .postCruise))
}
