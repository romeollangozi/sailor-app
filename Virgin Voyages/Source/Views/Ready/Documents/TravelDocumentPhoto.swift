//
//  TravelDocumentPhoto.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 6/28/24.
//

import SwiftUI

struct TravelDocumentPhoto: View {
	var photo: TravelDocumentTask.DocumentPhoto
	
	var body: some View {
		HStack(alignment: .top, spacing: 0) {
			switch photo {
			case .data(let data, _):
				if let image = UIImage(data: data) {
					Image(uiImage: image)
						.resizable()
						.aspectRatio(contentMode: .fit)
						.clipShape(RoundedRectangle(cornerRadius: 8))
						.padding(.top, 22)
				}
				
			case .url(let url):
				AuthenticatedProgressImage(url: url)
			}
			
			HStack(alignment: .center, spacing: 10) {
				ZStack {
					Circle()
						.frame(width: 44, height: 44)
						.foregroundStyle(.background)
						.shadow(radius: 2)
					Image(systemName: "camera")
						.foregroundStyle(.primary)
				}
				
				Text("Retake\nphoto")
					.fontStyle(.caption)
					.foregroundStyle(.primary)
			}
			.tint(.primary)
			.padding(.leading, -22)
		}
		.padding(.trailing, 20)
	}
}

#Preview {
    EmptyView()
}
