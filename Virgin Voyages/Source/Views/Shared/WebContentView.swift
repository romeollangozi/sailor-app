//
//  WebView.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 1/15/24.
//

import SwiftUI
import WebKit


typealias WebViewLinkEvent = (URL?) -> (WKNavigationActionPolicy)

private class WebViewCoordinator: NSObject, WKNavigationDelegate {
	var event: WebViewLinkEvent
	@Binding var finished: Bool

    init(event: @escaping WebViewLinkEvent, finished: Binding<Bool>) {
		self.event = event
		_finished = finished
	}
	
	func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction) async -> WKNavigationActionPolicy {
		return event(navigationAction.request.url)
	}
	
	func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
		finished = true
	}
}

private struct WebViewInternal: UIViewRepresentable {
	var url: URL
	var configuration: WKWebViewConfiguration = WKWebViewConfiguration()
    var event: WebViewLinkEvent
    @Binding var finished: Bool
    
	var authorizationHeader: String?
	var html: String?
	
    init(url: URL, 
		 configuration: WKWebViewConfiguration = WKWebViewConfiguration(),
         authorizationHeader: String? = nil,
         html: String? = nil,
         finished: Binding<Bool>,
         event: @escaping WebViewLinkEvent) {
		self.url = url
		self.configuration = configuration
		self.authorizationHeader = authorizationHeader
		self.html = html
		self.event = event
		_finished = finished
	}
	
	func makeUIView(context: Context) -> WKWebView {
		let preferences = WKWebpagePreferences.init()
		preferences.preferredContentMode = .mobile

		configuration.defaultWebpagePreferences = preferences
		let view = WKWebView(frame: .zero, configuration: configuration)
		view.navigationDelegate = context.coordinator
		return view
	}

	func updateUIView(_ view: WKWebView, context: Context) {
		if let html {
			view.loadHTMLString(html, baseURL: url)
		} else if let authorizationHeader {
			var request = URLRequest(url: url)
			request.addValue(authorizationHeader, forHTTPHeaderField: "Authorization")
			view.load(request)
		} else {
			let request = URLRequest(url: url)
			view.load(request)
		}
	}
	
	func makeCoordinator() -> WebViewCoordinator {
        WebViewCoordinator(event: event, finished: $finished)
	}
}

struct WebLinkView: View {
	@Environment(\.dismiss) var dismiss
	var url: URL
	var configuration: WKWebViewConfiguration = WKWebViewConfiguration()
	var event: WebViewLinkEvent
	@State var finished = false
	
	var body: some View {
		NavigationStack {
			ZStack {
				WebViewInternal(url: url, configuration:configuration, finished: $finished, event: { url in
                        let action = event(url)
                        if action == .cancel {
                            dismiss()
                        }
                        
                        return action
                })
					
				if !finished {
					ProgressView()
				}
			}
		}
	}
}

struct WebContentView: View {
	var authenticationService: AuthenticationServiceProtocol = AuthenticationService.shared
	var url: URL
	@State private var publishedHtml: String?
	@State private var finished = false
	
	var body: some View {
		NavigationStack {
			ZStack {
				if let html = webPage() {
					WebViewInternal(url: url, authorizationHeader: (try? authenticationService.currentUser())?.authorizationHeader, html: html, finished: $finished) { webURL in
						.allow
					}
				}
					
				if !finished {
					ProgressView()
				}
			}
		}
		.task {
			Task {
				if webPage() == nil {
					publishedHtml = try await authenticationService.currentUser().fetchPage(url: url)
					if let publishedHtml, let fileURL = url.cacheFileURL(with: "html") {
						try publishedHtml.write(to: fileURL, atomically: false, encoding: .utf8)
					}
				}
			}
		}
	}
	
	func webPage() -> String? {
		if let publishedHtml {
			return publishedHtml
		}
		
		if let fileURL = url.cacheFileURL(with: "html") {
			return try? String(contentsOf: fileURL)
		}
		
		return nil
	}
}
