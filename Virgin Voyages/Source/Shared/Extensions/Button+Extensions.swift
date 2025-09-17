//
//  Button+Extensions.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 11.2.25.
//

import SwiftUI

extension View {
    @ViewBuilder
    func primaryButtonStyle(isDisabled: Bool = false) -> some View {
        if !isDisabled {
            self.buttonStyle(PrimaryButtonStyle())
        } else {
            self.buttonStyle(PrimaryDisabledButtonStyle())
        }
    }
}

extension Button {
    @ViewBuilder
    func primaryButtonStyle(isDisabled: Bool = false) -> some View {
        if !isDisabled {
            self.buttonStyle(PrimaryButtonStyle())
        } else {
            self.buttonStyle(PrimaryDisabledButtonStyle())
        }
    }
}
