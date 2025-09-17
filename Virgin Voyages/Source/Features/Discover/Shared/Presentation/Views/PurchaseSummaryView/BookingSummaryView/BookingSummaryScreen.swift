//
//  BookingSummaryScreen.swift
//  Virgin Voyages
//
//  Created by TX on 8.5.25.
//


import SwiftUI
import VVUIKit

struct BookingSummaryScreen: View {

	@State var viewModel: BookingSummaryScreenViewModelProtocol
	@Binding var paymentError: String?

    var back: (() -> Void)
	var close: (() -> Void)

	init(
		viewModel: BookingSummaryScreenViewModelProtocol,
		paymentError: Binding<String?>,
		back: @escaping (() -> Void),
		close: @escaping () -> Void) {
		_viewModel = State(wrappedValue: viewModel)
		self._paymentError = paymentError
        self.back = back
        self.close = close
	}

	var body: some View {
		ZStack {
            Color.sheetBackgroundColor.edgesIgnoringSafeArea(.vertical)
			VStack(spacing: 0) {
				toolbar()
                if viewModel.screenState == .loading {
					Spacer()
					ProgressView()
						.progressViewStyle(CircularProgressViewStyle())
						.scaleEffect(1.5)
						.padding()
					Spacer()
                } else if viewModel.screenState == .loading {
                    Spacer()
                    Text("Could not load the data for summary")
                        .padding()
                        .font(.caption)
                    Spacer()
                } else {
					ScrollView {
						VStack(spacing: 0) {
							PurchaseSummaryHeaderView()
                            PurchaseSummaryTicketStubView(date: viewModel.date, category: viewModel.headline,
														  name: viewModel.name,
                                                          location: viewModel.location,
														  purchasedForText: viewModel.bookingForText,
														  bookableImageName: viewModel.bookableImageName,
														  sailorsProfileImageUrl: viewModel.sailorsProfileImageUrl)
							DoubleDivider()
                            if !viewModel.isNonPaid {
								PaymentSummaryView(description: viewModel.name,
												   price: viewModel.priceStringWithCurrencySign ?? "",
												   paymentError: paymentError)
								SingleLineSeparator()
							}
							if viewModel.isShipside || viewModel.isNonPaid {
								PaymentSummaryConfirmBookingExistingPaymentMethodView(
                                    payWithExistingCard: {
									viewModel.payWithExistingCard()
                                    },
                                    isNonPaidBooking: viewModel.isNonPaid,
                                    payWithExistingCardLoading: $viewModel.payWithExistingCardLoading)
							} else {
								if let card = viewModel.card {
									PaymentSummaryExistingPaymentMethodView(cardIssuer: card.cardIssuer?.name ?? "",
																			maskedCardNumber: card.cardMaskedNo ?? "",
																			cardImage: card.cardIssuer?.image,
																			payWithExistingCard: {
										viewModel.payWithExistingCard()
									}, payWithOtherCard: {
										viewModel.payWithOtherCard()
									}, payWithExistingCardLoading: $viewModel.payWithExistingCardLoading,
																			payWithDifferentCardLoading: $viewModel.payWithDifferentCardLoading)
								} else {
									PaymentSummaryAddPaymentMethodView(addCardAndPay: {
										viewModel.payWithOtherCard()
									}, addCardAndPayLoading: $viewModel.payWithDifferentCardLoading)
								}
							}
							privacyPolicyView()
						}
					}
				}
			}
			.disabled(viewModel.isRunningActivity)
		}
		.onAppear {
			viewModel.onAppear()
		}
        .onChange(of: viewModel.paymentError, { oldValue, newValue in
            paymentError = newValue
        })
		.sheet(isPresented: $viewModel.paymentDidSucceed) {
			BookingConfirmationSheet(title: viewModel.bookingConfirmationTitle,
									 subheadline: viewModel.bookingConfirmationSubheadline,
									 primaryButtonText: "Done",
                                     secondaryButtonText: viewModel.bookingConfirmationSecondaryButtonTitle,
									 isEnabled: true,
									 imageName: viewModel.bookingConfirmationImageName,
									 primaryButtonAction: {
				close()
                viewModel.paymentDidSucceed = false
			}, secondaryButtonAction: {
				close()
				viewModel.onViewInYourAgendaTapped()
			}, dismiss: {
				close()
                viewModel.paymentDidSucceed = false
			} ,hasDismissButton: true,
									 primaryButtonStyle: PrimaryButtonStyle(),
									 secondaryButtonStyle: LinkButtonStyle())
			.presentationDetents([.large])
			.sheet(isPresented: $viewModel.showPreviewMyAgendaSheet) {
				PreviewMyAgendaSheet(date: viewModel.bookableDate) {
					viewModel.onPreviewMyAgendaDismiss()
				}
			}
		}
	}

	func toolbar() -> some View {
		Toolbar(buttonStyle: viewModel.toolbarButtonStyle, onButtonPress: {
			back()
		}, onCloseButtonPress: {
			close()
		})
        .disabled(viewModel.isRunningActivity)
	}

    func privacyPolicyView() -> some View {
        VStack {
            TappableTextView(
                fullText: "By booking this event, you accept our company terms and conditions and privacy policy.",
                links: [
                    ("terms and conditions", {
                        viewModel.openTermsAndConditions()
                    }),
                    ("privacy policy", {
                        viewModel.openPrivacyPolicy()
                    })
                ]
            )
        }
        .frame(minHeight: 40)
        .padding(Paddings.defaultHorizontalPadding)
    }
}


class PreviewBookingSummaryScreenViewModel: BookingSummaryScreenViewModelProtocol {

	var toolbarButtonStyle: VVUIKit.ToolbarButtonStyle = .backAndCloseButton

	var portNameOrSeaDayText: String? = nil

	init() {}
	init(showPreviewMyAgendaSheet: Bool) {
		self.showPreviewMyAgendaSheet = showPreviewMyAgendaSheet
	}
	var showPreviewMyAgendaSheet: Bool = true

	func onPreviewAgendaTapped() {
		showPreviewMyAgendaSheet = true
	}
	
	func onPreviewMyAgendaDismiss() {
		showPreviewMyAgendaSheet = false
	}

	func onViewInYourAgendaTapped() {}

	var bookableDate: Date = Date()

    var screenState: ScreenState = .content
    
    var isRunningActivity: Bool = false
    
    var payWithDifferentCardLoading: Bool = false
    
    var payWithExistingCardLoading: Bool = false
    
    var shouldNavigateToPaymentPage: Bool = false
    
    var paymentDidSucceed: Bool = false
    
    var paymentURL: URL? = nil
    
    var isShipside: Bool = false
    
    var card: CardViewModel? = .init()
    
    var headline: String = "Headline text"
    
    var name: String = "Name text"
    
    var priceToPay: String = "priceToPay"
    
    var priceStringWithCurrencySign: String? = "priceStringWithCurrencySign"
    
    var bookingForText: String = "Booking for text"
    
    var isNonPaid: Bool = true
    
    var date: String? = nil
    
    var bookableImageName: String? = nil
    
    var sailorsProfileImageUrl: [String]? = nil
    
    var paymentError: String? = nil
    
    var bookingConfirmationTitle: String = "Booking Confirmation Title"
    
    var bookingConfirmationSubheadline: String = "Booking Confirmation Subheadline"
    
    var bookingConfirmationImageName: String = "bookingConfirmationImageName"
    
    var bookingConfirmationSecondaryButtonTitle: String? = "View in your Agenda"

    var location: String? = "Location text"
    
    func onAppear() {
        
    }
    
    func payWithExistingCard() {
        
    }
    
    func payWithOtherCard() {
        
    }
    
    func openTermsAndConditions() {

    }

    func openPrivacyPolicy() {
        
    }

    
}

#Preview {
    BookingSummaryScreen(viewModel: PreviewBookingSummaryScreenViewModel() , paymentError: .constant("")) {} close: {}

	BookingSummaryScreen(viewModel: PreviewBookingSummaryScreenViewModel(showPreviewMyAgendaSheet: true) , paymentError: .constant("")) {} close: {}
}
