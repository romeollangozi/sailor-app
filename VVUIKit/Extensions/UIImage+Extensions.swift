//
//  UIImage+Extensions.swift
//  VVUIKit
//
//  Created by Enxhi Kondakciu on 28.8.25.
//

import Foundation
import UIKit

extension UIImage {
    public func normalized() -> UIImage {
        if imageOrientation == .up { return self }
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(in: CGRect(origin: .zero, size: size))
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return normalizedImage ?? self
    }
}
