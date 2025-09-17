//
//  SpaceList.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 1/29/24.
//

import SwiftUI
import VVUIKit

struct ContentSpacingKey: EnvironmentKey {
	static let defaultValue: CGFloat = 15
}

extension EnvironmentValues {
	var contentSpacing: CGFloat {
		get { self[ContentSpacingKey.self] }
		set { self[ContentSpacingKey.self] = newValue }
	}
}

struct ContentModifier: ViewModifier {
	@Environment(\.contentSpacing) var listSpacing: CGFloat
	var spacing: CGFloat? = nil
	func body(content: Content) -> some View {
		content
			.padding(EdgeInsets(top: 0, leading: spacing ?? listSpacing, bottom: 0, trailing: spacing ?? listSpacing))
	}
}

extension View {
	func contentStyle(_ spacing: CGFloat? = nil) -> some View {
		self.modifier(ContentModifier(spacing: spacing))
	}
}

struct ContentScrollView<Content: View>: View {
	@Environment(\.contentSpacing) var listSpacing: CGFloat
	var spacing: CGFloat?
	var title: String?
	var deckLocation: String?
	var image: String?
	var height: CGFloat = 0.5
	@ViewBuilder var label: () -> Content
	var body: some View {
		ScrollView {
			VStack(alignment: .center, spacing: spacing ?? listSpacing) {
				if let image {
					ZStack(alignment: .bottomLeading) {
						FlexibleProgressImage(url: URL(string: image), heightRatio: height)
							.overlay {
								LinearGradient(colors: [.clear, .primary.opacity(0.5)], startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 0, y: 1))
							}
						
						VStack(alignment: .leading, spacing: 0) {
							if let title {
								Text(title)
									.foregroundColor(.white)
									.fontStyle(.largeTitle)
							}
							
							if let deckLocation {
								Text(deckLocation)
									.foregroundColor(.white)
									.fontStyle(.title)
							}
						}
						.padding(listSpacing)
					}
				}
				
				label()
					.contentStyle(spacing ?? listSpacing)
			}
			.padding(.bottom, spacing ?? listSpacing)
		}
		.frame(maxWidth: .infinity)
		.background(Color(uiColor: .systemGray6))
	}
}

#Preview {
	ContentScrollView {
		Text("Hello!")
	}
}
