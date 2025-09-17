//
//  Utilities.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 14.5.25.
//

import SwiftUI

public func resizeImage(_ image: UIImage, maxDimension: CGFloat) -> UIImage {
    let size = image.size
    let aspectRatio = size.width / size.height

    var newSize: CGSize
    if aspectRatio > 1 {
        newSize = CGSize(width: maxDimension, height: maxDimension / aspectRatio)
    } else {
        newSize = CGSize(width: maxDimension * aspectRatio, height: maxDimension)
    }

    let renderer = UIGraphicsImageRenderer(size: newSize)
    return renderer.image { _ in
        image.draw(in: CGRect(origin: .zero, size: newSize))
    }
}

public func cropImageToOverlay(
    _ image: UIImage,
    overlayFrame: CGRect,
    previewFrame: CGRect
) -> UIImage {
    let imageSize = image.size
    let previewSize = previewFrame.size

    let scale = max(
        imageSize.width / previewSize.width,
        imageSize.height / previewSize.height
    )

    let scaledPreviewWidth = previewSize.width * scale
    let scaledPreviewHeight = previewSize.height * scale
    let xOffset = (scaledPreviewWidth - imageSize.width) / 2
    let yOffset = (scaledPreviewHeight - imageSize.height) / 2

    let cropRect = CGRect(
        x: overlayFrame.origin.x * scale - xOffset,
        y: overlayFrame.origin.y * scale - yOffset,
        width: overlayFrame.size.width * scale,
        height: overlayFrame.size.height * scale
    )

    let safeCropRect = cropRect.intersection(CGRect(origin: .zero, size: imageSize))

    guard let cgImage = image.cgImage?.cropping(to: safeCropRect) else {
        print("⚠️ Cropping failed — returning original image")
        return image
    }

    return UIImage(cgImage: cgImage, scale: image.scale, orientation: image.imageOrientation)
}
