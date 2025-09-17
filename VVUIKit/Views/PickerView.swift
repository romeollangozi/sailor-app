//
//  PickerView.swift
//  VVUIKit
//
//  Created by Enxhi Kondakciu on 26.3.25.
//

import SwiftUI

public struct PickerView: View {
    @Binding var selected: String?
    let options: [Option]
    let placeholder: String

    @Environment(\.dismiss) private var dismiss
    @State private var searchText: String = ""

    private var filteredOptions: [Option] {
        if searchText.isEmpty {
            return options
        } else {
            return options.filter {
                $0.key.localizedCaseInsensitiveContains(searchText) ||
                $0.value.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    public var body: some View {
        VStack(spacing: 0) {
            toolbar
                .padding(.horizontal, Spacing.space24)
                .padding(.top, Spacing.space16)

            TextField("Search", text: $searchText)
                .padding(.horizontal, Spacing.space16)
                .padding(.vertical, Spacing.space16)
                .background(Color.lightGray)
            

            List {
                ForEach(filteredOptions, id: \.id) { option in
                    Button(action: {
                        selected = option.key
                        dismiss()
                    }) {
                        HStack {
                            Text(option.value)
                                .foregroundColor(.primary)
                            Spacer()
                            if selected == option.key {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.black)
                            }
                        }
                        .background(Color.white)
                        .padding(.vertical, 8)
                    }
                }
                .listRowBackground(Color.white)
            }
            .listStyle(.plain)
        }
        .background(Color.lightGray)
        .navigationBarHidden(true)
    }

    private var toolbar: some View {
        HStack {
            Spacer()
            ClosableButton {
                dismiss()
            }
        }
    }
}

struct PickerView_Previews: PreviewProvider {
    @State static var selectedOption: String? = nil

    static var previews: some View {
        PickerView(
            selected: $selectedOption,
            options: [
                Option(key: "1", value: "Option One"),
                Option(key: "2", value: "Option Two"),
                Option(key: "3", value: "Option Three")
            ],
            placeholder: "Choose an Option"
        )
    }
}
