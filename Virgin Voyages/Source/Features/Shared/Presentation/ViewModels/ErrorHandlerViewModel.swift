//
//  ErrorHandlerViewModel.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 8.11.24.
//

import Combine
import Foundation

@Observable class ErrorHandlerViewModel {

	var errorService: ErrorServiceProtocol
	var logoutUserUseCase: LogoutUserUseCaseProtocol

    let errorEventsService: ErrorEventsNotificationService
    private var listenerKey = "ErrorHandlerViewModel"

	var isShowingModalError: Bool = false

	var title: String? {
		switch errorService.error {
		case .genericError:
			return "#Awkward"
		case .error(let title, _):
			return title
		default:
			return nil
		}
	}

	var subheadline: String? {
		switch errorService.error {
		case .genericError:
			return "Oops! That didn't go as planned. Please try again!"
		case .error(_, let message):
			return message
		default:
			return nil
		}
	}

	init(
		errorService: ErrorServiceProtocol = ErrorService.shared,
		logoutUserUseCase: LogoutUserUseCaseProtocol = LogoutUserUseCase(),
        errorEventsService: ErrorEventsNotificationService = .shared
	) {
		self.errorService = errorService
		self.logoutUserUseCase = logoutUserUseCase
        self.errorEventsService = errorEventsService
//		observeErrorService()
        startObservingEvents()
	}


    func startObservingEvents() {
        errorEventsService.listen(key: listenerKey) { [weak self] in
            guard let self else { return }
            self.handleEvent($0)
        }
    }

    func handleEvent(_ event: ErrorNotification) {
        switch event {
        case .didReceiveError(let vvDomainError):
            print("errorEventsService handleEvent unable to get current sailor : ", self.errorService.error as Any)
            Task {
                await self.handleError(vvDomainError)
            }
        }
    }
    
    deinit {
        errorEventsService.stopListening(key: listenerKey)
    }
    
//	private func observeErrorService() {
//		withObservationTracking {
//			_ = errorService.error
//		} onChange: { [weak self] in
//			guard let self = self else { return }
//			self.observeErrorService()
//            print("observeErrorService handleError unable to get current sailor : ", self.errorService.error as Any)
//            Task {
//                await self.handleError(self.errorService.error)
//            }
//		}
//	}
    
    @MainActor
	private func handleError(_ error: VVDomainError?) {
		guard let error = error else {
			isShowingModalError = false
			return
		}
		switch error {
		case .genericError:
			isShowingModalError = true
		case .error(_, _):
			isShowingModalError = true
		case .unauthorized:
			Task {
				await logoutUserUseCase.execute()
			}
		case .validationError(_):
			return
		case .unknownError:
			return
        case .notFound:
            return
        }
	}
}


