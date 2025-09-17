//
//  ExpandableRow.swift
//  VVUIKit
//
//  Created by Pajtim on 28.8.25.
//


import SwiftUI

public struct ExpandableRow<Header: View, Content: View>: View {
    @State private var isExpanded: Bool = false


    let backgroundColor: Color
    let cornerRadius: CGFloat
    let borderColor: Color
    let borderWidth: CGFloat
    let header: (_ isExpanded: Bool) -> Header
    let content: () -> Content

    public init(
        backgroundColor: Color = .clear,
        cornerRadius: CGFloat = 0,
        borderColor: Color = .clear,
        borderWidth: CGFloat = 0,
        @ViewBuilder header: @escaping (_ isExpanded: Bool) -> Header,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.header = header
        self.content = content
    }

    public var body: some View {
        VStack(spacing: .zero) {
            Button {
                withAnimation {
                    isExpanded.toggle()
                }
            } label: {
                header(isExpanded)
            }
            .buttonStyle(PlainButtonStyle())

            if isExpanded {
                content()
                    .frame(maxWidth: .infinity)
                    .background(backgroundColor)
            }
        }
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(borderColor, lineWidth: borderWidth)
        )
    }
}

#Preview {
    ExpandableRow(
        header: { isExpanded in
            HStack {
                Text("Opening times")
                    .font(.headline)
                Spacer()
                Image(systemName: "chevron.down")
            }
            .padding()
            .background(Color.black)
            .foregroundColor(.white)
        },
        content: {
            VStack {
                Text("Event Detail 1")
                Text("Event Detail 2")
            }
            .padding()
        }
    )
}

