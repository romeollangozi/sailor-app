//
//  EaterySlotsView.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 26.11.24.
//

import SwiftUI
import VVUIKit

struct EaterySlotsView : View {
	let eatery: EateriesSlots.Restaurant
	let isLoading: Bool
	let slotsPadding: CGFloat
    let readMoreText: String
    let selectSlotSubheading: String?
	let onSlotClick: ((EateriesSlots.Restaurant, Slot) -> Void)?
	let onEditClick: ((EateriesSlots.Restaurant) -> Void)?
    let onReadMoreClick: ((EateriesSlots.Restaurant) -> Void)?

	init(eatery: EateriesSlots.Restaurant,
		 isLoading: Bool = false,
		 slotsPadding: CGFloat = 0,
         readMoreText: String = "Read More",
         selectSlotSubheading: String? = nil,
		 onSlotClick: ((EateriesSlots.Restaurant, Slot) -> Void)? = nil,
		 onEditClick: ((EateriesSlots.Restaurant) -> Void)? = nil,
         onReadMoreClick: ((EateriesSlots.Restaurant) -> Void)? = nil) {
		self.eatery = eatery
		self.isLoading = isLoading
		self.slotsPadding = slotsPadding
        self.readMoreText = readMoreText
        self.selectSlotSubheading = selectSlotSubheading

		self.onSlotClick = onSlotClick
		self.onEditClick = onEditClick
        self.onReadMoreClick = onReadMoreClick
	}
	
	var body: some View {
		if isLoading {
			ProgressView()
				.padding(Spacing.space8)
				.frame(maxWidth: .infinity)
		} else if let appointment = eatery.appointment {
			appointmentView(appointment: appointment)
		} else {
			switch(eatery.state) {
			case(.timeslotsAvailable):
				timeSlotsView()
			default:
				stateTextView()
			}
		}
	}
	
    private func appointmentView(appointment: AppointmentItem) -> some View {
        Button(action: {
            onEditClick?(eatery)
        }) {
            HStack {
                Text(eatery.stateText)
                    .font(.vvSmallBold)
                    .foregroundColor(Color.vvDarkGray)

                Spacer()

                if eatery.state != .timeslotsBookedInPast {
                    Text("Edit")
                        .font(.vvSmall)
                        .foregroundColor(Color.darkGray)
                        .underline()
                }
            }
            .padding(Spacing.space16)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            eatery.state == .timeslotsBookedInPast ? Color.borderGray : Color.selectedGreen
        )
    }
    
	private func timeSlotsView() -> some View {
        VStack(alignment: .leading, spacing: Spacing.space16) {
            if let selectSlotSubheading {
                Text(selectSlotSubheading)
                    .font(.vvBodyBold)
                    .foregroundStyle(Color.charcoalBlack)
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(eatery.slots, id: \.id) { slot in
                        Button {
                            onSlotClick?(eatery, slot)
                        } label: {
                            Text(slot.timeText)
                        }
                        .buttonStyle(BorderedProminentButtonStyle())
                        .fontStyle(.smallButton)
                    }
                }
            }
        }
        .padding(.vertical, Spacing.space16)
        .padding(.horizontal, slotsPadding)
	}
	
	private func stateTextView() -> some View {
        textView(text: eatery.stateText, state: eatery.state)
	}
	
    private func textView(text: String, state: EateryState) -> some View {
        HStack(alignment: .top, spacing: Spacing.space16) {
			Text(text)
				.font(.vvSmall)
				.foregroundColor(Color.slateGray)
                .multilineTextAlignment(.leading)


			Spacer()

            if state == .soldOut || state == .timeslotsSoldOut || state == .soldOutPreCruise {
                VStack {
                    Spacer()
                    Button {
                        onReadMoreClick?(eatery)
                    } label: {
                        Text(readMoreText)
                            .font(.vvSmall)
                            .foregroundColor(Color.slateGray)
                            .underline()
                    }
                    Spacer()
                }

            }
		}
		.padding(slotsPadding)
	}
}

#Preview("Eatery slots") {
	ScrollView {
		VStack(spacing: Spacing.space16) {
			EaterySlotsView(eatery: .sample().copy(slots:[
				Slot.sample().copy(startDateTime: Date()),
				Slot.sample().copy(startDateTime: Date().addingTimeInterval(TimeIntervalDurations.fifteenMinutes)),
				Slot.sample().copy(startDateTime: Date().addingTimeInterval(TimeIntervalDurations.thirtyMinutes)),
				Slot.sample().copy(startDateTime: Date().addingTimeInterval(TimeIntervalDurations.fortyFiveMinutes)),
				Slot.sample().copy(startDateTime: Date().addingTimeInterval(TimeIntervalDurations.oneHour))
			]))
			
			EaterySlotsView(eatery: .sample().copy(state: .brunchClosed, stateText: "Closed for brunch"))
			EaterySlotsView(eatery: .sample().copy(state: .brunchOver, stateText: "Brunch service over"))
			
			EaterySlotsView(eatery: .sample().copy(state: .dinnerClosed, stateText: "Closed for dinner"))
			EaterySlotsView(eatery: .sample().copy(state: .dinnerOver, stateText: "Dinner service over"))
			
			EaterySlotsView(eatery: .sample().copy(state: .timeslotsBooked, slots:[
				Slot.sample().copy(id: "1", startDateTime: Date()),
				Slot.sample().copy(startDateTime: Date().addingTimeInterval(TimeIntervalDurations.fifteenMinutes))
			], appointments: Appointments.sample().copy(items: [.sample().copy(slotId: "1", bannerText: "Booked for 2 @6:15pm", sailors: ["1"])])))
			
			EaterySlotsView(eatery: .sample().copy(state: .timeslotsBookedInPast, slots:[
				Slot.sample().copy(id: "1", startDateTime: Date()),
				Slot.sample().copy(startDateTime: Date().addingTimeInterval(TimeIntervalDurations.fifteenMinutes))
			], appointments: Appointments.sample().copy(items: [.sample().copy(slotId: "1", bannerText: "Booked for 2 @6:15pm", sailors: ["1"])])))
		}
	}
}

