//
//  HealthCheckEntryPointView.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 6/12/25.
//

import SwiftUI
import VVUIKit

protocol HealthCheckEntryPointViewModelProtocol {
    
    var screenState: ScreenState { get set }
    var homeHealthCheckDetail: HealthCheckDetail { get set }
    
    func onAppear()
    func onRefresh()
    func dismissHealthCheck()
    func goToHealthCheckQuestions()
}

struct HealthCheckEntryPointView: View {
    
    @State var viewModel: HealthCheckEntryPointViewModelProtocol
    
    init(viewModel: HealthCheckEntryPointViewModelProtocol = HealthCheckEntryPointViewModel()) {
        _viewModel = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        
        DefaultScreenView(state: $viewModel.screenState) {
            
            if viewModel.homeHealthCheckDetail.isHealthCheckComplete {
                HealthCheckCompleteView(viewModel: viewModel)
            } else {
                HealthCheckLandingView(viewModel: viewModel)
            }
            
        } onRefresh: {
            viewModel.onRefresh()
        }
        .onAppear {
            viewModel.onAppear()
        }
        .toolbar(.hidden, for: .tabBar)
        .navigationBarBackButtonHidden()
        .ignoresSafeArea(edges: [.top, .bottom])
        .navigationTitle("")
        
    }
}

#Preview {
    HealthCheckEntryPointView()
}
