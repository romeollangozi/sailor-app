//
//  SetPinViewModel.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 17.7.25.
//

import Observation

@Observable public class PinViewModel: PinViewModelProtocol {
	public var text: String = ""
	public var state: PinViewState = .empty
	public var onPinComplete: ((String) -> Void)?

	private var pinData: PinData {
		PinData(from: text)
	}

	public func handleTextChange(_ newValue: String) {
		let filtered = newValue.filter(\.isNumber)
		let limited = String(filtered.prefix(4))
		text = limited
		updateState()
	}

	public func updateState() {
		let newState = calculateNewState()

		guard state != newState else { return }

		state = newState

		if newState == .complete {
			onPinComplete?(text)
		}
	}

	public func reset() {
		text = ""
		state = .empty
	}

	public func showError() {
		state = .error

		Task { @MainActor in
			try? await Task.sleep(nanoseconds: 2_000_000_000)
			updateState()
		}
	}

	public func getDigitAtIndex(_ index: Int) -> String {
		index < pinData.digits.count ? pinData.digits[index] : ""
	}

	public func getCurrentActiveIndex() -> Int {
		pinData.digits.count
	}

	public func setFocusState(_ isFocused: Bool) {
		if isFocused && state == .empty {
			state = .entering
		}
	}

	private func calculateNewState() -> PinViewState {
		if pinData.isEmpty {
			return .empty
		} else if pinData.isComplete {
			return .complete
		} else {
			return .entering
		}
	}
}

public enum PinViewState: Equatable, CaseIterable {
	case empty
	case entering
	case complete
	case error

	public var description: String {
		switch self {
		case .empty: return "empty"
		case .entering: return "entering"
		case .complete: return "complete"
		case .error: return "error"
		}
	}
}
