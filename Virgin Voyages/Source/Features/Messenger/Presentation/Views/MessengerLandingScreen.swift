//
//  MessengerLandingScreen.swift
//  Virgin Voyages
//
//  Created by Timur Xhabiri on 18.10.24.
//

import SwiftUI


struct MessengerLandingScreen: View {
    @State private var viewModel: MessengerLandingScreenViewModelProtocol

    @State private var chatThreadsHasError: Bool = false
    @State private var chatThreadsIsLoading: Bool = true
    
    init(viewModel: MessengerLandingScreenViewModelProtocol) {
        _viewModel = State(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            // Main content
            NavigationStack(path: $viewModel.appCoordinator.homeTabBarCoordinator.messengerCoordinator.navigationRouter.navigationPath) {
                ScrollView {
                    VStack(alignment: .center) {
                        if viewModel.screenState == .content {
                            VStack(alignment: .leading, spacing: Paddings.defaultVerticalPadding32) {
                                
                                HStack(alignment: .center, spacing: Paddings.padding12) {
                                    
                                    // Support Chat button
                                    if viewModel.isSailorShip {
                                        SailorServiceButton(sailorType: viewModel.sailorType) {
                                            viewModel.sailorServicesButtonTapped()
                                        }
                                    }
                                    
                                    // Contacts button
                                    VVRoundedIconButton(text: viewModel.landingScreenModel.content.addFriendText, icon: "qrcode") {
                                        viewModel.appCoordinator.executeCommand(HomeTabBarCoordinator.OpenMessengerContactsScreenCommand(deepLink: nil))
                                    }
									.background(
										RoundedRectangle(cornerRadius: 24)
											.fill(Color.white)
											.shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
									)
                                    .frame(maxWidth: .infinity)

                                }
                                
                                if viewModel.isSailorShip {
                                    // Chat Threads
                                    ChatThreadsView(viewModel: ChatThreadsViewModel(), viewHasError: $chatThreadsHasError, viewIsLoading: $chatThreadsIsLoading)
                                }
                                
                                
                                if !chatThreadsHasError && !chatThreadsIsLoading {
                                    // Footer view
                                    FotterView(text: viewModel.landingScreenModel.content.welcomingText)
                                        .padding(.horizontal, Paddings.defaultVerticalPadding24)
                                        .padding(.top, Paddings.defaultVerticalPadding16)
                                }
                            }
                        }
                    }
                    .task {
                        print("Will refresh messages")
                        await viewModel.refresh()
                    }
                    .padding()
                    .navigationBarTitleDisplayMode(.large)
                    .navigationTitle(viewModel.landingScreenModel.content.screenTitle)
                    .navigationDestination(for: MessengerNavigationRoute.self) { route in
                        viewModel.destinationView(for: route)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
				.background(Color.white)
            }

            if viewModel.screenState == .loading {
                ProgressView()
                    .font(.footnote)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .onAppear() {
            viewModel.onAppear()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    NavigationStack() {
        let mockViewModel = MockMessengerLandingViewModel()
        MessengerLandingScreen(viewModel: mockViewModel)
    }
}
