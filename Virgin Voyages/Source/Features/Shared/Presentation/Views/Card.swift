//
//  Card.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 7.2.25.
//

import SwiftUI
import VVUIKit

public struct Card<Footer: View>: View {
	var title: String
	var imageUrl: String?
	var subheading: String?
	var footer: Footer?
	var onTap: (() -> Void)?
	var titleFont: Font?
	var showArrow: Bool
	
	public init(
		title: String,
		titleFont: Font? = nil,
		imageUrl: String? = nil,
		subheading: String? = nil,
		showArrow: Bool = false,
		onTap: (() -> Void)? = nil,
		@ViewBuilder footer: () -> Footer? = { nil }
	) {
		self.title = title
		self.titleFont = titleFont
		self.imageUrl = imageUrl
		self.subheading = subheading
		self.onTap = onTap
		self.footer = footer()
		self.showArrow = showArrow
	}
	
	
	public var body: some View {
		Button(action: {
			onTap?()
		}) {
			VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: Spacing.space16) {
					if let imageUrl {
						ImageViewer(url: imageUrl)
					}
					
					VStack(alignment: .leading, spacing: 0) {
						Text(title)
							.font(titleFont ?? .vvHeading4Bold)
							.foregroundColor(Color.blackText)
							.lineLimit(2)
							.fixedSize(horizontal: false, vertical: true)
							.multilineTextAlignment(.leading)
						
						if let subheading {
                            HTMLText(
                                htmlString: subheading,
                                fontType: .normal, fontSize: .size14,
                                color: Color.slateGray
                            )
                            .multilineTextAlignment(.leading)
						}
					}
					.frame(maxWidth: .infinity, alignment: .leading)
					
					if showArrow {
						Image("forward")
							.frame(width: 16, height: 16)
					}
				}
				.padding(Spacing.space16)
				
				if footer != nil {
					Divider()
					footer
				}
			}
			.frame(maxWidth: .infinity, alignment: .leading)
			.background(Color.white)
			.cardify()
		}
	}
	
}

extension Card where Footer == EmptyView {
	public init(
		title: String,
		titleFont: Font? = nil,
		imageUrl: String? = nil,
		subheading: String? = nil,
		showArrow: Bool = false,
		onTap: (() -> Void)? = nil
	) {
		self.init(title: title,
				  titleFont: titleFont,
				  imageUrl: imageUrl,
				  subheading: subheading,
				  showArrow: showArrow,
				  onTap: onTap,
				  footer: {})
	}
}

#Preview("Cards") {
	VStack {
		Card(title: "Razzle Dazzle Restaurant",
			 imageUrl: "https://cert.gcpshore.virginvoyages.com/dam/jcr:90d42f3b-8fc7-4509-ba55-d4bab1e814df/IMG-FNB-razzle-dazzle-interior-bw-v2-120xs120.jpg",
			 subheading: "Deck 5 Mid",
			 showArrow: true)
		
		Card(title: "Razzle Dazzle Restaurant",
			 imageUrl: "https://cert.gcpshore.virginvoyages.com/dam/jcr:90d42f3b-8fc7-4509-ba55-d4bab1e814df/IMG-FNB-razzle-dazzle-interior-bw-v2-120xs120.jpg",
			 subheading: "Deck 5 Mid",
			 showArrow: true,
			 footer: {
			VStack(alignment: .center) {
				Text("Footer")
			}.padding(16)
		})
		
		Card(title: "Redemption Spa", subheading: "Spa | Deck 5 Mid", showArrow: false)
	}
	.padding(32)
}
