//
//  TimeSlotPickerView.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 11/4/24.
//

import SwiftUI

public struct TimeSlotPickerView: View {

	public struct TimeSlot: Identifiable, Hashable {
		public var id: UUID
		public var dateText: String
		public var isSelected: Bool = false
		public var hasError: Bool

		public init(id: UUID = UUID(),
					dateText: String,
					isSelected: Bool,
					hasError: Bool = false) {
			self.id = id
			self.dateText = dateText
			self.isSelected = isSelected
			self.hasError = hasError
		}
	}

	var timeSlots: [TimeSlot]
	@Binding var selectedTimeSlot: TimeSlot?

	public init(timeSlots: [TimeSlot], selectedTimeSlot: Binding<TimeSlot?>) {
		self.timeSlots = timeSlots
		self._selectedTimeSlot = selectedTimeSlot
	}

	public var body: some View {
		ScrollView(.horizontal) {
			HStack(alignment: .top, spacing: 16) {
				timeSlotsList
			}
			.padding()
		}
	}

	private var timeSlotsList: some View {
	   ForEach(timeSlots) { timeSlot in
		   timeSlotView(for: timeSlot)
	   }
   }

   private func timeSlotView(for timeSlot: TimeSlot) -> some View {
	   TimeSlotView(dateText: timeSlot.dateText,
					isSelected: timeSlot.isSelected
	   ) {
		   toggleSelection(for: timeSlot)
	   }
	   .overlay(
		   Group {
			   if timeSlot.hasError {
				   ErrorStatusView()
					   .frame(width: Spacing.space20, height: Spacing.space20)
					   .alignmentGuide(.bottom) { _ in 25 }
					   .alignmentGuide(.trailing) { _ in 10 }
			   }
		   },
		   alignment: .bottomTrailing)
   }

   private func toggleSelection(for timeSlot: TimeSlot) {
	   if timeSlot.id == selectedTimeSlot?.id {
		   selectedTimeSlot = nil
	   } else {
		   selectedTimeSlot = timeSlot
	   }
   }
}

struct TimeSlotPickerView_Previews: PreviewProvider {

	@State static var selectedTimeSlot: TimeSlotPickerView.TimeSlot? = nil

	static var previews: some View {
		let sampleDates = [
			TimeSlotPickerView.TimeSlot(dateText: "10:00 AM", isSelected: false),
			TimeSlotPickerView.TimeSlot(dateText: "11:00 AM", isSelected: true),
			TimeSlotPickerView.TimeSlot(dateText: "2:00 PM", isSelected: false),
			TimeSlotPickerView.TimeSlot(dateText: "3:00 AM", isSelected: false)
		]

		return TimeSlotPickerView(timeSlots: sampleDates, selectedTimeSlot: $selectedTimeSlot)
			.previewLayout(.sizeThatFits)
			.padding()
	}
}
