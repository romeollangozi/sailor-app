//
//  BookingReferenceLoginView.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 8/22/24.
//

import SwiftUI
import VVUIKit

extension BookingReferenceLoginView {
    static func create() -> BookingReferenceLoginView {
        let viewModel = BookingReferenceLoginViewModel()
        return BookingReferenceLoginView(viewModel: viewModel)
    }
}

protocol BookingReferenceLoginViewModelProtocol: RecaptchaContainingViewModelProtocol {
    
    var isShipboard: Bool { get set }
    var lastName: String { get set }
    var cabinNumber: String { get set }
    var dateOfBirth: DateComponents { get set }
    var sailDate: DateComponents { get set }
    var bookingReferenceNumber: String { get set }
    var userAttemptAValueForBookingReference: Bool { get set }
    var shouldDisplayRecaptcha: Bool { get }
    var userInterfaceDisabled: Bool { get }
    var loginTitle: String { get }
    var dateOfBirthError: String? { get }
    var sailDateError: String? { get }
    var bookingReferenceFieldErrorText: String? { get }
    var showDateFieldErrorClarification: Bool { get }
    var dateFieldErrorClarification: String { get }
    var loginButtonDisabled: Bool { get }
    
    func loadBookingReferenceLoginView()
    func goBack()
    func login()
}

struct BookingReferenceLoginView: View {
    @State private var viewModel: BookingReferenceLoginViewModelProtocol
    @FocusState private var isBookingReferenceFieldFocused: Bool  // Focus state

    
    init(viewModel: BookingReferenceLoginViewModelProtocol) {
        _viewModel = State(wrappedValue: viewModel)
    }

	var body: some View {
		toolbar
        ScrollView {
            VStack(alignment: .center, spacing: 0.0) {
                header
                formView
                if viewModel.shouldDisplayRecaptcha {
                    reCaptcha
                }
                callToActionButtons
                Spacer()
            }
            .fontStyle(.body)
            .disabled(viewModel.userInterfaceDisabled)
            .interactiveDismissDisabled(viewModel.userInterfaceDisabled)
        }
        .onAppear {
            viewModel.loadBookingReferenceLoginView()
        }
	}
    
    private var toolbar: some View {
		Toolbar(buttonStyle: .backButton) {
            viewModel.goBack()
		}
	}
    
    private var header: some View {
        VStack(alignment: .center, spacing: 8.0) {
            VectorImage(name: "Anchor")
                .frame(width: 48, height: 48)
                .foregroundStyle(.white)

            Text("Ahoy there Sailor")
                .fontStyle(.largeTitle)
                .multilineTextAlignment(.center)

            Text(viewModel.loginTitle)
                .multilineTextAlignment(.center)
        }
        .padding(EdgeInsets(top: 0.0, leading: 24.0, bottom: 8.0, trailing: 24.0))
    }
    
    @ViewBuilder private var formView: some View {
        if viewModel.isShipboard {
            shipsideFormView
        } else {
            shoresideFormView
        }
    }
    
    private var shipsideFormView: some View {
        VStack(spacing: 16.0) {
            TextInputField(placeholder: "Last name", text: $viewModel.lastName)
                .textContentType(.familyName)
            TextInputField(placeholder: "Cabin number", text: $viewModel.cabinNumber)
            DatePickerView(headerText: "Date of Birth",
						   selectedDateComponents: $viewModel.dateOfBirth,
						   error: viewModel.dateOfBirthError)
            if (viewModel.showDateFieldErrorClarification) {
                errorMessage(message: viewModel.dateFieldErrorClarification)
                    .padding(.bottom, Paddings.defaultVerticalPadding16)
            }
            
        }
        .padding(EdgeInsets(top: 16.0, leading: 24.0, bottom: 16.0, trailing: 24.0))
    }
    
    private var shoresideFormView: some View {
        VStack(spacing: 16.0) {
            TextInputField(placeholder: "Last name", text: $viewModel.lastName)
                .textContentType(.familyName)
            
            TextInputField(placeholder: "Booking reference",
                           error: viewModel.bookingReferenceFieldErrorText,
                           text: $viewModel.bookingReferenceNumber)
            .focused($isBookingReferenceFieldFocused)
            
            DatePickerView(headerText: "Date of Birth",
						   selectedDateComponents: $viewModel.dateOfBirth,
						   error: viewModel.dateOfBirthError)
            if (viewModel.showDateFieldErrorClarification) {
                errorMessage(message: viewModel.dateFieldErrorClarification)
                    .padding(.bottom, Paddings.defaultVerticalPadding16)
            }
            
            DatePickerView(headerText: "Sail Date",
						   selectedDateComponents: $viewModel.sailDate,
						   error: viewModel.sailDateError)
        }
        .padding(EdgeInsets(top: 16.0, leading: 24.0, bottom: 16.0, trailing: 24.0))
        .onChange(of: isBookingReferenceFieldFocused, { oldValue, newValue in
            if !newValue {
                viewModel.userAttemptAValueForBookingReference = true
            }
        })
    }
    
    
    private var reCaptcha: some View {
        VStack (alignment: .center) {
            reCaptchaView()
                .padding(.horizontal, Paddings.defaultVerticalPadding24)
                .padding(.top, 8.0)
        }.frame(maxWidth: .infinity)
    }
    
    private func reCaptchaView() -> some View {
        ReCaptchaView(viewModel: ReCaptchaViewModel(action: ReCaptchaActions.loginWithReseservationNumber.key) ,confirmed: { status, token in
            viewModel.reCaptchaToken = token
            viewModel.reCaptchaIsChecked = status
        })
        .id(viewModel.reCaptchaRefreshID) // Triggers view refresh
    }

    
    private var callToActionButtons: some View {
        VStack(spacing: 16) {
            
            Button("Login", action: viewModel.login)
            .buttonStyle(PrimaryButtonStyle())
            .disabled(viewModel.loginButtonDisabled)
            
            Button("Cancel", action: viewModel.goBack)
            .buttonStyle(TertiaryButtonStyle())
        }.padding(24.0)
    }
    
    private func errorMessage(message: String) -> some View {
        Text(message)
            .foregroundStyle(.orange)
            .fontStyle(.caption)
    }
}
