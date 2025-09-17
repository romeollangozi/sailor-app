//
//  DiscoverRow.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 1/17/24.
//

import SwiftUI
import VVUIKit

struct DiscoverRow: View {
	var title: String
	var imageUrl: URL?
	var imageName: String?
	var caption: String?
	var body: some View {
        ZStack(alignment: .bottom) {
			if let url = imageUrl {
				FlexibleProgressImage(url: url)
					.overlay {
						LinearGradient(colors: [.black.opacity(0.4), .clear, .black.opacity(0.4)], startPoint: .top, endPoint: .bottom)
					}
			} else if let imageName {
				FlexibleHeightLayout {
					Image(imageName)
						.resizable()
						.aspectRatio(contentMode: .fill)
						.overlay {
							LinearGradient(colors: [.black.opacity(0.4), .clear, .black.opacity(0.4)], startPoint: .top, endPoint: .bottom)
						}
				}
			}
						
			if let caption {
				VStack {
					Text(caption)
						.fontStyle(.headline)
						.foregroundStyle(.background)
						.opacity(1)
						.padding()
					
					Spacer()
				}
			}
			
			Text(title)
				.fontStyle(.largeTitle)
				.foregroundStyle(.background)
				.opacity(1)
				.padding()
		}
        .multilineTextAlignment(.center)
		.background(Color(uiColor: .label))
		.clipShape(RoundedRectangle(cornerRadius: 8))
	}
}
