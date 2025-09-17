//
//  HorizontalView.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 14.1.25.
//

import SwiftUI

public struct HorizontalScroll<Content: View>: View {
    @ViewBuilder var content: () -> Content
	var alignCenter: Bool
    
    public init(alignCenter: Bool = true, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
		self.alignCenter = alignCenter
    }
    
    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
			HStack(alignment: .center) {
                content()
            }
			.if(alignCenter) { view in
				view.frame(minWidth: UIScreen.main.bounds.width)
			}
        }
    }
}


#Preview("Text with scrolling") {
    HorizontalScroll {
        Text("This is a very long text that will overflow the screen")
    }
}

#Preview("Text without scrolling") {
    HorizontalScroll {
        Text("This is a text in center")
    }
}
