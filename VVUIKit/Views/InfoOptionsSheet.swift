//
//  InfoOptionsSheet.swift
//  VVUIKit
//
//  Created by Enxhi Kondakciu on 20.8.25.
//

import SwiftUI

public struct InfoOptionsSheet: View {
    public let title: String
    public let description: String
    public let options: [Option]

    public struct Option: Hashable {
        public let id = UUID()
        public let name: String
        public let onTap: () -> Void

        public init(name: String, onTap: @escaping () -> Void) {
            self.name = name
            self.onTap = onTap
        }

        public static func == (lhs: Option, rhs: Option) -> Bool {
            lhs.id == rhs.id
        }

        public func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    }

    @Environment(\.dismiss) private var dismiss

    public init(
        title: String,
        description: String,
        options: [Option]
    ) {
        self.title = title
        self.description = description
        self.options = options
    }

    public var body: some View {
        ScrollView{
            VStack(alignment: .leading, spacing: Spacing.space24) {
                HStack {
                    Spacer()
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.darkGray)
                    }
                    .padding(.top, Spacing.space8)
                }
                Spacer()
                Text(title)
                    .font(.vvHeading3Bold)
                    .multilineTextAlignment(.leading)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.top, -Spacing.space48)
                
                Text(description)
                    .font(.vvSmall)
                    .foregroundColor(.darkGray)
                    .multilineTextAlignment(.leading)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.bottom, Spacing.space24)
                
                ForEach(options, id: \.self) { option in
                    Button(option.name) {
                        option.onTap()
                    }
                    .buttonStyle(SecondaryButtonStyle())
                }
                
                Spacer()
            }
        }
        .padding()
        .presentationDetents([.height(460)])
    }
}

#Preview {
    InfoOptionsSheet(
        title: "Choose your document",
        description: "Please select the document type you want to use from the options below.",
        options: [
            .init(name: "Passport", onTap: { print("Passport tapped") }),
            .init(name: "National ID", onTap: { print("ID tapped") })
        ]
    )
}
