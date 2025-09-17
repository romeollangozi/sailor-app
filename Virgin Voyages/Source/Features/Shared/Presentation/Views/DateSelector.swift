//
//  DatePicker.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 14.1.25.
//

import SwiftUI
import VVUIKit

public struct DateSelector : View {
	@Binding var selected: Date
	var options: [Date]
    var isPastDateDisabled: Bool = true
	var disabledDates: [Date] = []
	let onSelected: ((Date) -> Void)?
	
	public init(selected: Binding<Date>,
				options: [Date],
				isPastDateDisabled: Bool = true,
				disabledDates: [Date] = [],
				onSelected: ((Date) -> Void)? = nil) {
		self._selected = selected
		self.options = options
        self.isPastDateDisabled = isPastDateDisabled
		self.disabledDates = disabledDates
		self.onSelected = onSelected
	}
	
    public var body: some View {
        ScrollViewReader { proxy in
            HorizontalScroll {
                ForEach(Array(options.enumerated()), id: \.1) { index, date in
                    DateSelectorItem(
                        date: date,
                        isSelected: isSameDay(date1: date, date2: selected),
                        isDisabled: shouldateBeDisabled(date)
                    ) {
                        if !isSameDay(date1: selected, date2: date) {
                            selected = date
                            onSelected?(date)
                        }
                    }
                    .id(date.day)
                    .padding(.leading, index == 0 ? Paddings.defaultVerticalPadding40 : .zero)
                    .padding(.trailing, index == options.count - 1 ? Paddings.defaultVerticalPadding40 : .zero)
                }
            }
            .padding(Spacing.space0)
            .onAppear {
                if let selectedIndex = options.firstIndex(where: { isSameDay(date1: $0, date2: selected) }),
                   selectedIndex > 4 {
                    DispatchQueue.main.async {
                        withAnimation {
                            proxy.scrollTo(selected.day, anchor: .trailing)
                        }
                    }
                }
            }
        }
    }

	private func shouldateBeDisabled(_ date: Date) -> Bool {
		let disabled =  disabledDates.contains(where: {isSameDay(date1: $0, date2: date)})
		
		return disabled || (isPastDateDisabled && isPastDate(date))
	}
}

private struct DateSelectorItem: View {
	let date: Date
	let isSelected: Bool
	let isDisabled: Bool
	let onSelect: () -> Void
	
	var body: some View {
		if let letter = date.toLetter().first {
			Button(action: onSelect) {
				VStack {
					Text(String(letter))
						.tint(Color.slateGray)
						.font(.custom(.normal, size: .size12))
					
					Text(date.toDayNumber())
						.font(.custom(.normal, size: .size14))
						.tint(Color.darkGray)
						.padding(Spacing.space8)
						.frame(width: 40, height: 40)
						.background(Circle().fill(Color.white))
						.overlay(
							Circle()
								.stroke(style: StrokeStyle(lineWidth: 2))
								.tint(isSelected ? Color.selectedBlue : Color.borderGray)
						)
				}
                .padding(.horizontal, Paddings.defaultPadding8)
			}
			.disabled(isDisabled)
			.padding(.bottom, 1)
		}
	}
}

#Preview("Date Selector") {
	let available = DateGenerator.generateDates(from: Date(), totalDays: 10)
	
	DateSelector(selected: .constant(Date()), options: available)
}

#Preview("Date Selector without scroll") {
	let available = DateGenerator.generateDates(from: Date(), totalDays: 2)
	
	DateSelector(selected: .constant(Date()), options: available)
}

#Preview("Date Selector with disabled past dates") {
	DateSelector(
		selected: .constant(Date()),
		options: [
			Date().addingTimeInterval(-86400), // Yesterday
			Date(), // Today
			Date().addingTimeInterval(86400) // Tomorrow
		]
	)
}

#Preview("Date Selector with disabled past dates") {
	DateSelector(
		selected: .constant(Date().addingTimeInterval(86400)),
		options: [
			Date().addingTimeInterval(-86400), // Yesterday
			Date(), // Today
			Date().addingTimeInterval(86400), // Tomorrow
			Date().addingTimeInterval(86400 * 2),
			Date().addingTimeInterval(86400 * 3),
			Date().addingTimeInterval(86400 * 4),
		],
		disabledDates: [
			Date(),
			Date().addingTimeInterval(86400 * 4),
		]
	)
}
