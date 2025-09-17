//
//  ContactsSegmentView.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 28.10.24.
//

import SwiftUI

struct CustomSegmentedPicker: View {
    
    // MARK: - Binding property
    @Binding private var selectedOption: CodeOption
    
    // MARK: - Properties
    var yourCodeText: String
    var scanCodeText: String
    var height: CGFloat
    var onYourCodeSelected: () -> Void
    var onScanCodeSelected: () -> Void
    
    // MARK: - Init
    init(selectedOption: Binding<CodeOption>, yourCodeText: String, scanCodeText: String, height: CGFloat = Sizes.defaultSize32, onYourCodeSelected: @escaping () -> Void = {}, onScanCodeSelected: @escaping () -> Void = {}) {
        _selectedOption = selectedOption
        self.yourCodeText = yourCodeText
        self.scanCodeText = scanCodeText
        self.height = height
        self.onYourCodeSelected = onYourCodeSelected
        self.onScanCodeSelected = onScanCodeSelected
    }
    
    var body: some View {
        HStack(spacing: Paddings.zero) {
            Text(yourCodeText)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(selectedOption == .yourCode ? Color.vvDarkGray : Color.white)
                .foregroundColor(selectedOption == .yourCode ? Color.white : Color.vvDarkGray)
                .cornerRadius(CornerRadiusValues.defaultCornerRadius, corners: [.topLeft, .bottomLeft])
                .fontStyle(.smallButton)
                .onTapGesture {
                    selectedOption = .yourCode
                    onYourCodeSelected()
                }
            
            Text(scanCodeText)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(selectedOption == .scanCode ? Color.vvDarkGray : Color.white)
                .foregroundColor(selectedOption == .scanCode ? Color.white : Color.vvDarkGray)
                .cornerRadius(CornerRadiusValues.defaultCornerRadius, corners: [.topRight, .bottomRight])
                .fontStyle(.smallButton)
                .onTapGesture {
                    selectedOption = .scanCode
                    onScanCodeSelected()
                }
        }
        .frame(height: height)
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadiusValues.defaultCornerRadius)
                .stroke(Color.vvDarkGray, lineWidth: 1)
                .background(.clear)
        )
        .padding(.horizontal)

    }
}

enum CodeOption {
    case yourCode
    case scanCode
}

#Preview {
    VStack {
        CustomSegmentedPicker(
            selectedOption: .constant(.yourCode),
            yourCodeText: "Your Code",
            scanCodeText: "Scan Code",
            height: 50,
            onYourCodeSelected: {
                print("Your Code selected")
            },
            onScanCodeSelected: {
                print("Scan Code selected")
            }
        )
        .padding()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(.black)
}
