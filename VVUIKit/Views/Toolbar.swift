//
//  Toolbar.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 4/8/25.
//

import SwiftUI

public enum ToolbarButtonStyle {
	case backButton
	case closeButton
	case backAndCloseButton
}

public struct Toolbar: View {
	let buttonStyle: ToolbarButtonStyle
	let onButtonPress: () -> Void
	let onCloseButtonPress: (() -> Void)?

	public init(
		buttonStyle: ToolbarButtonStyle = .closeButton,
		onButtonPress: @escaping () -> Void,
		onCloseButtonPress: (() -> Void)? = nil
	) {
		self.buttonStyle = buttonStyle
		self.onButtonPress = onButtonPress
		self.onCloseButtonPress = onCloseButtonPress
	}

	public var body: some View {
		HStack {
			switch buttonStyle {
			case .backButton:
				BackButton(onButtonPress)
					.padding(
						EdgeInsets(
							top: Spacing.space24,
							leading: Spacing.space16,
							bottom: Spacing.space0,
							trailing: Spacing.space16
						)
					)
				Spacer()
			case .closeButton:
				Spacer()
				SailableCloseButton(action: onButtonPress)
					.padding(EdgeInsets(top: 24.0, leading: 16.0, bottom: 0, trailing: 16))
			case .backAndCloseButton:
				HStack {
					BackButton(onButtonPress)
						.padding(
							EdgeInsets(
								top: Spacing.space24,
								leading: Spacing.space16,
								bottom: Spacing.space0,
								trailing: Spacing.space16
							)
						)
					Spacer()
					SailableCloseButton(action: onCloseButtonPress ?? {})
						.padding(EdgeInsets(top: 24.0, leading: 16.0, bottom: 0, trailing: 16))
				}
			}
		}
	}
}
