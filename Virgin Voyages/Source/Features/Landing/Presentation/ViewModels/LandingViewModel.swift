//
//  LandingViewModel.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 8/20/24.
//

import Foundation
import SwiftUI

protocol DeepLinkPathViewModel {
    var currentDeepLink: DeepLinkType? { get set }
}

//TODO: Remove This DeepLink Integration, implement new DeepLinkManger with Coordinators.
protocol DeepLinkHandlingViewModel: DeepLinkPathViewModel{
    func handleDeepLink(deepLink: DeepLinkType?)
}

protocol LandingViewModelProtocol: DeepLinkHandlingViewModel, CoordinatorSheetViewProvider {
    
    var appCoordinator: AppCoordinator  { get set }
    var bottomButtonsAnimationDurationInSeconds: TimeInterval { get set }
    var bottomButtonsVisible: Bool { get set }
    var showLoginSheet: Bool { get set }
    var showSignUpSheet: Bool { get set }
    var showDeactivatedAccountSheet: Bool { get set }
    var backgroundVideoPlayer: LoopingVideoPlayer { get }
    func requestPermissions()
    func navigateToLogin()
    func navigateToSignUp()
    func destinationView(for route: any BaseSheetRouter) -> AnyView
    func dismissView()
}

@Observable class LandingViewModel: LandingViewModelProtocol {
  
    var appCoordinator: AppCoordinator
    var currentDeepLink: DeepLinkType?
    var bottomButtonsAnimationDurationInSeconds = 0.3333
    var bottomButtonsVisible = false
    var showLoginSheet = false
    var showSignUpSheet = false
    var showDeactivatedAccountSheet = false

    var backgroundVideoPlayer: LoopingVideoPlayer
    private var requestPushNotificationPermissionsUseCase: RequestPushNotificationPermissionsUseCase

    init(backgroundVideoPlayer: LoopingVideoPlayer,
         requestPushNotificationPermissionsUseCase: RequestPushNotificationPermissionsUseCase = RequestPushNotificationPermissionsUseCase(pushNotificationService: FirebasePushNotificationService.shared),
         appCoordinator: AppCoordinator = .shared,
         currentDeepLink: DeepLinkType? = nil) {
        self.backgroundVideoPlayer = backgroundVideoPlayer
        self.requestPushNotificationPermissionsUseCase = requestPushNotificationPermissionsUseCase
        self.appCoordinator = appCoordinator
        self.currentDeepLink = currentDeepLink
    }

    func requestPermissions() {
        Task {
            await requestPushNotificationPermissionsUseCase.execute()
        }
    }

    func handleDeepLink(deepLink: DeepLinkType?) {
        guard let deepLink else { return }

        if deepLink == .loginScreen {
            // Stay on the same page
        }
    }
    
    //MARK: Navigation
    func navigateToLogin() {
        appCoordinator.executeCommand(LandingScreensCoordinator.OpenLoginSelectionCommand())
    }
    
    func navigateToSignUp() {
        appCoordinator.executeCommand(LandingScreensCoordinator.OpenSignUpCommand())
    }
    
    func dismissView() {
        appCoordinator.executeCommand(LandingScreensCoordinator.DismissCurrentSheetCommand())
    }

    // MARK: Coordinator Destination Sheet provider
    func destinationView(for sheetRoute: any BaseSheetRouter) -> AnyView {
        guard let landingSheetRoute = sheetRoute as? LandingSheetRoute  else { return AnyView(EmptyView()) }
        switch landingSheetRoute {
        case .login:
            return AnyView(
                LoginSheet.create()
            )
        case .signup:
            return AnyView(
                SignUpSheet.create()
            )
        case .claimABookingDeactivatedAccount:
            return AnyView(
                ClaimBookingDeactivatedAccountSheet()
            )
        }
    }
}
