//
//  UIApplication+Extensions.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 3.7.25.
//

import UIKit

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder),
                   to: nil, from: nil, for: nil)
    }
}
