//
//  LandingScreen.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 8/20/24.
//

import SwiftUI
import AVFoundation

struct LandingScreen: View {
        
    var showWiFiSheet: (() -> Void)? = nil
    
    @State private var viewModel: LandingScreenViewModelProtocol
    
    init(viewModel: LandingScreenViewModelProtocol,
         showWiFiSheet: (() -> Void)? = nil
    ) {
        _viewModel = State(wrappedValue: viewModel)
        self.showWiFiSheet = showWiFiSheet
    }
    
    var body: some View {
        VirginScreenView(state: $viewModel.screenState,
                         content: {
            LandingView.create(backgroundVideoPlayer: viewModel.landingBackgroundVideoPlayer,
                               showWiFiSheet: showWiFiSheet,
                               currentDeepLink: viewModel.currentDeepLink)
        }, loadingView: {
			LandingSplashView(viewModel: LandingSplashViewModel(backgroundVideoPlayer: viewModel.splashBackgroundVideoPlayer))
        }, errorView: {
            NoDataView {
                viewModel.loadLanding()
            }
        })
    }
}

#Preview {
    return NavigationStack {
		LandingScreen(viewModel: LandingScreenViewModel())
    }
}
