//
//  TimeSlotView.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 11/4/24.
//

import SwiftUI

public struct TimeSlotView: View {
	var dateText: String
	var isSelected: Bool
	var action: () -> Void

	public var body: some View {
		Button(action: action) {
			Text(dateText)
				.foregroundColor(Color.darkGray)
				.padding(8)
				.padding(.horizontal)
				.overlay(
					RoundedRectangle(cornerRadius: 4)
						.stroke(isSelected ? Color.selectedBlue: Color.borderGray, lineWidth: 2)
				)
		}
		.padding(.vertical, 8)
	}
}

struct TimeSlotView_Previews: PreviewProvider {
	static var previews: some View {
		VStack(spacing: 10) {
			TimeSlotView(dateText: "10:00 AM", isSelected: true) {
				print("Selected time slot 1")
			}
			TimeSlotView(dateText: "2:00 PM", isSelected: false) {
				print("Selected time slot 2")
			}
		}
		.padding()
	}
}
