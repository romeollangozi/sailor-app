//
//  CheckboxWithErrorView.swift
//  Virgin Voyages
//
//  Created by Pajtim on 19.11.24.
//

import SwiftUI

struct CheckboxWithErrorView: View {
    @Binding var isChecked: Bool
    let text: String
    @Binding var error: String?

    var body: some View {
        VStack {
            HStack(alignment: .top) {
                Button(action: {
                    isChecked.toggle()
                }) {
                    Image(systemName: isChecked ? "checkmark.square.fill" : "square")
                        .font(Font.title.weight(.regular))
                        .foregroundColor(isChecked ? .vvBooked.opacity(0.7) : error != nil ? .errorLight : .gray)
                }

                Text(text)
                    .multilineTextAlignment(.leading)
                    .fontStyle(.body)
                    .foregroundStyle(Color.blackText)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            if let error, !isChecked {
                Text(error)
                    .multilineTextAlignment(.leading)
                    .fontStyle(.body)
                    .foregroundColor(.errorLight)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, Paddings.padding12)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .foregroundColor(error != nil ? .errorLight : .clear)
    }
}

#Preview {
    CheckboxWithErrorView(isChecked: .constant(false), text: "Checkbox", error: .constant("Checkbox is not checked"))
}
