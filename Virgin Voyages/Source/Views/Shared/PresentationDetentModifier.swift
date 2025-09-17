//
//  PresentationDetentModifier.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 2/25/24.
//

import SwiftUI

struct ContentFitModifier: ViewModifier {
	var padding: CGFloat
	
	func body(content: Content) -> some View {
		content
			.fixedSize(horizontal: false, vertical: true)
			.padding(.vertical, padding)
	}
}

extension View {
	func fitContent(_ padding: CGFloat = 0) -> some View {
		self.modifier(ContentFitModifier(padding: padding))
	}
}

struct HeightKey: PreferenceKey {
	static var defaultValue: CGFloat? { nil }
	static func reduce(value: inout CGFloat?, nextValue: () -> CGFloat?) {
		if let next = nextValue() {
			value = next
		}
	}
}

struct SheetHeightModifier: ViewModifier {
	@Environment(\.contentSpacing) var spacing
	@Binding var height: CGFloat

	func body(content: Content) -> some View {
		content
			.background {
				GeometryReader { reader in
					Color.clear
						.preference(key: HeightKey.self, value: reader.size.height + spacing * 2)
				}
			}
			.onPreferenceChange(HeightKey.self) {
				guard let newHeight = $0, newHeight < 2000 else {
					return
				}
				
				height = newHeight
			}
	}
}

private struct PresentationDetentModifier: ViewModifier {
	@Binding var height: CGFloat

	func body(content: Content) -> some View {
		content
			.modifier(SheetHeightModifier(height: $height))
			.presentationDetents([.height(height)])
	}
}

extension View {
	func flexiblePresentationDetents(height: Binding<CGFloat>) -> some View {
		self.modifier(PresentationDetentModifier(height: height))
	}
}

#Preview {
	Text("Hello World!")
		.flexiblePresentationDetents(height: .constant(10))
}
