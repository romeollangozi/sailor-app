//
//  MRZScannerOverlayView.swift
//  Virgin Voyages
//
//  Created by Pajtim on 6.3.25.
//

import SwiftUI
import VVUIKit

struct MRZScannerOverlayView: View {
    var onCancel: () -> Void
    var onCapture: () -> Void
    var onSwitchCamera: () -> Void
    var onGallery: () -> Void

    var body: some View {
        VStack {
            HStack {
                Button(action: onGallery) {
                    Image(systemName: "photo.on.rectangle")
                        .resizable()
                        .frame(width: 32, height: 22)
                        .foregroundColor(.white)
                }
                .padding(.horizontal, Paddings.defaultVerticalPadding24)
                .padding(.vertical)

                Spacer()
            }
            .background(Color.deepGray)

            Spacer()
            HStack {
                Button(action: onCancel) {
                    Text("Cancel")
                        .font(.vvBody)
                        .foregroundColor(.white)
                }
                Spacer()
                VStack {
                    Text("Photo")
                        .font(.vvSmall)
                        .foregroundColor(.yellow)

                    Button(action: onCapture) {
                        Image(.takePhoto)
                            .foregroundColor(.white)
                    }
                }
                Spacer()
                Button(action: onSwitchCamera) {
                    Image(.switchCamera)
                        .font(.largeTitle)
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal, Paddings.defaultVerticalPadding48)
            .padding(.vertical, Paddings.defaultVerticalPadding32)
            .background(Color.deepGray)
        }
    }
}

#Preview {
    MRZScannerOverlayView(onCancel: {}, onCapture: {}, onSwitchCamera: {}, onGallery: {})
}
