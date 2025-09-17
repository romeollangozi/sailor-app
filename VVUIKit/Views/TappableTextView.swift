//
//  testing view.swift
//  VVUIKit
//
//  Created by TX on 16.5.25.
//

import SwiftUI

public struct TappableTextView: UIViewRepresentable {
    let fullText: String
    let links: [(String, () -> Void)]
    
    public init(fullText: String, links: [(String, () -> Void)]) {
        self.fullText = fullText
        self.links = links
    }

    public class Coordinator: NSObject, UITextViewDelegate {
        var linkActions: [String: () -> Void] = [:]

        public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
            if let action = linkActions[URL.absoluteString] {
                action()
            }
            return false
        }
    }

    public func makeCoordinator() -> Coordinator {
        let coordinator = Coordinator()
        for (index, (_, action)) in links.enumerated() {
            coordinator.linkActions["link\(index)"] = action
        }
        return coordinator
    }

    public func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.delegate = context.coordinator
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        textView.linkTextAttributes = [
                .foregroundColor: UIColor.gray,
                .underlineStyle: NSUnderlineStyle.single.rawValue
            ]
        
        return textView
    }

    public func updateUIView(_ uiView: UITextView, context: Context) {
        let attributed = NSMutableAttributedString(string: fullText)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center

        attributed.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: fullText.count))
        attributed.addAttribute(.font, value: UIFont.preferredFont(forTextStyle: .subheadline), range: NSRange(location: 0, length: fullText.count))
        attributed.addAttribute(.foregroundColor, value: UIColor.gray, range: NSRange(location: 0, length: fullText.count))

        for (index, (text, _)) in links.enumerated() {
            let range = (fullText as NSString).range(of: text)
            if range.location != NSNotFound {
                attributed.addAttribute(.link, value: "link\(index)", range: range)
                attributed.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range)

                attributed.addAttribute(.foregroundColor, value: UIColor.gray, range: range) // <-- your custom color
            }
        }

        uiView.attributedText = attributed

        // Force width constraint to allow wrapping inside SwiftUI
        DispatchQueue.main.async {
            uiView.invalidateIntrinsicContentSize()
        }
    }
}

#Preview {
    TappableTextView(
        fullText: "By booking this event, you accept our company terms and conditions and privacy policy.",
        links: [
            ("terms and conditions", {
            }),
            ("privacy policy", {
            })
        ]
    )
    .frame(minHeight: 40)
    .padding(24)

}
