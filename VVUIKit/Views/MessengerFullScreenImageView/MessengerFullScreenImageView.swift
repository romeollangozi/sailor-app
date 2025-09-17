//
//  MessengerFullScreenImageView.swift
//  VVUIKit
//
//  Created by TX on 18.6.25.
//

import Foundation
import SwiftUI

public struct MessengerFullScreenImageView: View {
    let imageData: Data?
    let onDismiss: () -> Void
    
    public init(imageData: Data?, onDismiss: @escaping () -> Void) {
        self.imageData = imageData
        self.onDismiss = onDismiss
    }

    public var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            if let data = imageData, let uiImage = UIImage(data: data) {
                let imageWidth = UIScreen.main.bounds.width
                let aspectRatio = uiImage.size.height / uiImage.size.width
                let imageHeight = imageWidth * aspectRatio

                ZoomableScrollView(imageHeight: imageHeight, onSingleVerticalDrag: {
                    onDismiss()
                }) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: imageWidth, height: imageHeight)
                }
            }

            VStack {
                HStack {
                    Spacer()
                    Button(action: { onDismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .frame(width: 32, height: 32)
                            .padding()
                            .foregroundStyle(.white, .white.opacity(0.5))                            
                    }
                }
                Spacer()
            }
        }
    }
}
