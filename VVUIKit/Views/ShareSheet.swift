//
//  ShareSheet.swift
//  VVUIKit
//
//  Created by Pajtim on 18.7.25.
//

import SwiftUI

public struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]
    var applicationActivities: [UIActivity]?
    public init(activityItems: [Any], applicationActivities: [UIActivity]? = nil) {
        self.activityItems = activityItems
        self.applicationActivities = applicationActivities
    }

    public func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
    }

    public func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    Color.clear.sheet(isPresented: .constant(true)) {
        ShareSheet(activityItems: [])
    }
}
