//
//  ConnectWifiButton.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 3/19/25.
//

import SwiftUI

struct BorderedButton: View {

	let text: String
	let action: () -> Void

	var body: some View {
		Button(action: {
			action()
		}) {
			Text(text)
				.font(.vvBody)
				.foregroundColor(.darkGray)
				.frame(maxWidth: 190)
				.padding(.vertical, 7)
				.background(
					RoundedRectangle(cornerRadius: 4)
						.stroke(Color.darkGray, lineWidth: 1)
						.background(Color.white)
				)
		}
		.buttonStyle(PlainButtonStyle())
		.padding(.horizontal)
	}
}

struct BorderedButton_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			BorderedButton(text: "Bordered Button") {
				print("Button tapped")
			}
			.previewLayout(.sizeThatFits)
			.padding()
		}
	}
}
