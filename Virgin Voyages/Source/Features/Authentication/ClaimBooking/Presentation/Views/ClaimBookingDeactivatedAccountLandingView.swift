//
//  ClaimBookingDeactivatedAccountLandingView.swift
//  Virgin Voyages
//
//  Created by TX on 11.8.25.
//

import SwiftUI
import VVUIKit

struct ClaimBookingDeactivatedAccountLandingView: View {
   
    let didTapClose: VoidCallback
    let didTapWhyThisHappened: VoidCallback
    let didTapClaimABooking: VoidCallback

    init(didTapClose: @escaping VoidCallback, didTapWhyThisHappened: @escaping VoidCallback, didTapClaimABooking: @escaping VoidCallback) {
        self.didTapClose = didTapClose
        self.didTapWhyThisHappened = didTapWhyThisHappened
        self.didTapClaimABooking = didTapClaimABooking
    }
    
    var body: some View {
        toolbar()
        ScrollView {
            claimBookingInfoContent()
            claimBookingCTAs()
        }
    }
    
    func toolbar() -> some View {
        Toolbar(buttonStyle: .closeButton) {
            didTapClose()
        }
    }

    private func claimBookingInfoContent() -> some View {
        VStack(alignment: .leading, spacing: 16.0) {
            Text("Claim a booking")
                .fontStyle(.largeTitle)
                .multilineTextAlignment(.leading)

            Text("Hmm... it looks like we've had some issues with your account. Don't worry though, we'll have you set up again in a jiffy.\n\nWe'll need you to reclaim your booking before we continue.")
                .fontStyle(.largeTagline)
                .multilineTextAlignment(.leading)
                .foregroundColor(.gray)

            Button(action: {
                didTapWhyThisHappened()
            }) {
                Text("Why has this happened?")
                    .fontStyle(.largeTagline)
                    .foregroundColor(.gray)
                    .underline()
            }
        }
        .padding(24.0)
    }

    private func claimBookingCTAs() -> some View {
        VStack(spacing: 16) {
            Button("Claim a booking") {
                didTapClaimABooking()
            }
            .buttonStyle(PrimaryButtonStyle())
            .padding(.top, 16.0)
            .padding(.horizontal, 24.0)

            Button("Cancel") {
                didTapClose()
            }
            .buttonStyle(TertiaryButtonStyle())
            .padding(.top, 16.0)
            .padding(.horizontal, 24.0)
        }
    }
}
