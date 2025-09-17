//
//  VVTextField.swift
//  VVUIKit
//
//  Created by Enxhi Kondakciu on 5.3.25.
//

import SwiftUI
import Foundation

public struct VVTextField: View {
    let label: String
    @Binding var value: String
    let errorMessage: String?
    let readonly: Bool
    let required: Bool
    let isSecure: Bool
    let hasError: Bool
    let showRevealIcon: Bool
    var maskedValue: String?
    let keyboardType: UIKeyboardType
    
    @State private var isSecureTextVisible: Bool = false
    @State private var isMaskedVisible: Bool = false
    @State private var textFieldValue: String = ""
    @FocusState private var isFocused: Bool

    var showError: Bool {
        return ((value.isEmpty && required) || hasError)
    }

    public init(
        label: String,
        value: Binding<String>,
        errorMessage: String? = nil,
        readonly: Bool = false,
        required: Bool = false,
        isSecure: Bool = false,
        hasError: Bool = false,
        showRevealIcon: Bool = false,
        maskedValue: String? = nil,
        keyboardType: UIKeyboardType = .default
    ) {
        self.label = label
        self._value = value
        self.errorMessage = errorMessage
        self.readonly = readonly
        self.required = required
        self.isSecure = isSecure
        self.hasError = hasError
        self.showRevealIcon = showRevealIcon
        self.maskedValue = maskedValue
        self.keyboardType = keyboardType
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .leading) {
                Text(label)
                    .font(.body)
                    .foregroundColor(Color.gray)
                    .padding(.horizontal, 12)
                    .offset(y: (value.isEmpty && !isMaskedVisible) ? 0 : -14)
                    .scaleEffect((value.isEmpty && !isMaskedVisible) ? 1.0 : 0.85, anchor: .leading)
                    .animation(.easeInOut(duration: 0.2), value: value.isEmpty)

                ZStack{
                    HStack {
                        if isSecure && !isSecureTextVisible {
                            SecureField("", text: isMaskedVisible ? $textFieldValue : $value)
                                .padding(.top, (value.isEmpty && !isMaskedVisible) ? 0 : 10)
                                .padding(.horizontal, 12)
                                .frame(height: 56)
                                .allowsHitTesting(!readonly)
                                .font(.body)
                        } else {
                            TextField("", text: isMaskedVisible ? $textFieldValue : $value)
                                .padding(.top, (value.isEmpty && !isMaskedVisible) ? 0 : 10)
                                .padding(.horizontal, 12)
                                .frame(height: 56)
                                .allowsHitTesting(!readonly)
                                .font(.body)
                                .keyboardType(keyboardType)
                                .focused($isFocused)
                                .toolbar {
                                    if isFocused && keyboardType == .numberPad {
                                        ToolbarItemGroup(placement: .keyboard) {
                                            Spacer()
                                            Button("Done") {
                                                isFocused = false
                                            }
                                            .buttonStyle(.plain)
                                        }
                                    }
                                }
                        }
                        
                        if isSecure && showRevealIcon {
                            Button(action: {
                                isSecureTextVisible.toggle()
                            }) {
                                Image(systemName: isSecureTextVisible ? "eye.slash" : "eye")
                                    .foregroundColor(.gray)
                            }
                            .padding(.trailing, 12)
                        }
                    }
                    HStack{
                        Spacer()
                        if readonly {
                            Image("icon-lock")
                                .padding(.trailing, 12)
                        }
                    }
                }
            }
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(showError ? Color.red : Color.gray.opacity(0.5), lineWidth: 1)
            )
            .cornerRadius(4)
            .opacity(readonly ? 0.6 : 1.0)
            .background(showError ? Color.red.opacity(0.1) : Color.clear)

            if let error = errorMessage, showError{
                Text(error)
                    .font(.footnote)
                    .foregroundColor(Color.red)
                    .padding(.leading, 4)
                    .padding(.top, 8)
            }
        }
        .onAppear {
            if let masked = maskedValue, !value.isEmpty {
                textFieldValue = masked
                isMaskedVisible = true
            } else {
                textFieldValue = value
            }
        }
        .onChange(of: textFieldValue) { oldValue, newText in
            if isMaskedVisible {
                if newText.count < (maskedValue?.count ?? 0) {
                    // User is deleting the masked value
                    value = ""
                    textFieldValue = ""
                    isMaskedVisible = false
                }
            }
        }
        .onChange(of: value) { oldValue, newValue in
            if !isMaskedVisible && textFieldValue != newValue {
                textFieldValue = newValue
            }
            isMaskedVisible = false
        }
    }
}

public struct VVPasswordField: View {
	let label: String
	@Binding var value: String
	let errorMessage: String?
	let readonly: Bool
	let required: Bool
	let hasError: Bool
	
	public init(
		label: String,
		value: Binding<String>,
		errorMessage: String? = nil,
		readonly: Bool = false,
		required: Bool = false,
		hasError: Bool = false
	) {
		self.label = label
		self._value = value
		self.errorMessage = errorMessage
		self.readonly = readonly
		self.required = required
		self.hasError = hasError
	}

	public var body: some View {
		VVTextField(label: self.label, value: self.$value, errorMessage: self.errorMessage, readonly: self.readonly, required: self.required, isSecure: true, hasError: self.hasError, showRevealIcon: true)
	}
}

struct FloatingPlaceholderTextField_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
			TextFieldPreview()
                
			PasswordFieldPreview()
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}

struct TextFieldPreview: View {
    @State private var email: String = ""

    var body: some View {
        VVTextField(label: "Email", value: $email, errorMessage: "test")
    }
}

struct PasswordFieldPreview: View {
	@State private var value: String = ""

	var body: some View {
		VVPasswordField(label: "Password", value: $value, errorMessage: "Invalid password", required: true)
	}
}
