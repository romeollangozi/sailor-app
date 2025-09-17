//
//  ProgressArc.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 6/25/24.
//

import SwiftUI

struct ProgressArc: InsettableShape {
	var percent: CGFloat
	var insetAmount = 0.0
	
	func inset(by amount: CGFloat) -> some InsettableShape {
		var arc = self
		arc.insetAmount += amount
		return arc
	}

	func path(in rect: CGRect) -> Path {
		var path = Path()
		let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
		let radius = min(rect.width, rect.height) / 2 - insetAmount
		let startAngle = Angle(degrees: -90)
		let endAngle = Angle(degrees: -90 + (360 * Double(percent)))
		
		path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
		return path
	}
}

struct AnimatedProgressArc: View {
	var percent: CGFloat
	var lineWidth: CGFloat
	@State var animatedPercent: CGFloat = 0
	
	var body: some View {
		ProgressArc(percent: animatedPercent)
			.strokeBorder(style: .init(lineWidth: 6))
			.animation(.easeInOut(duration: 2.0), value: animatedPercent)
			.onAppear {
				animatedPercent = percent
			}
	}
}

#Preview {
	ZStack {
		Circle()
			.foregroundStyle(.red)
		
		Circle()
			.strokeBorder(style: .init(lineWidth: 6))
			.foregroundStyle(.blue)
		
		AnimatedProgressArc(percent: 0.4, lineWidth: 6)
	}
}
