//
//  ContactConfirmationView.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 1.11.24.
//

import SwiftUI
import VVUIKit

extension ContactConfirmationView {
    static func create(viewModel: ContactConfirmationViewModelProtocol, shouldHideToolbar: Bool = false, toolbarButtonStyle: ToolbarButtonStyle = .closeButton, back: @escaping () -> Void, closeScanner: @escaping () -> Void, onAllowAttendingChange: @escaping (Bool) -> Void, onContactDeleted: @escaping VoidCallback) -> ContactConfirmationView {
        
        return ContactConfirmationView(viewModel: viewModel, shouldHideToolbar: shouldHideToolbar, toolbarButtonStyle: toolbarButtonStyle, back: back, closeScanner: closeScanner, onAllowAttendingChange: onAllowAttendingChange, onContactDeleted: onContactDeleted)
    }
}

struct ContactConfirmationView: View {
    
    // MARK: - ViewModel
    @State private var viewModel: ContactConfirmationViewModelProtocol

    // MARK: - Navigation handlers
    let back: (() -> Void)
    let closeScanner: (() -> Void)
    let onAllowAttendingChange: ((Bool) -> Void)
    let onContactDeleted: VoidCallback

    // MARK: - Var
    var shouldHideToolbar: Bool
    let toolbarButtonStyle: ToolbarButtonStyle

    // MARK: - Init
    init(viewModel: ContactConfirmationViewModelProtocol = ContactConfirmationViewModel(),
         shouldHideToolbar: Bool = false,
         toolbarButtonStyle: ToolbarButtonStyle,
         back: @escaping () -> Void,
         closeScanner: @escaping () -> Void,
         onAllowAttendingChange: @escaping (Bool) -> Void,
         onContactDeleted: @escaping VoidCallback ) {
        
        _viewModel = State(wrappedValue: viewModel)
        self.back = back
        self.closeScanner = closeScanner
        self.onAllowAttendingChange = onAllowAttendingChange
        self.onContactDeleted = onContactDeleted
        self.shouldHideToolbar = shouldHideToolbar
        self.toolbarButtonStyle = toolbarButtonStyle
    }
    
    var body: some View {
        ZStack {
            VStack {
                if !shouldHideToolbar {
                    toolbar()
                        .padding(.bottom)
                } else {
                    Spacer().frame(height: Paddings.defaultVerticalPadding48)
                }
                
				profileImage()

                contactNameView()
                
                Divider()
                    .padding(.horizontal, Paddings.defaultVerticalPadding24)
                    .padding(.vertical, Paddings.defaultVerticalPadding16)
                
                allowAttendingView()
                
                doneButton()
                
                if viewModel.isSailorMate {
                    deleteSailorMateButton()
                }
                
                Spacer()
                
            }
            .onAppear {
                viewModel.onAppear()
            }
            .frame(alignment: .leading)
            
            if viewModel.showRemoveContactConfirmation {
                ConfirmationPopupAlert(
                    title: "Delete Contact?",
                    message: "Are you sure you want to delete this contact? You won’t be able to book activities with them.",
                    confirmButtonText: "Yes, delete contact",
                    cancelButtonText: "Cancel",
                    isLoading: $viewModel.isLoadingRemoveContact,
                    onConfirm: {
                        viewModel.executeRemoveContact(onFinished: onContactDeleted)
                    },
                    onCancel: { viewModel.showRemoveContactConfirmation = false }
                )
            }
        }
    }
    
    // MARK: - View builders
    private func toolbar() -> some View {
        Toolbar(buttonStyle: toolbarButtonStyle) {
            back()
        }
    }

	private func profileImage() -> some View {
		AuthURLImageView(imageUrl: viewModel.sailorProfileImage,
						 size: Sizes.defaultSize150,
						 clipShape: .circle,
						 defaultImage: "ProfilePlaceholder")
	}

    private func contactNameView() -> some View {
        VStack {
            Text(viewModel.confirmationContactModel.name)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.horizontal)
                .fontStyle(.title)
            if !viewModel.confirmationContactModel.name.isEmpty {
                Text(viewModel.confirmationContactModel.connectedSailorText)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .fontStyle(.lightBody)
                    .foregroundStyle(Color.lightGreyColor)
                    .padding(.bottom)
            }
        }
    }
    
    private func allowAttendingView() -> some View {
        HStack {
            Text(viewModel.confirmationContactModel.allowAttendingText)
                .fontStyle(.body)
            Spacer()
            VVToggle(isOn: $viewModel.allowAttending) { state in
                Task{
                    await viewModel.addContactPreferences()
                    onAllowAttendingChange(viewModel.allowAttending)
                }
            }
        }
        .padding(.horizontal, Paddings.defaultVerticalPadding24)
        .padding(.vertical, Paddings.defaultVerticalPadding16)
        
    }
    
    private func doneButton() -> some View {
        Button(viewModel.confirmationContactModel.doneText) {
            Task {
                closeScanner()
            }
        }
        .buttonStyle(AdaptiveButtonStyle())
        .padding(.vertical)
        .padding(.horizontal, Paddings.defaultHorizontalPadding)
    }
    
    private func deleteSailorMateButton() -> some View {
        LinkButton(viewModel.confirmationContactModel.deleteSailorMateButtonText, font: .vvBody, action: {
            Task {
                viewModel.onRemoveContactButtonTapped()
            }
        })
    }
}

#Preview {
    ContactConfirmationView.create(viewModel: ContactConfirmationViewModel()) {
        
    } closeScanner: {} onAllowAttendingChange: {_ in} onContactDeleted: {}
}
