//
//  SocialShareUseCase.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 27.1.25.
//


import Foundation
import SwiftUI

protocol SocialShareUseCaseProtocol {
    func shareText(_ text: String)
    func shareImage(_ image: UIImage)
    func shareURL(_ url: URL)
    func shareCustomData(_ items: [Any])
}

class SocialShareUseCase: SocialShareUseCaseProtocol {
    
    // MARK: - Private properties
    private let customizationHandler: ((UIActivityViewController) -> Void)?
    private let excludedActivityTypes: [UIActivity.ActivityType]?

    // MARK: - Init
    init(customizationHandler: ((UIActivityViewController) -> Void)? = nil,
         excludedActivityTypes: [UIActivity.ActivityType]? = nil) {
        self.customizationHandler = customizationHandler
        self.excludedActivityTypes = excludedActivityTypes
    }
    
    // MARK: - Protocol methods
    func shareText(_ text: String) {
        presentActivityViewController(with: [text])
    }
    
    func shareImage(_ image: UIImage) {
        presentActivityViewController(with: [image])
    }
    
    func shareURL(_ url: URL) {
        presentActivityViewController(with: [url])
    }
    
    func shareCustomData(_ items: [Any]) {
        presentActivityViewController(with: items)
    }
    
    
    private func getTopViewController(_ rootViewController: UIViewController? = nil) -> UIViewController? {
        guard Thread.isMainThread else {
            return DispatchQueue.main.sync {
                getTopViewController(rootViewController)
            }
        }
        
        let rootVC = rootViewController ?? UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }?.rootViewController
        
        if let navController = rootVC as? UINavigationController {
            return getTopViewController(navController.visibleViewController)
        }
        if let tabController = rootVC as? UITabBarController {
            return getTopViewController(tabController.selectedViewController)
        }
        if let presentedController = rootVC?.presentedViewController {
            return getTopViewController(presentedController)
        }
        return rootVC
    }


    
    // MARK: - Present share view
    private func presentActivityViewController(with items: [Any]) {
        guard let topViewController = getTopViewController() else {
            return
        }

        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
        activityVC.excludedActivityTypes = excludedActivityTypes

        customizationHandler?(activityVC)

        DispatchQueue.main.async {
            topViewController.present(activityVC, animated: true) {}
        }
    }
}
