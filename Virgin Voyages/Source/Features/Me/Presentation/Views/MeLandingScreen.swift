//
//  MeLandingScreen.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 3.3.25.
//

import SwiftUI

@MainActor
extension MeLandingScreen {
    static func create() -> MeLandingScreen {
        MeLandingScreen(viewModel: MeLandingScreenViewModel())
    }
}

struct MeLandingScreen: View, CoordinatorFullScreenViewProvider, CoordinatorNavitationDestinationViewProvider {
    
    @State private var viewModel: MeLandingScreenViewModelProtocol
    
    init(viewModel: MeLandingScreenViewModelProtocol) {
        _viewModel = State(wrappedValue: viewModel)
    }
    
    var body: some View {
		NavigationStack(path: $viewModel.appCoordinator.homeTabBarCoordinator.meCoordinator.navigationRouter.navigationPath) {
            MeView.createDefault(section: getSection(from: viewModel.appCoordinator.homeTabBarCoordinator.selectedTab))
				.navigationDestination(for: MeNavigationRoute.self) { route in
					destinationView(for: route)
				}
		}
        .fullScreenCover(item: $viewModel.appCoordinator.homeTabBarCoordinator.meCoordinator.fullScreenRouter) { route in
            destinationView(for: route)
        }
    }
    
    func destinationView(for fullScreenRoute: any BaseFullScreenRoute) -> AnyView {
        
        guard let meSectionFullScreenRoute = fullScreenRoute as? MeFullScreenRoute else {
            return AnyView(Text("View not implemented for route: \(fullScreenRoute)"))
        }
        switch meSectionFullScreenRoute {
        case .claimABooking:
            return AnyView(ClaimBookingView.create(shouldShowCloseFlowButton: true, rootPath: .bookingDetails))
        }
    }
    
    func destinationView(for navigationRoute: any BaseNavigationRoute) -> AnyView {
        guard let meNavigationRoute = navigationRoute as? MeNavigationRoute else {
            return AnyView(Text("View not supported"))
        }
        switch meNavigationRoute {
        case .vipBenefits:
            return AnyView(VipBenefitsView(onBackClick: {
                viewModel.navigateBack()
            })
            .navigationBarBackButtonHidden())
        case .settings:
            return AnyView(ProfileSettingsLandingScreen()
                .navigationBarBackButtonHidden())
        case .addons(let addonCode):
            return AnyView(
                AddOnReceiptScreen.create(viewModel: PurchasedAddonDetailsViewModel(addonCode: addonCode)) {
                    viewModel.navigateBack()
                    viewModel.openMeAddonsScreen()
                } goToAddonList: {
                    viewModel.openAddonsList()
                }
                .navigationBarBackButtonHidden()
            )
        case .eateryReceipt(let appointmentId):
            return AnyView(
                EateryReceiptScreen(appointmentId: appointmentId,
                                    onBackClick: {
                                        viewModel.navigateBack()
                                    },
                                    onBookingCanceled: {
                                        viewModel.navigateBack()
                                    })
            )
        case .shoreExcursionReceipt(let appointmentId):
            let receiptViewModel = ShoreThingReceiptScreenViewModel(appointmentId: appointmentId)
            return AnyView(
                ShoreThingReceiptScreen(viewModel: receiptViewModel, onBackClick: {
                    viewModel.navigateBack()
                }).navigationBarBackButtonHidden()
            )
        case .treatmentReceipt(let appointmentId):
            return AnyView(TreatmentReceiptScreen(appointmentId: appointmentId, onBackClick: {
                viewModel.navigateBack()
            }))
        case .entertainmentReceipt(let appointmentId):
            return AnyView(LineUpEventReceiptScreen(appointmentId: appointmentId, onBackClick: {
                viewModel.navigateBack()
            }))
        case .lineUpDetails:
            return AnyView(
                LineUpScreen(onViewEventDetailsClick: {event  in
                    
                }, onBackClick: {
                    viewModel.navigateBack()
                }) )
        case .wallet:
            return AnyView(
                FolioScreen(onBackClick: {
                    viewModel.navigateBack()
                })
                .navigationBarBackButtonHidden()
            )
        case .termsAndConditions:
            return AnyView(
                TermsAndConditionsScreen()
                    .navigationBarBackButtonHidden()
            )
        case .switchVoyage:
            return AnyView(
                VoyageSelectionScreen(
                    viewModel: VoyageSelectionScreenViewModel(onVoyageChanged: { reservationNumber in
                        viewModel.updateSailorReservation(reservationNumber: reservationNumber)
                }, onCurrentVoyageSelected: {
                    viewModel.openHomeDashboard()
                }), onBackClick: {
                    viewModel.navigateBack()
                }).navigationBarBackButtonHidden(true)
            )
        case .setPinLanding:
            return AnyView(
                SetPinLandingScreen(viewModel: SetPinLandingScreenViewModel())
                    .navigationBarBackButtonHidden(true))
        case .setPin:
            return AnyView(
                SetPinScreen()
                    .navigationBarBackButtonHidden(true))
        }
    }
}
