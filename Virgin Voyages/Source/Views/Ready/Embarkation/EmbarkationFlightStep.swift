//
//  EmbarkationFlightStep.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 6/1/24.
//

import SwiftUI

struct EmbarkationFlightStep: View {
	@Environment(\.contentSpacing) var spacing
	@Environment(EmbarkationTask.self) var embarkation
	@Binding var flight: EmbarkationTask.FlightInfo
    var isOutbound: Bool = false
	var action: () -> Void
    @State private var saveTask = ScreenTask()
	var authenticationService: AuthenticationServiceProtocol = AuthenticationService.shared
    @Environment(\.dismiss) var dismiss
    @State private var isShowingModalError = false

    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: spacing) {
                Spacer()

                Text(flight.title)
                    .fontStyle(.headline)

                if let body = flight.body {
                    Text(body)
                        .fontStyle(.body)
                }

                VSpacer(10)

                let airline = Binding(
                    get: { embarkation.airlineName(from: flight.airline) },
                    set: { newValue in flight.airline = embarkation.airlineCode(from: newValue) }
                )
                AirlineField(placeholder: embarkation.content.pageDetails.labels.airline, text: airline, airlines: embarkation.airlines)

                TextInputField(placeholder: embarkation.content.pageDetails.labels.flightNumber, text: $flight.flightNumber)
                    .textContentType(.flightNumber)

				DatePickerField(placeholder: isOutbound ? embarkation.content.pageDetails.labels.departureTime : embarkation.content.pageDetails.labels.arrivalTime, displayedComponents: .hourAndMinute, showToolbar: true, date: $flight.time)

                TaskButton(title: "Next", task: saveTask) {
                    if isOutbound, embarkation.partyMembers.isEmpty {
                        try await authenticationService.currentSailor().save(embarkation: embarkation)
                        dismiss()
                        return
                    }
                    if !isOutbound {
                        let slots = try await authenticationService.currentSailor().updateInboundFlight(embarkation: embarkation)
                        if !isValidSlotTime(slots: slots) {
                            isShowingModalError.toggle()
                            return
                        }
                        embarkation.content.availableSlots = slots.availableSlots
                    }
                    action()
                }
                .buttonStyle(PrimaryButtonStyle())
                .disabled(flight.airline.isEmpty || flight.flightNumber.isEmpty || flight.time == nil)
            }
            .sailableStepStyle()

            if isShowingModalError {
                arrivalTimeErrorModal()
            }
        }
    }

    func isValidSlotTime(slots: Endpoint.UpdateFlight.Response) -> Bool {
        if embarkation.content.isVip {
            if let time = flight.time, let slotEndTime = embarkation.content.slotEndTime, time.format(.time) >= slotEndTime {
                return false
            }
        } else if slots.availableSlots.isEmpty {
            return false
        }
        return true
    }

    @ViewBuilder
    private func arrivalTimeErrorModal() -> some View {
        VVSheetModal(
            title: "#awkward",
            subheadline: "Your flight arrival time is too late to assign an embarkation slot. Please contact sailor services or check and re-enter your flight details.",
            primaryButtonText: embarkation.content.pageDetails.buttons.reEnterFlightDetails,
            primaryButtonAction: {
                isShowingModalError.toggle()
            },
            dismiss: {
                isShowingModalError.toggle()
            },
            primaryButtonStyle: SecondaryButtonStyle()
        )
        .background(Color.clear)
    }
}
