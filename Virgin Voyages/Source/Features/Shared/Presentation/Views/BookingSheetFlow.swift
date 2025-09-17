//
//  BookingSheetFlow.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 1.5.25.
//

import SwiftUI

struct BookingSheetFlow : View {
	@State var viewModel: BookingSheetFlowViewModel
	
	@Binding var showScanner: Bool
	@Binding var isPresented: Bool
	
	// MARK: - Private Var
	@State private var viewOpacity: Double = 0.0
	
	init(isPresented: Binding<Bool>,
		 bookingSheetViewModel: BookingSheetViewModel,
		 showScanner: Binding<Bool> = .constant(false)) {
		_viewModel = State(wrappedValue: BookingSheetFlowViewModel(isSheetVisible: isPresented.wrappedValue, bookingSheetViewModel: bookingSheetViewModel))
		_showScanner = showScanner
		_isPresented = isPresented
	}
	
	/// Initializer for purchase summary root view
	init(isPresented: Binding<Bool>,
		 summaryInput: BookingSummaryInputModel,
		 showScanner: Binding<Bool> = .constant(false)) {
		_viewModel = State(wrappedValue: BookingSheetFlowViewModel(isSheetVisible: isPresented, summaryInput: summaryInput))
		_showScanner = showScanner
		_isPresented = isPresented
	}
	
	var body: some View {
		NavigationStack(path: $viewModel.appCoordinator.homeTabBarCoordinator.purchaseSheetCoordinator.navigationRouter.navigationPath) {
			VStack {
				visibleViewWithContent()
				invisibleModalContainer()
			}
		}
		.onChange(of: viewModel.isSheetVisible) { _, newValue in
			isPresented = newValue
		}
	}
	
	private func visibleViewWithContent() -> some View {
		// MARK: - Visible View
		Group {
			switch viewModel.rootViewType {
			case .bookingSheet:
                if let bookingSheetViewModel = viewModel.bookingSheetViewModel {
                    BookingSheet(viewModel: bookingSheetViewModel,
                                 onBookingAdded: {
                        viewModel.onBookingAdded()
                    }, onBookingUpdated: {
                        viewModel.onBookingUpdated()
                    },
                                 onDismiss: {
                        viewModel.removePurchaseSheet()
                    }, onAddNewSailorTapped: {
                        viewModel.navigateToAddFriend()
                    })
                    .interactiveDismissDisabled(true)
                }
			case .purchaseSummary(let summaryInput):
				let bookingSummaryViewModel = BookingSummaryScreenViewModel(inputModel: summaryInput)
				BookingSummaryScreen(
					viewModel: bookingSummaryViewModel,
					paymentError: $viewModel.paymentError,
					back: {
						viewModel.removePurchaseSheet()
					},
					close: {
						viewModel.removePurchaseSheet()
					})
			}
		}
		.navigationDestination(for: PurchaseSheetNavigationRoute.self) { route in
			destinationView(for: route)
				.navigationBarBackButtonHidden(true)
		}
	}
	
	private func invisibleModalContainer() -> some View {
		VStack {}
			.fullScreenCover(isPresented: $viewModel.showScanner) {
				ContactsScanView(
					displaysViewOnSuccess: false,
					back: { dismissWithAnimation() },
					action: { scannedCode in
						viewModel.navigateToScanSuccessScreen(scannedCode)
						dismissWithAnimation()
					},
					viewModel: ContactsScanViewModel(
						selectedOption: .scanCode,
						yourCodeText: "Your code",
						scanCodeText: "Scan code",
						showScanerSegmentControl: false)
				)
				.presentationBackground(.clear)
				.opacity(viewOpacity)
				.onAppear {
					fadeInView()
				}
			}
			.transaction { transaction in
				transaction.disablesAnimations = true
			}
	}
}


// MARK: - Helper func
extension BookingSheetFlow {
	private func fadeInView() {
		viewOpacity = 0.0
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
			withAnimation(.easeIn(duration: 0.33)) {
				viewOpacity = 1.0
			}
		}
	}
	
	private func dismissWithAnimation(completion: (() -> Void)? = nil) {
		withAnimation(.easeOut(duration: 0.33)) {
			viewOpacity = 0.0
		}
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.33) {
			viewModel.showScanner = false
			completion?()
		}
	}
	
}

extension BookingSheetFlow: CoordinatorNavitationDestinationViewProvider {
	
	func destinationView(for navigationRoute: any BaseNavigationRoute) -> AnyView {
		
		guard let purchaseSheetNavigationRoute = navigationRoute as? PurchaseSheetNavigationRoute else {
			return AnyView(Text("View not supported"))
		}
		
		switch purchaseSheetNavigationRoute {
		case .landing:
            guard let bookingSheetViewModel = viewModel.bookingSheetViewModel else {
                return AnyView(Text("View not supported"))
            }
			return AnyView(
				BookingSheet(viewModel: bookingSheetViewModel,
							 onBookingAdded: {
					viewModel.onBookingAdded()
				}, onBookingUpdated: {
					viewModel.onBookingUpdated()
				},
							 onDismiss: {
					viewModel.removePurchaseSheet()
				}, onAddNewSailorTapped: {
					viewModel.navigateToAddFriend()
				})
                .interactiveDismissDisabled(true)
			)
		case .addAFriend:
			return AnyView(
				AddFriendSheet(
					toolbarButtonStyle: .backButton,
					closeAction: {
						viewModel.appCoordinator.homeTabBarCoordinator.purchaseSheetCoordinator.navigationRouter.navigateBack()
					}, shareAction: {
						// This is currently implemented within AddFriendSheet
					}, scanAction: {
						viewModel.showScanner = true
					}, searchAction: {
						// Implement Search action with coordinators if needed.
					}
				)
			)
		case .friendAddedSuccessfully(let scannedQRCode):
			return AnyView(
				AddContactSheet(contact: AddContactData.from(sailorLink: scannedQRCode), isFromDeepLink: false, onDismiss: {
					viewModel.appCoordinator.executeCommand(PurchaseSheetCoordinator.GoBackToRootViewCommand())
				})
			)
		case .paymentPage(paymentURL: let url, let bookingConfirmationTitle, let bookingConfirmationSubheadline,
						  let activityCode, let activitySlotCode, let isEditBooking, let appointmentId, let summaryInput):

            let purchasePaymentViewModel = PurchasePaymentViewModel(
				inputModel: summaryInput,
				url: url,
                bookingConfirmationTitle: bookingConfirmationTitle,
                bookingConfirmationSubheadline: bookingConfirmationSubheadline
			)

			return AnyView(
				PurchasePaymentView(
					viewModel: purchasePaymentViewModel,
					back: {
						viewModel.navigateBack()
					},
					paymentError: { error in
						viewModel.paymentError = error
						viewModel.navigateBack()
					},
					backToRoot: {
						viewModel.navigateBackToRoot()
					}, done: {
                        viewModel.onPaymentSuccessFromWeb(activityCode: activityCode,
														  activitySlotCode: activitySlotCode,
														  isEditBooking: isEditBooking,
														  appointmentId: appointmentId)
					}
				)
			)
		case .clarification(conflicts: _, sailors: _):
			return AnyView(EmptyView())
        case .bookingSummary(summaryInput: let summaryInput):
            let bookingSummaryViewModel = BookingSummaryScreenViewModel(inputModel: summaryInput)
            return AnyView(
                BookingSummaryScreen(
                    viewModel: bookingSummaryViewModel,
                    paymentError: $viewModel.paymentError,
                    back: {
                        viewModel.navigateBack()
                    },
                    close: {
                        viewModel.removePurchaseSheet()
					})
            )
        case .termsAndConditions:
            return AnyView(
                TermsAndConditionsScreen(onBack: {
                    viewModel.navigateBack()
                })
            )
        case .privacyPolicy:
            return AnyView(
                TermsAndConditionsScreen(initiallySelectedKey: .privacy) {
                    viewModel.navigateBack()
                }
            )
		}
		
	}
	
}

