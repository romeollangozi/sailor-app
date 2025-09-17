//
//  PaymentMethodView.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 4/23/24.
//

import SwiftUI

protocol PaymentMethodViewModelProtocol: Sailable {
	var repository: PaymentMethodRepositoryProtocol { get }
	var step: PaymentMethodViewModel.Step { get set }
	var paymentMethodModel: PaymentMethodModel { get set }
	var imageURL: URL? { get set }
	var backgroundColor: Color { get set }
    
    var cardDetails: CreditCardDetails? { get set }

	var shouldShowReviewCreditCardModal: Bool { get set }
    var shouldShowFailedPayment: Bool { get set }
	var navigationMode: NavigationMode { get }
    var paymentFailedError: String { get set }
    var completionPercentage: Double { get set }

	func selectedPaymentMethodAtIndex(_ index: Int)

	func saveCard()
    func navigateToReviewCard()
    func navigateToAddCard()
    func dismissReviewCreditCardModal()
	func discardChanges()
	func startInterview()
	func startOver()
	func back()
	func reload(_ sailor: Endpoint.SailorAuthentication) async throws
}

struct PaymentMethodView: View {

	@Environment(\.dismiss) var dismiss

	@State private var viewModel: PaymentMethodViewModelProtocol

	init(paymentMethodViewModel: PaymentMethodViewModelProtocol) {
		_viewModel = State(initialValue: paymentMethodViewModel)
	}

	var body: some View {
		ZStack {
			contentForStep()
		}
        .sailableToolbar(task: viewModel)
        .fullScreenCover(isPresented: Binding.constant(viewModel.shouldShowReviewCreditCardModal)) {
            ReviewCreditCardConfirmationView(viewModel: ReviewCreditCardConfirmationViewModel(paymentMethodModel: viewModel.paymentMethodModel), useCardOnFile: {
                viewModel.saveCard()
            }, useDifferentCard: {
                viewModel.navigateToAddCard()
            }, dismiss: {
                viewModel.dismissReviewCreditCardModal()
            }).presentationBackground(Color.black.opacity(0.75))
        }
        .fullScreenCover(isPresented: $viewModel.shouldShowFailedPayment) {
            paymentFailed(with: viewModel.paymentFailedError) {
                viewModel.back()
                viewModel.shouldShowFailedPayment = false
            }
        }
	}

	@ViewBuilder
	private func contentForStep() -> some View {
		switch viewModel.step {
		case .start:
			startStepContent()
		case .cash:
			cashStepContent()
		case .addCard:
			addCardStepContent()
		case .reviewCard:
			reviewCardStepContent()
		case .someoneElse:
			someoneElseStepContent()
        case .viewCard:
            viewCardContent()
		}
	}

	@ViewBuilder
	private func startStepContent() -> some View {
		VStack {
			SelectPaymentMethodView(viewModel: SelectPaymentMethodViewModel(imageURL: viewModel.imageURL,
																			backgroundColor: viewModel.backgroundColor,
																			paymentMethodModel: viewModel.paymentMethodModel), 
									selectedPaymentMethodAtIndex: { index in

				viewModel.selectedPaymentMethodAtIndex(index)
			})
		}
	}

	@ViewBuilder
	private func cashStepContent() -> some View {
        PaymentMethodCashDepositView(viewModel:
                                        PaymentMethodCashDepositViewModel(
                                            paymentMethodModel: viewModel.paymentMethodModel,
                                            repository: viewModel.repository)
        ){
            dismiss()
        } goBack: {
            viewModel.step = .start
        }
	}

	@ViewBuilder
	private func addCardStepContent() -> some View {
		AddCreditCardScreen {
			dismiss()
		} didAuthorizeCard: { cardDetails in
            viewModel.cardDetails = cardDetails
			viewModel.step = .reviewCard
		} paymentFailed: { error in
            viewModel.paymentFailedError = error
            viewModel.shouldShowFailedPayment = true
		}
	}

	@ViewBuilder
	private func reviewCardStepContent() -> some View {
        let reviewCreditCardViewModel = ReviewCreditCardViewModel(paymentMethodModel: viewModel.paymentMethodModel,
                                                                  cardDetails: viewModel.cardDetails,
                                                                  savePaymentMethodUseCase: SavePaymentMethodUseCase(repository: viewModel.repository),
                                                                  deletePaymentMethodUseCase: DeletePaymentMethodUseCase(repository: viewModel.repository))
        ReviewCreditCardView(viewModel: reviewCreditCardViewModel, pressedEditCard: {
            viewModel.step = .addCard
        }, dismiss: {
            dismiss()
        })
	}

	@ViewBuilder
	private func someoneElseStepContent() -> some View {
		let savePaymentMethodUseCase = SavePaymentMethodUseCase(repository: viewModel.repository)
		let deletePaymentMethodUseCase = DeletePaymentMethodUseCase(repository: viewModel.repository)
		SomeoneElseView(viewModel: SomeoneElseViewModel(savePaymentMethodUseCase: savePaymentMethodUseCase,
														deletePaymentMethodUseCase: deletePaymentMethodUseCase,
                                                        paymentMethodModel: viewModel.paymentMethodModel,
                                                        completionPercentage: viewModel.completionPercentage),
						dismiss: {
			dismiss()
		})
	}
    
    @ViewBuilder
    private func viewCardContent() -> some View {
        let viewCreditCardViewModel = ViewCreditCardViewModel(paymentMethodModel: viewModel.paymentMethodModel,
                                                                  cardDetails: viewModel.cardDetails,
                                                                  savePaymentMethodUseCase: SavePaymentMethodUseCase(repository: viewModel.repository),
                                                                  deletePaymentMethodUseCase: DeletePaymentMethodUseCase(repository: viewModel.repository))
        ViewCreditCardView(viewModel: viewCreditCardViewModel, pressedEditCard: {
            viewModel.step = .addCard
        }, dismiss: {
            dismiss()
        })
    }

    @ViewBuilder
    private func paymentFailed(with error: String, onDismiss: @escaping (() -> Void)) -> some View {
        VVSheetModal(
            title: "#Awkward",
            subheadline: error,
            primaryButtonText: "Search again",
            primaryButtonAction: onDismiss,
            dismiss: onDismiss,
            primaryButtonStyle: SecondaryButtonStyle()
        )
        .background(Color.clear)
    }
}
