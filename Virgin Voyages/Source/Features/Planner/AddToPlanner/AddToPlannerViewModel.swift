//
//  AddToPlannerViewModel.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 29.8.25.
//

import Foundation

final class AddToPlannerViewModel: BaseViewModelV2, AddToPlannerViewModelProtocol {
    var actions: [PlannerAction] = [.init(title: "Dining Reservation", action: { }), .init(title: "Spa Treatments", action: { }), .init(title: "Shore Excursion", action: { })]
    
    func onDismiss() {
        navigationCoordinator.executeCommand(
            HomeTabBarCoordinator.DismissFullScreenOverlayCommand(pathToDismiss: .addToPlanner)
        )
    }
}
