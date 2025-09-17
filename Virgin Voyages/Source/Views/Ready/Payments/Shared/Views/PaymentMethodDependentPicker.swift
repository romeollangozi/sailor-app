//
//  DependentPicker.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 5/18/24.
//

import SwiftUI
import VVUIKit

struct PaymentMethodDependentPicker: View {
	@Environment(\.contentSpacing) var spacing

	@State var viewModel: PaymentMethodDependentPickerViewModel

	init(viewModel: PaymentMethodDependentPickerViewModel) {
		_viewModel = State(wrappedValue: viewModel)
	}

    var body: some View {
		VStack(alignment: .leading, spacing: spacing * 1.5) {
			VSpacer(spacing)
			ThinDoubleDivider()
			
			VStack(alignment: .leading, spacing: spacing) {
				Button {
					viewModel.expanded.toggle()
				} label: {
					HStack {
						Text(viewModel.dependentTitle)
							.fontStyle(.headline)
						
						Spacer()
						
						Image(systemName: viewModel.expanded ? "chevron.down" : "chevron.up")
							.imageScale(.small)
					}
				}
				.tint(.primary)
				
                Text(viewModel.pendingPaymentDependentDescription)
					.fontStyle(.subheadline)
					.foregroundStyle(.secondary)
				
				if viewModel.expanded {
					ForEach($viewModel.paymentMethodModel.dependents) { $dependent in
						if let partyMember = viewModel.paymentMethodModel.partyMemberWithoutPayment(dependent: dependent) {
							Toggle(isOn: $dependent.selected) {
								HStack {
									if let url = URL(string: partyMember.imageURL) {
										ProgressImage(url: url)
											.frame(width: 40, height: 40)
									}
									Text(partyMember.name)
								}
							}
							.fontStyle(.body)
						}
					}
					
					if viewModel.shouldShowCompletedPaymentDependentSection {
						Text(viewModel.completedPaymentDependentDescription)
							.fontStyle(.boldTagline)
                            .fontWeight(.bold)
                            .lineSpacing(6)
							.foregroundStyle(.secondary)
						
						ForEach($viewModel.paymentMethodModel.dependents) { $dependent in
							if let partyMember = viewModel.paymentMethodModel.partyMemberWithPayment(dependent: dependent) {
								Divider()
								Toggle(partyMember.name, isOn: $dependent.selected)
									.fontStyle(.body)
							}
						}
					}
				}
			}
			
			ThinDoubleDivider()
			VSpacer(spacing)
		}
    }
}
