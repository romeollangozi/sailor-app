//
//  AlertModifier.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 7/1/25.
//

import SwiftUI

extension View {
    func alertButtonTint(color: Color) -> some View {
        modifier(AlertButtonTintColor(color: color))
    }
}

struct AlertButtonTintColor: ViewModifier {
    let color: Color
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = UIColor(color)
            }
    }
}
