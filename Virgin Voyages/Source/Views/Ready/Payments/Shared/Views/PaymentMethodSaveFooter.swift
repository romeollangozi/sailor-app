//
//  PaymentMethodSaveFooter.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 6/17/24.
//

import SwiftUI
import VVUIKit

struct PaymentMethodSaveFooter: View {
	@Environment(\.contentSpacing) var spacing
    var saveable: Bool
    
    var showChangePaymentMethod: Bool = false
    var saveLoading: Bool = false
    
    var save: (() -> Void)?
    var changePaymentMethod: (() -> Void)?
    var onCancel: (() -> Void)?
	
	var body: some View {
		VStack(spacing: spacing) {
			if showChangePaymentMethod {
				if saveable {
					LoadingButton(title: "Save changes", loading: saveLoading) {
						save?()
					}
					.buttonStyle(PrimaryButtonStyle())
				}
                LoadingButton(title: "Change payment method", underline: true) {
                    changePaymentMethod?()
                }.buttonStyle(TertiaryButtonStyle())
			} else {
				if saveable {
					LoadingButton(title: "Save payment method", loading: saveLoading) {
						save?()
					}
					.buttonStyle(PrimaryButtonStyle())
				}
                LoadingButton(title: "Cancel", underline: true) {
                    onCancel?()
                }.buttonStyle(TertiaryButtonStyle())
			}
		}
	}
}

struct PaymentMethodSaveFooter_Previews: PreviewProvider {
	static var previews: some View {
		PaymentMethodSaveFooter(
			saveable: true,
			showChangePaymentMethod: true,
			saveLoading: false,
			save: {
				print("Save payment method tapped")
			},
			changePaymentMethod: {
				print("Change payment method tapped")
			},
            onCancel: {
				print("Dismiss action")
			}
		)
		.previewLayout(.sizeThatFits)
		.padding() // Adding padding for better visualization in the preview
	}
}
