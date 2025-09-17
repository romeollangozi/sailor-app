//
//  BaseViewModel.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 6.11.24.
//

import Foundation

@Observable class BaseViewModel {

    // MARK: - Properties
	var isFirstLaunch: Bool = true
    var errorService: ErrorService
	var navigationCoordinator: CoordinatorProtocol
	var logger: LoggerProtocol

    let errorEventsService: ErrorEventsNotificationService
    
    // MARK: - Init
	init(
		errorService: ErrorService = ErrorService.shared,
		navigationCoordinator: CoordinatorProtocol = AppCoordinator.shared,
		logger: LoggerProtocol = DefaultLogger(),
        errorEventsService: ErrorEventsNotificationService = .shared
	) {
		self.errorService = errorService
		self.navigationCoordinator = navigationCoordinator
		self.logger = logger
        self.errorEventsService = errorEventsService
    }

	func executeNavigationCommand(_ command: NavigationCommandProtocol) {
		self.navigationCoordinator.executeCommand(command)
	}

	func executeUseCase<T>(_ callback: @escaping () async throws -> T) async -> T? {
		do {
			let result = try await UseCaseExecutor.execute {
				try await callback()
			}
			return result
		} catch let error as VVError {
			handleError(error)
			return nil
		} catch {
			return nil
		}
	}

    // MARK: - Base methods
    func handleError(_ error: VVError) {
		if let commonError = error as? VVDomainError {
			errorService.error = commonError
            errorEventsService.publish(.didReceiveError(commonError))
		}
		logger.log(error)
    }
    
    @MainActor
    func executeOnMain(_ callback: VoidCallback) {
        callback()
    }
}

@MainActor protocol BaseViewModelProtocol {
	var navigationCoordinator: CoordinatorProtocol { get set }
}

@MainActor
@Observable class BaseViewModelV2: BaseViewModelProtocol {

	// MARK: - Properties
	var isFirstLaunch: Bool = true
	var errorService: ErrorService
	var navigationCoordinator: CoordinatorProtocol
	var logger: LoggerProtocol

	let errorEventsService: ErrorEventsNotificationService

	// MARK: - Init
	init(
		errorService: ErrorService = ErrorService.shared,
		navigationCoordinator: CoordinatorProtocol = AppCoordinator.shared,
		logger: LoggerProtocol = DefaultLogger(),
		errorEventsService: ErrorEventsNotificationService = .shared
	) {
		self.errorService = errorService
		self.navigationCoordinator = navigationCoordinator
		self.logger = logger
		self.errorEventsService = errorEventsService
	}

	func executeNavigationCommand(_ command: NavigationCommandProtocol) {
		self.navigationCoordinator.executeCommand(command)
	}

	func executeUseCase<T>(_ callback: @escaping () async throws -> T) async -> T? {
		do {
			let result = try await UseCaseExecutor.execute {
				try await callback()
			}
			return result
		} catch let error as VVError {
			handleError(error)
			return nil
		} catch {
			return nil
		}
	}

	// MARK: - Base methods
	func handleError(_ error: VVError) {
		if let commonError = error as? VVDomainError {
			errorService.error = commonError
			errorEventsService.publish(.didReceiveError(commonError))
		}
		logger.log(error)
	}
}
