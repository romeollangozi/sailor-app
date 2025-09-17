//
//  CancellationFlow.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 3.2.25.
//

import SwiftUI

public struct CancellationFlow: View {
    public struct Labels {
        var cancellationTitle: String
        var confirmationTitle: String
        var individualCancellationMessage: String
        var groupCancellationMessage: String
        var cancellationNotAllowedMessage: String
        var refundConfirmationMessage: String
        var primaryCancelButtonText: String
        var secondaryCancelButtonText: String
        var groupSecondaryButtonText: String
        var notAllowedPrimaryButtonText: String
        var refundSecondaryButtonText: String
        var cancellationSucessTitle: String
        var cancellationSucessMessage: String
        var cancellationSucessDone: String
        var refundTextForIndividual: String
        var refundTextForGroup: String?
        var individualCancelButtonText: String
        
        public init(
            cancellationTitle: String = "Cancellation",
            confirmationTitle: String = "Confirm Cancellation",
            individualCancellationMessage: String = "Just double checking, we would hate for you to lose your place through a slip of the thumb!",
            groupCancellationMessage: String = "Hi Sailor, sorry you can’t make it. Do you want to cancel this booking just for yourself or for the entire group?",
            cancellationNotAllowedMessage: String = "Hi Sailor, sorry but you can’t cancel this booking so close to the start-time. However, under exceptional circumstances, Sailor Services may be able to help you.",
            refundConfirmationMessage: String = "Please confirm if you would like to proceed.",
            primaryCancelButtonText: String = "Yes, cancel",
            secondaryCancelButtonText: String = "No, I’ve changed my mind",
            groupSecondaryButtonText: String = "For the whole group",
            notAllowedPrimaryButtonText: String = "Ok, got it",
            refundSecondaryButtonText: String = "No, I’ve changed my mind",
            cancellationSucessTitle: String = "Booking cancelled",
            cancellationSucessMessage: String = "",
            cancellationSucessDone: String = "Done",
            refundTextForIndividual: String = "",
            refundTextForGroup: String? = nil,
            individualCancelButtonText: String = "Just for me") {
            self.cancellationTitle = cancellationTitle
            self.confirmationTitle = confirmationTitle
            self.individualCancellationMessage = individualCancellationMessage
            self.groupCancellationMessage = groupCancellationMessage
            self.cancellationNotAllowedMessage = cancellationNotAllowedMessage
            self.refundConfirmationMessage = refundConfirmationMessage
            self.primaryCancelButtonText = primaryCancelButtonText
            self.secondaryCancelButtonText = secondaryCancelButtonText
            self.groupSecondaryButtonText = groupSecondaryButtonText
            self.notAllowedPrimaryButtonText = notAllowedPrimaryButtonText
            self.refundSecondaryButtonText = refundSecondaryButtonText
            self.cancellationSucessTitle = cancellationSucessTitle
            self.cancellationSucessMessage = cancellationSucessMessage
            self.cancellationSucessDone = cancellationSucessDone
            self.refundTextForIndividual = refundTextForIndividual
            self.refundTextForGroup = refundTextForGroup
            self.individualCancelButtonText = individualCancelButtonText
        }
    }
    
    var guest: Int
    var isAllowedToCancel: Bool
    var errorMessage: String?
    var refundText: String?
    var onCancel: ((Int) -> Void)? = nil
    var onCancelHandler: ((Int) async -> Bool)? = nil
    var onDismiss: (() -> Void)? = nil
    var onFinsih: (() -> Void)? = nil
    var labels: Labels
    @State private var showRefundConfirmation: Bool
    @State private var showCancelationCompleted: Bool
    
    @State private var isLoadingCancelationForIndividual: Bool = false
    @State private var isLoadingCancelationForGroup: Bool = false
    

    
    public init(
        guests: Int,
        isAllowedToCancel: Bool = true,
        errorMessage: String? = nil,
        refundText: String? = nil,
        labels: Labels = Labels(),
        onCancel: ((Int) -> Void)? = nil,
        onCancelHandler: ((Int) async -> Bool)? = nil,
        onDismiss: (() -> Void)? = nil,
        onFinish: (() -> Void)? = nil
    ) {
        self.guest = guests
        self.isAllowedToCancel = isAllowedToCancel
        self.errorMessage = errorMessage
        self.onCancel = onCancel
        self.onCancelHandler = onCancelHandler
        self.onDismiss = onDismiss
        self.onFinsih = onFinish
        self.refundText = refundText
        self.labels = labels

        _showRefundConfirmation = State(initialValue: false)
        _showCancelationCompleted = State(initialValue: false)
    }
    
	public var body: some View {
		VStack(alignment: .leading) {
			if isAllowedToCancel {
				if showRefundConfirmation {
					refundConfirmation()
				} else if(showCancelationCompleted) {
					cancellationCompleted()
				} else {
					if guest > 1 {
						cancellationForGroup()
					} else {
						cancellationForIndividual()
					}
				}
			} else {
				cancellationIsNotAllowed()
			}
			
			Spacer()
		}
	}

    private func cancellationForIndividual() -> some View {
        cancellationBaseView(
            title: labels.cancellationTitle,
            subheadline: labels.individualCancellationMessage,
            primaryButtonText: labels.primaryCancelButtonText,
            primaryButtonAction: {
                if refundText != nil {
                    switchToRefundConfirmation()
                } else {
                    isLoadingCancelationForIndividual = true
                    Task {
                        if let handler = onCancelHandler {
                            let status = await handler(1)//for one guest
                            DispatchQueue.main.async {
                                showCancelationCompleted = status
                                isLoadingCancelationForIndividual = false
                            }
                        }
                    }
                }
            },
            secondaryButtonText: labels.secondaryCancelButtonText,
            secondaryButtonAction: {
                onDismiss?()
            }
        )
    }


    
    private func cancellationForGroup() -> some View {
        cancellationBaseView(
            title: labels.cancellationTitle,
            subheadline: labels.groupCancellationMessage,
            primaryButtonText: labels.individualCancelButtonText,
            primaryButtonAction: {
                if refundText != nil {
                    switchToRefundConfirmation()
                } else {
                    isLoadingCancelationForIndividual = true
                    Task {
                        if let handler = onCancelHandler {
                            let status = await handler(1)//for one guest
                            DispatchQueue.main.async {
                                showCancelationCompleted = status
                                isLoadingCancelationForIndividual = false
                            }
                        }
                    }
                }
            },
            secondaryButtonText: labels.groupSecondaryButtonText,
            secondaryButtonAction: {
                if refundText != nil {
                    switchToRefundConfirmation()
                } else {
                    isLoadingCancelationForGroup = true

                    Task {
                        if let handler = onCancelHandler {
							let status = await handler(guest)//for one group
                            DispatchQueue.main.async {
                                showCancelationCompleted = status
                                isLoadingCancelationForIndividual = false
                            }
                        }
                    }
                }
            }
        )
    }

    private func cancellationIsNotAllowed() -> some View {
        cancellationBaseView(
            title: labels.cancellationTitle,
            subheadline: labels.cancellationNotAllowedMessage,
            primaryButtonText: labels.notAllowedPrimaryButtonText,
            primaryButtonAction: {
                onDismiss?()
            }
        )
    }
    
    
    private func cancellationCompleted() -> some View {
        cancellationCompleteView(title: labels.cancellationSucessTitle,
                                 subheadline: labels.cancellationSucessMessage,
                                 primaryButtonText: labels.cancellationSucessDone,
                                 primaryButtonAction: {
            onFinsih?()
        })
    }

    private func refundConfirmation() -> some View {
        cancellationBaseView(
            title: labels.confirmationTitle,
            subheadline: labels.refundConfirmationMessage,
            primaryButtonText: labels.primaryCancelButtonText,
            primaryButtonAction: {
                Task {
                    if let handler = onCancelHandler {
                        let status = await handler(self.guest)
                        DispatchQueue.main.async {
                            self.showRefundConfirmation = false
                            self.showCancelationCompleted = status
                        }
                    }
                }

            },
            secondaryButtonText: labels.refundSecondaryButtonText,
            secondaryButtonAction: {
                onDismiss?()
            },
			bodyText: guest > 1 ? labels.refundTextForGroup : labels.refundTextForIndividual
        )
    }
    
    private func cancellationBaseView(
        title: String,
        subheadline: String,
        primaryButtonText: String,
        primaryButtonAction: @escaping () -> Void,
        secondaryButtonText: String? = nil,
        secondaryButtonAction: (() -> Void)? = nil,
        cancellationConfirmationImage: String = "CancelationConfirmation",
        bodyText: String? = nil
    ) -> some View {
        VStack {
            HStack {
                Spacer()
                ClosableButton {
                    onDismiss?()
                }
                .padding()
            }
            
            VStack {
                Image(cancellationConfirmationImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
                    .padding(.bottom, 20)
                    .padding(.top, Spacing.space64)
                    .grayscale(1)
                
                Text(title)
                    .foregroundStyle(Color.blackText)
                    .font(.vvHeading3Bold)
                    .padding(.bottom, 10)
                
                Text(subheadline)
                    .font(.vvBody)
                    .foregroundStyle(Color.blackText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                
                if let bodyText {
                    Text(bodyText)
                        .font(.vvBodyBold)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                        .padding(.top, 5)
                }
            }
            .padding(Spacing.space16)
            
            if let errorMessage = self.errorMessage {
                VStack {
                    MessageBar(style: .Warning, text: errorMessage)
                }
                .padding(Spacing.space16)
            }
            
            DoubleDivider()
            
            VStack {
                let networkProcessRunning = isLoadingCancelationForIndividual || isLoadingCancelationForGroup
               
                SecondaryButton(primaryButtonText, isDisabled: networkProcessRunning, isLoading: isLoadingCancelationForIndividual) {
                    primaryButtonAction()
                }
                
                if let secondaryButtonText {
					LinkButton(secondaryButtonText, isDisabled: networkProcessRunning, isLoading: isLoadingCancelationForGroup) {
                        secondaryButtonAction?()
                    }
                }
            }
            .padding(Spacing.space16)
        }
    }
    
    private func cancellationCompleteView(
        title: String,
        subheadline: String,
        primaryButtonText: String,
        primaryButtonAction: @escaping () -> Void,
        bodyText: String? = nil
    ) -> some View {
        VStack {
            HStack {
                Spacer()
                ClosableButton {
                    primaryButtonAction()
                }
                .padding()
            }
            
            VStack {
                Image("CancelationConfirmed")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
                    .padding(.bottom, 20)
                    .padding(.top, Spacing.space64)
                    .grayscale(1)
                
                Text(title)
                    .foregroundStyle(Color.blackText)
                    .font(.vvHeading3Bold)
                    .padding(.bottom, 10)
                
                Text(subheadline)
                    .font(.vvBody)
                    .foregroundStyle(Color.blackText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                
                if let bodyText {
                    Text(bodyText)
                        .font(.vvBodyBold)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                        .padding(.top, 5)
                }
            }
            .padding(Spacing.space16)
            

            DoubleDivider()
            
            VStack {
                PrimaryButton(primaryButtonText) {
                    primaryButtonAction()
                }
            }
            .padding(Spacing.space16)
        }
        .interactiveDismissDisabled(true)
    }
    
    private func switchToRefundConfirmation() {
        self.showRefundConfirmation = true
    }
    
}


#Preview("Cancel booking for indvidual") {
    CancellationFlow(guests: 1)
}

#Preview("Cancel booking for indvidual with refund") {
    CancellationFlow(guests: 1, refundText: "Refund of $100 will be made to the purchasers credit card")
}

#Preview("Cancel booking for group") {
    CancellationFlow(guests: 2)
}

#Preview("Cancel booking for group with refund") {
    CancellationFlow(guests: 2, refundText: "Refund of $100 will be made to the purchasers credit card")
}

#Preview("Cancel booking is not allowed") {
    CancellationFlow(guests: 1, isAllowedToCancel: false)
}

#Preview("Cancel booking in loading state") {
    CancellationFlow(guests: 1)
}

#Preview("Cancel booking with error message") {
    CancellationFlow(guests: 1, errorMessage: "An error occurred")
}

