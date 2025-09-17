//
//  UIImage+DetectAndCropDocument.swift
//  Virgin Voyages
//
//  Created by Pajtim on 26.5.25.
//


import UIKit
import Vision

extension UIImage {

    /// Crops the image based on a detected rectangle, adding padding.
    private func cropDocument(using observation: VNRectangleObservation, paddingRatio: CGFloat) -> UIImage? {
        guard let cgImage = self.cgImage else { return nil }

        let imageSize = CGSize(width: cgImage.width, height: cgImage.height)
        let boundingBox = observation.boundingBox
        var rect = CGRect(
            x: boundingBox.origin.x * imageSize.width,
            y: (1 - boundingBox.origin.y - boundingBox.height) * imageSize.height,
            width: boundingBox.width * imageSize.width,
            height: boundingBox.height * imageSize.height
        )

        // Add padding
        let paddingX = rect.width * paddingRatio
        let paddingY = rect.height * paddingRatio
        rect = rect.insetBy(dx: -paddingX, dy: -paddingY)

        // Clamp to image bounds
        let clampedRect = rect.intersection(CGRect(origin: .zero, size: imageSize))

        guard let croppedCGImage = cgImage.cropping(to: clampedRect) else {
            return nil
        }

        return UIImage(cgImage: croppedCGImage, scale: self.scale, orientation: self.imageOrientation)
    }
}

extension UIImage {
    func scale(targetSize: CGSize) -> UIImage {
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        let scaleFactor = min(widthRatio, heightRatio)
        let width = size.width * scaleFactor
        let height = size.height * scaleFactor
        let scaledImageSize = CGSize(width: width, height: height)
        let renderer = UIGraphicsImageRenderer(size: scaledImageSize)

        let scaledImage = renderer.image { _ in
            self.draw(in: CGRect(
                origin: .zero,
                size: scaledImageSize
            ))
        }

        return scaledImage
    }
}
