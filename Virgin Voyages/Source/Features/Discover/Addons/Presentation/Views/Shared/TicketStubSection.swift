//
//  TicketStubSection.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 10/17/24.
//

import SwiftUI

struct TicketStubSection<Content: View>: View {

	enum Position {
		case top
		case middle
		case bottom
	}

	var position: Position
    var backgroundColor: Color
    var paddingTop: CGFloat
    var paddingBottom: CGFloat
	let content: Content

    init (position: Position = .middle,
          backgroundColor: Color = .white,
          paddingTop: CGFloat = 24,
          paddingBottom: CGFloat = 24,
          @ViewBuilder content: () -> Content) {
		self.position = position
        self.backgroundColor = backgroundColor
        self.paddingTop = paddingTop
        self.paddingBottom = paddingBottom
		self.content = content()
	}

	var body: some View {
		content
        .padding(.top, paddingTop)
        .padding(.bottom, paddingBottom)
        .padding(.horizontal, 24)
		.background(backgroundColor)
		.cornerRadius(position == .top ? 8 : 0, corners: [.topLeft, .topRight])
		.cornerRadius(position == .bottom ? 8 : 0, corners: [.bottomLeft, .bottomRight])
	}
}
