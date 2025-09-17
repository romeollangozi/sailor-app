//
//  CameraDocumentOverlayView.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 7/31/24.
//

import SwiftUI

struct CameraDocumentOverlayView: View {
    private let borderColor: Color = .white
    private let borderWidth: CGFloat = 1.86
    private let cornerRadius: CGFloat = 8
    private let overlayPadding: CGFloat = 32
    var overlayHeight: CGFloat = 250
    private let bottomPadding: CGFloat = 150
    var description: String = "Position your document within the box with the code within the dotted area."
    var dottedFrameHeight: CGFloat = 50.0
    var onFrameUpdate: ((CGRect) -> Void)? = nil

    var body: some View {
        VStack {
            Spacer()
            ZStack {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(borderColor, lineWidth: borderWidth)
                    .frame(height: overlayHeight)
                    .overlay {
                        VStack {
                            Spacer()
                            Rectangle()
                                .stroke(style: StrokeStyle(lineWidth: 1, dash: [5, 3]))
                                .frame(height: dottedFrameHeight, alignment: .bottom)
                                .foregroundColor(.white)
                                .padding()
                        }
                    }
                    .overlay {
                        GeometryReader { geo in
                            ZStack{
                                Color.clear
                                    .onAppear {
                                        let rect = geo.frame(in: .global)
                                        onFrameUpdate?(rect)
                                    }
                                    .onChange(of: geo.frame(in: .global)) { _, newValue in
                                        let rect = newValue
                                        onFrameUpdate?(rect)
                                    }
                            }
                        }
                    }
            }
            .padding(.horizontal, overlayPadding)
            .frame(height: overlayHeight)

            Text(description)
                .foregroundStyle(.white)
                .fontStyle(.smallBody)
                .multilineTextAlignment(.center)
                .padding(overlayPadding)

            Spacer()
        }
        .padding(.bottom, bottomPadding)
    }
}

#Preview {
    CameraDocumentOverlayView()
        .background(.gray)
}
