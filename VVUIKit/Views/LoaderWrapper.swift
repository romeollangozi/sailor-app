//
//  LoaderWrapper.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 3.2.25.
//

import SwiftUI

public struct LoaderWrapper<Content: View>: View {
    var isLoading: Bool
    @ViewBuilder var content: () -> Content
    
    public init(isLoading: Bool, @ViewBuilder content: @escaping () -> Content) {
        self.isLoading = isLoading
        self.content = content
    }
    
    public var body: some View {
        if isLoading {
            ProgressView()
                .padding(Spacing.space8)
                .frame(maxWidth: .infinity)
        } else {
            content()
        }
    }
}

#Preview ("Loading true") {
    LoaderWrapper(isLoading: true) { Text("Hello, World!") }
}

#Preview ("Loading false") {
    LoaderWrapper(isLoading: false) { Text("Hello, World!") }
}
