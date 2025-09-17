//
//  DiscoverView.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 1/8/25.
//

import SwiftUI

struct DiscoverView: View {
	@State var viewModel: DiscoverViewModel
	
	let goToPurchasedAddOns: (() -> Void)
	var section: DiscoverNavigationSection
	@State private var lastHandledSection: DiscoverNavigationSection? = nil
	
	init(
		viewModel: DiscoverViewModel = DiscoverViewModel(),
		goToPurchasedAddOns: @escaping () -> Void,
		section: DiscoverNavigationSection
	) {
		_viewModel = State(wrappedValue: viewModel)
		self.goToPurchasedAddOns = goToPurchasedAddOns
		self.section = section
	}
	
	var body: some View {
        NavigationStack(path: $viewModel.appCoordinator.discoverCoordinator.navigationRouter.navigationPath) {
			DiscoverLandingView { route in
				viewModel.navigateTo(route)
			}
			.navigationDestination(for: DiscoverNavigationRoute.self) { route in
				switch route {
				case .addOnDetails(let addOn):
					AddOnDetailsScreen(addOn: addOn, onBackClick: {
						viewModel.navigateBack()
					}, onViewReceiptClick : {
						viewModel.navigateTo(.addOnReceipt(code: $0))
					})
					.navigationBarBackButtonHidden(true)
				case .addOnDetailsByCode(let code):
					AddOnDetailsScreen(addOnCode: code, onBackClick: {
						viewModel.navigateBack()
					}, onViewReceiptClick : {
						viewModel.navigateTo(.addOnReceipt(code: $0))
					})
					.navigationBarBackButtonHidden(true)
				case .addOnList(let selectedCode):
					AddOnsListScreen.create(selectedAddOnCode: selectedCode) {
						viewModel.navigateBack()
					} details: { addOn in
						viewModel.navigateTo(.addOnDetails(addOn: addOn))
					} goToPurchasedAddOns: {
						 goToPurchasedAddOns()
					}
					.navigationBarBackButtonHidden(true)
				case .addOnReceipt(let code):
					AddOnReceiptScreen.create(viewModel: PurchasedAddonDetailsViewModel(addonCode: code),
											  back: {
						viewModel.navigateBack()
					},
											  goToAddonList: {
						viewModel.navigateTo(.addOnList())
					})
					.navigationBarBackButtonHidden(true)
				case .shoreThingsReceiptView(let appointmentId):
					ShoreThingReceiptScreen(viewModel: ShoreThingReceiptScreenViewModel(appointmentId: appointmentId),
					onBackClick: {
						viewModel.navigateBack()
					}).navigationBarBackButtonHidden()
				case .shoreThings:
					ShoreThingPortScreen(viewModel: ShoreThingPortScreenViewModel(), onViewListTapped: {
						viewModel.navigateTo(.shoreThingsList(portCode: $0, arrivalDateTime: $1, departureDateTime: $2))
					}, onBackClick: {
						viewModel.navigateBack()
					})
					.navigationBarBackButtonHidden(true)
				case .shoreThingsList(let portCode, let arrivalDateTime, let departureDateTime):
					ShoreThingsListScreen(
						viewModel: ShoreThingsListScreenViewModel(portCode: portCode, arrivalDateTime: arrivalDateTime, departureDateTime: departureDateTime),
						onBackClick: {
							viewModel.navigateBack()
						},
						onViewDetails: {
							viewModel.navigateTo(.shoreThingItemDetails(shoreThingItem: $0))
						},
						onAppointmentTapped : {
							viewModel.navigateTo(.shoreThingsReceiptView(appointmentId: $0))
						}
					)
					.navigationBarBackButtonHidden(true)
				case .shoreThingItemDetails(shoreThingItem: let shoreThingItem):
					ShoreThingDetailsScreen(
						viewModel: ShoreThingDetailsScreenViewModel(shoreThingItem: shoreThingItem),
						onBackClick: {
							viewModel.navigateBack()
						},
						onAppointmentTapped : {
							viewModel.navigateTo(.shoreThingsReceiptView(appointmentId: $0))
						}
					)
					.navigationBarBackButtonHidden(true)
				case .eventLandingView:
					LineUpScreen(
						onViewEventDetailsClick: { event in
							// Event details screen
							viewModel.navigateTo(.eventDetailsView(event: event))
						},
						onBackClick: {
							// Back action
							viewModel.navigateBack()
						}
					)
				case .eventDetailsView(let event):
					LineUpEventDetailsScreen(event: event,
											 onViewReceiptClick: { id in
						viewModel.navigateTo(.eventReceiptDetailsView(id: id))
					}
					)
				case .eventReceiptDetailsView(let id):
					LineUpEventReceiptScreen(viewModel: LineUpEventReceiptViewModel(appointmentId: id)) {
						viewModel.navigateBack()
					}
				case .shipSpacesView:
					ShipSpacesCategoriesScreen(
						onViewShipSpaceCategoryClick: { code in
							if code == SpaceCategory.eateries.description {
								viewModel.navigateTo(.diningView)
							} else {
								viewModel.navigateTo(.shipSpaceCategoryView(categoryCode: code))
							}
						},
						onBackClick: {
							viewModel.navigateBack()
						}
					)
				case .shipSpaceCategoryView(let categoryCode):
					ShipSpaceCategoryDetailsScreen(categoryCode: categoryCode) { shipSpace in
						viewModel.navigateTo(.shipSpaceDetailsView(shipSpace: shipSpace))
					}
					onBackClick: { viewModel.navigateBack() }
				case .shipSpaceDetailsView(shipSpace: let shipSpace):
					ShipSpaceDetailsScreen(shipSpace: shipSpace) {
						viewModel.navigateBack()
					} onViewTreatmentClick: { treatmentId in
						viewModel.navigateTo(.treatmentDetails(treatmentId: treatmentId))
					}
				case .diningView:
					EateriesListScreen(
						onDetailsClick : {slug, filter in
							viewModel.navigateTo(.diningDetails(slug: slug, filter: filter))
						},
						onBackClick: {
							viewModel.navigateBack()
						},
						onViewAllOpeningTimesClick : { filter in
							viewModel.navigateTo(.diningOpeningTimes(filter: filter))
						})
				case .diningDetails(let slug, let filter):
					EateriesDetailsScreen(slug: slug, filter: filter, onBackClick: {
						viewModel.navigateBack()
					}, onViewReceiptClick: { appointmentId in
						viewModel.navigateTo(.diningReceipt(appointmentId: appointmentId))
					})
				case .diningOpeningTimes(let filter):
					EateriesOpeningTimesScreen(
						filter: filter,
						onDetailsClick : {slug, venueId, isBookable, filter in
							viewModel.navigateTo(.diningDetails(slug: slug, filter: filter))
						},
						onBackClick: {
							viewModel.navigateBack()
						})
				case .diningReceipt(let appointmentId):
					EateryReceiptScreen(appointmentId: appointmentId, onBackClick: {
						viewModel.navigateBack()
					}, onBookingCanceled: {
						viewModel.navigateBack(steps: 2)
					})
				case .treatmentDetails(let treatmentId):
					TreatmentDetailsScreen(treatmentId: treatmentId){
						viewModel.navigateBack()
					} onViewReceiptClick: { appointmentId in
						viewModel.navigateTo(.treatmentReceipt(appointmentId: appointmentId))
					}
				case .treatmentReceipt(let appointmentId):
					TreatmentReceiptScreen(appointmentId: appointmentId, onBackClick: {
						viewModel.navigateBack()
					})
				}
			}
            .sheet(item: $viewModel.appCoordinator.discoverCoordinator.sheetRouter.currentSheet, onDismiss: {
                viewModel.dismissSheet()
            }, content: { sheetRoute in
                viewModel.destinationView(for: sheetRoute)
            })
		}
		.onChange(of: section ) {
			navigationHandler()
		}
		.onAppear {
			navigationHandler()
		}
	}

	private func navigationHandler() {
		// Prevent duplicate navigations when onAppear and onChange fire with the same section
		guard lastHandledSection != section else { return }
		lastHandledSection = section
		viewModel.navigateToRoot()
		switch section {
		case .home:
			viewModel.navigateToRoot()
		case .addonList(let selectedAddOnCode):
			viewModel.navigateTo(.addOnList(code: selectedAddOnCode))
		case .shoreThings:
			viewModel.navigateTo(.shoreThings)
        case .events:
            viewModel.navigateTo(.eventLandingView)
		case .eateries:
			viewModel.navigateTo(.diningView)
		case .shipSpaceCategoryView(let categoryCode):
			viewModel.navigateTo(.shipSpaceCategoryView(categoryCode: categoryCode))
		}
	}
}
