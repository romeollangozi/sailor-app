//
//  Color+Hex.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 11/5/24.
//

import SwiftUI

public extension Color {
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
