//
//  Virgin_VoyagesApp.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 11/28/22.
//

import SwiftUI
import GoogleSignIn

@main
struct Virgin_VoyagesApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @Environment(\.scenePhase) var scenePhase
    
    @State private var viewModel: AppViewModel
    private let contentViewModel: ContentViewViewModelProtocol
    
    init() {
        let appViewModel = AppViewModel()
        _viewModel = .init(wrappedValue: appViewModel)
        
        contentViewModel = ContentViewViewModel(
            errorHandlingViewModel: appViewModel.errorHandlingViewModel,
            notificationService: appViewModel.pushNotificationService,
            landingScreenViewModel: LandingScreenViewModel(),
            mainViewViewModel: MainViewViewModel()
        )
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: contentViewModel)
                .onAppear {
                    viewModel.onAppear()
                }
                .uncancellableAlert(
                    isPresented: $viewModel.shouldShowAppStoreUpdate,
                    title: "Your app needs to be updated.",
                    message: "An update to the Virgin Voyages app is now available. Please update to continue using the application.",
                    buttonText: "Update",
                    action: {
                        viewModel.openAppStore()
                    }
                )
                .onOpenURL { url in
                    viewModel.handleExternalURL(url: url)
                    
                    GIDSignIn.sharedInstance.handle(url)
                }
				.onContinueUserActivity(NSUserActivityTypeBrowsingWeb) { userActivity in
					if let url = userActivity.webpageURL {
						viewModel.handleExternalURL(url: url)
					}
				}
                .onChange(of: scenePhase) {
                    switch scenePhase {
                    case .active:
                        viewModel.appDidBecomeActive()
                        return
                    case .inactive:
                        viewModel.appDidBecomeInactive()
                        return
                    case .background:
                        print("App is in the background")
                    @unknown default:
                        print("Unexpected new value for scenePhase.")
                    }
                }
        }
    }
}
