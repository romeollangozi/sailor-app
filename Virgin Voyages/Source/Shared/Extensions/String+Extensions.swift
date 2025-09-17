//
//  String+Extensions.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 17.10.24.
//

import Foundation
import UIKit

extension String {
    func replacingPlaceholder(_ placeholder: String, with value: String) -> String {
        self.replacingOccurrences(of: "{\(placeholder)}", with: value)
    }

	func splitLines(maxLineWidth: CGFloat, fontSize: CGFloat) -> [String] {
		let words = self.split(separator: " ")
		var lines: [String] = []
		var currentLine = ""

		let font = UIFont.systemFont(ofSize: fontSize)

		for word in words {
			let potentialLine = currentLine.isEmpty ? String(word) : "\(currentLine) \(word)"

			if potentialLine.widthOfString(usingFont: font) > maxLineWidth {
				lines.append(currentLine)
				currentLine = String(word)
			} else {
				currentLine = potentialLine
			}
		}

		if !currentLine.isEmpty {
			lines.append(currentLine)
		}

		return lines
	}

	func widthOfString(usingFont font: UIFont) -> CGFloat {
		let attributes: [NSAttributedString.Key: Any] = [.font: font]
		let size = (self as NSString).size(withAttributes: attributes)
		return size.width
	}
	
    var plainText: String {
        var plainText = self
            .replacingOccurrences(of: "&amp;", with: "&")
            .replacingOccurrences(of: "&lt;", with: "<")
            .replacingOccurrences(of: "&gt;", with: ">")
            .replacingOccurrences(of: "&quot;", with: "\"")
            .replacingOccurrences(of: "&#39;", with: "'")
        
        if let regex = try? NSRegularExpression(pattern: "<[^>]+>", options: .caseInsensitive) {
            plainText = regex.stringByReplacingMatches(
                in: plainText,
                options: [],
                range: NSRange(location: 0, length: plainText.utf16.count),
                withTemplate: ""
            )
        }
        
        return plainText.trimmingCharacters(in: .whitespacesAndNewlines)
        
    }
    
    var isEmptyOrWhitespace: Bool {
        return self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    func capitalizedFirstLetter() -> String {
        guard let first = self.first else { return self }
        return first.uppercased() + self.dropFirst().lowercased()
    }
    
    var isNumeric: Bool {
        return !isEmpty && self.allSatisfy { $0.isNumber }
    }
    
    var containsSpace: Bool {
        return contains(" ")
    }

	var isSvg: Bool {
		return hasSuffix(".svg") || hasSuffix(".SVG")
	}
    
    static let notificationType = "Notification_Type"
    static let notificationData = "Notification_Data"
    
    func pluralized(for count: Int) -> String {
        return count > 1 ? self + "s" : self
    }
}
