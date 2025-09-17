//
//  ErrorSheetModal.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 8/6/24.
//

import SwiftUI
import VVUIKit

struct ErrorSheetModal: View {


	var title: String?
	var subheadline: String?
	var primaryButtonText: String?
	var secondaryButtonText: String?
    var isEnabled: Bool = true
    
	var primaryButtonAction: (() -> Void)?
    var secondaryButtonAction: (() -> Void)?
	var dismiss: (() -> Void)?

    var body: some View {
        VStack {
            HStack {
                Spacer()
                SailableCloseButton() {
                    dismiss?()
                }
            }
            Image("Porthole")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 181, height: 180)
                .padding(.bottom, Paddings.defaultVerticalPadding24)
                .grayscale(isEnabled ? 0 : 1)

			if let title = title {
				Text(title)
                    .fontStyle(.title)
                    .foregroundStyle(Color.black)
					.bold()
                    .padding(.horizontal, Paddings.defaultHorizontalPadding20)
                    .padding(.bottom, Paddings.defaultVerticalPadding16)
			}

			if let subheadline = subheadline {
				Text(subheadline)
                    .fontStyle(.smallBody)
                    .foregroundStyle(Color.vvDarkGray)
					.multilineTextAlignment(.center)
                    .padding(.bottom, Paddings.defaultVerticalPadding16)
			}

			if let primaryButtonText = primaryButtonText {
				Button(primaryButtonText) {
					primaryButtonAction?()
				}
				.buttonStyle(SecondaryButtonStyle())
                .padding(.vertical, Paddings.defaultVerticalPadding16)
			}

			if let secondaryButtonText = secondaryButtonText {
				Button(secondaryButtonText) {
					secondaryButtonAction?()
				}
				.buttonStyle(TertiaryButtonStyle())
                .padding(.bottom, Paddings.defaultVerticalPadding16)
			}
        }
        .padding(Paddings.defaultVerticalPadding24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(radius: 10)
        )
        .padding(Paddings.defaultVerticalPadding24)
    }
}

struct PaymentMethodSheetModal_Previews: PreviewProvider {
	static var previews: some View {
		ErrorSheetModal(
			title: "Payment Method",
			subheadline: "Sorry sailor we can’t seem to log you in with those details, please check and try again.\n\nIf you keep having problems, you can Sign-up or Login with a email address and password",
			primaryButtonText: "Continue",
			secondaryButtonText: "Cancel",
			primaryButtonAction: {
				print("Primary button tapped")
			},
			secondaryButtonAction: {
				print("Secondary button tapped")
			},
			dismiss: {
				print("Dismiss action")
			}
		)
		.previewLayout(.sizeThatFits)
	}
}
