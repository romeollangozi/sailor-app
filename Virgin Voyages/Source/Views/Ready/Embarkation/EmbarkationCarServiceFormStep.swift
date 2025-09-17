//
//  EmbarkationCarServiceFormStep.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 10/29/24.
//

import SwiftUI

struct EmbarkationCarServiceFormStep: View {
	@Environment(EmbarkationTask.self) var embarkation
	@Environment(\.contentSpacing) var spacing
    @State private var showCallAlert: Bool = false

    var body: some View {
		let vipFlowContent = embarkation.content.pageDetails.vipFlowContent
        let buttons = embarkation.content.pageDetails.buttons
        VStack(alignment: .leading, spacing: spacing * 2) {
            EmbarkationTerminalArrivalLabel()

            Text(vipFlowContent.contactPage.header)
                .fontStyle(.largeTitle)

            Text(vipFlowContent.contactPage.description)
                .fontStyle(.largeTagline)
                .foregroundColor(.vvGray)

            Spacer()

            VStack(alignment: .leading) {
                HStack(spacing: spacing) {
                    Button(buttons.callNow) {
                        showCallAlert.toggle()
                    }
                    .buttonStyle(PrimaryCapsuleButtonStyle())
                    .alert("Call \(SupportPhones.sailorServicesPhoneNumber)", isPresented: $showCallAlert) {
                        Button("OK") {
                            callPhone(number: SupportPhones.sailorServicesPhoneNumber)
                            embarkation.transportationStep = .complete
                        }
                        Button("Cancel", role: .cancel) {}
                    } message: {
                        Text(buttons.nativeMobilePopup)
                    }

                    Button(buttons.email) {
                        sendMail(to: SupportServices.email, subject: vipFlowContent.contactEmailContent.subject, body: vipFlowContent.contactEmailContent.body)
                        embarkation.transportationStep = .complete
                    }
                    .buttonStyle(PrimaryCapsuleButtonStyle())
                }

                Button(buttons.skip) {
                    embarkation.transportationStep = .complete
                }
                .buttonStyle(TertiaryButtonStyle())
            }
        }
		.sailableStepStyle()
    }
}
