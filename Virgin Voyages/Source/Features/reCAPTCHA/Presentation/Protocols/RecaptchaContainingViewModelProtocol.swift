//
//  RecaptchaContainingViewModelProtocol.swift
//  Virgin Voyages
//
//  Created by TX on 1.8.25.
//

import Foundation

protocol RecaptchaContainingViewModelProtocol: AnyObject {
    var reCaptchaIsChecked: Bool { get set }
    var reCaptchaToken: String? { get set }
    var reCaptchaError: String? { get }
    var reCaptchaRefreshID: UUID { get }
}
