//
//  FocusedInputField.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 2/2/24.
//

import SwiftUI
import VVUIKit

struct DatePickerView: View {
	var headerText: String
	@Binding var selectedDateComponents: DateComponents
	var error: String?

	var body: some View {
		VStack(spacing: 16.0) {
			HStack(spacing: 0) {
				Text(headerText)
                    .font(.vvBodyBold)
                    .foregroundColor(.darkGray)
				Spacer()
			}
			HStack(spacing: 16.0) {
				MonthView(selectedDateComponents: $selectedDateComponents,
						  error: error)

				DayView(selectedDateComponents: $selectedDateComponents,
						error: error)

				YearView(selectedDateComponents: $selectedDateComponents,
						 error: error)
			}
		}
	}
}

struct MonthView: View {
	let months: [String]

	@Binding var selectedDateComponents: DateComponents
	var error: String?

	init(selectedDateComponents: Binding<DateComponents>, error: String? = nil) {
		_selectedDateComponents = selectedDateComponents

		let calendar = Calendar.current
		self.months = [""] + calendar.monthSymbols

        self.error = error
    }
    
    var body: some View {
        Menu {
            ForEach(months, id: \.self) { month in
                Button(month) {
                    if let monthIndex = months.firstIndex(of: month) {
                        selectedDateComponents.month = monthIndex == 0 ? nil : monthIndex
                    }
                }
            }
        } label: {
            InputFieldPicker(placeholder: "Month",
                             error: error,
                             text: Binding(
                                 get: { months[selectedDateComponents.month.map { $0 } ?? 0] },
                                 set: { newMonth in
                                     if let monthIndex = months.firstIndex(of: newMonth) {
                                         selectedDateComponents.month = monthIndex
                                     }
                                 }
                             ),
                             presented: .constant(false))
        }
    }
}

struct DayView: View {
	@Binding var selectedDateComponents: DateComponents
	var placeholder = "Day"
	var error: String?
	private let characterLimit = 2
	@FocusState private var isFocused: Bool

	var body: some View {
		InputFieldContainer(placeholder: placeholder,
							error: error,
							text: Binding(
								get: {
									if let day = selectedDateComponents.day {
										return String(day)
									}
									return ""
								},
								set: { newValue in
									if let intValue = Int(newValue), newValue.count <= characterLimit {
										selectedDateComponents.day = intValue
									}
								}
							)) {
			TextField(placeholder, text: Binding(
								get: {
									if let day = selectedDateComponents.day {
										return String(day)
									}
									return ""
								},
								set: { newValue in
									if let intValue = Int(newValue), newValue.count <= characterLimit {
										selectedDateComponents.day = intValue
									}
								}
							))
                .font(.vvSmallBold)
                .foregroundColor(.slateGray)
				.keyboardType(.numberPad)
				.textContentType(.birthdateDay)
				.autocapitalization(.none)
				.autocorrectionDisabled(true)
				.accessibilityIdentifier("day")
				.focused($isFocused)
				.toolbar {
					if isFocused {
						ToolbarItemGroup(placement: .keyboard) {
							Spacer()
							Button("Done") {
								isFocused = false
							}
						}
					}
				}
		}
	}
}

struct YearView: View {
	@Binding var selectedDateComponents: DateComponents
	var placeholder = "Year"
	var error: String?
	private let characterLimit = 4
	@FocusState private var isFocused: Bool

	var body: some View {
		InputFieldContainer(placeholder: placeholder,
							error: error,
							text: Binding(
								get: {
									if let year = selectedDateComponents.year {
										return String(year)
									}
									return ""
								},
								set: { newValue in
									if let intValue = Int(newValue), newValue.count <= characterLimit {
										selectedDateComponents.year = intValue
									}
								}
							)) {
			TextField(placeholder, text: Binding(
								get: {
									if let year = selectedDateComponents.year {
										return String(year)
									}
									return ""
								},
								set: { newValue in
									if let intValue = Int(newValue), newValue.count <= characterLimit {
										selectedDateComponents.year = intValue
									}
								}
							))
                .font(.vvSmallBold)
                .foregroundColor(.slateGray)
				.keyboardType(.numberPad)
				.textContentType(.birthdateYear)
				.autocapitalization(.none)
				.autocorrectionDisabled(true)
				.accessibilityIdentifier("year")
				.focused($isFocused)
				.toolbar {
					if isFocused {
						ToolbarItemGroup(placement: .keyboard) {
							Spacer()
							Button("Done") {
								isFocused = false
							}
						}
					}
				}
		}
	}
}

// MARK: Containers
private struct InputFieldContainer<Content: View>: View {
	@Environment(\.isEnabled) var enabled
	var placeholder: String
	var error: String?
	@Binding var text: String
	@ViewBuilder var content: () -> Content

	var body: some View {
		VStack(alignment: .leading) {
			ZStack(alignment: .topLeading) {
				PlaceholderText(placeholder: placeholder, isVisible: text.isEmpty)

				content()
					.foregroundStyle(enabled ? .primary : .secondary)
					.padding(EdgeInsets(top: text.isEmpty ? 12 : 20, leading: 8, bottom: text.isEmpty ? 12 : 4, trailing: 8))
			}
			.background {
				InputFieldBackground(hasError: error != nil)
			}
			.overlay {
				InputFieldOverlay(hasError: error != nil)
			}
			.opacity(enabled ? 1 : 0.6)

			ErrorText(error: error)
		}
	}
}

private struct PlaceholderText: View {
	var placeholder: String
	var isVisible: Bool

	var body: some View {
		Text(placeholder)
			.fontStyle(.caption)
			.foregroundStyle(.secondary)
			.opacity(isVisible ? 0 : 1)
			.padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
	}
}

private struct InputFieldBackground: View {
	var hasError: Bool

	var body: some View {
		ZStack {
			RoundedRectangle(cornerRadius: 4)
				.fill(.white)

			if hasError {
				RoundedRectangle(cornerRadius: 4)
					.fill(Color(hex: "##FFFAF1"))
			}
		}
	}
}

private struct InputFieldOverlay: View {
	var hasError: Bool

	var body: some View {
		RoundedRectangle(cornerRadius: 4)
            .stroke(hasError ? Color.orangeDark : .gray, lineWidth: 1)
	}
}

private struct ErrorText: View {
	var error: String?

	var body: some View {
		if let error, error.count > 0 {
			Text(error)
				.fontStyle(.caption)
                .foregroundStyle(Color.orangeDark)
		}
	}
}

struct InputFieldPicker: View {
	var placeholder: String
	var error: String?
	@Binding var text: String
	@Binding var presented: Bool
	var body: some View {
		Button {
			presented.toggle()
		} label: {
			VStack(alignment: .leading) {
				ZStack(alignment: .trailing) {
					InputFieldContainer(placeholder: placeholder, error: error, text: $text) {
						TextField(placeholder, text: $text)
							.disabled(true)
							.multilineTextAlignment(.leading)
                            .font(.vvSmallBold)
                            .foregroundColor(.slateGray)
					}
					
					Image(systemName: "chevron.down")
						.padding(.trailing, 8)
				}
				
				if let error, error.count > 0 {
					Text(error)
						.fontStyle(.caption)
						.foregroundStyle(.orange)
				}
			}
		}
		.tint(.primary)
	}
}

private struct FormFieldContainer<Content: View>: View {
	@Environment(\.isEnabled) var enabled
	var placeholder: String
	var error: String?
	@Binding var text: String
	@ViewBuilder var content: () -> Content
	var body: some View {
		VStack(alignment: .leading) {
			ZStack(alignment: .topLeading) {
				Text(placeholder)
					.fontStyle(.caption)
					.foregroundStyle(.secondary)
					.opacity(text == "" ? 0 : 1)
					.padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
				
				content()
					.foregroundStyle(enabled ? .primary : .secondary)
					.padding(EdgeInsets(top: text == "" ? 12 : 20, leading: 8, bottom: text == "" ? 12 : 4, trailing: 8))
			}
			.background {
				RoundedRectangle(cornerRadius: 4)
					.fill(.white)
				
				if error != nil {
					RoundedRectangle(cornerRadius: 4)
						.fill(.orange)
						.opacity(0.1)
				}
			}
			.overlay {
				RoundedRectangle(cornerRadius: 4)
					.stroke(error == nil ? .gray : .orange, lineWidth: 1)
			}
			.opacity(enabled ? 1 : 0.6)
			
			if let error {
				Text(error)
					.fontStyle(.caption)
					.foregroundStyle(.orange)
			}
		}
	}
}

// MARK: Text Input

struct TextInputField: View {
	var placeholder = ""
	var error: String?
	@Binding var text: String
    var body: some View {
		InputFieldContainer(placeholder: placeholder, error: error, text: $text) {
            TextField(placeholder, text: $text)
        }
    }
}

struct NameInputField: View {
	var placeholder: String = "Name"
	@Binding var text: String
	var body: some View {
		InputFieldContainer(placeholder: placeholder, text: $text) {
			TextField(placeholder, text: $text)
				.textContentType(.name)
				.accessibilityIdentifier("name")
		}
	}
}

struct EmailInputField: View {
	var placeholder = "Email"
	@Binding var text: String
	var error: String?
	var body: some View {
		InputFieldContainer(placeholder: placeholder,
							error: error,
							text: $text) {
			TextField(placeholder, text: $text)
				.keyboardType(.emailAddress)
				.textContentType(.emailAddress)
				.autocapitalization(.none)
				.autocorrectionDisabled(true)
				.accessibilityIdentifier("email")
		}
	}
}

struct PhoneInputField: View {
	var placeholder: String
	@Binding var text: String
	var body: some View {
		InputFieldContainer(placeholder: placeholder, text: $text) {
			TextField(placeholder, text: $text)
				.keyboardType(.phonePad)
				.textContentType(.telephoneNumber)
				.accessibilityIdentifier("phoneNumber")
		}
	}
}

struct PasswordInputField: View {
	var placeholder = "Password"
	@Binding var text: String
	var error: String?
	var body: some View {
		InputFieldContainer(placeholder: placeholder,
							error: error,
							text: $text) {
			SecureField(placeholder, text: $text)
				.accessibilityIdentifier("password")
		}
	}
}

struct PasswordInputToggleField: View {
    var placeholder = "Password"
    @Binding var text: String
    @FocusState private var isFocused: Bool
    let focused: ((Bool) -> Void)
    var error: String?
    var body: some View {
        InputFieldContainer(placeholder: placeholder,
                            error: error,
                            text: $text) {
            SecureFieldToggle(password: $text, placeholder: placeholder)
                .accessibilityIdentifier("password")
                .focused($isFocused)
                .onChange(of: isFocused) {
                    self.focused(isFocused)
                }
        }
    }
}


struct SecureFieldToggle: View {
    @State private var isVisible = false
    @Binding var password: String
    var placeholder = "Password"
    
    var body: some View {
        ZStack {
            if isVisible {
                TextField(placeholder, text: $password)
            } else {
                SecureField(placeholder, text: $password)
            }
            if !password.isEmpty {
                HStack {
                    Spacer()
                    Button(action: {
                        self.isVisible.toggle()
                    }, label: {
                        Image("PasswordShown")
                    })
                    .padding(.trailing, 8)
                }
            }
        }
    }
}

// MARK: Picker Input

struct DialingCodeField: View {
	var placeholder: String
	@Binding var text: String
	var countries: [Endpoint.GetLookupData.Response.LookupData.Country]
	@State private var showSheet = false
	var body: some View {
		InputFieldPicker(placeholder: placeholder, text: $text, presented: $showSheet)
			.sheet(isPresented: $showSheet) {
				NavigationStack {
                    CountryCodePicker(viewModel: CountryCodePickerViewModel(countries: countries), mode: .dialingCode) { country in
                        if let dialingCode = country.dialingCode {
                            text = "+\(dialingCode)"
                        }
                        showSheet = false
					}
				}
			}
	}
}

struct CountryField: View {
	var placeholder: String
    var error: String?
    @Binding var text: String
    var countries: [Endpoint.GetLookupData.Response.LookupData.Country]
    @State private var showSheet = false
    @Environment(\.isEnabled) var enabled

	var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .topLeading) {
                InputFieldPicker(placeholder: placeholder, text: $text, presented: $showSheet)
                    .sheet(isPresented: $showSheet) {
                        NavigationStack {
                            CountryCodePicker(viewModel: CountryCodePickerViewModel(countries: countries), mode: .country) { country in
                                text = country.name
                                showSheet = false
                            }
                        }
                    }
            }
            .overlay {
                InputFieldOverlay(hasError: error != nil)
            }
            .opacity(enabled ? 1 : 0.6)
            
            ErrorText(error: error)
        }
	}
}

struct AirlineField: View {
	var placeholder: String
	@Binding var text: String
	var airlines: [Endpoint.GetLookupData.Response.LookupData.Airline]
	@State private var showSheet = false
	var body: some View {
		InputFieldPicker(placeholder: placeholder, text: $text, presented: $showSheet)
			.sheet(isPresented: $showSheet) {
				NavigationStack {
					AirlinePicker(airlines: airlines) { airline in
                        text = airline.name
						showSheet = false
					}
				}
			}
	}
}

struct VisaEntryField: View {
	var placeholder: String
	@Binding var text: String
	var visaEntries: [Endpoint.GetLookupData.Response.LookupData.VisaEntry]
	@State private var showSheet = false
	var body: some View {
		InputFieldPicker(placeholder: placeholder, text: $text, presented: $showSheet)
			.confirmationDialog("Visa Entry", isPresented: $showSheet, titleVisibility: .visible) {
				ForEach(visaEntries, id: \.code) { visaEntry in
					Button(visaEntry.name) {
						text = visaEntry.code
					}
				}
			}
	}
}

// MARK: Date

struct DateInputField: View {
	var placeholder = ""
	var displayedComponents: DatePickerComponents = .date
	var error: String?
	@Binding var date: Date
	@State private var text = ""
	var body: some View {
		FormFieldContainer(placeholder: placeholder, error: error, text: $text) {
			DatePicker(placeholder, selection: $date, displayedComponents: displayedComponents)
		}
	}
}

struct DatePickerField: View {
	var placeholder = ""
	var displayedComponents: DatePickerComponents = .date
	var error: String?
	var showToolbar: Bool = false
	var doneButtonText: String = "Done"
	var resetButtonText: String = "Reset"
	@Binding var date: Date?
	@State private var text = ""
	@State private var showSheet = false
	@State private var initialDate: Date?

	var body: some View {
		InputFieldPicker(placeholder: placeholder, text: $text, presented: $showSheet)
			.sheet(isPresented: $showSheet) {
				VStack(spacing: 0) {
					if showToolbar {
						HStack {
							Button(resetButtonText) {
								date = initialDate
							}
							.padding()

							Spacer()

							Button(doneButtonText) {
								showSheet = false
							}
							.padding()
						}
						.padding(.top, 30)
					}

					DatePicker(placeholder, selection: Binding(
						get: { date ?? Date() },
						set: { date = $0 }
					), displayedComponents: displayedComponents)
						.datePickerStyle(.wheel)
						.labelsHidden()
						.presentationDetents([.fraction(0.3)])
				}
			}
			.onChange(of: date) { _, newValue in
				if let newValue {
					text = newValue.format(.time).lowercased()
				}
			}
			.onAppear {
				initialDate = date

				if let date {
					text = date.format(.time).lowercased()
				}
			}
	}
}

struct GenderField: View {
    var placeholder: String
    var error: String?
    @Binding var text: String
    var genders: [Endpoint.GetLookupData.Response.LookupData.Gender]
    @State private var showSheet = false
    @Environment(\.isEnabled) var enabled

    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .topLeading) {
                InputFieldPicker(placeholder: placeholder, text: $text, presented: $showSheet)
                    .confirmationDialog("Gender", isPresented: $showSheet, titleVisibility: .visible) {
                        ForEach(genders, id: \.code) { gender in
                            Button(gender.name) {
                                text = gender.name
                            }
                        }
                    }
            }
        }
        .overlay {
            InputFieldOverlay(hasError: error != nil)
        }
        .opacity(enabled ? 1 : 0.6)

        ErrorText(error: error)

    }
}

#Preview {
	@State var name = "Chris DeSalvo"
	@State var phoneNumber = "123-456-7890"
	@State var date: Date = .now
    @State var dateComponents = DateComponents(calendar: Calendar.current)
	
	return VStack(spacing: 12) {
        DatePickerView(headerText: "Date of Birth", selectedDateComponents: $dateComponents)
        
		TextInputField(placeholder: "Placeholder", error: "Some error message", text: .constant(""))
		
		InputFieldPicker(placeholder: "Picker", text: .constant("Value"), presented: .constant(false))
		
		InputFieldPicker(placeholder: "Picker", text: .constant(""), presented: .constant(false))
		
		NameInputField(placeholder: "Name", text: $name)
			.disabled(true)
		
		EmailInputField(text: .constant(""))
		
		PasswordInputField(text: .constant(""))
        PasswordInputToggleField(text: .constant(""), focused: {state in })
		PhoneInputField(placeholder: "Phone Number", text: $phoneNumber)
		
		DateInputField(placeholder: "Date", error: "Date error", date: $date)

		DateInputField(placeholder: "Date", error: "Date error", date: $date)
//			.disabled(true)
		
		VisaEntryField(placeholder: "Visa Entry", text: .constant(""), visaEntries: [.init(code: "S", name: "Single"), .init(code: "M", name: "Multiple")])
	}
	.fontStyle(.body)
	.padding()
	.background(.secondary)
}
