//
//  CameraSelfieOverlayView.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 7/9/24.
//

import SwiftUI
import Foundation

struct CameraSelfieOverlayView: View {
    private let borderColor: Color = .white
    private let borderWidth: CGFloat = 1.86
    private let cornerRadius: CGFloat = 16
    private let overlayPadding: CGFloat = 32
    private let overlayHeight: CGFloat = 420
    private let bottomPadding: CGFloat = 150

    var body: some View {
        VStack {
            Spacer()
            ZStack {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(borderColor, lineWidth: borderWidth)
                    .frame(height: overlayHeight)
                    .padding(.horizontal, overlayPadding)
                    .overlay {
                        DashedOvalShape()
                    }
            }
            Spacer()
        }
        .padding(.bottom, bottomPadding)
    }
}

#Preview {
	CameraSelfieOverlayView()
		.background(.black)
}
