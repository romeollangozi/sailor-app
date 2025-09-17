//
//  AppCoordinator+ApplicationScreenFlow.swift
//  Virgin Voyages
//
//  Created by TX on 21.7.25.
//

import Foundation

extension AppCoordinator {

	func calculateCurrentScreenFlow() {
        
        if authenticationService.error != nil {
            setCurrentFlow(.authenticationServiceError)
            return
        }
        
		let currentSailor = currentSailorManager.getCurrentSailor()
		if let errorState = currentSailor?.errorState {
			setCurrentFlowBySailorProfileErrorState(errorState)
			return
		}

		if authenticationService.isSwitchingReservation {
			setCurrentFlow(.loadingReservation)
			return
		}

		if authenticationService.currentAccount != nil &&
			authenticationService.currentAccount?.status == .active {

			if authenticationService.userProfile != nil {

				if authenticationService.isFetchingReservation {
					setCurrentFlow(.loadingReservation)
					return
				}

				if currentSailor?.errorState == .voyageUpdate {
					setCurrentFlow(.voyageUpdate)
					return
				}

				if authenticationService.reservation != nil {
					setCurrentFlow(.loggedIn)
					return
				} else {
					if let errorState = currentSailor?.errorState {
						setCurrentFlowBySailorProfileErrorState(errorState)
						return
					}
					setCurrentFlow(.reservationNotFound)
					return
				}
			}

			setCurrentFlow(.loggedOut)
			return
		}

		setCurrentFlow(.loggedOut)
		return
	}

	private func setCurrentFlowBySailorProfileErrorState(_ errorState: SailorProfileV2ErrorState) {
		switch errorState {
		case .voyageUpdate:
			setCurrentFlow(.voyageUpdate)
		case .voyageCancelled:
			setCurrentFlow(.voyageCancelled)
		case .voyageNotFound:
			setCurrentFlow(.voyageNotFound)
		case .guestNotFound:
			setCurrentFlow(.guestNotFound)
		}
		return
	}

	private func setCurrentFlow(_ flow: ApplicationFlow) {
		print("Setting current flow from \(self.currentFlow) to \(flow)")
		self.currentFlow = flow
	}
}
