//
//  MusterDrillCoordinator.swift
//  Virgin Voyages
//
//  Created by TX on 7.4.25.
//

import Foundation

enum MusterDrillFullScreenRoute: BaseFullScreenRoute {
    case video
    var id: String {
        switch self {
        case .video:
            return "video"
        }
    }
}

enum MusterDrillSheetRoute: BaseSheetRouter {
    case languages

    var id: String {
        switch self {
        case .languages:
            return "languages"
        }
    }
}

@Observable class MusterDrillCoordinator {
    var fullScreenRouter: MusterDrillFullScreenRoute?
    var sheetRouter: SheetRouter<MusterDrillSheetRoute>

    init(fullScreenRouter: MusterDrillFullScreenRoute? = nil,
         sheetRouter: SheetRouter<MusterDrillSheetRoute> = .init()) {
        self.fullScreenRouter = fullScreenRouter
        self.sheetRouter = sheetRouter
    }
}

extension MusterDrillCoordinator {
    struct ShowLanguagesSheetCommand: NavigationCommandProtocol {
        func execute(on coordinator: AppCoordinator) {
            coordinator.homeTabBarCoordinator.musterDrillCoordinator.sheetRouter.present(sheet: .languages)
        }
    }
    
    struct DismissAnySheetCommand: NavigationCommandProtocol{
        func execute(on coordinator: AppCoordinator) {
            coordinator.homeTabBarCoordinator.musterDrillCoordinator.sheetRouter.dismiss()
        }
    }
    
    struct ShowMusterDrillVideoFullScreenCommand: NavigationCommandProtocol{
        func execute(on coordinator: AppCoordinator) {
            coordinator.homeTabBarCoordinator.musterDrillCoordinator.fullScreenRouter = .video
        }
    }
    
    struct DismissMusterDrillVideoFullScreenCommand: NavigationCommandProtocol{
        func execute(on coordinator: AppCoordinator) {
            if coordinator.homeTabBarCoordinator.musterDrillCoordinator.fullScreenRouter == .video {
                coordinator.homeTabBarCoordinator.musterDrillCoordinator.fullScreenRouter = nil
            }
        }
    }
}
