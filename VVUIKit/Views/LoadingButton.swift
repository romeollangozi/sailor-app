//
//  LoadingButton.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 8/7/24.
//

import SwiftUI

public struct LoadingButton: View {
    var title: String?
    var systemImage: String?
    var progressTint: Color?
    var underline: Bool?
    var loading: Bool = false
    var progressText: String?
    var image: String?
    var action: (() -> Void)?

    public init(title: String? = nil, systemImage: String? = nil, progressTint: Color? = nil, underline: Bool? = nil, loading: Bool = false, progressText: String? = nil, image: String? = nil, action: (() -> Void)? = nil) {
        self.title = title
        self.systemImage = systemImage
        self.progressTint = progressTint
        self.underline = underline
        self.loading = loading
        self.progressText = progressText
        self.image = image
        self.action = action
    }

    public var body: some View {
        Button {
            action?()
        } label: {
            LoadingButtonLabel(title: title,
                               systemImage: systemImage,
                               progressTint: progressTint,
                               underline: underline,
                               loading: loading,
                               progressText: progressText,
                               image: image)
        }
        .disabled(loading)
    }
}

#Preview {
    LoadingButton(title: "Loading", loading: true)
}
