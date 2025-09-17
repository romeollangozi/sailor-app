//
//  AnchorView.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 26.8.24.
//

import SwiftUI

struct AnchorView: View {
    let width: Double
    let height: Double
    
    init(size: Double = 48.0 ) {
        self.width = size
        self.height = size
    }
    
    var body: some View {
        VectorImage(name: "Anchor")
            .frame(width: width, height: height)
            .foregroundStyle(.white)
    }
}

#Preview {
    AnchorView()
}
