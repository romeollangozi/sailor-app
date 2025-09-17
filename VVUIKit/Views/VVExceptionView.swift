//
//  VVExceptionView.swift
//  VVUIKit
//
//  Created by Darko Trpevski on 4.8.25.
//

import SwiftUI

// MARK: - Exception Types
public enum ExceptionLayout {
	case defaultLayout
    case withLinkButton
}

public enum ExceptionButtonAction {
	case primaryButtonAction
	case secondaryButtonAction
}

@MainActor
public protocol ExceptionViewModelProtocol {
	var exceptionTitle: String { get }
	var exceptionDescription: String { get }
	var imageName: String { get }
	var primaryButtonText: String { get }
	var secondaryButtonText: String { get }
    var primaryButtonIsLoading: Bool { get }
	var exceptionLayout: ExceptionLayout { get }
	var primaryButtonAction: ExceptionButtonAction { get }
	var secondaryButtonAction: ExceptionButtonAction { get }
	func onAppear()
	func onPrimaryButtonTapped()
	func onSecondaryButtonTapped()
}

public struct VVExceptionView: View {
	@State var viewModel: ExceptionViewModelProtocol

	public init(viewModel: ExceptionViewModelProtocol) {
		_viewModel = State(wrappedValue: viewModel)
	}

	public var body: some View {
		GeometryReader { geo in
            VStack(spacing: Spacing.space24) {
				headerView
				errorImageView
				actionButtonsView
			}
			.frame(maxWidth: .infinity, maxHeight: .infinity)
			.background(Color.softCream)
		}
	}

	private var headerView: some View {
		VStack(spacing: .zero) {
			Text(viewModel.exceptionTitle)
				.font(.vvHeading1Bold)
				.multilineTextAlignment(.center)
				.padding()
			Text(viewModel.exceptionDescription)
				.font(.vvBody)
				.multilineTextAlignment(.center)
				.padding(.horizontal)
		}
		.fixedSize(horizontal: false, vertical: true)
	}

	private var errorImageView: some View {
		Image(viewModel.imageName)
			.resizable()
			.aspectRatio(contentMode: .fit)
			.frame(height: Spacing.space400)
			.clipped()
	}

	private var actionButtonsView: some View {
		VStack(spacing: Spacing.space0) {
			// Primary Button
			if !viewModel.primaryButtonText.isEmpty {
                PrimaryButton(viewModel.primaryButtonText,
                              padding:0.0,
                              isLoading: viewModel.primaryButtonIsLoading,
                              action: {
					handleButtonAction(viewModel.primaryButtonAction)
				})
                .padding(.horizontal)
                
			}

			// Secondary Button
			if !viewModel.secondaryButtonText.isEmpty {
                switch viewModel.exceptionLayout {
                case .defaultLayout:
                    SecondaryButton(viewModel.secondaryButtonText, action: {
                        handleButtonAction(viewModel.secondaryButtonAction)
                    })

                case .withLinkButton:
                    LinkButton(
                        viewModel.secondaryButtonText,
                        color: .gray,
                        action: {
                        handleButtonAction(viewModel.secondaryButtonAction)
                    })
				}
			}
		}
		.padding(.horizontal)
		.padding(.bottom, Spacing.space32)
	}

	private func handleButtonAction(_ action: ExceptionButtonAction) {
		switch action {
		case .primaryButtonAction:
			viewModel.onAppear()
			viewModel.onPrimaryButtonTapped()
		case .secondaryButtonAction:
			viewModel.onSecondaryButtonTapped()
		}
	}
}

// MARK: - Preview Models
@Observable final class ExceptionViewModelPreview: ExceptionViewModelProtocol {
    
	var exceptionTitle: String
	var exceptionDescription: String
	var imageName: String
	var primaryButtonText: String
	var secondaryButtonText: String
    var primaryButtonIsLoading: Bool = false
	var exceptionLayout: ExceptionLayout
	var primaryButtonAction: ExceptionButtonAction
	var secondaryButtonAction: ExceptionButtonAction

	init(
		exceptionTitle: String,
		exceptionDescription: String,
		imageName: String,
		primaryButtonText: String,
		secondaryButtonText: String = "",
        exceptionLayout: ExceptionLayout = .defaultLayout,
		primaryButtonAction: ExceptionButtonAction = .primaryButtonAction,
		secondaryButtonAction: ExceptionButtonAction = .secondaryButtonAction
	) {
		self.exceptionTitle = exceptionTitle
		self.exceptionDescription = exceptionDescription
		self.imageName = imageName
		self.primaryButtonText = primaryButtonText
		self.secondaryButtonText = secondaryButtonText
		self.exceptionLayout = exceptionLayout
		self.primaryButtonAction = primaryButtonAction
		self.secondaryButtonAction = secondaryButtonAction
	}

	func onAppear() {}

	func onPrimaryButtonTapped() {
		print("Primary button tapped")
	}

	func onSecondaryButtonTapped() {
		print("Secondary button tapped")
	}
}

// MARK: - Previews
#Preview("Voyage Cancelled") {
	VVExceptionView(
		viewModel: ExceptionViewModelPreview(
			exceptionTitle: "Voyage Cancelled",
			exceptionDescription: "Your voyage for French Daze & Ibiza Nights on September 29, 2025 has been cancelled. Please contact your primary booker or Sailor Services if you need further assistance",
			imageName: "exception_voyager_not_found",
			primaryButtonText: "Ok, got it",
			secondaryButtonText: "Contact Sailor Services",
            exceptionLayout: .withLinkButton,
			primaryButtonAction: .primaryButtonAction,
			secondaryButtonAction: .secondaryButtonAction
		)
	)
}

#Preview("Guest Not Found") {
	VVExceptionView(
		viewModel: ExceptionViewModelPreview(
			exceptionTitle: "Guest Not Found",
			exceptionDescription: "We're unable to locate your guest details. Please verify your booking information or contact Sailor Services.",
			imageName: "exception_voyager_not_found",
			primaryButtonText: "Try again",
            exceptionLayout: .defaultLayout,
			primaryButtonAction: .primaryButtonAction
		)
	)
}

#Preview("Voyage Not Found") {
	VVExceptionView(
		viewModel: ExceptionViewModelPreview(
			exceptionTitle: "Voyage Not Found",
			exceptionDescription: "We're unable to locate your voyage details. Please verify your booking information or contact Sailor Services.",
			imageName: "exception_voyager_not_found",
			primaryButtonText: "Contact Sailor Services",
            exceptionLayout: .withLinkButton,
			primaryButtonAction: .primaryButtonAction
		)
	)
}
