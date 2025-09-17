//
//  EmbarkationReviewStep.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 10/29/24.
//

import SwiftUI

struct EmbarkationReviewStep: View {
	@Environment(\.contentSpacing) var spacing
	@Environment(EmbarkationTask.self) var embarkation
    @Environment(\.dismiss) var dismiss

    var body: some View {
        GeometryReader { reader in
            SailableReviewStepScrollable(imageUrl: URL(string: embarkation.content.pageDetails.nonVipFlowContent.embarkationSlotReviewPage.imageURL)) {
                VStack(alignment: .leading, spacing: spacing * 3) {
                    Text("Embarkation")
                        .fontStyle(.largeTitle)

                    VStack(alignment: .leading, spacing: spacing) {
                        Text(embarkation.content.pageDetails.postVoyagePlansContent.inAndOutBoundReviewPage.inBoundTitle)
                            .fontStyle(.title)

                        if embarkation.arrivalFlight.complete {
                            EmbarkationFlightDetailLabel(flight: embarkation.arrivalFlight)
                        }
                        EmbarkationTerminalArrivalLabel()

                        HStack {
                            Spacer()
                            Button {
                                embarkation.editingInbound()
                            } label: {
                                Label(embarkation.content.pageDetails.buttons.edit, systemImage: "pencil.circle")
                                    .imageScale(.large)
                                    .fontStyle(.body)
                                    .textCase(.uppercase)
                            }
                        }
                    }

                    if embarkation.isOutboundSkiped || embarkation.content.postCruiseInfo?.isFlyingOut != false {
                        VStack(alignment: .leading, spacing: spacing) {
                            Text(embarkation.content.pageDetails.postVoyagePlansContent.inAndOutBoundReviewPage.outBoundTitle)
                                .fontStyle(.title)

                            if embarkation.departureFlight.complete {
                                EmbarkationFlightDetailLabel(flight: embarkation.departureFlight, isOutbound: true)

                                HStack {
                                    Spacer()
                                    Button {
                                        embarkation.editingOutbound()
                                    } label: {
                                        Label(embarkation.content.pageDetails.buttons.edit, systemImage: "pencil.circle")
                                            .imageScale(.large)
                                            .fontStyle(.body)
                                            .textCase(.uppercase)
                                    }
                                }
                            } else {
                                Button {
                                    embarkation.editingOutbound()
                                } label: {
                                    VStack {
                                        ZStack {
                                            Circle()
                                                .frame(width: 60, height: 60)
                                                .foregroundStyle(.white)
                                            Image(systemName: "plus")
                                        }
                                        .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 8)

                                        Text(embarkation.content.pageDetails.postVoyagePlansContent.inAndOutBoundReviewPage.emptyOutboundInfo)
                                            .multilineTextAlignment(.center)
                                    }
                                    .padding(spacing)
                                    .frame(minWidth: 0, maxWidth: .infinity)
                                    .background(Color(uiColor: .systemGray6))
                                }
                                .tint(.primary)
                            }
                        }
                    }
                    Spacer()

                    Button("Ok, got it") {
                        dismiss()
                    }
                    .padding(.bottom, spacing)
                    .buttonStyle(PrimaryButtonStyle())
                }
                .frame(minHeight: reader.size.height)
            }
        }
        .environment(embarkation)
    }
}
