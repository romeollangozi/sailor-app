//
//  LaunchScreen.swift
//  Virgin Voyages
//
//  Created by TX on 23.7.25.
//

import SwiftUI

struct LaunchScreen: View {
    
    @State private var viewModel: LaunchScreenViewModelProtocol
    
    init(viewModel: LaunchScreenViewModelProtocol = LaunchScreenViewModel()) {
        self._viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            // This is the replicated view of the LaunchScreen.storyboard
            Image("Logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100.0, height: 100.0, alignment: .center)
        }
        .onAppear {
            viewModel.onAppear()
        }
    }
}

#Preview {
    LaunchScreen()
}
