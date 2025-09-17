//
//  DefaultURLOpener.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 3/5/25.
//


import UIKit

class DefaultURLOpener: URLOpener {
    func open(_ url: URL) {
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
