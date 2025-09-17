//
//  TrailingArc.swift
//  Voyages
//
//  Created by Chris DeSalvo on 12/29/23.
//

import SwiftUI

struct TrailingArcShape: Shape {
	func path(in rect: CGRect) -> Path {
		var path = Path()
		let width = rect.size.width
		let height = rect.size.height
		let radius = min(width, height / 2)
		let startPoint = CGPoint(x: width, y: 0)
		path.move(to: startPoint)
		path.addArc(center: CGPoint(x: width, y: height / 2), radius: radius, startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 270), clockwise: false)
		path.closeSubpath()
		return path
	}
}

#Preview {
	TrailingArcShape()
		.frame(width: 20, height: 40)
		.background(.green)
}
