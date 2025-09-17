//
//  VVPickerField.swift
//  VVUIKit
//
//  Created by Enxhi Kondakciu on 7.3.25.
//

import SwiftUI

public struct Option: Identifiable,  Equatable, Hashable {
    public let id = UUID()
    public let key: String
    public let value: String
    
    public init(key: String, value: String) {
        self.key = key
        self.value = value
    }
}


public struct VVPickerField: View {
    let label: String
    let options: [Option]
    @Binding var selected: String?
    @State private var showPicker = false
    let errorMessage: String?
    let readonly: Bool
    let required: Bool
    let isSecure: Bool
    let maskedValue: String?
    let hasError: Bool

    public init(label: String,
                options: [Option],
                selected: Binding<String?>,
                showPicker: Bool = false,
                errorMessage: String? = nil,
                readonly: Bool = false,
                required: Bool = false,
                isSecure: Bool = false,
                maskedValue: String? = nil,
                hasError: Bool = false) {
        self.label = label
        self.options = options
        self._selected = selected
        self.showPicker = showPicker
        self.errorMessage = errorMessage
        self.readonly = readonly
        self.required = required
        self.isSecure = isSecure
        self.maskedValue = maskedValue
        self.hasError = hasError
    }
    
    var showError: Bool {
        return (required && (selected == nil || selected == "" || selected == "|")) || hasError
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack {
                VVTextField(
                    label: label,
                    value: Binding(
                        get: { options.first(where: { $0.key == selected })?.value ?? "" },
                        set: { _ in }
                    ),
                    errorMessage: nil,
                    readonly: readonly,
                    required: required,
                    isSecure: isSecure,
                    hasError: hasError,
                    maskedValue: maskedValue
                )
                .frame(height: 56)
                .cornerRadius(4)
                
                if !readonly{
                    HStack {
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundColor(.darkGray)
                            .padding(.trailing, 16)
                    }
                    .frame(height: 56)
                    
                    Button(action: {
                        showPicker = true
                    }) {
                        Color.white
                            .opacity(0.1)
                    }
                    .frame(height: 56)
                    .contentShape(Rectangle())
                    .buttonStyle(PlainButtonStyle())
                }
            }
            
            .sheet(isPresented: $showPicker) {
                PickerView(selected: $selected, options: options, placeholder: label)
            }
            
            if let error = errorMessage, hasError {
                Text(error)
                    .font(.vvSmall)
                    .foregroundColor(Color.lightError)
                    .padding(.leading, Spacing.space4)
                    .padding(.top, Spacing.space8)
            }
        }
    }
}

struct TestVVPickerField: View {
    let countries = [
        Option(key: "AL", value: "Albania"),
        Option(key: "US", value: "United States")
    ]
    
    @State private var selectedKey: String? = "AL"  // Store only the key
    
    var body: some View {
        VStack(spacing: 16) {
            VVPickerField(label: "Select a Country", options: countries, selected: $selectedKey)
            Text("Selected Country: \(countries.first(where: { $0.key == selectedKey })?.value ?? "None")")
        }
        .padding()
    }
}

struct VVPickerField_Previews: PreviewProvider {
    static var previews: some View {
        TestVVPickerField()
            .previewLayout(.sizeThatFits)
    }
}
