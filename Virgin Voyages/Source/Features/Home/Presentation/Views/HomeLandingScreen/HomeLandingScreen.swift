//
//  LandingScreen.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 10.3.25.
//

import SwiftUI

protocol HomeLandingScreenViewModelProtocol {
    var appCoordinator: AppCoordinator { get set }
    var screenState: ScreenState { get set }
    var sections: [HomeSection] { get }
    var sailingMode: SailingMode { get }
    var sailorLocation: SailorLocation { get }
    var yOffset: CGFloat { get set }
    var headerHeight: CGFloat { get set }
	var reloadableViewModels: HomeReloadableViewModels { get set }
    
    func onAppear()
	func onRefresh()
    func dismissSheet()
    
    // added navigation helpers for destination view
    func navigateBack()
    func navigateBack(steps: Int)
    func updateSailorReservation(reservationNumber: String)
    
    // added “open” helpers (wrap coordinator commands)
    func openDiningDetails(slug: String, filter: EateriesSlotsInputModel?)
    func openDiningOpeningTimes(filter: EateriesSlotsInputModel)
    func openDiningReceipt(appointmentId: String)
    
    func openShipSpaceDetails(shipSpaceDetailsItem: ShipSpaceDetails)
    func openTreatments(treatmentID: String)
    func openTreatmentsReceipt(appointmentID: String)
    
    func openEventLineUpDetails(event: LineUpEvents.EventItem)
    func openEventLineUpReceipt(id: String)
    
    func openShoreThingsList(portCode: String, arrivalDateTime: Date?, departureDateTime: Date?)
    func openShoreThingItemDetails(shoreThingItem: ShoreThingItem)
    func openShoreThingsReceipt(appointmentId: String)

}


extension HomeLandingScreen {
    static func create(viewModel: HomeLandingScreenViewModelProtocol = HomeLandingScreenViewModel()) -> HomeLandingScreen {
        return HomeLandingScreen(viewModel: viewModel)
    }
}
struct HomeLandingScreen: View, CoordinatorFullScreenViewProvider, CoordinatorNavitationDestinationViewProvider, CoordinatorSheetViewProvider {
    @State private var viewModel: HomeLandingScreenViewModelProtocol
    @State private var homeScrollView: HomeScrollView? = nil
    
    init(viewModel: HomeLandingScreenViewModelProtocol = HomeLandingScreenViewModel()) {
        _viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
		DefaultScreenView(state: $viewModel.screenState) {
            if let homeScrollView {
                NavigationStack(path: $viewModel.appCoordinator.homeTabBarCoordinator.homeDashboardCoordinator.navigationRouter.navigationPath) {
                    
                    homeScrollView
                        .navigationDestination(for: HomeDashboardNavigationRoute.self) { route in
                            destinationView(for: route)
                        }
                }
                .padding(.zero)
                .fullScreenCover(item: $viewModel.appCoordinator.homeTabBarCoordinator.homeDashboardCoordinator.fullScreenRouter) { path in
                    destinationView(for: path)
                }
                .sheet(item: $viewModel.appCoordinator.homeTabBarCoordinator.homeDashboardCoordinator.sheetRouter.currentSheet) {
                    viewModel.dismissSheet()
                } content: { path in
                    destinationView(for: path)
                }
            }
		} onRefresh: {
			viewModel.onAppear()
		}.onAppear {
            instantiateHomeScrollView()
			viewModel.onAppear()
        }.navigationBarBackButtonHidden()
    }
    
    func instantiateHomeScrollView() {
        if homeScrollView == nil {
            homeScrollView = HomeScrollView(
                viewModel: viewModel,
                yOffset: $viewModel.yOffset,
                headerHeight: $viewModel.headerHeight
            )
        }
    }
}

extension HomeLandingScreen {
    func destinationView(for navigationRoute: any BaseNavigationRoute) -> AnyView {
        guard let path = navigationRoute as? HomeDashboardNavigationRoute else { return AnyView(Text("Path not found"))}
        
        switch path {
        case .landingPage:
            return AnyView(
                HomeLandingScreen()
            )
        case .travelPartyAssist:
            return AnyView(
                TravelAssistView()
                    .toolbar(.hidden, for: .tabBar)
            )
        case .boardingPass:
            return AnyView(
                BoardingPassScreen(viewModel: BoardingPassViewModel())
            )
        case .eateriesList:
            return AnyView(
                EateriesListScreen(
                    onDetailsClick : {slug, filter in
                        viewModel.openDiningDetails(slug: slug, filter: filter)
                    }, onBackClick: {
                        viewModel.navigateBack()
                    }, onViewAllOpeningTimesClick : { filter in
                        viewModel.openDiningOpeningTimes(filter: filter)
                    }
                )
            )
        case .diningReceipt(let appointmentId):
            return AnyView(
                EateryReceiptScreen(appointmentId: appointmentId, onBackClick: {
                    viewModel.navigateBack()
                }, onBookingCanceled: {
                    viewModel.navigateBack(steps: 2)
                })
            )
        case .diningDetails(let slug, let filter):
            return AnyView(
                EateriesDetailsScreen(slug: slug, filter: filter, onBackClick: {
                    viewModel.navigateBack()
                }, onViewReceiptClick: {
                    viewModel.openDiningReceipt(appointmentId: $0)
                })
            )
        case .diningOpeningTimes(let filter):
            return AnyView(
                EateriesOpeningTimesScreen(
                    filter: filter,
                    onDetailsClick : {slug, venueId, isBookable, filter in
                        viewModel.openDiningDetails(slug: slug, filter: filter)
                    }, onBackClick: {
                        viewModel.navigateBack()
                    }
                )
            )
        case .shipSpace(let shipSpaceCode):
            return AnyView(
                ShipSpaceCategoryDetailsScreen(categoryCode: shipSpaceCode) { shipSpace in
                    viewModel.openShipSpaceDetails(shipSpaceDetailsItem: shipSpace)
                }
                onBackClick: {
                    viewModel.navigateBack()
                }
            )
        case .shipSpaceDetails(let shipSpaceDetailsItem):
            return AnyView(
                ShipSpaceDetailsScreen(shipSpace: shipSpaceDetailsItem) {
                    viewModel.navigateBack()
                } onViewTreatmentClick: { treatmentID in
                    viewModel.openTreatments(treatmentID: treatmentID)
                }
            )
        case .treatment(let treatmentId):
            return AnyView(
                TreatmentDetailsScreen(treatmentId: treatmentId){
                    viewModel.navigateBack()
                } onViewReceiptClick: { appointmentID in
                    viewModel.openTreatmentsReceipt(appointmentID: appointmentID)
                }
            )
        case .treatmentReceipt(appointmentID: let appointmentID):
            return AnyView(
                TreatmentReceiptScreen(appointmentId: appointmentID, onBackClick: {
                    viewModel.navigateBack()
                })
            )
        case .eventLineUp:
            return AnyView(
                LineUpScreen(onViewEventDetailsClick: { event in
                    viewModel.openEventLineUpDetails(event: event)
                }, onBackClick: {
                    viewModel.navigateBack()
                })
            )
        case .eventLineUpDetails(let event):
            return AnyView(
                LineUpEventDetailsScreen(event: event, backAction: {
                    viewModel.navigateBack()
                }, onViewReceiptClick: { id in
                    viewModel.openEventLineUpReceipt(id: id)
                })
            )
        case .eventLineUpDetailsReceipt(let id):
            return AnyView(
                LineUpEventReceiptScreen(appointmentId: id) {
                    viewModel.navigateBack()
                }
            )
            
        case .shoreThings:
            return AnyView(
                   ShoreThingPortScreen(viewModel: ShoreThingPortScreenViewModel(),
                                        onViewListTapped: { portCode, arrivalDateTime, departureDateTime in

                       //self.appCoordinator.executeCommand(HomeDashboardCoordinator.OpenShoreThingsPortScreenCommand(port: $0.toDomain()))
                       viewModel.openShoreThingsList(
                           portCode: portCode,
                           arrivalDateTime: arrivalDateTime,
                           departureDateTime: departureDateTime
                       )
                   }, onBackClick: {
                       viewModel.navigateBack()
                   })
               )
        case .shoreThingsList(let portCode, let arrivalDateTime, let departureDateTime):
            return AnyView(
                ShoreThingsListScreen(
                    viewModel: ShoreThingsListScreenViewModel(portCode: portCode, arrivalDateTime: arrivalDateTime, departureDateTime: departureDateTime),
                    onBackClick: {
                        viewModel.navigateBack()
                    },
                    onViewDetails: {
                        viewModel.openShoreThingItemDetails(shoreThingItem: $0)
                    },
                    onAppointmentTapped : {
                        viewModel.openShoreThingsReceipt(appointmentId: $0)
                    }
                )
            )
        case .shoreThingItemDetails(shoreThingItem: let shoreThingItem):
            return AnyView(
                ShoreThingDetailsScreen(
                    viewModel: ShoreThingDetailsScreenViewModel(shoreThingItem: shoreThingItem),
                    onBackClick: {
                        viewModel.navigateBack()
                    },
                    onAppointmentTapped : {
                        viewModel.openShoreThingsReceipt(appointmentId: $0)
                    }
                )
            )
        case .shoreThingsReceipt(let appointmentId):
            return AnyView(
                ShoreThingReceiptScreen(viewModel: ShoreThingReceiptScreenViewModel(appointmentId: appointmentId), onBackClick: {
                    viewModel.navigateBack()
                })
                .navigationBarBackButtonHidden()
            )
        case .switchVoyage:
            return AnyView(
                VoyageSelectionScreen(viewModel: VoyageSelectionScreenViewModel(onVoyageChanged: { reservationNumber in
                    viewModel.updateSailorReservation(reservationNumber: reservationNumber)
                }, onCurrentVoyageSelected: {
                    viewModel.navigateBack()
                }), onBackClick: {
                    viewModel.navigateBack()
                })
                .navigationBarBackButtonHidden(true)
            )
        case .wallet:
            return AnyView(
                FolioScreen(onBackClick: {
                    viewModel.navigateBack()
                })
                .navigationBarBackButtonHidden()
            )
        case .homeComingGuide:
            return AnyView(
                HomeComingGuideScreen()
                    .toolbar(.hidden, for: .tabBar)
                    .navigationBarBackButtonHidden()
            )
        
        }
    }
    
    func destinationView(for fullScreenRoute: any BaseFullScreenRoute) -> AnyView {
        guard let homeDashboardFullScreenRoute = fullScreenRoute as? HomeDashboardFullScreenRoute  else { return AnyView(Text("View route not implemented")) }
        switch homeDashboardFullScreenRoute {
        case .rts(let sailor, let rtsTaskDetails):
            return AnyView(
                ReadyView(sailor: sailor, dashboardTask: rtsTaskDetails)
                        .onDisappear {
                            // reload home
                            viewModel.onAppear()
                        }
            )
        case .travelAssist:
            return AnyView(
                TravelAssistView()
            )
            
        case .healthCheckLanding:
            return AnyView(
                HealthCheckScreenView.create()
                    .onDisappear {
                        // Reload home
                        viewModel.onAppear()
                    }
            )
        }
    }
    
    func destinationView(for sheetRoute: any BaseSheetRouter) -> AnyView {
        guard let homeDashboardSheetRoute = sheetRoute as? HomeDashboardSheetRoute  else { return AnyView(Text("View route not implemented")) }

        switch homeDashboardSheetRoute {
        case .shipMap:
            return AnyView(ShipMapSheet())
        case .itineraryDetails:
            return AnyView(HomeItineraryDetailsSheet())
        }
    }
}

class HomeLandingScreenPreviewViewModel: HomeLandingScreenViewModelProtocol {
    
    var appCoordinator: AppCoordinator = .init()
    
    var screenState: ScreenState = .content
    
    var sections: [any HomeSection] = [
        HomeHeader.sample(),
        HomeMusterDrillSection.sample(),
        HomeActionsSection.sample(),
        EmptySection(id: "2", title: "Home Section 2"),
        EmptySection(id: "3", title: "Home Section 3")
    ]
    
    var sailingMode: SailingMode = .shipBoardDebarkationDay
    
    var sailorLocation: SailorLocation = .shore
    
	var voyageActivitiesViewModel: any VoyageActivitiesViewModelProtocol = VoyageActivitiesMockViewModel()
	
    var yOffset: CGFloat = 0.0
    
    var headerHeight: CGFloat = 420.0
	
	var reloadableViewModels: HomeReloadableViewModels = .init()
    
    func onAppear() {}
	
	func onRefresh() {}
    
    func destinationView(for fullScreenRoute: any BaseFullScreenRoute) -> AnyView {
        AnyView(EmptyView())
    }
    
    func destinationView(for navigationRoute: any BaseNavigationRoute) -> AnyView {
        AnyView(EmptyView())
    }
    
    func destinationView(for sheetRoute: any BaseSheetRouter) -> AnyView {
        AnyView(EmptyView())
    }
    
    func dismissSheet() {}
    
    func navigateBack() {
        
    }
    
    func navigateBack(steps: Int) {
        
    }
    
    func updateSailorReservation(reservationNumber: String) {
        
    }
    
    func openDiningDetails(slug: String, filter: EateriesSlotsInputModel?) {
        
    }
    
    func openDiningOpeningTimes(filter: EateriesSlotsInputModel) {
        
    }
    
    func openDiningReceipt(appointmentId: String) {
        
    }
    
    func openShipSpaceDetails(shipSpaceDetailsItem: ShipSpaceDetails) {
        
    }
    
    func openTreatments(treatmentID: String) {
        
    }
    
    func openTreatmentsReceipt(appointmentID: String) {
        
    }
    
    func openEventLineUpDetails(event: LineUpEvents.EventItem) {
        
    }
    
    func openEventLineUpReceipt(id: String) {
        
    }
    
    func openShoreThingsList(portCode: String, arrivalDateTime: Date?, departureDateTime: Date?) {
        
    }
    
    func openShoreThingItemDetails(shoreThingItem: ShoreThingItem) {
        
    }
    
    func openShoreThingsReceipt(appointmentId: String) {
        
    }
}

#Preview {
    let previewViewModel = HomeLandingScreenPreviewViewModel()
    HomeLandingScreen(viewModel: previewViewModel)
}


