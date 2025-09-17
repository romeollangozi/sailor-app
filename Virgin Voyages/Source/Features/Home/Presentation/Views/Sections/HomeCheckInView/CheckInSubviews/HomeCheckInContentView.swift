//
//  HomeCheckInContentView.swift
//  Virgin Voyages
//
//  Created by TX on 17.3.25.
//

import SwiftUI

struct HomeCheckInContentView: View {
    @State var viewModel: HomeCheckInViewModelProtocol
    
    init(viewModel: HomeCheckInViewModelProtocol) {
        _viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
        if viewModel.shouldDisplayLargeCheckinSection {
            HomeCheckInLargeView(viewModel: viewModel)
        } else {
            HomeCheckInCompactView(viewModel: viewModel)
        }
    }
}

#Preview {
    HomeCheckInContentView(viewModel: HomeCheckInViewModel.mockViewModel())
}
