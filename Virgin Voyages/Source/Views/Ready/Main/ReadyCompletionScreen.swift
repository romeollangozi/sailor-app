//
//  ReadyCompletionScreen.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 7/9/24.
//

import SwiftUI
import VVUIKit

struct ReadyCompletionScreen: View {
	@Environment(\.dismiss) var dismiss
	@Environment(\.contentSpacing) var spacing
	@Binding var showRTS: Bool
	@State var videoPlayer: LoopingVideoPlayer?
	
    var body: some View {
		ZStack {
			if let videoPlayer {
				LoopingVideoPlayerView(player: videoPlayer)
			}

            VStack(alignment: .center, spacing: spacing * 2) {
                HStack {
                    Spacer()
                    SailableCloseButton {
                        dismiss()
                    }
                }
                .padding(.top)
				Spacer()
				
				Text("You’re Ready to Sail!")
					.fontStyle(.title)
				
				Text("That's all for now—but don't forget to complete your **health check 24 hours** before your voyage begins.")

				Text("We're currently validating your documents. Once your documents are approved and your health check is complete, your **Boarding pass** will be available.")

				VStack(alignment: .center, spacing: spacing) {
					Button("Got it") {
						dismiss()
					}
					.buttonStyle(SecondaryButtonStyle())
					
					Button("Edit your details") {
						showRTS = true
					}
					.buttonStyle(TertiaryButtonStyle())
					
					VSpacer(spacing)
				}
			}
			.multilineTextAlignment(.center)
			.sailableStepStyle()
			.fontStyle(.body)
		}
		.ignoresSafeArea()
		.background(Color(uiColor: .systemGray6))
    }
}

#Preview {
	ReadyCompletionScreen(showRTS: .constant(false))
}
