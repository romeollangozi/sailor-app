//
//  GroupInputField.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 29.8.24.
//

import SwiftUI
import VVUIKit

private struct InputGroupFieldContainer<Content: View>: View {
    @Environment(\.isEnabled) var enabled
    var placeholder: String
    var error: String?
    var shouldHideErrorText: Bool = false
    var optionalText: String = ""
    var type: GroupFormItemType
    var keyboardType: UIKeyboardType = .default
    @Binding var text: String
    @ViewBuilder var content: () -> Content
    @FocusState private var textFieldFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .topLeading) {
                HStack {
                    Text(placeholder)
                        .fontStyle(.caption)
                        .foregroundStyle(.secondary)
                        .opacity(text == "" ? 0 : 1)
                        .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
                    Spacer()
                    Text(optionalText)
                        .font(.vvCaptionBold)
                        .foregroundColor(.iconGray)
                        .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
                }
                content()
                    .foregroundStyle(enabled ? .primary : .secondary)
                    .padding(EdgeInsets(top: text == "" ? 12 : 20, leading: 8, bottom: text == "" ? 12 : 4, trailing: 8))
            }
            .focused($textFieldFocused)
            .onTapGesture {
                textFieldFocused = true
            }
            .background {
                FormItemRoundedRectangle(cornerRadius: 4, type: type)
                    .fill(.white)
                
                if error != nil {
                    FormItemRoundedRectangle(cornerRadius: 4, type: type)
                        .fill(.orange)
                        .opacity(0.1)
                }
            }
            .overlay {
                FormItemRoundedRectangle(cornerRadius: 4, type: type)
                    .stroke(error == nil ? .gray : .orange, lineWidth: 1)
            }
            .opacity(enabled ? 1 : 0.6)
                
            if let error, !shouldHideErrorText {
                Text(error)
                    .fontStyle(.caption)
                    .foregroundStyle(.orange)
            }
        }
    }
    
}

struct GroupInputField: View {
    var placeholder: String = ""
    var optionalText: String = ""
    var type: GroupFormItemType = .single
    var keyboardType: UIKeyboardType = .default
    var error: String?
    var shouldHideErrorText: Bool = false
    
    @Binding var text: String
    var body: some View {
        InputGroupFieldContainer(placeholder: placeholder, error: error, shouldHideErrorText: shouldHideErrorText, optionalText: optionalText, type: type, keyboardType: keyboardType, text: $text) {
            TextField(placeholder, text: $text)
                .keyboardType(keyboardType)
                .accessibilityIdentifier(placeholder)
                .keyboardType(keyboardType)
                .font(.vvSmallBold)
                .foregroundColor(.slateGray)
        }
    }
}

struct FormItemRoundedRectangle: Shape {
    var cornerRadius: CGFloat
    var type: GroupFormItemType
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: type.corners(),
            cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)
        )
        return Path(path.cgPath)
    }
}

enum GroupFormItemType {
    case top
    case middle
    case bottom
    case single
    
    func corners() -> UIRectCorner {
        switch self {
        case .top:
            return [.topLeft, .topRight]
        case .middle:
            return []
        case .bottom:
            return [.bottomLeft, .bottomRight]
        case .single:
            return [.topLeft, .topRight, .bottomLeft, .bottomRight]
        }
    }
}
