//
//  LoadingButtonLabel.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 8/7/24.
//

import SwiftUI

public struct LoadingButtonLabel: View {
    var title: String?
    var systemImage: String?
    var progressTint: Color?
    var underline: Bool?
    var loading: Bool
    var progressText: String?
    var image: String?

    public init(title: String? = nil, systemImage: String? = nil, progressTint: Color? = nil, underline: Bool? = nil, loading: Bool, progressText: String? = nil, image: String? = nil) {
        self.title = title
        self.systemImage = systemImage
        self.progressTint = progressTint
        self.underline = underline
        self.loading = loading
        self.progressText = progressText
        self.image = image
    }

    public var body: some View {
        ZStack {
            if let progressText = progressText {
                ProgressView(progressText)
                    .opacity(loading ? 1 : 0)
                    .tint(loading ? progressTint : nil)
            } else {
                ProgressView()
                    .opacity(loading ? 1 : 0)
                    .tint(loading ? progressTint : nil)
            }
            
            if let title, let systemImage {
                Label(title, systemImage: systemImage)
                    .opacity(loading ? 0 : 1)
            } else if let systemImage {
                Image(systemName: systemImage)
                    .imageScale(.large)
                    .opacity(loading ? 0 : 1)
            } else if let title {
                Text(title)
                    .underline(underline == true)
                    .opacity(loading ? 0 : 1)
            } else if let image {
                Image(image)
                    .opacity(loading ? 0 : 1)
            }
        }
    }
}
#Preview {
    LoadingButtonLabel(title: "title", loading: true)
}
