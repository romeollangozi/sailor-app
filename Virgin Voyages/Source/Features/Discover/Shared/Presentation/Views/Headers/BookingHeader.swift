//
//  BookingHeader.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 10/8/24.
//

import SwiftUI
import VVUIKit

struct BookingHeader: View {
    
    let heading: String?
    let description: String?
    let price: String?
    
    init(heading: String? = nil, description: String? = nil, price: String? = nil) {
        self.heading = heading
        self.description = description
        self.price = price
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 0) {
				if let heading = heading {
					Text("\(heading)")
						.fontStyle(.largeTagline)
						.fontWeight(.bold)
				}
                Spacer()
                if let price = price {
                    Text("\(price)")
                        .fontStyle(.largeTagline)
                        .fontWeight(.bold)
                }
            }
			if let description = description {
				Text("\(description)")
					.fontStyle(.body)
					.foregroundColor(.slateGray)
			}
        }
    }
}
