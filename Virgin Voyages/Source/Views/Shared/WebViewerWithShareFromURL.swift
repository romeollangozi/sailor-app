//
//  WebViewerWithShareFromURL.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 20.5.25.
//

import SwiftUI
import QuickLook
import VVUIKit

struct WebViewerWithShareFromURL: View {
    let url: URL?
    @State private var showShareSheet = false

    var body: some View {
        VStack {
            if let url {
                VVWebLinkView(url: url)
                    .edgesIgnoringSafeArea(.all)

                Button {
                    showShareSheet = true
                } label: {
                    Image(systemName: "square.and.arrow.up")
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .trailing)
                .foregroundColor(.blue)
                .sheet(isPresented: $showShareSheet) {
                    ShareSheet(activityItems: [url])
                }

            } else {
                Text("Invalid or missing PDF URL.")
                    .padding()
            }
        }
    }
}
