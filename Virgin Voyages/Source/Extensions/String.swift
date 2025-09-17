//
//  String.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 6/2/23.
//

import SwiftUI

extension String {
	var markdown: AttributedString {
		let tags = [
			"strong": "**",
			"b": "**",
			"em": "*",
			"p": "",
			"br": "\n",
		]

		var text = self.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "\n", with: "")
		for (tag, markdown) in tags {
			text = text.replacingOccurrences(of: "<\(tag)>", with: markdown)
			text = text.replacingOccurrences(of: "</\(tag)>", with: markdown)
			text = text.replacingOccurrences(of: "<\(tag) />", with: markdown)
		}
		
		let regexPattern = "<a href=\"(.*?)\">(.*?)</a>"
		if let regex = try? NSRegularExpression(pattern: regexPattern, options: []) {
			let range = NSRange(location: 0, length: text.utf16.count)
			text = regex.stringByReplacingMatches(in: text, options: [], range: range, withTemplate: "[$2]($1)")
		}

		return (try? .init(markdown: text, options: .init(interpretedSyntax: .inlineOnlyPreservingWhitespace))) ?? .init(text)
	}
    
    func isValidEmail() -> Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: self)
    }
    
    func isValidName() -> Bool {
        let nameRegex = "^[A-Za-z][A-Za-z '-]{0,49}$"
        let nameTest = NSPredicate(format: "SELF MATCHES %@", nameRegex)
        return nameTest.evaluate(with: self)
    }
}

// MARK: Date

extension String {
	func iso8601(timeZone: TimeZone) -> Date? {
		let dateFormatter = DateFormatter()
		dateFormatter.locale = Locale(identifier: "en_US_POSIX")
		dateFormatter.timeZone = timeZone
		dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
		if let date = dateFormatter.date(from: self) {
			return date
		}
		
		return nil
	}
	
	var iso8601: Date? {
		let dateFormatter = DateFormatter()
		dateFormatter.locale = Locale(identifier: "en_US_POSIX")
		dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
		if let date = dateFormatter.date(from: self) {
			return date
		}
		
		dateFormatter.dateFormat = "yyyy-MM-dd"
		if let date = dateFormatter.date(from: self) {
			return date
		}
				
		dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
		if let date = dateFormatter.date(from: self) {
			return date
		}
		
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        if let date = dateFormatter.date(from: self) {
            return date
        }
        
		let formatter = ISO8601DateFormatter()
		formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
		return formatter.date(from: self)
	}
	
	func dateStyle(_ style: DateStyle) -> Date? {
		let dateFormatter = DateFormatter()
		dateFormatter.locale = Locale(identifier: "en_US_POSIX")
		dateFormatter.dateFormat = style.format
		return dateFormatter.date(from: self)
	}
	
	var time: Date? {
		let dateFormatter = DateFormatter()
		dateFormatter.locale = Locale(identifier: "en_US_POSIX")
		dateFormatter.dateFormat = "HH:mm:ss"
		return dateFormatter.date(from: self)
	}
}

extension String {
	var queryNameString: String {
		self.replacingOccurrences(of: " ", with: "-").replacingOccurrences(of: "&", with: "-").replacingOccurrences(of: "'", with: "-")
	}
}

extension Color {
	init(hex: String) {
		guard let hex = Int(hex.replacingOccurrences(of: "#", with: ""), radix: 16) else {
			self = .primary
			return
		}
		
		let r = Double((hex >> 16) & 0xff) / 255
		let g = Double((hex >> 08) & 0xff) / 255
		let b = Double((hex >> 00) & 0xff) / 255
		self = .init(.sRGB, red: r, green: g, blue: b, opacity: 1.0)
	}
}
