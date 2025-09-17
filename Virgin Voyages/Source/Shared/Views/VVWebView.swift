//
//  VVWebView.swift
//  Virgin Voyages
//
//  Created by Timur Xhabiri on 1.11.24.
//

import SwiftUI
import VVUIKit
import Foundation
@preconcurrency import WebKit

struct VVWebView: View {
    var htmlString: String
    var onHeightCalculated: (() -> Void)?  // Completion handler
    
    @State private var webViewHeight: CGFloat = 0
    
    var body: some View {
        VStack {
            HTMLStringReadingWebView(htmlString: htmlString, height: $webViewHeight, onHeightCalculated: onHeightCalculated)
        }
        .frame(height: webViewHeight)
    }
}

struct HTMLStringReadingWebView: UIViewRepresentable {
    var htmlString: String
    @Binding var height: CGFloat
    var onHeightCalculated: (() -> Void)?  // Closure for height update
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.minimumZoomScale = 1.0
        webView.scrollView.maximumZoomScale = 1.0
        webView.scrollView.zoomScale = 1.0
        loadHTML(webView)
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        loadHTML(uiView)
    }
    
    private func loadHTML(_ webView: WKWebView) {
        let fontName = FontStyle.body.fontName
        let fontSize = FontStyle.body.pointSize
        let textColor = Color.slateGray.hexadecimalString
        let linkColor = Color.vvRed.hexadecimalString
        
        let css = generateCSS(fontName: fontName, fontSize: fontSize, textColor: textColor, linkColor: linkColor)
        let fullHTML = generateHTMLContent(bodyContent: htmlString, css: css)

        webView.loadHTMLString(fullHTML, baseURL: Bundle.main.bundleURL)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: HTMLStringReadingWebView
        
        init(_ parent: HTMLStringReadingWebView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            webView.evaluateJavaScript("document.body.scrollHeight") { (height, error) in
                if let height = height as? CGFloat {
                    DispatchQueue.main.async {
                        self.parent.height = height
                        self.parent.onHeightCalculated?()  // Trigger callback on height update
                    }
                }
            }
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if let url = navigationAction.request.url, navigationAction.navigationType == .linkActivated {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
                decisionHandler(.cancel)
            } else {
                decisionHandler(.allow)
            }
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            print("WebView ERROR - failed to load with error: \(error.localizedDescription)")
        }
    }
}

extension HTMLStringReadingWebView {
    private func generateCSS(fontName: String, fontSize: CGFloat, textColor: String, linkColor: String) -> String {
        let fontPath = Bundle.main.path(forResource: fontName, ofType: "otf") ?? ""
        let fontURL = fontPath.isEmpty ? "" : "src: url('\(URL(fileURLWithPath: fontPath).absoluteString)') format('opentype');"
        
        return """
            <style>
                @font-face {
                    font-family: '\(fontName)';
                    \(fontURL)
                }
                body {
                    font-family: '\(fontName)';
                    font-size: \(fontSize)px;
                    line-height: 1.5;
                    padding: 0;
                    margin: 0;
                }
                * {
                    font-family: '\(fontName)', sans-serif;
                    color: \(textColor);
                }
                a {
                    color: \(linkColor);
                    text-decoration: none;
                }
                a:hover {
                    color: \(linkColor);
                    text-decoration: underline;
                }
                ul {
                    list-style-type: disc;
                    padding-left: 18px;
                }
                li {
                    margin: 5px 0px;
                }
            </style>
        """
    }

    private func generateHTMLContent(bodyContent: String, css: String) -> String {
        return """
            <html>
            <head>
                <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no, minimum-scale=1.0, maximum-scale=1.0">
                \(css)
            </head>
            <body>
                \(bodyContent)
            </body>
            </html>
        """
    }

}


#Preview {
    let previewHtmlString = "<p>The United States Government requires cruise lines which operate in United States waters to provide certain information to their passengers in the form of a Security Guide.&nbsp;&nbsp;</p>\n\n<p>The safety and security of our passengers and crew is our highest priority.&nbsp; Allegations of crime, missing person reports and medical emergencies are taken seriously, and we are committed to responding in an effective and caring manner for those involved.&nbsp; Each of our ships is staffed with dedicated security and medical teams to respond to alleged crimes and medical situations, respectively.&nbsp; They are onboard, on duty and available at all times. For voyages embarking or debarking in the United States, you may independently contact the FBI or US Coast Guard for incidents arising at any time during the voyage from your phone, or through the ship&rsquo;s Security Office. For incidents within state or foreign waters or ports you may, in addition, contact local law enforcement authorities.&nbsp;&nbsp;</p>\n\n<p>Contact information for these entities, along with contact information for third party victim advocacy groups and the locations of United States Embassies and Consulates for the ports we plan to visit during United States oriented voyages is provided below.&nbsp; If you need assistance in locating this information or if you find this information has changed since publication or is incorrect, please contact the onboard Sailor Services desk immediately.<br />\n<br />\nLink to <a href=\"https://prod.virginvoyages.com/dam/jcr:dac27bfb-bee1-4622-ba61-b324357cfd7b/VV_Security_GuideAndContactList.pdf\">our Security Guide</a></p>\n"
    
    VVWebView(htmlString: previewHtmlString)
}


