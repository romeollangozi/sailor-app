//
//  AddAFriendScreen.swift
//  Virgin Voyages
//
//  Created by TX on 24.2.25.
//

import SwiftUI

protocol AddAFriendViewModelProtocol: CoordinatorNavitationDestinationViewProvider, CoordinatorFullScreenViewProvider {
    var appCoordinator: CoordinatorProtocol { get set }
    func closeAction()
    func shareAction()
    func scanAction()
    func searchAction()
}

struct AddAFriendScreen: View {
    
    @State private var viewModel: AddAFriendViewModelProtocol
    
    init(viewModel: AddAFriendViewModelProtocol = AddAFriendViewModel()) {
        _viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack(path: $viewModel.appCoordinator.homeTabBarCoordinator.addAFriendCoordinator.navigationRouter.navigationPath) {
            VStack {
                AddFriendSheet {
                    viewModel.closeAction()
                } shareAction: {
                    viewModel.shareAction()
                } scanAction: {
                    viewModel.scanAction()
                } searchAction: {
                    viewModel.searchAction()
                }
                .navigationDestination(for: AddAFriendNavigationRoute.self) { path in
                    viewModel.destinationView(for: path)
                }
                .fullScreenCover(item: $viewModel.appCoordinator.homeTabBarCoordinator.addAFriendCoordinator.fullScreenRouter) { path in
                    viewModel.destinationView(for: path)
                }
                .transaction { transaction in
                    transaction.disablesAnimations = true
                }
            }
        }
    }
}

class MockAddAFriendViewModel: AddAFriendViewModelProtocol {
    var appCoordinator: CoordinatorProtocol = AppCoordinator()
    
    func closeAction() {}
    func shareAction() {}
    func scanAction() {}
    func searchAction() {}
    
    func destinationView(for navigationRoute: any BaseNavigationRoute) -> AnyView {
        AnyView(Text("Preview destination view"))
    }
    
    func destinationView(for fullScreenRoute: any BaseFullScreenRoute) -> AnyView {
        AnyView(Text("Preview destination view"))
    }
}

#Preview {
    AddAFriendScreen(viewModel: MockAddAFriendViewModel())
}
