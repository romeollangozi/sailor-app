//
//  PurchasePaymentView.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 10/24/24.
//

import SwiftUI
import VVUIKit

struct PurchasePaymentView: View {
	@State var viewModel: PurchasePaymentViewModel
	let back: (() -> Void)
	let paymentError: ((String) -> Void)
	let backToRoot: (() -> Void)?
    let done: (() -> Void)?

	init(viewModel: PurchasePaymentViewModel,
		 back: @escaping (() -> Void),
		 paymentError: @escaping ((String) -> Void),
		 backToRoot: (() -> Void)?,
         done: (() -> Void)? = nil) {
		_viewModel = State(wrappedValue: viewModel)
		self.back = back
		self.paymentError = paymentError
		self.backToRoot = backToRoot
        self.done = done
	}

	var body: some View {
        ZStack {
        Color.sheetBackgroundColor.edgesIgnoringSafeArea(.top)
            VStack(spacing: 0) {
                toolbar()
                HStack(spacing: 0) {
                    if !viewModel.paymentDidSucceed {
                        AddCreditCardView(url: viewModel.url) {
                            back()
                        } didAuthorizeCard: { cardDetails in
                            viewModel.didAuthorizeCard()
						} paymentFailed: { error in
							paymentError(error)
						}
                    }
                }
            }
		}
        .sheet(isPresented: $viewModel.paymentDidSucceed, onDismiss: {
            (done ?? back)?()
        }, content: {
            BookingConfirmationSheet(title: viewModel.bookingConfirmationTitle,
                                  subheadline: viewModel.bookingConfirmationSubheadline,
                                  primaryButtonText: "Done",
                                  secondaryButtonText: viewModel.shouldShowAgendaNavigation ? "View in your Agenda" : nil,
                                  isEnabled: true,
                                  imageName: "CancelationConfirmed",
                         primaryButtonAction: {
                (done ?? back)?()
            }, secondaryButtonAction: viewModel.shouldShowAgendaNavigation ? {
                (done ?? back)?()
                viewModel.navigateToAgenda()
            } : nil, dismiss: {
                (done ?? back)?()
            }, hasDismissButton: true,
                                  primaryButtonStyle: PrimaryButtonStyle(),
                                  secondaryButtonStyle: LinkButtonStyle())
            .presentationDetents([.large])

        })
	}
    
    private func toolbar() -> some View {
        Toolbar(buttonStyle: .backButton) {
            back()
        }
    }
}
