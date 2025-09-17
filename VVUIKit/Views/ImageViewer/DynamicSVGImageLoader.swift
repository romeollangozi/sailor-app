//
//  DynamicSVGImageLoader.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 4/1/25.
//

import SwiftUI
import WebKit

public struct DynamicSVGImageLoader: UIViewRepresentable {
    let url: URL
    @Binding var isLoading: Bool
    
    public init(url: URL, isLoading: Binding<Bool>) {
        self.url = url
        self._isLoading = isLoading
    }
    
    public class Coordinator: NSObject, WKNavigationDelegate {
        var parent: DynamicSVGImageLoader
        var spinner: UIActivityIndicatorView?
        var spinnerContainer: UIView?
        
        public init(_ parent: DynamicSVGImageLoader) {
            self.parent = parent
        }
        
        @MainActor
        public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            self.parent.isLoading = true
            self.showSpinner(in: webView)
        }
        
        public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            DispatchQueue.main.async {
                self.parent.isLoading = false
                self.hideSpinner()
            }
        }
        
        public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            DispatchQueue.main.async {
                self.parent.isLoading = false
                self.hideSpinner()
            }
        }
        
        private func showSpinner(in webView: WKWebView) {
            // Create a container view for the spinner
            let container = UIView()
            container.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.7)
            container.translatesAutoresizingMaskIntoConstraints = false
            webView.addSubview(container)
            
            // Constrain the container to fill the webView
            NSLayoutConstraint.activate([
                container.leadingAnchor.constraint(equalTo: webView.leadingAnchor),
                container.trailingAnchor.constraint(equalTo: webView.trailingAnchor),
                container.topAnchor.constraint(equalTo: webView.topAnchor),
                container.bottomAnchor.constraint(equalTo: webView.bottomAnchor)
            ])
            
            // Create and configure spinner
            let spinner = UIActivityIndicatorView(style: .large)
            spinner.translatesAutoresizingMaskIntoConstraints = false
            spinner.startAnimating()
            container.addSubview(spinner)
            
            // Center spinner in container
            NSLayoutConstraint.activate([
                spinner.centerXAnchor.constraint(equalTo: container.centerXAnchor),
                spinner.centerYAnchor.constraint(equalTo: container.centerYAnchor)
            ])
            
            self.spinner = spinner
            self.spinnerContainer = container
        }
        
        private func hideSpinner() {
            spinner?.stopAnimating()
            spinner?.removeFromSuperview()
            spinnerContainer?.removeFromSuperview()
            spinner = nil
            spinnerContainer = nil
        }
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    public func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.bounces = false
        webView.backgroundColor = .clear
        webView.isOpaque = false
        
        let htmlString = """
        <html>
            <head>
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <style>
                    body {
                        margin: 0;
                        padding: 0;
                        background: transparent;
                        display: flex;
                        justify-content: center;
                        align-items: center;
                    }
                    img {
                        max-width: 100%;
                        height: auto;
                        display: block;
                        margin: auto;
                        object-fit: contain;
                        display: block;
                    }
                </style>
            </head>
            <body>
                <img src="\(url.absoluteString)" />
            </body>
        </html>
        """
        webView.loadHTMLString(htmlString, baseURL: nil)
        
        return webView
    }
    
    public func updateUIView(_ uiView: WKWebView, context: Context) {}
}
