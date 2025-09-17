//
//  OfflineModeHomeHeader.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 3/19/25.
//

import SwiftUI

public struct OfflineModeHomeHeader: View {
	private var safeAreaInsets: EdgeInsets
	private var shipTimeFormattedText: String?
	private var allAboardTimeFormattedText: String?
	@State private var imageSize: CGSize = .zero

	public var body: some View {
		ZStack {
			// Background image layer
			Image(.offlineModeHeader)
				.resizable()
				.scaledToFit()
				.frame(maxWidth: .infinity)
				.background(
					GeometryReader { imageGeometry in
						Color.clear
							.onAppear {
								self.imageSize = imageGeometry.size
							}
							.onChange(of: imageGeometry.size) {
								self.imageSize = imageGeometry.size
							}
					}
				)

			// Overlay color
			Color.black
				.opacity(0.4)
				.frame(maxWidth: .infinity)

			VStack(spacing: Spacing.space0) {
				// No wifi icon
				Image(systemName: "wifi.slash")
					.font(.system(size: imageSize.height * 0.10))
					.foregroundColor(.white)

				// OFFLINE PORT-MODE text
				Text("OFFLINE\nPORT-MODE")
					.font(.vvVoyagesLargeBold)
					.minimumScaleFactor(0.3)
					.foregroundColor(.white)
					.multilineTextAlignment(.center)

				// Shiptime and all aboard info
				if let shipTimeFormattedText = shipTimeFormattedText {
					HStack(spacing: Spacing.space0) {
						Text("Shiptime ")
							.font(.vvBody)
							.minimumScaleFactor(0.3)
							.foregroundColor(.white)
						Text(shipTimeFormattedText)
							.font(.vvBodyBold)
							.minimumScaleFactor(0.3)
							.foregroundColor(.white)
					}
				}
				if let allAboardTimeFormattedText = allAboardTimeFormattedText {
					HStack(spacing: Spacing.space0) {
						Text("All aboard by ")
							.font(.vvBody)
							.minimumScaleFactor(0.3)
							.foregroundColor(.white)
						Text(allAboardTimeFormattedText)
							.font(.vvBodyBold)
							.minimumScaleFactor(0.3)
							.foregroundColor(.white)
					}
				}
			}
			.frame(width: imageSize.width, height: max(imageSize.height - safeAreaInsets.top - 30, 0))
			.padding(.top, safeAreaInsets.top)
			.padding(.bottom, 30)
		}
	}

	init(safeAreaInsets: EdgeInsets,
		 shipTimeFormattedText: String? = nil,
		 allAboardTimeFormattedText: String? = nil) {
		self.safeAreaInsets = safeAreaInsets
		self.shipTimeFormattedText = shipTimeFormattedText
		self.allAboardTimeFormattedText = allAboardTimeFormattedText
	}
}

struct OfflineModeHomeHeader_Previews: PreviewProvider {
	static var previews: some View {
		OfflineModeHomeHeader(safeAreaInsets: EdgeInsets(.zero))
			.previewLayout(.sizeThatFits)
	}
}
