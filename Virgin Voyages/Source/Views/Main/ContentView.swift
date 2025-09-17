//
//  ContentView.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 11/28/22.
//

import AVKit
import SwiftUI
import VVUIKit

enum DeepLinkType: Equatable {
    case messengerScreen
    case loginScreen
    case reactNativeApp
    case custom
    
    var deepLinkActionTitle: String {
        switch self {
        case .messengerScreen:
            return "Open In Messenger"
        case .loginScreen:
            return "Go To Login"
        case .reactNativeApp:
            return "Open In App"
        case .custom:
            return "Custom text"
        }
    }
}


struct ContentView: View {
    
    @State private var viewModel: ContentViewViewModelProtocol

    init(viewModel: ContentViewViewModelProtocol) {
        _viewModel = State(wrappedValue:viewModel)
    }
    
	var body: some View {
        ZStack {
            switch viewModel.navigationCoordinator.currentFlow {
            case .loggedOut:
                LandingScreen(viewModel: viewModel.landingScreenViewModel) {
                    viewModel.showWifiSheet()
                }
            case .loggedIn:
                MainView(viewModel: viewModel.mainViewViewModel)
                    .onAppear {
                        viewModel.mainViewViewModel.resetSelectedTabState()
                    }
            case .loadingReservation:
                // TODO: Need UI for loading booking transition for after login
                ProgressView("Loading your booking...")
                    .fontStyle(.headline)
                
            case .reservationNotFound:
                ClaimBookingView.create()

			case .voyageUpdate:
				VoyageUpdatingView()
            case .initialLoading:
                LaunchScreen()
			case .voyageCancelled:
				CancelledVoyageView()
			case .voyageNotFound:
				VVExceptionView(viewModel: VoyageNotFoundViewModel())
			case .guestNotFound:
				VVExceptionView(viewModel: GuestNotFoundViewModel())
            case .authenticationServiceError:
                VVExceptionView(viewModel: ProfileReservationCoreErrorViewModel())
            }
        
            if viewModel.errorHandlingViewModel.isShowingModalError {
				VVSheetModal(title: viewModel.errorHandlingViewModel.title,
							 subheadline: viewModel.errorHandlingViewModel.subheadline,
							 primaryButtonText: "OK",
							 primaryButtonAction: {
					viewModel.errorHandlingViewModel.isShowingModalError = false
				}, dismiss: {
					viewModel.errorHandlingViewModel.isShowingModalError = false
				})
				.background(Color.clear)
				.transition(.opacity)
            }
        }
        .onAppear {
            viewModel.onAppear()
        }
        .onDisappear() {
            viewModel.onDisappear()
        }
        .overlay(
            ZStack {
                PushNotificationBannerView(
                    pushNotification: viewModel.notificationService.latestNotification,
                    showNotification: $viewModel.notificationService.showNotification,
                    didAppear: {
                        // Preload user application status to avoid waiting for network calls after user taps the banner
                        Task { await self.viewModel.preloadUserApplicationStatus() }
                    }, onTap: {
                        // Handle notification on tap
                        Task {
                            if let notification = viewModel.notificationService.latestNotification {
                                await viewModel.handleNotificationTap(notification: notification)
                            }
                        }
                    }
                )
            }
        )
		.navigationBarTitleDisplayMode(.inline)
        .animation(.easeInOut, value: viewModel.navigationCoordinator.currentFlow)
        .onChange(of: viewModel.currentDeepLink, { _, newValue in
            viewModel.handleDeepLink(deepLink: newValue)
        })
		.sheet(isPresented: $viewModel.shouldShowWifiSheet) {
			WiFiSheet()
				.presentationDetents([.medium])
				.presentationDragIndicator(.visible)
		}
        .preferredColorScheme(.light)
	}
}
