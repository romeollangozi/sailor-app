//
//  UIFont+Extension.swift
//  VVUIKit
//
//  Created by TX on 4.4.25.
//

import UIKit

extension UIFont {
    static func custom(_ type: FontType, size: FontSize) -> UIFont {
        return UIFont(name: type.rawValue, size: size.rawValue) ?? UIFont.systemFont(ofSize: size.rawValue)
    }
}
