//
//  GIFView.swift
//  VVUIKit
//
//  Created by Enxhi Kondakciu on 26.6.25.
//

import SwiftUI
import UIKit
import ImageIO

public struct GIFView: UIViewRepresentable {
    public let gifName: String

    public init(gifName: String) {
        self.gifName = gifName
    }

    public func makeUIView(context: Context) -> UIView {
        let container = UIView()
        let imageView = UIImageView()

        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: container.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
        ])

        if let path = Bundle.main.path(forResource: gifName, ofType: "gif"),
           let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
           let source = CGImageSourceCreateWithData(data as CFData, nil),
           let animatedImage = UIImage.animatedImageWithSource(source) {
            imageView.image = animatedImage
        }

        return container
    }

    public func updateUIView(_ uiView: UIView, context: Context) {}
}

extension UIImage {
    static func animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        var images = [UIImage]()
        var duration: TimeInterval = 0

        for i in 0..<count {
            if let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) {
                let frameDuration = frameDurationAtIndex(source, index: i)
                duration += frameDuration
                images.append(UIImage(cgImage: cgImage))
            }
        }

        return UIImage.animatedImage(with: images, duration: duration)
    }

    private static func frameDurationAtIndex(_ source: CGImageSource, index: Int) -> TimeInterval {
        let defaultDuration = 0.1
        guard let properties = CGImageSourceCopyPropertiesAtIndex(source, index, nil) as? [CFString: Any],
              let gif = properties[kCGImagePropertyGIFDictionary] as? [CFString: Any],
              let unclampedDelay = gif[kCGImagePropertyGIFUnclampedDelayTime] as? Double ?? gif[kCGImagePropertyGIFDelayTime] as? Double
        else {
            return defaultDuration
        }

        return unclampedDelay > 0.011 ? unclampedDelay : defaultDuration
    }
}
