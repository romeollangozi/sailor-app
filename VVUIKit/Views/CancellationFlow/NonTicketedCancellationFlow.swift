//
//  NonTicketedCancellationFlow.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 11.2.25.
//

import SwiftUI

public struct NonTicketedCancellationFlow: View {
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
        var cancellationSucessTitle: String
        var cancellationSucessMessage: String
        var cancellationSucessDone: String
        var individualCancelButtonText: String
        
        public init(
            cancellationTitle: String = "Remove from your Agenda",
            confirmationTitle: String = "Confirm Cancellation",
            individualCancellationMessage: String = "We’re just double checking - Are you sure you want to remove this event from your agenda?",
            groupCancellationMessage: String = "We’re just double checking - Are you sure you want to remove this event from your agenda?",
            cancellationNotAllowedMessage: String = "Hi Sailor, sorry but you can’t cancel this booking so close to the start-time. However, under exceptional circumstances, Sailor Services may be able to help you.",
            refundConfirmationMessage: String = "Please confirm if you would like to proceed.",
            primaryCancelButtonText: String = "Yes remove",
            secondaryCancelButtonText: String = "Cancel",
            groupSecondaryButtonText: String = "Remove for everyone",
            notAllowedPrimaryButtonText: String = "Ok, got it",
            cancellationSucessTitle: String = "Removed from your Agenda",
            cancellationSucessMessage: String = "",
            cancellationSucessDone: String = "Done",
            individualCancelButtonText: String = "Remove just for me") {
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
            self.cancellationSucessTitle = cancellationSucessTitle
            self.cancellationSucessMessage = cancellationSucessMessage
            self.cancellationSucessDone = cancellationSucessDone
            self.individualCancelButtonText = individualCancelButtonText
        }
    }
    
    var guest: Int
    var isAllowedToCancel: Bool

    var errorMessage: String?
    var onCancel: ((Int) -> Void)? = nil
    var onCancelHandler: ((Int) async -> Bool)? = nil
    var onDismiss: (() -> Void)? = nil
    var onFinsih: (() -> Void)? = nil
    var labels: Labels
    @State private var showCancelationCompleted: Bool
    @State private var isLoadingCancelationForIndividual: Bool = false
    @State private var isLoadingCancelationForGroup: Bool = false
    
    public init(
        guests: Int,
        isAllowedToCancel: Bool = true,
        errorMessage: String? = nil,
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
        self.labels = labels

        _showCancelationCompleted = State(initialValue: false)
    }
    
	public var body: some View {
		VStack(alignment: .leading) {
			if isAllowedToCancel && !showCancelationCompleted {
				if guest > 1 {
					cancellationForGroup()
				} else {
					cancellationForIndividual()
				}
			} else if (isAllowedToCancel && showCancelationCompleted) {
				cancellationCompleted()
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
                isLoadingCancelationForIndividual = true
                Task {
                    
                    if let handler = onCancelHandler {
                        let status = await handler(1)
                        DispatchQueue.main.async {
                            self.showCancelationCompleted = status
                            isLoadingCancelationForIndividual = false
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
                isLoadingCancelationForIndividual = true
                Task {
                    if let handler = onCancelHandler {
                        let status = await handler(1)
                        DispatchQueue.main.async {
                            self.showCancelationCompleted = status
                            isLoadingCancelationForIndividual = false
                        }
                    }
                }
            },
            secondaryButtonText: labels.groupSecondaryButtonText,
            secondaryButtonAction: {
                isLoadingCancelationForGroup = true

                Task {
                    if let handler = onCancelHandler {
						let status = await handler(guest)
                        DispatchQueue.main.async {
                            self.showCancelationCompleted = status
                            isLoadingCancelationForGroup = false
                        }
                    }
                }
            }, tertiaryButtonText: "Cancel" , tertiaryButtonAction: {
                onDismiss?()
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

    private func cancellationBaseView(
        title: String,
        subheadline: String,
        primaryButtonText: String,
        primaryButtonAction: @escaping () -> Void,
        secondaryButtonText: String? = nil,
        secondaryButtonAction: (() -> Void)? = nil,
        tertiaryButtonText: String? = nil,
        tertiaryButtonAction: (() -> Void)? = nil,
        cancellationConfirmationImage: String? = nil,
        bodyText: String? = nil) -> some View {
            
        VStack {
            HStack {
                Spacer()
                ClosableButton {
                    onDismiss?()
                }
                .padding()
            }
            
            VStack {
                Image("NonTicketedCancelationConfirmed")
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
                
                if let tertiaryButtonText {
                    LinkButton(tertiaryButtonText, isDisabled: networkProcessRunning, isLoading: false) {
                        tertiaryButtonAction?()
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
            VStack {
                Image("NonTicketedCancelationConfirmed")
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

}


#Preview("Cancel booking for indvidual") {
    CancellationFlow(guests: 1)
}

#Preview("Cancel booking for group") {
    CancellationFlow(guests: 2)
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

