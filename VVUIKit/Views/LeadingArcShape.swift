//
//  LeadingArc.swift
//  Voyages
//
//  Created by Chris DeSalvo on 12/29/23.
//

import SwiftUI

struct LeadingArcShape: Shape {
	func path(in rect: CGRect) -> Path {
		var path = Path()
		let width = rect.size.width
		let height = rect.size.height
		let radius = min(width, height / 2)
		let startPoint = CGPoint(x: 0, y: 0)
		path.move(to: startPoint)
		path.addArc(center: CGPoint(x: 0, y: height / 2), radius: radius, startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 270), clockwise: true)
		path.closeSubpath()
		return path
	}
}

#Preview {
	LeadingArcShape()
		.frame(width: 20, height: 40)
		.background(.red)
}
