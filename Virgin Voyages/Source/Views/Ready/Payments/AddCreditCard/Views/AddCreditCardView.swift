//
//  AddCreditCardView.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 7/7/24.
//

import WebKit
import VVUIKit
import SwiftUI

struct AddCreditCardView: View {
	@State var viewModel: AddCreditCardViewModel

	var back: (() -> Void)
	var didAuthorizeCard: ((CreditCardDetails) -> Void)
	var paymentFailed: ((String) -> Void)

	init(
		url: URL,
		back: @escaping (() -> Void),
		didAuthorizeCard: @escaping ((CreditCardDetails) -> Void),
		paymentFailed: @escaping ((String) -> Void)
	) {
		_viewModel = State(wrappedValue: AddCreditCardViewModel(url: url))
		self.back = back
		self.didAuthorizeCard = didAuthorizeCard
		self.paymentFailed = paymentFailed
	}

	var body: some View {
		VStack {
			ZStack {
				createWebLinkView()
				if viewModel.isLoading {
					Color.lightGray.edgesIgnoringSafeArea(.all)
					ProgressView()
						.progressViewStyle(CircularProgressViewStyle())
						.scaleEffect(1.5)
						.padding()
				}
			}
		}
		.ignoresSafeArea()
		.background(Color.lightGray)
		.onChange(of: viewModel.result) {
			switch viewModel.result {
			case .success:
				if let cardDetails = viewModel.addCreditCardResponse?.cardDetails {
					didAuthorizeCard(cardDetails)
				} else {
					back()
				}
			case .failure(let errorMessage):
				paymentFailed(errorMessage)
			default:
				return
			}
		}
	}

	private func createWebLinkView() -> some View {
		InternalPaymentWebView(
			url: viewModel.url,
			configuration: configuration,
			isLoading: $viewModel.isLoading
		)
	}

	private var configuration: WKWebViewConfiguration {
		let configuration = WKWebViewConfiguration()

		// ✅ Persistent cookies/localStorage (required for PayPal)
		configuration.websiteDataStore = .default()

		// ✅ JS + popups
		configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
		let webpagePreferences = WKWebpagePreferences()
		webpagePreferences.allowsContentJavaScript = true
		configuration.defaultWebpagePreferences = webpagePreferences

		// If you ever enable app-bound domains elsewhere, keep this off or whitelist PayPal.
		configuration.limitsNavigationsToAppBoundDomains = false

		// ✅ Script messaging without breaking PayPal
		configuration.userContentController = createUserContentController()
		configuration.userContentController.addUserScript(createMessageListenerScript())

		return configuration
	}

	private func createUserContentController() -> WKUserContentController {
		let contentController = WKUserContentController()
		contentController.add(viewModel, name: "ios")
		return contentController
	}

	// 🔁 NEW: listen/forward messages; DO NOT override window.postMessage
	private func createMessageListenerScript() -> WKUserScript {
		let scriptCode = """
		(function () {
		  if (window.__vv_ios_bridge_installed__) return;
		  window.__vv_ios_bridge_installed__ = true;

		  // Forward a copy of any postMessage events to iOS without interfering
		  window.addEventListener('message', function (event) {
			try {
			  var payload = { origin: event.origin, data: event.data };
			  if (window.webkit && window.webkit.messageHandlers && window.webkit.messageHandlers.ios) {
				window.webkit.messageHandlers.ios.postMessage(event.data);
			  }
			} catch (e) { /* swallow */ }
		  }, false);
		})();
		"""
		return WKUserScript(source: scriptCode, injectionTime: .atDocumentStart, forMainFrameOnly: false)
	}
}

struct InternalPaymentWebView: UIViewRepresentable {
	let url: URL
	var configuration: WKWebViewConfiguration = WKWebViewConfiguration()
	@Binding var isLoading: Bool

	func makeCoordinator() -> Coordinator { Coordinator(self) }

	func makeUIView(context: Context) -> WKWebView {
		let webView = WKWebView(frame: .zero, configuration: configuration)
		webView.navigationDelegate = context.coordinator
		webView.uiDelegate = context.coordinator // ✅ Required for window.open / target=_blank
		webView.load(URLRequest(url: url))
		return webView
	}

	func updateUIView(_ uiView: WKWebView, context: Context) { }

	class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate {
		var parent: InternalPaymentWebView
		init(_ parent: InternalPaymentWebView) { self.parent = parent }

		func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
			parent.isLoading = true
		}

		func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
			parent.isLoading = false
		}

		// Handle PayPal popups in-place
		func webView(_ webView: WKWebView,
					 createWebViewWith configuration: WKWebViewConfiguration,
					 for navigationAction: WKNavigationAction,
					 windowFeatures: WKWindowFeatures) -> WKWebView? {
			if navigationAction.targetFrame == nil {
				webView.load(navigationAction.request)
			}
			return nil
		}

		func webView(_ webView: WKWebView,
					 decidePolicyFor navigationAction: WKNavigationAction,
					 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
			if navigationAction.targetFrame == nil {
				webView.load(navigationAction.request)
				decisionHandler(.cancel)
				return
			}
			decisionHandler(.allow)
		}

		func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
			parent.isLoading = false
			print("Page loading failed with error: \(error)")
		}
	}
}
