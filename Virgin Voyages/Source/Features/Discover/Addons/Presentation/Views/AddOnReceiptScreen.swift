//
//  PurchasedAddonDetailsView.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 7.10.24.
//

import SwiftUI
import VVUIKit

extension AddOnReceiptScreen {
    static func create(viewModel: PurchasedAddonDetailsViewModelProtocol = PurchasedAddonDetailsViewModel(addonCode: ""), back: @escaping (() -> Void), goToAddonList: @escaping (() -> Void)) -> AddOnReceiptScreen {
        return AddOnReceiptScreen(viewModel: viewModel, back: back, goToAddonList: goToAddonList)
    }
}

struct AddOnReceiptScreen: View {

    // MARK: - ViewModel
    @State private var viewModel: PurchasedAddonDetailsViewModelProtocol

    // MARK: - Init
    init(viewModel: PurchasedAddonDetailsViewModelProtocol, back: @escaping () -> Void, goToAddonList: @escaping () -> Void) {
        _viewModel = State(wrappedValue: viewModel)
        self.back = back
        self.goToAddonList = goToAddonList
    }

    // MARK: - Navigation actions
    let back: (() -> Void)
    let goToAddonList: (() -> Void)

    var body: some View {
        VirginScreenView(state: $viewModel.screenState) {
            VStack(spacing: Paddings.zero) {
                ZStack(alignment: .topLeading) {
                    ScrollView(.vertical) {
                        VStack(spacing: Paddings.zero) {
                            FlexibleProgressImage(url: URL(string: viewModel.addonDetailsModel.imageURL))
                                .frame(height: Sizes.addonDetailsImageSize)
                                .frame(maxWidth: .infinity)
                            adaptiveAddonView()
                                .padding()
                                .padding(.top, Paddings.minus50)
                        }
                        DoubleDivider()
                            .padding(.bottom, Paddings.defaultVerticalPadding16)

                        buttonsView()
                    }
                    toolbar()
                        .padding(.top, Paddings.defaultVerticalPadding24)
                }
                Spacer()
            }
            .ignoresSafeArea(edges: [.top])
            .background(Color(uiColor: .systemGray6))
        } loadingView: {
            ProgressView("Loading...")
                .fontStyle(.headline)
        } errorView: {
            NoDataView {
                Task {
                    await viewModel.onAppear()
                }
            }
        }
        .sheet(isPresented: $viewModel.showCancelationRefuse) {
            cancelRefused()
        }
        .sheet(isPresented: $viewModel.showCancelationOptions) {
            cancelOptions()
        }
        .sheet(isPresented: $viewModel.showConfirmCancelation.confirmation) {
            confirmCancelation()
        }
        .sheet(isPresented: $viewModel.showCanceledPurchase) {
            purchaseCanceled()
        }
        .onAppear {
            Task {
                await viewModel.onAppear()
            }
        }
    }


    // MARK: - View builders
    private func toolbar() -> some View {
        Toolbar(buttonStyle: .backButton) {
            back()
        }
    }

    private func cancelRefused() -> some View {
        BookingConfirmationSheet(
            title: viewModel.addonDetailsModel.cancelButtonText,
            subheadline: viewModel.addonDetailsModel.cancelRefusedText,
            primaryButtonText: viewModel.addonDetailsModel.okButtonText,
            secondaryButtonText: viewModel.addonDetailsModel.contactSailorServiceText,
            isEnabled: true,
            imageName: "CancelationConfirmation",
            isLoadingButtonAction: .constant(false),
            primaryButtonAction: {
                viewModel.showCancelationRefuse = false
            }, secondaryButtonAction: {
                viewModel.showCancelationRefuse = false
                Task {
                    callPhone(number: SupportPhones.sailorServicesPhoneNumber)
                }
            }, dismiss: {
                viewModel.showCancelationRefuse = false
            },
            hasDismissButton: false,
            primaryButtonStyle: SecondaryButtonStyle(),
            secondaryButtonStyle: TertiaryButtonStyle()
        )
        .presentationDetents([.large])
    }

    private func cancelOptions() -> some View {
        BookingConfirmationSheet(
            title: viewModel.addonDetailsModel.cancelButtonText,
            subheadline: viewModel.addonDetailsModel.cancelClarifyText,
            primaryButtonText: viewModel.addonDetailsModel.justForMeText,
            secondaryButtonText: viewModel.addonDetailsModel.wholeGroupText,
            isEnabled: false,
            imageName: "CancelationConfirmation",
            isLoadingButtonAction: .constant(false),
            primaryButtonAction: {
                //Only one guest
                viewModel.showCancelationOptions = false
                viewModel.prepearForCancellation(confirmation: true, forSingleGuest: true)
            },
            secondaryButtonAction: {
                //For more guests
                viewModel.showCancelationOptions = false
                viewModel.prepearForCancellation(confirmation: true, forSingleGuest: false)
            }, dismiss: {
                viewModel.showCancelationOptions = false
            },
            hasDismissButton: true,
            primaryButtonStyle: SecondaryButtonStyle(),
            secondaryButtonStyle: SecondaryButtonStyle()
        )
        .presentationDetents([.large])
    }


    private func confirmCancelation() -> some View {
        BookingConfirmationSheet(
            title: viewModel.addonDetailsModel.confirmationTitle,
            subheadline: viewModel.addonDetailsModel.confirmationSubTitle,
            bodyText: viewModel.confirmCancellationHeading,
            primaryButtonText: viewModel.addonDetailsModel.confirmationYesCancelText,
            secondaryButtonText: viewModel.addonDetailsModel.confirmationChangedMindText,
            isEnabled: true,
            imageName: "CancelationConfirmation",
            isLoadingButtonAction: $viewModel.isRunningCanceling,
            primaryButtonAction: {
                Task {
                    viewModel.isRunningCanceling = true
                    let cancel = await viewModel.cancelAddon(singleGuest:viewModel.showConfirmCancelation.forSingleGuest)
                    switch cancel {
                    case .success:
                        viewModel.showConfirmCancelation.confirmation = false
                        viewModel.showCanceledPurchase = true
						viewModel.didCancelAddon()
                    case .failure:
                        viewModel.showConfirmCancelation.confirmation = false
                    }
                    viewModel.isRunningCanceling = false
                }
            },
            secondaryButtonAction: {
                viewModel.showConfirmCancelation.confirmation = false
            },
            dismiss: {
                viewModel.showConfirmCancelation.confirmation = false
            },
            hasDismissButton: true,
            primaryButtonStyle: SecondaryButtonStyle(),
            secondaryButtonStyle: TertiaryButtonStyle()
        )
        .presentationDetents([.large])

    }

    private func purchaseCanceled() -> some View {
        BookingConfirmationSheet(
            title: "Purchase cancelled",
            subheadline: viewModel.addonDetailsModel.name,
            primaryButtonText: viewModel.addonDetailsModel.doneText,
            isEnabled: true,
            imageName: "CancelationConfirmed",
            isLoadingButtonAction: .constant(false),
            primaryButtonAction: {
                viewModel.showCanceledPurchase = false
                back()
            },
            dismiss: {
                viewModel.showCanceledPurchase = false
            },
            hasDismissButton: false,
            primaryButtonStyle: PrimaryButtonStyle(),
            secondaryButtonStyle: SecondaryButtonStyle()
        )
        .presentationDetents([.large])
    }

    private func adaptiveAddonView() -> some View {
        VStack {
            AdaptiveMultiTicketLabel(spacing: Paddings.defaultVerticalPadding, backgroundColor: Color(uiColor: .systemGray6), hasLabel: ($viewModel.addonDetailsModel.guests.count > 0), header: {
                addonHeaderView()
            }, label: {
                purchaseForView()
            }, footer: {
                needToKnowView()
            })
        }
    }

    private func addonHeaderView() -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(viewModel.addonDetailsModel.addonCategory)
                    .fontStyle(.boldTagline)
                    .foregroundStyle(Color.squidInk)
                Text(viewModel.addonDetailsModel.name)
                    .fontStyle(.largeCaption)
                    .foregroundStyle(.black)
            }
            Spacer()
            Image("GiftIcon")
                .resizable()
                .frame(width: Sizes.defaultSize32, height: Sizes.defaultSize32)
                .aspectRatio(contentMode: .fit)
                .padding(.trailing)
                .foregroundStyle(Color.squidInk)
        }
        .frame(alignment: .leading)
        .padding()
    }

    private func buttonsView() -> some View {
        VStack(spacing: Paddings.defaultVerticalPadding24) {
            if viewModel.addonDetailsModel.isActionButtonsDisplay && viewModel.addonDetailsModel.isPurchased {
                Button(viewModel.addonDetailsModel.viewAddonPageText) {
                    goToAddonList()
                }
                .frame(maxWidth: .infinity)
                .buttonStyle(AdaptiveButtonStyle())
            }

			if viewModel.addonDetailsModel.amount > 0 && viewModel.addonDetailsModel.isActionButtonsDisplay {
                Button(viewModel.addonDetailsModel.cancelPurchaseText) {
                    switch viewModel.addonDetailsModel.isCancellable {
                    case true:
                        //Check if this addon is purchsed for sailor
                        if viewModel.addonDetailsModel.guests.count == 1 {
                            viewModel.showConfirmCancelation = ConfirmCancelationType(confirmation: true, forSingleGuest: true, numberOfGuests: 1)
                        } else {
                            viewModel.showCancelationOptions = true
                        }
                    case false:
                        viewModel.showCancelationRefuse = true
                    }
                }
                .buttonStyle(AdaptiveButtonStyle())
            }
            Button(viewModel.addonDetailsModel.contactSailorServiceText) {
                callPhone(number: SupportPhones.sailorServicesPhoneNumber)
            }
            .buttonStyle(TertiaryLinkStyle())
        }
        .padding()
    }

    private func purchaseForView() -> some View {
        VStack(alignment: .leading, spacing: Paddings.zero) {
            Text(viewModel.addonDetailsModel.purchasedForText.uppercased())
                .fontStyle(.smallButton)
                .foregroundStyle(Color.secondary)
                .padding(.horizontal)
                .padding(.top, Paddings.defaultVerticalPadding)
            ScrollView(.horizontal) {
                HStack(spacing: 5) {
                    ForEach(viewModel.addonDetailsModel.guestURL, id: \.self) { url in
                        AuthURLImageView(imageUrl: url, size: Spacing.space48, clipShape: .circle, defaultImage: "ProfilePlaceholder")
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, Paddings.defaultVerticalPadding16)
                .padding(.bottom, Paddings.defaultVerticalPadding24)
            }
        }
    }

    private func needToKnowView() -> some View {
		VStack(alignment: .leading, spacing: Spacing.space16) {
			Text("Need to know")
				.textCase(.uppercase)
				.fontStyle(.boldTagline)
				.foregroundStyle(Color.slateGray)
			ForEach(viewModel.addonDetailsModel.needToKnows, id: \.self) { item in
				HStack(alignment: .top, spacing: Spacing.space16) {
					Image("NeedToKnow")
						.resizable()
						.frame(width: Sizes.defaultSize24, height: Sizes.defaultSize24)
						.aspectRatio(contentMode: .fit)

					Text(item)
						.fontStyle(.lightBody)
						.foregroundColor(.lightGreyColor)
						.multilineTextAlignment(.leading)
				}
			}
		}
		.frame(maxWidth: .infinity, alignment: .leading)
		.padding(.vertical, Spacing.space24)
		.padding(.horizontal, Spacing.space16)
    }
}


struct PurchasedAddonDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        let mockViewModel = PurchasedAddonDetailsMockViewModel()
        AddOnReceiptScreen.create(
            viewModel: mockViewModel,
            back: {
                print("Back action triggered")
            },
            goToAddonList: {
                print("Go to Addon List triggered")
            }
        )
    }
}
