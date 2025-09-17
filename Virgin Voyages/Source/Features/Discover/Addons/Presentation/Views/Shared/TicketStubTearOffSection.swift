//
//  TicketStubTearOffSection.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 10/17/24.
//

import SwiftUI
import VVUIKit

struct TicketStubTearOffSection: View {
    
    var foregroundColor: Color
    
    init(foregroundColor: Color = .white) {
        self.foregroundColor = foregroundColor
    }
    
    
	var body: some View {
		Rectangle()
			.frame(height: 12)
			.foregroundColor(foregroundColor)
			.clipShape(TicketStubTearOffSectionShape())
			.overlay {
				DashedLine(color: .borderGray)
					.padding(24)
			}
			.shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 0) // Apply shadow left, right, and bottom
			.clipShape(Rectangle())
	}
}

fileprivate struct TicketStubTearOffSectionShape: Shape {
	func path(in rect: CGRect) -> Path {
		var path = Path()

		// Define the radius for the outward half-circles (6 points)
		let circleRadius: CGFloat = 6

		// Start at the top-left corner
		path.move(to: CGPoint(x: 0, y: 0))

		// Draw the top straight line
		path.addLine(to: CGPoint(x: rect.width, y: 0))

		// Right side inward half-circle cutout
		path.addArc(center: CGPoint(x: rect.width, y: rect.height / 2), radius: circleRadius, startAngle: .degrees(-90), endAngle: .degrees(-270), clockwise: true)

		// Draw the bottom straight line
		path.addLine(to: CGPoint(x: 0, y: rect.height))

		// Left side outward half-circle cutout
		path.addArc(center: CGPoint(x: 0, y: rect.height / 2), radius: circleRadius, startAngle: .degrees(90), endAngle: .degrees(-90), clockwise: true)

		// Close the path to return to the starting point
		path.addLine(to: CGPoint(x: 0, y: 0))

		return path
	}
}

