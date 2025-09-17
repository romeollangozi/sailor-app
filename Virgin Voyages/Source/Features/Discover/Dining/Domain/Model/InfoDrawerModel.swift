//
//  InfoDrawerModel.swift
//  Virgin Voyages
//
//  Created by Pajtim on 4.8.25.
//

import Foundation

struct InfoDrawerModel {
    let title: String
    let description: String
    let buttonTitle: String?
    let isSpaceOnBottom: Bool? = nil
    let action: (() -> Void)? = nil

    static func empty() -> InfoDrawerModel {
        .init(title: "title", description: "", buttonTitle: "Got it")
    }
}
