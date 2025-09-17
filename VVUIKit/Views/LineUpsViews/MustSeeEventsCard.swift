//
//  MustSeeEventsCard.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 18.8.25.
//

import SwiftUI

public struct MustSeeEventsCard: View {
    var title: String
    var subtitle: String
    var location: String
    var imageUrl: String?
    var onTap: (() -> Void)?
    
    public init(
        title: String,
        subtitle: String,
        location: String,
        imageUrl: String? = nil,
        onTap: (() -> Void)? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.location = location
        self.imageUrl = imageUrl
        self.onTap = onTap
    }
    
    public var body: some View {
        Button(action: {
            onTap?()
        }) {
            VStack(alignment: .leading, spacing: .zero) {
                HStack(spacing: Spacing.space16) {
                    if let imageUrl {
                        ImageViewer(url: imageUrl, width: Spacing.space48, height: Spacing.space48)
                    }
                    
                    VStack(alignment: .leading, spacing: .zero) {
                        Text(location)
                            .font(.vvSmallBold)
                            .foregroundColor(Color.deepPurple)
                            .multilineTextAlignment(.leading)
                        
                        Text(title)
                            .font(.vvBodyBold)
                            .foregroundColor(Color.blackText)
                            .lineLimit(2)
                            .fixedSize(horizontal: false, vertical: true)
                            .multilineTextAlignment(.leading)
                        
                        Text(subtitle)
                            .font(.vvSmall)
                            .foregroundColor(Color.slateGray)
                            .multilineTextAlignment(.leading)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Image("ForwardRed")
                        .frame(width: Spacing.space16, height: Spacing.space16)
                        .foregroundColor(Color.vvRed)
                }
                .padding(.horizontal, Spacing.space16)
                .padding(.vertical, Spacing.space8)
            }
            }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
    }
}
