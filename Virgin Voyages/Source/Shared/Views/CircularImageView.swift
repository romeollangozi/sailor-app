//
//  CircularImageView.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 9/9/24.
//

import SwiftUI

struct CircularImageView: View {
	let image: ImageResource
	let size: CGFloat

	var body: some View {
		Image(image)
			.resizable()
			.scaledToFill()
			.frame(width: size, height: size)
			.clipShape(Circle())
	}
}
