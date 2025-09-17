//
//  PurchaseSummaryTicketStubView.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 10/17/24.
//

import SwiftUI
import VVUIKit

struct PurchaseSummaryTicketStubView: View {

    let date: String?
	let category: String
	let name: String
    let location: String?
	let purchasedForText: String
	let bookableImageName: String?
	var sailorsProfileImageUrl: [String]?

	var body: some View {
		VStack(spacing: 0) {
			TicketStubSection(position: .top) {
				HStack(spacing: 0) {
					VStack(alignment: .leading, spacing: 0) {
//                        if let date {
//                            Text(date)
//                                .font(.caption)
//                                .foregroundColor(.black)
//                        }
						Text(category)
							.fontStyle(.boldTagline)
							.foregroundColor(.squidInk)
						Text(name)
							.fontStyle(.smallTitle)
							.foregroundColor(.blackText)
					}
					Spacer()
					if let imageName = bookableImageName {
						ImageViewer(url: imageName, width: Spacing.space40, height: Spacing.space40)
							.padding(Spacing.space10)
					}
				}
			}
            if let location {
                TicketStubTearOffSection()
                TicketStubSection(position: .middle) {
                    HStack(spacing: 0) {
                        VStack(alignment: .leading, spacing: 0) {
                            Text(location)
                                .font(.vvSmall)
                                .foregroundColor(.slateGray)
                        }
                        Spacer()
                    }
                }
            }
			TicketStubTearOffSection()
			TicketStubSection(position: .bottom) {
				HStack(spacing: 0) {
					VStack(alignment: .leading, spacing: 0) {
						HStack {
							if let profileImages = sailorsProfileImageUrl {
								HorizontalImageStack(imageUrls: profileImages, imageSize: Spacing.space24)
							}
							Text(purchasedForText)
								.fontStyle(.boldTagline)
								.foregroundColor(.slateGray)
							Spacer()
						}
					}
					Spacer()
				}
			}
		}
		.padding(EdgeInsets(top: 16, leading: 16, bottom: 32, trailing: 16))
	}
}
