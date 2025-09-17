//
//  VVSailorPickerLabel.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 1/14/25.
//

import SwiftUI

struct VVSailorPickerLabel: View {

	var imageUrl: URL?
	var imageName: String?
	var title: String
	var style: VVSailorPhotoModifier.Style = .unselected

	var body: some View {
		VStack {
			ZStack(alignment: .bottomTrailing) {
				imageView
				statusIcon
			}
			titleView
		}
	}

	@ViewBuilder
	private var imageView: some View {
		if let imageUrl {
			AuthenticatedProgressImage(url: imageUrl)
				.modifier(VVSailorPhotoModifier(style: style))
		} else if let imageName {
			Image(imageName)
				.resizable()
				.modifier(VVSailorPhotoModifier(style: style))
		} else {
			Rectangle()
				.fill(Color(uiColor: .systemGray6))
				.modifier(VVSailorPhotoModifier(style: style))
		}
	}

	@ViewBuilder
	private var statusIcon: some View {
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
		case .confirmed:
			Image(systemName: "checkmark.circle.fill")
				.imageScale(.large)
				.foregroundStyle(.white, Color("Tropical Blue"))
		}
	}

	private var titleView: some View {
		Text(title)
			.font(.caption)
			.foregroundColor(.secondary)
			.frame(width: 56)
	}
}

struct VVSailorPhotoModifier: ViewModifier {

	enum Style {
		case unselected
		case selected
		case error
		case confirmed

		var borderColor: Color {
			switch self {
			case .selected, .confirmed: Color("Tropical Blue")
			case .unselected: Color(uiColor: .systemGray4)
			case .error: .orange
			}
		}
	}

	var style: Style
	var size: CGFloat

	init(style: Style, size: CGFloat = 56.0) {
		self.style = style
		self.size = size
	}

	func body(content: Content) -> some View {
		content
			.frame(width: size, height: size)
			.background(Color(uiColor: .systemGray6))
			.clipShape(Circle())
			.overlay(borderOverlay)
	}

	private var borderOverlay: some View {
		ZStack {
			Circle()
				.stroke(lineWidth: 6)
				.foregroundStyle(.background)
				.frame(width: size - 2, height: size - 2)

			Circle()
				.stroke(lineWidth: 2)
				.foregroundStyle(style.borderColor)
				.frame(width: size, height: size)
		}
	}
}
