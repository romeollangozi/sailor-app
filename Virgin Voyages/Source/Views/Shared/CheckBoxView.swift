//
//  CheckBoxView.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 26.8.24.
//

import SwiftUI

struct CheckboxView: View {
    @Binding var isChecked: Bool
    let text: String
    
    var body: some View {
        HStack(alignment: .center) {
            Button(action: {
                isChecked.toggle()
            }) {
                Image(systemName: isChecked ? "checkmark.square.fill" : "square")
                    .foregroundColor(.gray)
                    .font(Font.title.weight(.ultraLight))
            }
            
            Text(text)
                .foregroundColor(.lightGreyColor)
                .fontStyle(.lightLink)
                .multilineTextAlignment(.leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
