//
//  TourDifferentiatorView.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 1/14/25.
//

import SwiftUI
import VVUIKit

struct TourDifferentiatorViewModel {
	var name: String
	var imageURL: URL?
}

struct TourDifferentiatorView: View {
	var viewModel: TourDifferentiatorViewModel

	var body: some View {
		HStack {
			if let url = viewModel.imageURL {
				ProgressImage(url: url)
					.frame(width: 32, height: 32)
					.padding(.trailing, 2)
					.padding(.top, 2)
			}
		}
	}
}
