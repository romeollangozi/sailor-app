//
//  LockedTextField.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 8/16/24.
//

import SwiftUI

struct IconTextField: View {
	var title: String
	@Binding var text: String
	var systemName: String
    let keyboardType: UIKeyboardType
	var onButtonTap: () -> Void

    init(title: String, text: Binding<String>, systemName: String, keyboardType: UIKeyboardType = .default, onButtonTap: @escaping () -> Void) {
		self.title = title
		_text = text
		self.systemName = systemName
		self.onButtonTap = onButtonTap
        self.keyboardType = keyboardType
	}

	var body: some View {
		VStack(alignment: .leading, spacing: 5) {
			Text(text.count > 0 ? title : "")
				.fontStyle(.caption)
				.foregroundColor(.gray)

			HStack {
				TextField(title, text: $text)
					.keyboardType(keyboardType)
					.autocapitalization(.none)
					.disableAutocorrection(true)
					.fontStyle(.button)
					.foregroundColor(.black)

				Spacer()

				Button(action: onButtonTap) {
					Image(systemName: systemName)
						.foregroundColor(.gray)
						.fixedSize(horizontal: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
						.frame(width: 6, height: 6)
				}
			}
		}
		.padding(EdgeInsets(top: 8,
							leading: 16,
							bottom: 8,
							trailing: 16))
		.background(
			RoundedRectangle(cornerRadius: 8)
				.stroke(Color.gray, lineWidth: 1)
		)
	}
}

struct LockedTextField: View {
	var title: String
	var text: String

	var body: some View {
		VStack(alignment: .leading, spacing: 5) {
			Text(title)
				.fontStyle(.caption)
				.foregroundColor(.gray)

			HStack {
				Text(text)
					.fontStyle(.button)
					.foregroundColor(.black)

				Spacer()

				Image(systemName: "lock.fill")
					.foregroundColor(.gray)
					.fixedSize(horizontal: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
					.frame(width: 6, height: 6)
			}
		}
		.padding(EdgeInsets(top: 8,
							leading: 16,
							bottom: 8,
							trailing: 16))
		.background(
			RoundedRectangle(cornerRadius: 8)
				.stroke(Color.gray, lineWidth: 1)
		)
	}
}

struct SecureTextField_Previews: PreviewProvider {
	static var text: String = ""

	static var previews: some View {
		VStack {
			LockedTextField(title: "Card number", text: "**** **** **** 0089")
		}
		.padding()
	}
}
