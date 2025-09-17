//
//  ServiceBackgroundImage.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 4/24/25.
//

import SwiftUI
import VVUIKit

struct ServiceBackgroundImage: View {
    
    let imageUrlString: String
    
    var body: some View {
        
        if let imageURL = URL(string: imageUrlString) {
            
            FlexibleProgressImage(url: imageURL)
                .overlay {
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.black.opacity(0.4),
                            Color.black.opacity(0.4)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                }
        } else {
            Color.gray
                .frame(maxWidth: .infinity)
        }
        
    }
}

#Preview {
    ServiceBackgroundImage(imageUrlString: "https://cms-cert.ship.virginvoyages.com/dam/jcr:24afc9f5-9271-40c4-b233-3c804060c1ac/C4D-Sailor-App-Services-Landing-800x1280.jpg")
}
