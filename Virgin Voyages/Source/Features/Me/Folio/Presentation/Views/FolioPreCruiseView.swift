//
//  FolioPreCruiseView.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 14.5.25.
//

import SwiftUI
import VVUIKit

struct FolioPreCruiseView: View {
    let preCruise: Folio.PreCruise

    var body: some View {
        VStack(spacing: Spacing.space24) {
            AsyncImage(url: URL(string: preCruise.imageUrl)) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Color.gray.opacity(0.1)
            }
            .frame(width: 150, height: 150)
            .clipShape(Circle())
            .shadow(radius: 4)
            .padding(.top, Spacing.space64)

            Text(preCruise.header)
                .font(.vvHeading1Bold)
                .multilineTextAlignment(.center)
                .padding(.horizontal, Spacing.space16)
                .padding(.top, Spacing.space16)

            Text(preCruise.subheader)
                .font(.vvHeading5)
                .multilineTextAlignment(.center)
                .padding(.horizontal, Spacing.space16)

//            HTMLText(htmlString: preCruise.body, fontType: .medium, fontSize: .size16, color: Color.slateGray)
//                .multilineTextAlignment(.center)
//                .frame(maxWidth: .infinity, alignment: .center)
//                .padding(.horizontal, Spacing.space16)

            Spacer()
        }
        .padding(.vertical, Spacing.space32)
    }
    
}

#Preview {
    FolioPreCruiseView(preCruise: Folio.sample().preCruise!)
}
