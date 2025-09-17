//
//  DashedLine.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 1/30/24.
//

import SwiftUI

public struct DashedLine: View {
    var color: Color
    
    public init(color: Color) {
        self.color = color
    }
    
    public var body: some View {
		Canvas { context, size in
			let dashes = 25.0
			let dashWidth = 8.0
			let space = (size.width - (dashes * dashWidth)) / (dashes - 1.0)
			
			var path = Path()
			path.move(to: CGPoint(x: 0, y: 0))
			path.addLine(to: CGPoint(x: size.width, y: 0))
			context.stroke(path, with: .color(color), style: .init(lineWidth: 2, dash: [dashWidth, space]))
		}
		.frame(height: 1)
    }
}

#Preview {
	DashedLine(color: Color(uiColor: .systemGray4))
}
