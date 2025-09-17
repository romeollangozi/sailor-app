//
//  DiningDayPicker.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 1/28/24.
//

import SwiftUI

struct DayPickerV2: View {
    struct Day: Identifiable, Hashable {
        var id: UUID
        var dayLetter: String
        var dayNumber: String
        var isSelected: Bool
        var isEnabled: Bool

        init(id: UUID = UUID(), dayLetter: String, dayNumber: String, isSelected: Bool, isEnabled: Bool = true) {
            self.id = id
            self.dayLetter = dayLetter
            self.dayNumber = dayNumber
            self.isSelected = isSelected
            self.isEnabled = isEnabled
        }
    }

    @Environment(\.contentSpacing) var spacing
    @Binding var selectedDay: Day?
    
    let days: [Day]

    init(selectedDay: Binding<Day?>, days: [Day]) {
        self._selectedDay = selectedDay
        self.days = days
    }

    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 24.0) {
                        ForEach(days) { day in
                            Button {
                                selectedDay = day
                                withAnimation {
                                    proxy.scrollTo(day.id, anchor: .center)
                                }
                            } label: {
                                VStack {
                                    Text(day.dayLetter)
                                        .tint(.secondary)
                                        .fontStyle(.boldTagline)

                                    Text(day.dayNumber)
                                        .fontStyle(.body)
                                        .tint(.primary)
                                        .padding(10)
                                        .frame(width: 40, height: 40)
                                        .overlay {
                                            Circle()
                                                .stroke(style: .init(lineWidth: 2))
                                                .tint(day.isSelected ? Color("Tropical Blue") : Color(uiColor: .systemGray4))
                                                .padding(2)
                                        }
                                }
                            }
                            .disabled(!day.isEnabled)
                            .opacity(day.isEnabled ? 1.0 : 0.4)
                            .id(day.id)
                        }
                    }
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                }
                .mask(
                    LinearGradient(
                        gradient: Gradient(stops: [
                            .init(color: Color.black.opacity(0), location: 0),
                            .init(color: Color.black.opacity(1), location: 0.05),
                            .init(color: Color.black.opacity(1), location: 0.95),
                            .init(color: Color.black.opacity(0), location: 1)
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .onAppear {
                    if !days.isEmpty, let selected = days.first(where: { $0.isSelected }) {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            withAnimation {
                                proxy.scrollTo(selected.id, anchor: .center)
                            }
                        }
                    }
                }
                .onChange(of: days) { oldDays, newDays in
                    if !newDays.isEmpty, let selected = newDays.first(where: { $0.isSelected }) {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            withAnimation {
                                proxy.scrollTo(selected.id, anchor: .center)
                            }
                        }
                    }
                }
            }
        }
        .frame(minHeight: 30.0, maxHeight: 100.0)
    }
}

struct DayPicker: View {
    @Environment(\.contentSpacing) var spacing
    @Binding var selectedDay: Date?
    var days: [Date]
    var body: some View {
        HFlowStack(alignment: .leading, horizontalSpacing: spacing, verticalSpacing: spacing) {
            ForEach(days, id: \.self) { day in
                if let letter = day.format(.dayLetter).first {
                    Button {
                        selectedDay = day
                    } label: {
                        VStack {
                            Text(String(letter))
                                .tint(.secondary)
                                .fontStyle(.caption)
                            
                            Text(day.format(.dayNumber))
                                .fontStyle(.body)
                                .tint(.primary)
                                .padding(10)
                                .frame(width: 40, height: 40)
                                .overlay {
                                    Circle()
                                        .stroke(style: .init(lineWidth: 2))
                                        .tint(day == selectedDay ? Color("Tropical Blue") : Color(uiColor: .systemGray4))
                                }
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 48)
    }
}

#Preview {
    let days: [DayPickerV2.Day] =  [
        .init(dayLetter: "Mon", dayNumber: "1", isSelected: false, isEnabled: false),
        .init(dayLetter: "Tue", dayNumber: "2", isSelected: false, isEnabled: false),
        .init(dayLetter: "Wed", dayNumber: "3", isSelected: false, isEnabled: false),
        .init(dayLetter: "Thu", dayNumber: "4", isSelected: false, isEnabled: false),
        .init(dayLetter: "Fri", dayNumber: "5", isSelected: false, isEnabled: true),
        .init(dayLetter: "Sat", dayNumber: "6", isSelected: true, isEnabled: true),
        .init(dayLetter: "Sun", dayNumber: "7", isSelected: false, isEnabled: true),
        .init(dayLetter: "Mon", dayNumber: "8", isSelected: false, isEnabled: true)
    ]
    
    VStack {
        DayPickerV2(
            selectedDay: .constant(days[7]),
            days:days
        )
        .environment(\.contentSpacing, 20)
    }
}

#Preview {
    @Previewable @State var day: Date? = .now
    var days: [Date] = []
    for i in 1...13 {
        if let day = Calendar.current.date(byAdding: .day, value: i - 2, to: .now) {
            days += [day]
        }
    }
    
    return DayPicker(selectedDay: $day, days: days)
}
