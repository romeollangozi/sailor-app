//
//  SocialProfileView.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 4.9.24.
//

import SwiftUI
import VVUIKit

extension SocialProfileView {
    static func create(viewModel: SocialProfileViewModelProtocol, isSocialSignup: Bool = false) -> SocialProfileView {
        return SocialProfileView(viewModel: viewModel, isSocialSignup: isSocialSignup)
    }
}

struct SocialProfileView: View {
    
    // MARK: - State properties
    @State private var viewModel: SocialProfileViewModelProtocol
    @State private var showCamera = false
    @State var isSocialSignup = false

    // MARK: - Init
    init(viewModel: SocialProfileViewModelProtocol, isSocialSignup: Bool = false) {
        _viewModel = State(wrappedValue: viewModel)
        _isSocialSignup = State(wrappedValue: isSocialSignup)
    }
    
    var body: some View {
        toolbar()
        ZStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    AnchorView()
                    Text("Confirm your deets")
                        .fontStyle(.largeTitle)
                        .multilineTextAlignment(.center)
                    
                    Text("Check, edit, and/or complete your details and we are good to go")
                        .fontStyle(.largeTagline)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.gray)
                    
                    ProfileImageView(placeholderImage: viewModel.profileImage, showCameraButton: true, cameraAction: { self.showCamera = true })
                        .padding(.bottom, Paddings.defaultVerticalPadding64)
                        .padding(.top,  Paddings.defaultVerticalPadding48)
                    
                    VStack(spacing: 0) {
                        GroupInputField(placeholder: "First name", type: .top, text: $viewModel.signUpInputModel.firstName)
                        GroupInputField(placeholder: "Last name", type: .bottom, text: $viewModel.signUpInputModel.lastName)
                        Text("Your name has to exactly match what is on your passport.")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(.lightGreyColor)
                            .fontStyle(.lightLink)
                            .padding(.top, Paddings.defaultVerticalPadding)
                        GroupInputField(placeholder: "Preferred name", optionalText: "optional" ,text: $viewModel.signUpInputModel.preferredName)
                            .padding(.top, Paddings.defaultVerticalPadding16)
                            .padding(.bottom, Paddings.defaultVerticalPadding)
                        Text("Let us know if you have a name you’d prefer to be called day-to-day")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(.lightGreyColor)
                            .fontStyle(.lightLink)
                        
                        DatePickerView(headerText: "Date of Birth",
                                       selectedDateComponents: $viewModel.signUpInputModel.dateOfBirth,
                                       error: viewModel.dateOfBirthError)
                        .padding(.top, Paddings.defaultVerticalPadding16)
                        .padding(.bottom, Paddings.defaultVerticalPadding16)
                        
                        if (viewModel.showClarification) {
                            errorMessage(message: viewModel.clarification)
                                .padding(.bottom, Paddings.defaultVerticalPadding16)
                        }
                        
                        EmailInputField(placeholder: "name@domain.com", text: $viewModel.signUpInputModel.email, error: viewModel.emailError)
                            .padding(.bottom, Paddings.defaultVerticalPadding16)
                        
                        Text("Virgin Voyages News")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .fontStyle(.headline)
                            .foregroundColor(.lightGreyColor)
                            .padding(.vertical, Paddings.defaultVerticalPadding16)
                        
                        Text("Fun, ship puns and exclusive travel news are all yours with a simple check of the box. (Our privacy policy means your details stay safe.)")
                            .multilineTextStyle(.lightBody, alignment: .leading)
                            .foregroundColor(.lightGreyColor)
                        
                        CheckboxView(isChecked: $viewModel.signUpInputModel.receiveEmails, text: "Yes please I want to receive lovely email updates from Virgin Voyages")
                            .padding(.vertical, Paddings.defaultVerticalPadding16)
                        
                        VStack(spacing: Paddings.defaultVerticalPadding16) {
                            nextButton()
                            cancelButton()
                        }
                        .padding(.vertical, (Paddings.defaultVerticalPadding24))
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, Paddings.defaultHorizontalPadding)
            }
            .frame(maxWidth: .infinity)
            .fullScreenCover(isPresented: $showCamera) {
                CameraView(compressionQuality: 0.5, task: viewModel.cameraTask) { data in
                    viewModel.signUpInputModel.imageData = data
                } overlay: {
                    CameraSelfieOverlayView()
                }
            }
        }
    }
    
    // MARK: - Methods
    private func toolbar() -> some View {
        Toolbar(buttonStyle: .backButton) {
            viewModel.navigateBack()
        }
    }
    
    private func nextButton() -> some View {
        LoadingButton(title: "Next", loading: viewModel.isLoading) {
            viewModel.signUp()
        }
        .buttonStyle(PrimaryButtonStyle())
        .disabled(viewModel.nextButtonDisabled || viewModel.isLoading)
    }
    
    private func cancelButton() -> some View {
        Button("Cancel") {
            viewModel.navigateBackToRoot()
        }
        .buttonStyle(TertiaryButtonStyle())
    }
    
    private func errorMessage(message: String) -> some View {
        Text(message)
            .foregroundStyle(.orange)
            .fontStyle(.caption)
    }
}

//Preview
struct SocialProfileView_Previews: PreviewProvider {
    static var previews: some View {
        let model = SignUpInputModel(email: "trpevski@gmail.com", firstName: "Darko", lastName: "Trpevski", preferredName: "Richi", dateOfBirth: DateComponents(calendar: Calendar.current), password: "admin123", imageData: nil)
        let mockViewModel = SocialProfileViewModel(signUpInputModel: model)
        
        
        SocialProfileView(viewModel: mockViewModel)
    }
}
