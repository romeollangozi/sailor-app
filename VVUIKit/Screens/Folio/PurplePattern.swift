//
//  PurplePattern.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 2/2/24.
//

import SwiftUI

public struct PurplePattern: View {
	private let dark = Color(red: 52.0 / 255.0, green: 23.0 / 255.0, blue: 72.0 / 255.0)
	private let light = Color(red: 63.0 / 255.0, green: 36.0 / 255.0, blue: 82.0 / 255.0)
	private let stretchRatio = 1.5
    
    public init() {}
    
    public var body: some View {
		Canvas { context, size in
			var y: CGFloat = -100
			for _ in 1..<6 {
				var path = Path()
				path.move(to: CGPoint(x: 0, y: y))
				path.addLine(to: CGPoint(x: size.width / 2.0, y: y + (size.width / 2.0) * stretchRatio))
				path.addLine(to: CGPoint(x: size.width, y: y))
				context.stroke(path, with: .color(dark), style: .init(lineWidth: 60))
				y += 60 * 3.5
			}
		}
		.background(light)
		.ignoresSafeArea()
    }
}

#Preview {
    PurplePattern()
}
