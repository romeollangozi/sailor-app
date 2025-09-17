//
//  DiscoverViewModel.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 2/4/25.
//


import SwiftUI
import VVUIKit

@Observable class DiscoverViewModel: BaseViewModel {

    var appCoordinator: AppCoordinator = AppCoordinator.shared
    
	private var navigationRouter: NavigationRouter<DiscoverNavigationRoute> {
		return AppCoordinator.shared.discoverCoordinator.navigationRouter
	}
    
    private var sheetRouter: SheetRouter<DiscoverSheetRoute> {
        return AppCoordinator.shared.discoverCoordinator.sheetRouter
    }

	var navigationPath: NavigationPath {
		get {
			return navigationRouter.navigationPath
		}
		set {
			navigationRouter.navigationPath = newValue
		}
	}
    
    private let cancelAppointmentUseCase: CancelAppointmentUseCaseProtocol

    init(cancelAppointmentUseCase: CancelAppointmentUseCaseProtocol = CancelAppointmentUseCase()) {
        self.cancelAppointmentUseCase = cancelAppointmentUseCase
    }

	func navigateBack() {
		navigationRouter.navigateBack()
	}

	func navigateBack(steps: Int) {
		navigationRouter.navigateBack(steps: steps)
	}

	func navigateTo(_ route: DiscoverNavigationRoute) {
		navigationRouter.navigateTo(route)
	}

	func navigateToRoot() {
		navigationRouter.goToRoot()
	}
    
	func showCancellationFlow(activity: any CancelBookableActivity) {
        sheetRouter.present(sheet: .cancellationFlow(activity: activity))
    }
    
    func dismissSheet() {
        sheetRouter.dismiss()
    }
    
    // MARK: - Cancel Appointment Use Case
	func cancelAppointment(numberOfGuests: Int, activity: any CancelBookableActivity) async -> Bool {
        let sailors = CancelAppointmentInputModel.map(from: activity.sailors)
        let input = CancelAppointmentInputModel(
            appointmentLinkId: activity.appointmentLinkId,
			categoryCode: activity.category,
            numberOfGuests: numberOfGuests,
            isRefund: false,
            personDetails: sailors
        )
        if let result = await executeUseCase({
            try await self.cancelAppointmentUseCase.execute(inputModel: input)
        }) {
            let success = (result.message == nil)
            return success
        } else {
            return false
        }
    }
    
    func destinationView(for sheetRoute: any BaseSheetRouter) -> AnyView {
        guard let discoverSheetRoute = sheetRoute as? DiscoverSheetRoute else { return AnyView(EmptyView()) }
        switch discoverSheetRoute {
        case .cancellationFlow(let activity):
            if activity.isWithinCancellationWindow {
                switch activity.inventoryState {
                case .nonInventoried:
                    return AnyView(NonTicketedCancellationFlow(
                        guests: activity.sailors.count,
                        labels: NonTicketedCancellationFlow.Labels(cancellationSucessMessage: activity.cancelationCompletedText),
                        onCancelHandler: { guestCount in
                            return await self.cancelAppointment(numberOfGuests: guestCount, activity: activity)
                        },
                        onDismiss: {
                            self.dismissSheet()
                        },
                        onFinish: {
                            self.dismissSheet()
                            self.appCoordinator.executeCommand(HomeTabBarCoordinator.RemoveReceipScreenCommand())
                        }
                    ))
                default:
                    return AnyView(CancellationFlow(
                        guests: activity.sailors.count,
                        refundText: activity.refundTextForIndividual,
						labels: CancellationFlow.Labels(refundConfirmationMessage: activity.refundConfirmationMessage,
                            cancellationSucessMessage: activity.cancelationCompletedText,
                            refundTextForIndividual: activity.refundTextForIndividual,
                            refundTextForGroup: activity.refundTextForGroup
                        ),
                        onCancelHandler: { guestCount in
                            return await self.cancelAppointment(numberOfGuests: guestCount, activity: activity)
                        },
                        onDismiss: {
                            self.dismissSheet()
                        },
                        onFinish: {
                            self.dismissSheet()
                            self.appCoordinator.executeCommand(HomeTabBarCoordinator.RemoveReceipScreenCommand())
                        }
                    ))
                }
            } else {
                return AnyView(CancellationFlow(
                    guests: activity.sailors.count,
                    isAllowedToCancel: false,
                    onDismiss: {
                        self.dismissSheet()
                    },
                    onFinish: {
                        self.dismissSheet()
                        self.appCoordinator.executeCommand(HomeTabBarCoordinator.RemoveReceipScreenCommand())
                    }
                ))
            }
        }
    }
}
