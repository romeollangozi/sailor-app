//
//  DashedOvalShape.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 7/9/24.
//

import SwiftUI

private struct OvalShape: Shape {
	func path(in rect: CGRect) -> Path {
		Path(ellipseIn: rect)
	}
}


struct DashedOvalShape: View {
    private let ovalDashPattern: [CGFloat] = [5, 3]
    private let ovalLineWidth: CGFloat = 1
    private let ovalSize: CGSize = CGSize(width: 215, height: 290)

    var body: some View {
        OvalShape()
            .stroke(style: StrokeStyle(lineWidth: ovalLineWidth, dash: ovalDashPattern))
            .frame(width: ovalSize.width, height: ovalSize.height)
            .foregroundColor(.white)
    }
}

#Preview {
	DashedOvalShape()
		.background(.black)
}
