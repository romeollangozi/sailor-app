//
//  MyQRCodeView.swift
//  Virgin Voyages
//
//  Created by TX on 25.2.25.
//

import Foundation
import SwiftUI

struct MyQRCodeView: View {
    let deepLink: String
    let profileImageUrl: String
    let shareText: String
    let preferredName: String
    let qrCodeImageCallback: ((Data?, String) -> Void)

    var body: some View {
        VStack(spacing: Paddings.zero) {
            HStack {
                Spacer()
                
                VVQRCodeView(
                    viewModel: VVQRCodeViewModel(
                        input: deepLink,
                        profileImage: profileImageUrl
                    ),
                    qrCodeImage: qrCodeImageCallback
                )
                .frame(maxWidth: .infinity, alignment: .center)
                
                Spacer()
                
                VVShareButton(deepLink: deepLink, shareText: shareText)
                    .padding(.leading, Paddings.minusPadding64)
            }
            .padding(.horizontal)
            .padding(.bottom, Paddings.defaultVerticalPadding16)

            Text(preferredName)
                .fontStyle(.largeCaption)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.horizontal, Paddings.defaultHorizontalPadding)
                .padding(.bottom, Paddings.defaultVerticalPadding16)
        }
    }
}

