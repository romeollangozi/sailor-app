//
//  ScreenTask.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 4/15/23.
//

import SwiftUI
import Observation

@Observable class ScreenTask {
	var showError = false
	var showSheet = false
	var status: Status?
	var error: Endpoint.Error?
	var progress: Double?
	var text: String? = nil
    var errorService: ErrorService
    let errorEventsService: ErrorEventsNotificationService
	typealias TaskAction = () async throws -> Void
	
	var disabled: Bool {
		status == .fetching
	}
	
	enum Status {
		case empty
		case fetching
		case success
		case failed
	}
	
    init(_ status: Status? = nil,
         errorService: ErrorService = ErrorService.shared,
         errorEventsService: ErrorEventsNotificationService = .shared) {
		self.status = status
        self.errorService = errorService
        self.errorEventsService = errorEventsService
	}
	
	@MainActor func run(action: TaskAction) async throws {
		text = nil
		status = .fetching
		showError = false
		do {
			try await action()
			status = .success
			text = nil
		} catch(let endpointError as Endpoint.Error) {
			error = endpointError
            handleError(error: endpointError)

		} catch {
            showError = true
			status = .failed
		}

    }
    
    private func handleError(error: Endpoint.Error) {
        guard let errorCode = error.statusCode else {
            status = .failed
            self.showError = true
            return
        }
        
        if Endpoint.Error.ErrorCode.retryableErrors.contains(errorCode) {
            status = .failed
            self.showError = true
        } else {
            let domainError = Endpoint.Error.mapToVVDomainError(from: error)
            errorEventsService.publish(.didReceiveError(domainError))
            errorService.error = domainError
        }
    }
    
}
