//
//  PinView.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 17.7.25.
//

import SwiftUI
import VVUIKit

public protocol PinViewModelProtocol {
	var text: String { get set }
	var state: PinViewState { get set }

	func handleTextChange(_ newValue: String)
	func reset()
	func showError()
	func getDigitAtIndex(_ index: Int) -> String
	func getCurrentActiveIndex() -> Int
	func updateState()
	func setFocusState(_ isFocused: Bool)
}

public struct PinView: View {

	private let spacing: CGFloat
	private let digitSize: CGSize
	private let onPinComplete: (String) -> Void

	@State private var viewModel: PinViewModelProtocol
	@FocusState private var isTextFieldFocused: Bool

	init(
		viewModel: PinViewModelProtocol = PinViewModel(),
		spacing: CGFloat = Spacing.space16,
		digitSize: CGSize = CGSize(width: Spacing.space48, height: Spacing.space64),
		onPinComplete: @escaping (String) -> Void
	) {
		_viewModel = State(wrappedValue: viewModel)
		self.spacing = spacing
		self.digitSize = digitSize
		self.onPinComplete = onPinComplete
	}

	public var body: some View {
		ZStack {
			hiddenTextField
			pinDigitsDisplay
		}
		.onAppear {
			setupViewModelCallbacks()
			viewModel.updateState()
		}
		.onChange(of: isTextFieldFocused) { _, focused in
			viewModel.setFocusState(focused)
		}
		.onChange(of: viewModel.state) { _, state in
			handleStateChange(state)
		}
		.onChange(of: viewModel.text) { _, text in
			onPinComplete(text)
		}
	}
}

private extension PinView {
	func setupViewModelCallbacks() {
		if let pinViewModel = viewModel as? PinViewModel {
			pinViewModel.onPinComplete = { pin in
				onPinComplete(pin)
			}
			viewModel = pinViewModel
		}
	}

	func handleStateChange(_ state: PinViewState) {
		if state == .complete {
			Task { @MainActor in
				try? await Task.sleep(nanoseconds: 300_000_000)
				isTextFieldFocused = false
			}
		}
	}
}

private extension PinView {
	var hiddenTextField: some View {
		TextField("", text: Binding(
			get: { viewModel.text },
			set: { viewModel.handleTextChange($0) }
		))
		.keyboardType(.numberPad)
		.textContentType(.oneTimeCode)
		.focused($isTextFieldFocused)
		.opacity(0)
	}

	var pinDigitsDisplay: some View {
		HStack(spacing: spacing) {
			ForEach(0..<4, id: \.self) { index in
				PinDigitView(
					digit: viewModel.getDigitAtIndex(index),
					isActive: index == viewModel.getCurrentActiveIndex() && viewModel.state == .entering,
					hasError: viewModel.state == .error,
					isFocused: isTextFieldFocused,
					size: digitSize
				)
				.onTapGesture {
					isTextFieldFocused = true
				}
			}
		}
	}
}

struct PinDigitView: View {
	let digit: String
	let isActive: Bool
	let hasError: Bool
	let isFocused: Bool
	let size: CGSize

	private let cornerRadius: CGFloat = Spacing.space8
	private let borderWidth: CGFloat = Spacing.space1
	private let cursorWidth: CGFloat = Spacing.space2
	private let cursorHeight: CGFloat = Spacing.space24

	@State private var shouldAnimateCursor = false

	var body: some View {
		ZStack {
			digitContainer
			digitText
			animatedCursor
		}
		.frame(width: size.width, height: size.height)
	}
}

private extension PinDigitView {
	var digitContainer: some View {
		RoundedRectangle(cornerRadius: cornerRadius)
			.stroke(borderColor, lineWidth: borderWidth)
			.background(
				RoundedRectangle(cornerRadius: cornerRadius)
					.fill(backgroundColor)
			)
			.scaleEffect(isActive ? 1.02 : 1.0)
			.animation(.easeInOut(duration: 0.2), value: isActive)
			.animation(.easeInOut(duration: 0.2), value: hasError)
	}

	@ViewBuilder
	var digitText: some View {
		if !digit.isEmpty {
			Text(digit)
				.font(.system(.title2, design: .default, weight: .semibold))
				.foregroundColor(textColor)
				.scaleEffect(digit.isEmpty ? 0.8 : 1.0)
				.animation(.spring(response: 0.3, dampingFraction: 0.7), value: digit.isEmpty)
		}
	}

	@ViewBuilder
	var animatedCursor: some View {
		if isActive && isFocused {
			RoundedRectangle(cornerRadius: Spacing.space1)
				.fill(.black)
				.frame(width: cursorWidth, height: cursorHeight)
				.opacity(shouldAnimateCursor ? 0.3 : 1.0)
				.animation(.easeInOut(duration: 0.8).repeatForever(), value: shouldAnimateCursor)
				.onAppear { shouldAnimateCursor = true }
				.onDisappear { shouldAnimateCursor = false }
		}
	}
}

private extension PinDigitView {
	var borderColor: Color {
		switch (hasError, isActive && isFocused, !digit.isEmpty) {
		case (true, _, _):
			return .black
		case (false, true, _), (false, false, true):
			return .black
		default:
			return .gray.opacity(0.4)
		}
	}

	var backgroundColor: Color {
		switch (hasError, isActive && isFocused, !digit.isEmpty) {
		case (true, _, _):
			return .white.opacity(0.1)
		case (false, true, _):
			return .white.opacity(0.05)
		case (false, false, true):
			return .white.opacity(0.1)
		default:
			return .white
		}
	}

	var textColor: Color {
		hasError ? .red : .black
	}
}
