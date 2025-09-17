//
//  MainView.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 4/15/23.
//

import SwiftUI
import VVUIKit

enum MainViewScreen: Hashable {
	case dashboard
	case discover(section: DiscoverNavigationSection)
	case services
	case messenger
    case me(section: MeNavigationSection)
}

enum DiscoverNavigationSection: Hashable {
	case home
    case addonList(selectedAddOnCode: String? = nil)
	case shoreThings
	case events
	case eateries
	case shipSpaceCategoryView(shipSpace: String)
}

enum MeNavigationSection: Hashable {
    case agenda
    case agendaOnSpecificDate(date: Date)
    case addOns
}

func getSection(from screen: MainViewScreen) -> DiscoverNavigationSection {
	if case let .discover(section) = screen {
		return section
	}
	return .home
}

func getSection(from screen: MainViewScreen) -> MeNavigationSection {
    if case let .me(section) = screen {
        return section
    }
    return .agenda
}

struct MainView: View {

	@State var viewModel: MainViewViewModelProtocol
    @State private var musterDrillIsExpanded: Bool = false
    
    private let homeLandingScreen: HomeLandingScreen

	init(viewModel: MainViewViewModelProtocol) {
		_viewModel = State(initialValue: viewModel)
        self.homeLandingScreen = HomeLandingScreen()
	}

	var body: some View {
		ZStack {
			if viewModel.isOfflineModePortDay {
				offlineModePortDayHomeScreen
			} else {
                VStack(spacing: .zero) {
                    switch viewModel.appCoordinator.homeTabBarCoordinator.fullScreenRouter {
                    case .musterDrill(shouldRemainOpenAfterUserHasWatchedSafteyVideo: let shouldRemainOpenAfterUserHasWatchedSafteyVideo):
                        MusterDrillScreen(shouldRemainOpenAfterUserHasWatchedSafteyVideo: shouldRemainOpenAfterUserHasWatchedSafteyVideo, isExpanded: $musterDrillIsExpanded)
                            .zIndex(10)
                            .onDisappear {
                                viewModel.publishEventsOnHomeViewDidAppear()
                            }
                    case .none:
                        EmptyView()
                    }
                    
                    StatusBannerContent(
                        notificationBanners: viewModel.statusBannerNotifications,
                        onBannerClick: { banner in
                            viewModel.handleNotificationTap(statusBanerNotificationItem: banner)
                        },
                        onDismissClick: { notificationId in
                            withAnimation(.easeInOut(duration: 0.3)) {
                                viewModel.deleteOneNotification(notificationId: notificationId) {
                                    viewModel.statusBannerNotifications.removeAll { $0.id == notificationId }
                                }
                            }
                        }
                    ) {
                        mainTabView
                            .zIndex(1)
                    }

                }
			}
		}
		.alert("Trying to Shake for Champagne?", isPresented: $viewModel.showShakeForChampagne) {
					Button("Open Sailor App", role: .none) {
						viewModel.openReactNativeApp()
					}
					Button("Not Now", role: .cancel) {
						print("Not Now tapped")
					}
				} message: {
					Text("Not to worry—once you’re onboard, that shake won’t go to waste. While we’re still putting the finishing touches on this shiny new app, you’ll need to head over to the Sailor App to enjoy that well-deserved bottle of bubbly.")
				}
		.onAppear {
			viewModel.onAppear()
		}
		.fullScreenCover(isPresented: $viewModel.showConnectToWiFiScreen) {
			connectToWiFiScreen
		}
        .fadeFullScreenCover(item: $viewModel.appCoordinator.homeTabBarCoordinator.fullScreenOverlayRouter, content: { path in
            switch path {
            case .notifications:
                NotificationsScreen()
            case .shakeForChampagneLanding(let orderId):
                ShakeForChampagneScreen(orderId: orderId) {
                    viewModel.getStatusBannerNotifications()
                }
            case .addToPlanner:
                AddToPlannerView(viewModel: AddToPlannerViewModel())
            }
        })
	}

	private var offlineModePortDayHomeScreen: some View {
		OfflineModeHomeLandingScreen(
			viewModel: OfflineModeHomeLandingScreenViewModel(),
			navigateToConnectToWiFi: {
				viewModel.showConnectToWiFi()
			}
		)
	}

	private var mainTabView: some View {
        TabView(selection: $viewModel.appCoordinator.homeTabBarCoordinator.selectedTab) {
            Group {
                homeTab
                discoverTab
                servicesTab
                messengerTab
                meTab
            }
            .toolbarBackground(.white, for: .tabBar)
            .toolbarBackground(.visible, for: .tabBar)
            .toolbar(viewModel.appCoordinator.homeTabBarCoordinator.isTabBarHidden ? .hidden : .visible, for: .tabBar)
        }
        .sheet(item: $viewModel.appCoordinator.homeTabBarCoordinator.sheetRouter.currentSheet, content: { path in
            viewModel.destinationView(for: path)
        })
        .onChange(of: viewModel.currentDeepLink) { _, newValue in
            viewModel.handleDeepLink(deepLink: newValue)
        }
	}

	private var homeTab: some View {
        self.homeLandingScreen
			.tag(MainViewScreen.dashboard)
			.tabItem {
				Label("Home", systemImage: "house")
			}
	}

	private var discoverTab: some View {
		DiscoverView(
			goToPurchasedAddOns: {
				navigateTo(tab: .me(section: .addOns))
			},
			section: getSection(from: viewModel.appCoordinator.homeTabBarCoordinator.selectedTab)
		)
		.navigationTitle("Discover")
		.tag(MainViewScreen.discover(section: getSection(from: viewModel.appCoordinator.homeTabBarCoordinator.selectedTab)))
		.tabItem {
			Label("Discover", image: .discoverTabIcon)
		}
	}

	private var servicesTab: some View {
		ServicesLandingScreen()
        .tag(MainViewScreen.services)
        .tabItem {
			Label("Services", image: .servicesTabIcon)
        }
	}

	private var messengerTab: some View {
		MessengerLandingScreen(viewModel: MessengerLandingScreenViewModel())
			.tag(MainViewScreen.messenger)
			.tabItem {
				Label("Messenger", image: .messengerTabIcon)
			}
	}

	private var meTab: some View {
        MeLandingScreen.create()
            .tag(MainViewScreen.me(section: getSection(from: viewModel.appCoordinator.homeTabBarCoordinator.selectedTab)))
			.tabItem {
				Label("Me", image: .meTabIcon)
			}
	}

	private var connectToWiFiScreen: some View {
		NavigationStack {
			let connectToWiFiScreenViewModel = ConnectToWiFiScreenViewModel()
			ConnectToWiFiScreen(viewModel: connectToWiFiScreenViewModel)
		}
	}

    private func navigateTo(tab: MainViewScreen) {
        viewModel.navigate(to: tab)
    }
}

#Preview {
    class MockMainViewViewModel: MainViewViewModelProtocol {
        func deleteOneNotification(notificationId: String, completion: (() -> Void)?) {
            
        }
        
        var statusBannerNotifications: [StatusBannersNotifications.StatusBannersNotificationItem] = []
        
        
        var pushNotificationService: PushNotificationServiceProtocol = PushNotificationService(provider: FirebasePushNotificationService.shared)

		func openReactNativeApp() {
		}
		
		var showShakeForChampagne: Bool = false

		func showConnectToWiFi() {
		}

		func dismissSheet() {
		}
		
		func destinationView(for sheetRoute: any BaseSheetRouter) -> AnyView {
			AnyView(EmptyView())
		}
        
        func destinationView(for fullScreenRoute: any BaseFullScreenRoute) -> AnyView {
            AnyView(EmptyView())
        }
		
		var currentDeepLink: DeepLinkType? = nil

		var isOfflineModePortDay: Bool = false
		var showConnectToWiFiScreen: Bool = false
		var appCoordinator: AppCoordinator = AppCoordinator.shared

		func onAppear() {
			print("MainView appeared")
		}

		func navigate(to screen: MainViewScreen) {
			print("Navigating to \(screen)")
		}

		func resetSelectedTabState() {
			print("Resetting selected tab state")
		}

		func trackShoreThings() {
			print("Tracking shore things")
		}

		func handleDeepLink(deepLink: DeepLinkType?) {
			print("Handling deep link: \(String(describing: deepLink))")
		}
        
        func publishEventsOnHomeViewDidAppear() {
            print("MainView should publish events")
        }
        
        func getStatusBannerNotifications() {
            
        }
        
        func handleNotificationTap(statusBanerNotificationItem: StatusBannersNotifications.StatusBannersNotificationItem) {
            
        }
	}

	let viewModel = MockMainViewViewModel()
    return MainView(viewModel: viewModel)
}
