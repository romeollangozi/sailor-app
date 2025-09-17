//
//  VVWebLinkView.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 20.5.25.
//

import SwiftUI
import WebKit

struct VVWebLinkView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        let request = URLRequest(url: url)
        webView.load(request)
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}
}
