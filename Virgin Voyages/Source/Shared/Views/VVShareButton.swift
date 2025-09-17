//
//  VVShareButton.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 29.10.24.
//

import SwiftUI
import VVUIKit

struct VVShareButton: View {
    
    @State private var isShareSheetPresented = false
    private let deepLink: String
    private let shareText: String
    
    init(isShareSheetPresented: Bool = false, deepLink: String, shareText: String) {
        self.isShareSheetPresented = isShareSheetPresented
        self.deepLink = deepLink
        self.shareText = shareText
    }
    
    var body: some View {
        Button(action: {
            isShareSheetPresented = true
        }) {
            Image(systemName: "square.and.arrow.up")
                .font(.system(size: 30))
                .foregroundColor(Color.primary)
                .padding()
        }
        .sheet(isPresented: $isShareSheetPresented) {
            ShareSheet(activityItems: [shareText, deepLink])
        }
    }
}
