//
//  MessengerLandingScreenFotterView.swift
//  Virgin Voyages
//
//  Created by Timur Xhabiri on 22.10.24.
//

import SwiftUI

extension MessengerLandingScreen {
    struct FotterView: View {
        var text: String = ""
        
        var body: some View {
            HStack {
                Spacer()
                VStack(alignment:.center, spacing: Paddings.defaultVerticalPadding32) {
                    AnchorView(size: 54.0)
                        .opacity(0.65)
                    Text(text)
                        .fontStyle(.smallBody)
                        .foregroundColor(.vvGray)
                        .multilineTextAlignment(.center)
                }
                Spacer()
            }
        }
    }
}


#Preview {
    VStack {
        MessengerLandingScreen.FotterView(text:"Welcome sailor, when you get on ship you will be able to message your fellow sailors and much more.")
    }
}

