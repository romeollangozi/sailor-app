//
//  HomeActionsView.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 25.3.25.
//

import SwiftUI
import VVUIKit

struct HomeActionsView: View {
    @State private var viewModel: HomeActionsViewModelProtocol
    
    init(viewModel: HomeActionsViewModelProtocol = HomeActionsViewModel()) {
        _viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: Spacing.space8) {
            ForEach(viewModel.homeActions.items) { item in
                HomeActionItemsView(imageUrl: item.imageUrl, title: item.title, description: item.description)
                    .onTapGesture {
                        viewModel.didTapAction(item: item)
                    }
            }
        }
        .padding(.horizontal, Spacing.space20)
    }
}

#Preview {
    let viewModel = HomeActionsViewModel(homeActions: .sample())
    HomeActionsView(viewModel: viewModel)
}
