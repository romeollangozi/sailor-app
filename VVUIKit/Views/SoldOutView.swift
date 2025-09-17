//
//  SoldOutView.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 11/13/24.
//

import SwiftUI

public struct SoldOutView: View {
    public var body: some View {
        HStack {
            Text("Sold Out")
                .textCase(.uppercase)
                .font(.subheadline)
                .padding(8)
                .foregroundColor(.white)
            Spacer()
        }
        .background(Color.black)
    }
    
    public init() {
    }
}

struct SoldOutView_Previews: PreviewProvider {
    static var previews: some View {
        SoldOutView()
            .previewLayout(.sizeThatFits)
            .padding()
            .background(Color.gray.opacity(0.2))
    }
}
