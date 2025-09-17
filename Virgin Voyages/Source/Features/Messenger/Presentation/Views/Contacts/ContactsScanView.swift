//
//  ContactsScanView.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 30.10.24.
//

import SwiftUI
import VVUIKit

extension ContactsScanView {
    static func create(viewModel: ContactsScanViewModelProtocol = ContactsScanViewModel(), back: @escaping (() -> Void), displaysViewOnSuccess: Bool = true, action: @escaping ((String) -> Void)) -> ContactsScanView {
        return ContactsScanView(displaysViewOnSuccess: displaysViewOnSuccess, back: back, action: action, viewModel: viewModel)
	}
}

// MARK: ContactsScanView

// TODO: Refactor display of view on scann success.
//
// ContactsScanView should not present the success view.
// On success action should be handled via a callback.
// Handling of a success action wether presenting a navigating somewhere else by the parrent view, should be implemented from its parrent view.


struct ContactsScanView: View {
    
    // MARK: - State properties
    @State private var viewModel: ContactsScanViewModelProtocol
    @State private var isVisible = false

    // MARK: - Navigation handlers
    let displaysViewOnSuccess: Bool
    let back: (() -> Void)
    let action: (String) -> Void
    
    // MARK: - Init
    init(displaysViewOnSuccess: Bool = true, back: @escaping () -> Void, action: @escaping (String) -> Void, viewModel: ContactsScanViewModelProtocol) {
        self.displaysViewOnSuccess = displaysViewOnSuccess
        self.back = back
        self.action = action
        _viewModel = State(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            QRCodeScannerView(onCodeScanned: { code in
				viewModel.scannedCode = code
				viewModel.checkQRCode(qrCode: code)
            }, isScanning: $viewModel.isScanning)
            .ignoresSafeArea()
            .opacity(isVisible ? 1 : 0)
            .animation(.easeIn(duration: 0.25), value: isVisible)

            
            VStack {
                HStack {
                    photoGallery()
                    Spacer()
                    toolbar()
                }	
                .padding(.bottom, viewModel.showScanerSegmentControl ? Paddings.zero : Paddings.defaultVerticalPadding128)
                
                if viewModel.showScanerSegmentControl {
                    segmentControlView()
                }
                
                qrCodeAreaView()
                Spacer()
                helpButton()
                Spacer()
            }
            .padding()
            .opacity(isVisible ? 1 : 0)
            .animation(.easeIn(duration: 0.25), value: isVisible)

            
			if self.displaysViewOnSuccess {
                VStack {}
                    .fullScreenCover(isPresented: $viewModel.showConfirmation) {
						AddContactSheet(contact: AddContactData.from(sailorLink: viewModel.scannedCode.value), isFromDeepLink: false, onDismiss: {
							viewModel.showConfirmation = false
							viewModel.isScanning = true
						})
						.navigationBarHidden(true)
                    }
            }

			if viewModel.showOnboardingDialog {
				VVSheetModal(title: viewModel.labels.onboardTitle, subheadline: viewModel.labels.onboardDescription,
							 primaryButtonText: viewModel.labels.onboardButtonTitle,
							 imageName: "OnboardingAlert",
							 primaryButtonAction: {
					viewModel.hideOnboardingDialog()
				}, dismiss: {
					viewModel.hideOnboardingDialog()
				})
				.background(Color.clear)
				.transition(.opacity)
			}
        }
		.fullScreenCover(isPresented: $viewModel.showInvalidQRCodeAlert) {
			Group {
				if let error = viewModel.qrCodeError {
					VVSheetModal(
						title: error.info.title,
						subheadline: error.info.subtitle,
						primaryButtonText: "OK",
						imageName: "AddFriendError",
						primaryButtonAction: {
							viewModel.hideScanError()
						},
						dismiss: {
							viewModel.hideScanError()
						}
					)
				} else {
					EmptyView()
				}
			}
		}
		.sheet(isPresented: $viewModel.contactIsAlreadyAdded, content: {
			FriendAlreadyExistsSheet(contact: AddContactData.from(sailorLink: viewModel.scannedCode.value), onClose: {
				back()
			})
		})
        .sheet(isPresented: $viewModel.showHelpMe, content: {
            ContactsHelpToolTipSheet.create(
                title: viewModel.scanCodeModel.helpTitle,
                message: viewModel.scanCodeModel.helpDescription,
                back: {
                    viewModel.showHelpMe = false
                }
            )
            .presentationDetents([.medium, .fraction(0.3)])
        })

        .onAppear {
			Task {
				await viewModel.onAppear()
				DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
					isVisible = true
				}
			}
        }
        .onChange(of: viewModel.showConfirmation) { oldValue, newValue in
            if newValue, let scannedCode = viewModel.scannedCode {
                DispatchQueue.main.async {
                    viewModel.isScanning = false
                    action(scannedCode)
                }
            }
        }
    }

    // MARK: - View builders
    private func segmentControlView() -> some View {
        CustomSegmentedPicker(
            selectedOption: $viewModel.selectedOption,
            yourCodeText: viewModel.scanCodeModel.yourCodeText,
            scanCodeText: viewModel.scanCodeModel.scanCodeText,
            onYourCodeSelected: {
                back()
            },
            onScanCodeSelected: { }
        )
        .padding()
    }

    private func qrCodeAreaView() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: CornerRadiusValues.defaultCornerRadius)
                .stroke(Color.white, lineWidth: 2)
                .frame(width: Sizes.qrCodeImageSize, height: Sizes.qrCodeImageSize)
                .background(Color.clear)

            VStack {
                Spacer()
                Image(systemName: "plus")
                    .foregroundColor(.white)
                    .font(.system(size: Sizes.defaultSize32, weight: .light))
                Spacer()
            }

            VStack {
                Spacer()
                Text(viewModel.scanCodeModel.positionSailorCodeText)
                    .foregroundColor(.white)
                    .padding(.bottom, Paddings.defaultVerticalPadding32)
            }
        }
        .frame(width: Sizes.qrCodeImageSize, height: Sizes.qrCodeImageSize)
    }

    private func helpButton() -> some View {
        Button(action: {
            viewModel.showHelpMe = true
        }) {
            HStack {
                Image(systemName: "info.circle.fill")
                    .foregroundColor(.white)
                Text(viewModel.scanCodeModel.helpMeText)
                    .foregroundColor(.white)
            }
            .padding(.horizontal, Paddings.defaultVerticalPadding16)
            .padding(.vertical, Paddings.defaultVerticalPadding)
        }
        .padding(.top, Paddings.defaultVerticalPadding16)
    }

    private func toolbar() -> some View {
        Toolbar(buttonStyle: .closeButton) {
            back()
        }
    }

    private func photoGallery() -> some View {
        PhotoPickerView(task: viewModel.photoTask) { imageData in
            if let ciImage = CIImage(data: imageData) {
                viewModel.readQRCode(from: ciImage)
            }
        } label: {
            Image(.uploadQr)
        }
        .frame(width: 32, height: 32)
        .padding(.top, Paddings.defaultVerticalPadding24)
        .padding(.bottom, 0)
        .padding(.horizontal, Paddings.defaultVerticalPadding16)
    }
}

extension ContactsScanView {
	struct Labels {
		let onboardTitle: String
		let onboardDescription: String
		let onboardButtonTitle: String
	}
}


#Preview {
    ContactsScanView(back: {}, action: {_ in }, viewModel: ContactsScanViewModel(selectedOption: .scanCode, yourCodeText: "Your code", scanCodeText: "Scan code"))
}
