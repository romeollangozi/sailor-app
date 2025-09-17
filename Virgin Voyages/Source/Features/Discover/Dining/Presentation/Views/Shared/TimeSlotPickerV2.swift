//
//  TimeSlotPickerV2.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 4.12.24.
//

import SwiftUI
import VVUIKit

struct TimeSlotPickerV2 : View {
	var options: [TimeSlotOptionV2]
	@Binding var selected: TimeSlotOptionV2
	let onSelected: ((TimeSlotOptionV2) -> Void)?
	
	init(options: [TimeSlotOptionV2],
		 selected: Binding<TimeSlotOptionV2>,
		 onSelected: ((TimeSlotOptionV2) -> Void)? = nil) {
		self.options = options
		self._selected = selected
		self.onSelected = onSelected
	}
	
	var body: some View {
		ScrollViewReader { scrollViewProxy in
			ScrollView(.horizontal, showsIndicators: false) {
				HStack(alignment: .center, spacing: Spacing.space16) {
					ForEach(options, id: \.id) { x in
						ZStack(alignment: .bottomTrailing) {
							VStack(alignment: .leading) {
								Text(x.text)
									.font(.vvSmall)
									.foregroundColor(getForegroundColor(x))
									.padding(Spacing.space8)
									.onTapGesture {
										onTapGesture(x)
										withAnimation {
											scrollViewProxy.scrollTo(x.id, anchor: .center)
										}
									}
							}
							.padding(Paddings.zero)
							.background(getBackgroundColor(x))
							.clipShape(RoundedRectangle(cornerRadius: 6))
							.overlay(
								RoundedRectangle(cornerRadius: 6)
									.stroke(getBorderColor(x), lineWidth: 2)
							)

							if x.hasWarning {
								Image(systemName: "exclamationmark.circle.fill")
									.imageScale(.large)
									.foregroundStyle(.white, Color.brightOrange)
									.padding(4)
									.offset(x: 16, y: 16)
							}
						}
						.padding(.bottom, Spacing.space16)
						.id(x.id)
					}
				}
				.padding(Spacing.space4)
			}
			.padding(Spacing.space0)
			.onAppear {
				withAnimation {
					scrollViewProxy.scrollTo(selected.id, anchor: .trailing)
				}
			}
		}
	}
	
	private func onTapGesture(_ item: TimeSlotOptionV2) {
		if !item.isDisabled {
			selected = item
			onSelected?(item)
		}
	}
	
	private func getBackgroundColor(_ item: TimeSlotOptionV2) -> Color {
		if item.isDisabled {
			return Color.borderGray
		} else if item.isHignlighted {
			return Color.vvTropicalBlue
		
		}
		
		return .white
	}
	
	private func getForegroundColor(_ item: TimeSlotOptionV2) -> Color {
		if item.isDisabled {
			return Color.vvWhite
		} else if item.isHignlighted {
			return Color.vvBlack
		
		}
		
		return .darkGray
	}
	
	private func getBorderColor(_ item: TimeSlotOptionV2) -> Color {
		if item.isHignlighted {
			return Color.vvTropicalBlue
		} else if item == selected {
			return Color.selectedBlue
		}
		
		return .borderGray
	}
	
}

struct TimeSlotOptionV2 : Equatable, Identifiable {
	let id: String
	let text: String
	let hasWarning: Bool
	let isDisabled: Bool
	let isHignlighted: Bool
	
	init(id: String, text: String, hasWarning: Bool = false, isDisabled: Bool = false, isHignlighted: Bool = false) {
		self.id = id
		self.text = text
		self.hasWarning = hasWarning
		self.isDisabled = isDisabled
		self.isHignlighted = isHignlighted
	}
}

extension TimeSlotOptionV2 {
	static var samples: [TimeSlotOptionV2] {
		return [
			TimeSlotOptionV2(id: UUID().uuidString, text: "5:00 pm"),
			TimeSlotOptionV2(id: UUID().uuidString, text: "5:30 pm"),
			TimeSlotOptionV2(id: UUID().uuidString, text: "6:00 pm"),
			TimeSlotOptionV2(id: UUID().uuidString, text: "6:30 pm"),
			TimeSlotOptionV2(id: UUID().uuidString, text: "7:00 pm"),
			TimeSlotOptionV2(id: UUID().uuidString, text: "7:30 pm"),
			TimeSlotOptionV2(id: UUID().uuidString, text: "8:00 pm"),
			TimeSlotOptionV2(id: UUID().uuidString, text: "8:30 pm")
		]
	}
	
	static var empty : TimeSlotOptionV2 {
		TimeSlotOptionV2(id: "", text: "")
	}
}

extension Array where Element == TimeSlotOptionV2 {
	func markTimeSlotsWithWarning(_ ids: [String]) -> [TimeSlotOptionV2] {
		return self.map { $0.copy(hasWarning: ids.contains($0.id)) }
	}
}

extension Array where Element == TimeSlotOptionV2 {
	func clearAllSlotsFromWarning() -> [TimeSlotOptionV2] {
		return self.map { $0.copy(hasWarning: false) }
	}
}

extension TimeSlotOptionV2 {
	func copy(
		id: String? = nil,
		text: String? = nil,
		hasWarning: Bool? = nil,
		isDisabled: Bool? = nil,
		isHignlighted: Bool? = nil
	) -> TimeSlotOptionV2 {
		return TimeSlotOptionV2(
			id: id ?? self.id,
			text: text ?? self.text,
			hasWarning: hasWarning ?? self.hasWarning,
			isDisabled: isDisabled ?? self.isDisabled,
			isHignlighted: isHignlighted ?? self.isHignlighted
		)
	}
}


#Preview("Time slot picker") {
	@Previewable @State var selected: TimeSlotOptionV2 = .init(id: "1", text: "7:00 pm")
	
	let available = [TimeSlotOptionV2(id: "1", text: "6:00 pm"),
					 TimeSlotOptionV2(id: "2", text: "6:30 pm", isDisabled: true),
					 TimeSlotOptionV2(id: "3", text: "7:00 pm", isHignlighted: true),
					 TimeSlotOptionV2(id: "4", text: "8:00 pm", hasWarning: true)
	]
	
	TimeSlotPickerV2(options: available, selected: $selected)
}
