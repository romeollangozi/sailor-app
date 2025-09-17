//
//  VVRadioSelector.swift
//  VVUIKit
//
//  Created by Enxhi Kondakciu on 25.3.25.
//

import SwiftUI

public struct VVRadioGroup: View {
    public struct RadioOption: Identifiable, Equatable {
        public var id: String { value }
        public let value: String
        public let label: String

        public init(value: String, label: String) {
            self.value = value
            self.label = label
        }
    }

    let label: String
    let options: [RadioOption]
    @Binding var selected: String
    let errorMessage: String?
    let required: Bool
    
    public init(
        label: String,
        options: [RadioOption],
        selected: Binding<String>,
        errorMessage: String? = nil,
        required: Bool = false
    ) {
        self.label = label
        self.options = options
        self._selected = selected
        self.errorMessage = errorMessage
        self.required = required
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: Spacing.space16) {
            Text(label)
                .font(.vvHeading5Medium)

            ForEach(options) { option in
                Button(action: {
                    selected = option.value
                }) {
                    HStack(alignment: .top, spacing: Spacing.space12) {
                            if selected == option.value {
                                ZStack{
                                    Circle()
                                        .fill(Color.vvTropicalBlue)
                                        .frame(width: 32, height: 32)
                                    Circle()
                                        .fill(Color.black)
                                        .frame(width: 16, height: 16)
                                }
                            } else {
                                Circle()
                                    .stroke(required && selected.isEmpty ? Color.lightError : Color.mediumGray, lineWidth: 1)
                                    .fill(required && selected.isEmpty ? Color.lightErrorBackground : Color.clear)
                                    .frame(width: 32, height: 32)
                            }

                        Text(option.label)
                            .font(.vvBody)
                            .foregroundColor(.black)
                            .multilineTextAlignment(.leading)

                        Spacer()
                    }
                    .padding(.top, Spacing.space12)
                    .padding(.horizontal, Spacing.space8)
                }
                .buttonStyle(PlainButtonStyle())
            }
            if let error = errorMessage, required, (selected == "") {
                Text(error)
                    .font(.vvSmall)
                    .foregroundColor(Color.lightError)
                    .padding(.leading, Spacing.space4)
            }
        }
        .padding(.bottom, 32)
    }
}

struct VVRadioGroup_Previews: PreviewProvider {
    static var previews: some View {
        TestRadioGroup()
            .padding()
            .previewLayout(.sizeThatFits)
    }

    struct TestRadioGroup: View {
        @State private var selected = ""

        var body: some View {
            VVRadioGroup(
                label: "What are your post voyage plans?",
                options: [
                    .init(value: "vacation", label: "I'm traveling for leisure, vacation or personal time off."),
                    .init(value: "work", label: "I'm traveling for business-related purposes including meetings or events."),
                    .init(value: "other", label: "Other reasons not listed above.")
                ],
                selected: $selected
            )
        }
    }
}
