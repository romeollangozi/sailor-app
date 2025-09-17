//
//  HTMLText.swift
//  VVUIKit
//
//  Created by TX on 4.4.25.
//

import SwiftUI

public struct HTMLText: View {
    let htmlString: String
    let fontType: FontType
    let fontSize: FontSize
    let color: Color

    public struct StrongOverride {
        public let fontType: FontType
        public let fontSize: FontSize
        public let color: Color
        public init(fontType: FontType, fontSize: FontSize, color: Color) {
            self.fontType = fontType
            self.fontSize = fontSize
            self.color = color
        }
    }

    public struct Options {
        public var strongOverride: StrongOverride? = nil
        public var shouldInsertLineBreakAfterStrong: Bool = false
        public var wrapInPre: Bool = true
        public static let `default` = Options()

        public init(
            strongOverride: StrongOverride? = nil,
            shouldInsertLineBreakAfterStrong: Bool = false,
            wrapInPre: Bool = true
        ) {
            self.strongOverride = strongOverride
            self.shouldInsertLineBreakAfterStrong = shouldInsertLineBreakAfterStrong
            self.wrapInPre = wrapInPre
        }
    }

    let options: Options
    
    @State private var currentRenderedText: AttributedString?
    @State private var isFirstLoad: Bool = true

    public init(htmlString: String, fontType: FontType, fontSize: FontSize, color: Color) {
        self.htmlString = htmlString
        self.fontType = fontType
        self.fontSize = fontSize
        self.color = color
        self.options = .default
    }

    public init(
        htmlString: String,
        fontType: FontType,
        fontSize: FontSize,
        color: Color,
        options: Options
    ) {
        self.htmlString = htmlString
        self.fontType = fontType
        self.fontSize = fontSize
        self.color = color
        self.options = options
    }

    public var body: some View {
        Group {
            if let currentRenderedText {
                Text(currentRenderedText)
            } else {
                ProgressView()
            }
        }
        .onAppear {
            if isFirstLoad {
                render(htmlString: htmlString)
                isFirstLoad = false
            }
        }
        .onChange(of: htmlString, { _, newValue in
            render(htmlString: newValue)
        })
    }

    private func render(htmlString: String) {
        
        let baseFont = UIFont.custom(fontType, size: fontSize)
        let baseColor = UIColor(color)

        let strongFont: UIFont? = options.strongOverride.map { UIFont.custom($0.fontType, size: $0.fontSize) }
        let strongColor: UIColor? = options.strongOverride.map { UIColor($0.color) }

        var proccessedHtmlString = htmlString
        
        if options.wrapInPre {
            proccessedHtmlString = preprocessHTML(proccessedHtmlString)
        }
        if options.shouldInsertLineBreakAfterStrong {
            proccessedHtmlString = ensureDoubleBreakAfterStrong(in: proccessedHtmlString)
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let rendered = renderAttributedString(
                from: proccessedHtmlString,
                baseFont: baseFont,
                baseColor: baseColor,
                strongFont: strongFont,
                strongColor: strongColor
            )

            DispatchQueue.main.async {
                withAnimation(.easeInOut(duration: 0.15)) {
                    self.currentRenderedText = rendered
                }
            }
        }
    }

    private func renderAttributedString(
            from html: String,
            baseFont: UIFont,
            baseColor: UIColor,
            strongFont: UIFont?,
            strongColor: UIColor?
        ) -> AttributedString {
        guard let data = html.data(using: .utf8),
              let attributed = try? NSMutableAttributedString(
                  data: data,
                  options: [
                      .documentType: NSAttributedString.DocumentType.html,
                      .characterEncoding: String.Encoding.utf8.rawValue
                  ],
                  documentAttributes: nil
              )
        else {
            return AttributedString(stringLiteral: html)
        }

        let fullRange = NSRange(location: 0, length: attributed.length)

        attributed.addAttribute(.foregroundColor, value: baseColor, range: fullRange)

        attributed.enumerateAttribute(.font, in: fullRange) { value, range, _ in
            guard let existingFont = value as? UIFont else {
                attributed.addAttribute(.font, value: font, range: range)
                return
            }

            let traits = existingFont.fontDescriptor.symbolicTraits
            if traits.contains(.traitBold), let strongFont, let strongColor {
                attributed.addAttribute(.font, value: strongFont, range: range)
                attributed.addAttribute(.foregroundColor, value: strongColor, range: range)
            } else if let merged = baseFont.fontDescriptor.withSymbolicTraits(traits) {
                let mergedFont = UIFont(descriptor: merged, size: baseFont.pointSize)
                attributed.addAttribute(.font, value: mergedFont, range: range)
            }
        }

        return AttributedString(attributed)
    }
    
    private func ensureDoubleBreakAfterStrong(in html: String) -> String {
        let pattern = #"</span>(?!<br\s*/?><br\s*/?>)(<br\s*/?>)?(?=\S)"#

        guard let regex = try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive]) else {
            return html
        }

        let range = NSRange(html.startIndex..<html.endIndex, in: html)
        let updated = regex.stringByReplacingMatches(in: html, options: [], range: range, withTemplate: "</span><br>")

        
        return updated
    }

    private func preprocessHTML(_ html: String) -> String {
        if html.contains("\n") {
            return "<pre style='white-space: pre-wrap; font-family: inherit;'>\(html)</pre>"
        }
        return html
    }

}


#Preview {
    HTMLText(htmlString: "<p><strong>0/6</strong> tasks complete</p><p>Check in before <strong>2025-04-30</strong></p>", fontType: .medium, fontSize: .size16, color: .blackText)
}
