//
//  ContentView.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 14.1.25.
//

import SwiftUI

public struct ContentView<Content: View>: View  {
	var backgroundColor: Color
    var scrollIndicator: ScrollIndicatorVisibility
    @ViewBuilder var content: () -> Content
    
    public init(backgroundColor: Color = .softGray,
                scrollIndicator: ScrollIndicatorVisibility = .automatic,
                @ViewBuilder content: @escaping () -> Content) {
        self.content = content
		self.backgroundColor = backgroundColor
        self.scrollIndicator = scrollIndicator
    }
    
    public var body: some View {
        ScrollView {
            content()
        }
        .frame(maxWidth: .infinity)
        .background(backgroundColor)
        .scrollIndicators(scrollIndicator)
    }
}

#Preview {
	ContentView {
		Text("Hello, World!")
	}
}

#Preview("With Background Color") {
	ContentView(backgroundColor: .blue) {
		Text("Hello, World!")
	}
}
