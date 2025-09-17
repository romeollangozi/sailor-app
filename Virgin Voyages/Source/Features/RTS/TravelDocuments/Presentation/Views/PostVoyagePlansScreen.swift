//
//  PostVoyagePlansScreen.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 25.3.25.
//

import SwiftUI
import VVUIKit

protocol PostVoyagePlansScreenViewModelProtocol {
    var screenState: ScreenState { get set }
    var inputPostVoyagePlans: PostVoyagePlansInput { get set }
    var lookupOptions: [String: [Option]] { get }

    var title: String { get }
    var description: String { get }
    var isStayingIn: Bool { get }
    var voyagePlanLabel: String { get }
    var voyagePlanOptions: [Option] { get }

    var stayTypeLabel: String { get }

    var transportationLabel: String { get }
    var transportationOptions: [Option] { get }

    var shouldShowHotelNameField: Bool { get }
    var shouldShowFlightFields: Bool { get }
    
    var isInputValid: Bool { get }
    
    var shouldValidate: Bool { get }
    
    var usStatesOptions: [Option] { get }
    
    func onAppear() async
    func onRefresh() async
    func save() async
    func navigateBack()
}

struct PostVoyagePlansScreen: View {
    @State var viewModel: PostVoyagePlansScreenViewModelProtocol
    @StateObject private var keyboard = KeyboardResponder()

    init(viewModel: PostVoyageViewModel = PostVoyageViewModel()) {
        _viewModel = State(wrappedValue: viewModel)
    }

    var body: some View {
        DefaultScreenView(state: $viewModel.screenState) {
            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.space24) {
                    toolbar
                        .padding(.top, Spacing.space48)
                    header
                    if viewModel.isStayingIn {
                        addressInfoFields()
                    } else {
                        airlineInfoFields()
                    }
                    Spacer(minLength: Spacing.space24)
                    Button("Save") {
                        Task {
                            print(viewModel.inputPostVoyagePlans)
                            await viewModel.save()
                        }
                    }
                    .primaryButtonStyle(isDisabled: (!viewModel.isInputValid && viewModel.shouldValidate))
                }
                .padding(.horizontal, Spacing.space24)
            }
            .padding(.bottom, (keyboard.keyboardHeight))
            .animation(.easeOut(duration: 0.25), value: keyboard.keyboardHeight)
            .ignoresSafeArea()
            
        } onRefresh: {
            Task {
                await viewModel.onRefresh()
            }
        }
        .onAppear {
            Task {
                await viewModel.onAppear()
            }
        }
    }

    private var toolbar: some View {
        HStack {
            BackButton {
                viewModel.navigateBack()
            }
            .opacity(0.8)
            Spacer()
        }
    }
    
    private var header: some View {
        VStack(alignment: .leading, spacing: Spacing.space24) {
            Text(viewModel.title)
                .font(.vvHeading1Bold)
                .padding(.top, Spacing.space16)
            Text(viewModel.description)
                .font(.vvHeading5Light)
                .multilineTextAlignment(.leading)
            
            VVRadioGroup(
                label: viewModel.voyagePlanLabel,
                options: viewModel.voyagePlanOptions.map { .init(value: $0.key, label: $0.value) },
                selected: Binding(
                    get: {
                        viewModel.inputPostVoyagePlans.isStayingIn ? "true" : "false"
                    },
                    set: { newValue in
                        viewModel.inputPostVoyagePlans.isStayingIn = (newValue == "true")
                    }
                ),
                errorMessage: "Please select an option",
                required: viewModel.shouldValidate
            )
        }
        
    }

    private func addressInfoFields() -> some View {
        VStack(alignment: .leading, spacing: Spacing.space16) {
            VVRadioGroup(
                label: viewModel.stayTypeLabel,
                options: StayTypeCode.allCases.map {
                    .init(value: $0.rawValue, label: $0.label)
                },
                selected: $viewModel.inputPostVoyagePlans.stayTypeCode,
                errorMessage: "Please select an option",
                required: viewModel.shouldValidate
            )
            
            if viewModel.shouldShowHotelNameField{
                VVTextField(
                    label: "Hotel name (if applicable)",
                    value: Binding(get: {
                        viewModel.inputPostVoyagePlans.addressInfo?.hotelName ?? ""
                    }, set: {
                        viewModel.inputPostVoyagePlans.addressInfo?.hotelName = $0
                    })
                )
            }
            VVTextField(
                label: "Street",
                value: Binding(get: {
                    viewModel.inputPostVoyagePlans.addressInfo?.line1 ?? ""
                }, set: {
                    viewModel.inputPostVoyagePlans.addressInfo?.line1 = $0
                }),
                errorMessage: "Enter a street",
                required: viewModel.shouldValidate
            )
            VVTextField(
                label: "Number",
                value: Binding(get: {
                    viewModel.inputPostVoyagePlans.addressInfo?.line2 ?? ""
                }, set: {
                    viewModel.inputPostVoyagePlans.addressInfo?.line2 = $0
                }),
                errorMessage: "Enter a number",
                required: viewModel.shouldValidate
            )
            
            VVTextField(
                label: "City",
                value: Binding(get: {
                    viewModel.inputPostVoyagePlans.addressInfo?.city ?? ""
                }, set: {
                    viewModel.inputPostVoyagePlans.addressInfo?.city = $0
                }),
                errorMessage: "Enter a city",
                required: viewModel.shouldValidate
            )
            
            VVPickerField(
                label: "State",
                options: viewModel.usStatesOptions,
                selected: Binding<String?>(
                    get: {
                        return "\(viewModel.inputPostVoyagePlans.addressInfo?.stateCode ?? "")|\(viewModel.inputPostVoyagePlans.addressInfo?.countryCode ?? "")"
                    },
                    set: { newValue in
                        guard let value = newValue,
                              let parsed = StateKeyParser.parse(from: value) else {
                            viewModel.inputPostVoyagePlans.addressInfo?.stateCode = ""
                            viewModel.inputPostVoyagePlans.addressInfo?.countryCode = ""
                            return
                        }
                        viewModel.inputPostVoyagePlans.addressInfo?.stateCode = parsed.code
                        viewModel.inputPostVoyagePlans.addressInfo?.countryCode = parsed.countryCode
                    }
                ),
                errorMessage: "Select a state",
                required: viewModel.shouldValidate
            )
            
            VVTextField(
                label: "Zip",
                value: Binding(get: {
                    viewModel.inputPostVoyagePlans.addressInfo?.zipCode ?? ""
                }, set: {
                    viewModel.inputPostVoyagePlans.addressInfo?.zipCode = $0
                }),
                errorMessage: "Enter a ZIP code",
                required: viewModel.shouldValidate
            )
        }
    }
    
    private func airlineInfoFields() -> some View {
        VStack(alignment: .leading, spacing: Spacing.space16) {
            VVRadioGroup(
                label: viewModel.transportationLabel,
                options: TransportationTypeCode.allCases.map {
                    .init(value: $0.rawValue, label: $0.label)
                },
                selected: $viewModel.inputPostVoyagePlans.transportationTypeCode,
                  errorMessage: "Select an option",
                  required: viewModel.shouldValidate
            )
            
            if viewModel.shouldShowFlightFields{
                
                VVPickerField(label: "Airport", options: viewModel.lookupOptions["airports"] ?? [], selected: Binding<String?>(
                    get: { viewModel.inputPostVoyagePlans.flightDetails?.departureAirportCode },
                    set: { viewModel.inputPostVoyagePlans.flightDetails?.departureAirportCode = $0 ?? ""}
                ),
                  errorMessage: "Select an airport",
                  required: viewModel.shouldValidate
                )
                
                VVPickerField(label: "Carrier", options: viewModel.lookupOptions["airlines"] ?? [], selected: Binding<String?>(
                    get: { viewModel.inputPostVoyagePlans.flightDetails?.airlineCode ?? "" },
                    set: { viewModel.inputPostVoyagePlans.flightDetails?.airlineCode = $0 ?? ""}
                ),
                  errorMessage: "Select a carrier",
                  required: viewModel.shouldValidate
                )
               
                VVTextField(
                    label: "Flight Number",
                    value: Binding(get: {
                        viewModel.inputPostVoyagePlans.flightDetails?.number ?? ""
                    }, set: {
                        viewModel.inputPostVoyagePlans.flightDetails?.number = $0
                    }),
                    errorMessage: "Enter a flight number",
                    required: viewModel.shouldValidate
                )
            }
        }
    }
}

struct PostVoyagePlansScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            PostVoyagePlansScreen(viewModel: PostVoyageViewModel())
        }
    }
}

