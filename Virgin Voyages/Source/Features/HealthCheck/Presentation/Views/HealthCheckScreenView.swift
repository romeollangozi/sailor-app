//
//  HealthCheckScreenView.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 6/4/25.
//

import SwiftUI

@MainActor
extension HealthCheckScreenView {
    static func create() -> HealthCheckScreenView {
        HealthCheckScreenView(viewModel: HealthCheckViewModel())
    }
}

struct HealthCheckScreenView: View, CoordinatorNavitationDestinationViewProvider {
    
    @State var viewModel: HealthCheckViewModel
    
    init(viewModel: HealthCheckViewModel) {
        _viewModel = State(wrappedValue: viewModel)
    }

    var body: some View {
        
        NavigationStack(path: $viewModel.navigationPath) {
            HealthCheckEntryPointView()
                .navigationDestination(for: HealthCheckRoute.self) { route in
                    destinationView(for: route)
                }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            viewModel.goToRoot()
        }
    }
    
    func destinationView(for navigationRoute: any BaseNavigationRoute) -> AnyView {
        
        guard let healthCheckNavigationRoute = navigationRoute as? HealthCheckRoute else { return AnyView(Text("View not supported")) }
        
        switch healthCheckNavigationRoute {
        case .healthCheckQuestion(let healthCheckDetail):
            return AnyView(
                HealthCheckQuestionScreenView(healthCheckDetail: healthCheckDetail)
            )
        }
    }
    
}
