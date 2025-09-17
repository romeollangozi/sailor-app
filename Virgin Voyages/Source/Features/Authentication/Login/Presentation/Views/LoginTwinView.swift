//
//  LoginTwinView.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 7.8.25.
//

import SwiftUI
import VVUIKit

protocol LoginTwinViewViewModelProtocol {
    var guestDetails: [LoginGuestDetails] { get }
    var selectedGuest: LoginGuestDetails? { get set }
    var isNextButtonDisabled: Bool { get }
    var userInterfaceDisabled: Bool { get }
    
    func cancel()
    func login()
    func onAppear()
    func navigateBack()
}

extension LoginTwinView {
    static func create(guestDetails: [LoginGuestDetails], sailDate: Date? = nil, cabinNumber:String? = nil) -> LoginTwinView {
        let viewModel = LoginTwinViewModel(guestDetails: guestDetails, sailDate: sailDate, cabinNumber: cabinNumber)
        return LoginTwinView(viewModel: viewModel)
    }
}

struct LoginTwinView: View {

    @State private var viewModel: LoginTwinViewViewModelProtocol

    init(viewModel: LoginTwinViewViewModelProtocol) {
        _viewModel = .init(wrappedValue: viewModel)
    }

    var body: some View {
        toolbar
        VStack(spacing: Paddings.defaultVerticalPadding24) {
            header
            sailorSelectionForm
            callToActionButtons
            Spacer()
        }
        .padding(.horizontal, Paddings.defaultVerticalPadding24)
        .disabled(viewModel.userInterfaceDisabled)
        .interactiveDismissDisabled(viewModel.userInterfaceDisabled)
        .onAppear {
            viewModel.onAppear()
        }
    }

    private var toolbar: some View {
        Toolbar(buttonStyle: .backButton) {
            viewModel.navigateBack()
        }
    }
    
    private var header: some View {
        VStack(spacing: Paddings.defaultPadding8) {
            VectorImage(name: "Anchor")
                .frame(width: Paddings.defaultVerticalPadding48, height: Paddings.defaultVerticalPadding48)
                .foregroundStyle(.white)
                .padding(.vertical, Paddings.defaultPadding8)
            
            Text("Hey stranger")
                .font(.vvHeading1Bold)
                .foregroundColor(Color.blackText)
                .multilineTextAlignment(.center)

            Text("Well that’s awkward! We can’t uniquely identify you from the information we asked for. Please select yourself from the list below.")
                .font(.vvHeading5)
                .foregroundColor(Color.slateGray)
                .multilineTextAlignment(.center)
        }
        .padding(.bottom, Paddings.defaultPadding8)
    }

    private var sailorSelectionForm: some View {
        VStack(alignment: .leading, spacing: Paddings.defaultPadding8) {
            VStack(alignment: .leading, spacing: Paddings.defaultVerticalPadding24) {
                ForEach(Array(viewModel.guestDetails.enumerated()), id: \.offset) { index, guestDetails in
                    HStack(spacing: .zero) {
                        RadioButton(text: guestDetails.name.capitalized,
                                    selected: $viewModel.selectedGuest,
                                    mode: guestDetails)
                        Spacer()
                    }
                }
            }
            if viewModel.selectedGuest == nil {
                Text("Please select yourself from the list above before continuing")
                    .font(.vvSmall)
                    .foregroundColor(Color.orangeDark)
            }
        }
    }

    private var callToActionButtons: some View {
        VStack(alignment: .center, spacing: Paddings.defaultVerticalPadding16) {
            Button("Next") {
                viewModel.login()
            }
            .buttonStyle(PrimaryButtonStyle())
            .disabled(viewModel.isNextButtonDisabled)

            Button("Cancel") {
                viewModel.cancel()
            }
            .buttonStyle(TertiaryButtonStyle())
        }.padding(.top, Paddings.defaultVerticalPadding24)
    }
}

#Preview {
    LoginTwinView(viewModel: LoginTwinViewPreviewViewModel())
}

struct LoginTwinViewPreviewViewModel: LoginTwinViewViewModelProtocol {
    
    var guestDetails: [LoginGuestDetails] = [LoginGuestDetails.sample(), LoginGuestDetails.sample()]
    var selectedGuest: LoginGuestDetails? = nil
    var isNextButtonDisabled: Bool = true
    var userInterfaceDisabled: Bool = false
    
    func cancel() {}
    func login() {}
    func onAppear() {}
    func navigateBack() {}
}

