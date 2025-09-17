//
//  SailorPickerLabelStyle.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 22.1.25.
//

import SwiftUI

enum SailorPickerLabelStyle {
	case unselected
	case selected
	case error
	
	var color: Color {
		switch self {
		case .selected: Color("Tropical Blue")
		case .unselected: Color(uiColor: .systemGray4)
		case .error: .orange
		}
	}
}

struct SailorPhotoModifier: ViewModifier {
	var style: SailorPickerLabelStyle
    var size: Double
    
    init(style: SailorPickerLabelStyle, size: Double = 56.0) {
        self.style = style
        self.size = size
    }
    
	func body(content: Content) -> some View {
		content
			.frame(width: size, height: size)
			.background(Color(uiColor: .systemGray6))
			.clipShape(Circle())
			.overlay {
				Circle()
					.stroke(style: .init(lineWidth: 6))
					.frame(width: size - 2, height: size - 2)
					.foregroundStyle(.background)
			}
			.overlay {
				Circle()
					.stroke(style: .init(lineWidth: 2))
					.frame(width: size, height: size)
					.foregroundStyle(style.color)
			}
	}
}
