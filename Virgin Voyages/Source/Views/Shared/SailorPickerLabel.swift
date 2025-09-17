//
//  SailorPickerLabel.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 7/30/24.
//

import SwiftUI

extension Array where Element: Equatable {
	mutating func toggle(_ element: Element) {
		if let index = firstIndex(of: element) {
			remove(at: index)
		} else {
			append(element)
		}
	}
}

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

struct SailorPickerLabel: View {
	var imageUrl: URL?
	var imageName: String?
	var title: String
	var style: SailorPickerLabelStyle = .unselected
	
	var body: some View {
		VStack {
			ZStack(alignment: .bottomTrailing) {
				if let imageUrl {
					AuthenticatedProgressImage(url: imageUrl)
						.modifier(SailorPhotoModifier(style: style))
				} else if let imageName {
					Image(imageName)
						.resizable()
						.modifier(SailorPhotoModifier(style: style))
				} else {
					Rectangle()
						.fill(Color(uiColor: .systemGray6))
						.modifier(SailorPhotoModifier(style: style))
				}
				
				switch style {
				case .unselected:
					Image(systemName: "plus.circle.fill")
						.imageScale(.large)
						.foregroundStyle(.white, .gray)
				case .selected:
					EmptyView()
				case .error:
					Image(systemName: "exclamationmark.circle.fill")
						.imageScale(.large)
						.foregroundStyle(.white, .orange)
				}
			}

			Text(title)
				.fontStyle(.caption)
				.tint(.secondary)
				.frame(width: 56)

		}
	}
}
#Preview {
	SailorPickerLabel(title: "Sailor", style: .unselected)
}
