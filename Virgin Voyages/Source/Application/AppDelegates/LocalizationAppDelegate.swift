//
//  LocalizationAppDelegate.swift
//  Virgin Voyages
//
//  Created by TX on 16.6.25.
//

import Foundation
import UIKit

class LocalizationAppDelegate: NSObject, UIApplicationDelegate {
    private var localizationUseCase: LoadLocalizationUseCaseProtocol?

    init(useCase: LoadLocalizationUseCaseProtocol? = nil) {
        self.localizationUseCase = useCase
    }

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        // Only create a default if none was injected
        if localizationUseCase == nil {
            localizationUseCase = LoadLocalizationUseCase(
                repository: ResourcesRepository(),
                diskStore: StringResourcesDiskStore(),
                localizationManager: LocalizationManager.shared
            )
        }

        Task {
            await localizationUseCase?.execute(useCache: false)
        }

        return true
    }
}
