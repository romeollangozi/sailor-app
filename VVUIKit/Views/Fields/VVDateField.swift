//
//  VVDateField.swift
//  VVUIKit
//
//  Created by Enxhi Kondakciu on 5.3.25.
//

import SwiftUI

public struct VVDateField: View {
    let label: String
    @Binding var date: Date?
    let errorMessage: String?
    let readonly: Bool
    let required: Bool
    let isSecure: Bool
    let maskedValue: String?
    let hasError: Bool

    @State private var selectedMonth: Int?
    @State private var day: String?
    @State private var year: String?
    
    let months = Calendar.current.shortMonthSymbols
    
    var showError: Bool {
        return ((date == nil && required) || hasError)
    }

    public init(
        label: String = "",
        date: Binding<Date?> = .constant(nil),
        errorMessage: String? = nil,
        readonly: Bool = false,
        required: Bool = false,
        isSecure: Bool = false,
        maskedValue: String? = nil,
        hasError: Bool = false
    ) {
        self.label = label
        self._date = date
        self.errorMessage = errorMessage
        self.readonly = readonly
        self.required = required
        self.isSecure = isSecure
        self.maskedValue = maskedValue
        self.hasError = hasError
        
        let calendar = Calendar.current
        if let unwrappedDate = date.wrappedValue {
            let components = calendar.dateComponents([.month, .day, .year], from: unwrappedDate)
            _selectedMonth = State(initialValue: components.month)
            _day = State(initialValue: components.day.map { "\($0)" })
            _year = State(initialValue: components.year.map { "\($0)" })
        } else {
            _selectedMonth = State(initialValue: nil)
            _day = State(initialValue: nil)
            _year = State(initialValue: nil)
        }
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: Spacing.space4) {
            Text(label)
                .font(.vvBodyMedium)
                .padding(.bottom, Spacing.space8)
            HStack(spacing: Spacing.space16) {
                ZStack{
                    VVTextField(
                        label: "Month",
                        value: Binding(
                            get: { selectedMonth == nil ? "" : "\(months[selectedMonth! - 1])" },
                            set: {_ in }
                        ),
                        errorMessage: nil,
                        readonly: readonly,
                        required: required,
                        isSecure: isSecure,
                        hasError: hasError
                    )
                    .frame(height: 56)
                    .disabled(true)
                    
                    if !readonly{
                        HStack {
                            Spacer()
                            Image(systemName: "chevron.down")
                                .foregroundColor(.darkGray)
                                .padding(.trailing, Spacing.space16)
                        }
                        .frame(height: 56)
                        
                        Picker("Month", selection: Binding(
                            get: { selectedMonth ?? 0 },
                            set: { selectedMonth = $0; updateDate() }
                        )) {
                            ForEach(1...12, id: \.self) { index in
                                Text(months[index - 1]).tag(index)
                                    .foregroundColor(.primary)
                            }
                        }
                        .frame(width: 103, height: 56)
                        .accentColor(Color.clear)
                        .cornerRadius(4)
                        .pickerStyle(.menu)
                        .disabled(readonly)
                    }
                    
                }
                
                VVTextField(
                    label: "Day",
                    value: Binding(
                        get: { day ?? "" },
                        set: { newValue in
                            if isValidDay(newValue) { day = newValue; updateDate() }
                        }
                    ),
                    errorMessage: nil,
                    readonly: readonly,
                    required: required,
                    isSecure: isSecure,
                    hasError: hasError,
                    keyboardType: .numberPad
                )
                .frame(height: 56)
                
                VVTextField(
                    label: "Year",
                    value: Binding(
                        get: { year ?? "" },
                        set: { newValue in
                            if isValidYear(newValue) { year = newValue; updateDate() }
                        }
                    ),
                    errorMessage: nil,
                    readonly: readonly,
                    required: required,
                    isSecure: isSecure,
                    hasError: hasError,
                    maskedValue: maskedValue,
                    keyboardType: .numberPad
                )
                .frame(height: 56)
            }
            .background(Color.white)
            
            if let error = errorMessage, showError {
                Text(error)
                    .font(.vvSmall)
                    .foregroundColor(Color.lightError)
                    .padding(.leading, Spacing.space4)
                    .padding(.top, Spacing.space8)
                    .multilineTextAlignment(.leading)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
    
    private func updateDate() {
        var components = DateComponents()
        if let selectedMonth = selectedMonth, let day = day, let year = year {
            components.month = selectedMonth
            components.day = Int(day)
            components.year = Int(year)
            
            if let newDate = Calendar.current.date(from: components) {
                date = newDate
            } else {
                date = nil
            }
        }else {
            date = nil
        }
        
    }
    
    private func isDateEmpty() -> Bool {
        return selectedMonth == nil || day == nil || year == nil || day?.isEmpty == true || year?.isEmpty == true
    }
    
    private func isValidDay(_ text: String) -> Bool {
        if let day = Int(text), day >= 1, day <= 31 { return true }
        return text.isEmpty
    }
    
    private func isValidYear(_ text: String) -> Bool {
        if let year = Int(text), year >= 1, year <= 2100 { return true }
        return text.isEmpty
    }
}

struct TestFloatingDateTextField: View {
    @State private var date: Date? = nil
    
    var body: some View {
        VStack {
            VVDateField(
                label: "Date of birth",
                date: $date,
                errorMessage: nil
            )
            .padding()
            
            Text("Selected Date: \(date?.formatted(date: .long, time: .omitted) ?? "No Date Selected")")
                .font(.headline)
                .padding(.top, 10)
        }
    }
}

struct FloatingDateTextField_Previews: PreviewProvider {
    static var previews: some View {
        TestFloatingDateTextField()
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
