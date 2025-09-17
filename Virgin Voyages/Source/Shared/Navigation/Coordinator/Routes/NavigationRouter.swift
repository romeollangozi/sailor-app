//
//  NavigationRouter.swift
//  Virgin Voyages
//
//  Created by TX on 15.1.25.
//

import Foundation
import SwiftUI

@Observable class NavigationRouter<Route: Hashable> {
    var navigationPath = NavigationPath()
    private var routeStack: [Route] = []

    var rootAction: (() -> Void)?

    func navigateTo(_ route: Route, animation: Bool = true) {
        
        // Disabling animations for this specific navigation
        withTransaction(Transaction(animation: animation ? .default : nil)) {
            navigationPath.append(route)
            routeStack.append(route)
        }
    }

    func navigateBack(animation: Bool = true) { // Add animation parameter
        if !navigationPath.isEmpty {
            withTransaction(Transaction(animation: animation ? .default : nil)) {
                navigationPath.removeLast()
                routeStack.removeLast()
            }
        }
    }

    func navigateBack(steps: Int = 1, animation: Bool = true) {
        guard steps > 0, routeStack.count >= steps else { return }
        withTransaction(Transaction(animation: animation ? .default : nil)) {
            for _ in 0..<steps {
                navigationPath.removeLast()
                routeStack.removeLast()
            }
        }
    }

    func root(animation: Bool = true) { // Add animation parameter
        if !navigationPath.isEmpty {
            withTransaction(Transaction(animation: animation ? .default : nil)) {
                navigationPath.removeLast(navigationPath.count)
                routeStack.removeAll()
            }
        }
        goToRoot(animation: animation) // Call goToRoot with animation parameter
    }

    func goToRoot(animation: Bool = true) {
        Task { @MainActor in
            withTransaction(Transaction(animation: animation ? .default : nil)) {
                navigationPath = NavigationPath()
                routeStack = []
            }
            rootAction?()
        }
    }
    
    func setupPaths(paths: [Route], animation: Bool = false) {
        if animation {
            Task {
                for path in paths {
                    try? await Task.sleep(nanoseconds: 35_000_000) // 35ms delay for animation to be visible
                    navigationPath.append(path)
                    routeStack.append(path)
                }
            }
        } else {
            withTransaction(Transaction(animation: animation ? .default : nil)) {
                navigationPath = NavigationPath(paths)
                routeStack = paths
            }
        }
    }

    func navigateBackTo(_ targetRoute: Route, animation: Bool = true) {
        guard let index = routeStack.lastIndex(of: targetRoute) else { return }
        let stepsToPop = routeStack.count - index - 1
        guard stepsToPop > 0 else { return }

        withTransaction(Transaction(animation: animation ? .default : nil)) {
            for _ in 0..<stepsToPop {
                navigationPath.removeLast()
                routeStack.removeLast()
            }
        }
    }
    
    func getCurrentRoute() -> Route? {
        routeStack.last
    }
    
}

protocol BaseNavigationRoute: Hashable {}
protocol BaseFullScreenRoute: Hashable, Identifiable {}
