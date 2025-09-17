//
//  ReviewCreditCardConfirmationView.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 8/14/24.
//

import SwiftUI
import VVUIKit

protocol ReviewCreditCardConfirmationViewModelProtocol {
	var cardNumber: String { get }
	var name: String { get }
	var expiryMonth: String { get }
	var expiryYear: String { get }
}

struct ReviewCreditCardConfirmationView: View {

	@State var viewModel: ReviewCreditCardConfirmationViewModelProtocol

	var useCardOnFile: (() -> Void)?
	var useDifferentCard: (() -> Void)?
	var dismiss: (() -> Void)?

	init(viewModel: ReviewCreditCardConfirmationViewModelProtocol,
		 useCardOnFile: (() -> Void)? = nil,
		 useDifferentCard: (() -> Void)? = nil,
		 dismiss: (() -> Void)? = nil) {
		_viewModel = State(wrappedValue: viewModel)
		self.useCardOnFile = useCardOnFile
		self.useDifferentCard = useDifferentCard
		self.dismiss = dismiss
	}

	var body: some View {
		VStack {
			closeButton
			cardInfo
			questionText
			messageText
			actionButtons
		}
		.padding(20)
		.background(
			RoundedRectangle(cornerRadius: 20)
				.fill(Color.white)
				.shadow(radius: 10)
		)
		.padding(20)
	}

	// MARK: - Subviews

	private var closeButton: some View {
		HStack {
			Spacer()
			SailableCloseButton {
				dismiss?()
			}
		}
	}

	private var cardInfo: some View {
		PaymentMethodCreditCardLabel(
			cardNumber: viewModel.cardNumber.maskedExceptLastFour(),
			name: viewModel.name.maskedByWord(),
			expiryMonth: viewModel.expiryMonth,
			expiryYear: viewModel.expiryYear
		)
	}

	private var questionText: some View {
		Text("Quick question...")
			.foregroundStyle(Color.black)
			.font(.title)
			.bold()
			.padding(.bottom, 10)
	}

	private var messageText: some View {
		Text("Looks like you already have a card on file.")
			.font(.subheadline)
			.multilineTextAlignment(.center)
			.padding(.horizontal, 20)
	}

	private var actionButtons: some View {
		VStack(spacing: 12) {
			LoadingButton(title: "Use card on file", loading: false) {
				useCardOnFile?()
			}
			.buttonStyle(PrimaryButtonStyle())

			LoadingButton(title: "Use a different card", loading: false) {
				useDifferentCard?()
			}
			.buttonStyle(TertiaryButtonStyle())
		}
	}
}
