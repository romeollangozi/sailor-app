//
//  HomeTabBarCoordinator.swift
//  Virgin Voyages
//
//  Created by TX on 11.2.25.
//

import Foundation

enum HomeTabBarFullScreenRoute: BaseFullScreenRoute {
    case musterDrill(shouldRemainOpenAfterUserHasWatchedSafteyVideo: Bool)
    
    var id: String {
        switch self {
        case .musterDrill:
            return "musterDrill"
        }
    }
}

enum TabBarFullScreenOverlayRoute: BaseFullScreenRoute {
    case notifications
    case shakeForChampagneLanding(orderId: String?)
    case addToPlanner
    
    var id: String {
        switch self {
        case .notifications:
            return "notifications"
        case .shakeForChampagneLanding:
            return "shakeForChampagneLanding"
        case .addToPlanner:
            return "addToPlanner"
        }
    }
}

@Observable class HomeTabBarCoordinator {
    
	var selectedTab: MainViewScreen = .dashboard {
		didSet {
			let wasMe = {
				if case .me = oldValue { return true }
				return false
			}()
			let isNowMe = {
				if case .me = selectedTab { return true }
				return false
			}()

			if !wasMe && isNowMe {
				meCoordinator.navigationRouter.goToRoot(animation: false)
			}
		}
	}

    // MARK: Routers
    var sheetRouter: SheetRouter<HomeSheetRoute>
    var fullScreenRouter: HomeTabBarFullScreenRoute?
    var fullScreenOverlayRouter: TabBarFullScreenOverlayRoute?

    //MARK: Sub-coordinators
    var homeDashboardCoordinator: HomeDashboardCoordinator
    var serviceCoordinator: ServiceCoordinator
    var messengerCoordinator: MessengerCoordinator
    var addAFriendCoordinator: AddAFriendCoordinator
    var purchaseSheetCoordinator: PurchaseSheetCoordinator
    var travelDocumentsCoordinator: TravelDocumentsCoordinator
    var healthCheckCoordinator: HealthCheckCoordinator
	var meCoordinator: MeCoordinator
    var musterDrillCoordinator: MusterDrillCoordinator
    var notificationsCoordinator: NotificationsCoordinator
    var shakeForChampagneCoordinator: ShakeForChampagneCoordinator
    var isTabBarHidden: Bool = true

    // MARK: - Init
    init(selectedTab: MainViewScreen,
         sheetRouter: SheetRouter<HomeSheetRoute> = .init(),
         fullScreenRouter: HomeTabBarFullScreenRoute? = nil,
         homeDashboardCoordinator: HomeDashboardCoordinator = .init(),
         serviceCoordinator: ServiceCoordinator = .init(),
         messengerCoordinator: MessengerCoordinator = .init(),
         addAFriendCoordinator: AddAFriendCoordinator = .init(),
         purchaseSheetCoordinator: PurchaseSheetCoordinator = .init(),
		 travelDocumentsCoordinator: TravelDocumentsCoordinator = .init(),
         healthCheckCoordinator: HealthCheckCoordinator = .init(),
		 meCoordinator: MeCoordinator = .init(),
         musterDrillCoordinator: MusterDrillCoordinator = .init(),
         notificationsCoordinator: NotificationsCoordinator = .init(),
         fullScreenOverlayRouter: TabBarFullScreenOverlayRoute? = nil,
         shakeForChampagneCoordinator: ShakeForChampagneCoordinator = .init(),
         isTabBarHidden: Bool = true) {
        self.selectedTab = selectedTab
        self.sheetRouter = sheetRouter
        self.fullScreenRouter = fullScreenRouter
        self.homeDashboardCoordinator = homeDashboardCoordinator
        self.serviceCoordinator = serviceCoordinator
        self.messengerCoordinator = messengerCoordinator
        self.addAFriendCoordinator = addAFriendCoordinator
        self.purchaseSheetCoordinator = purchaseSheetCoordinator
        self.travelDocumentsCoordinator = travelDocumentsCoordinator
        self.healthCheckCoordinator = healthCheckCoordinator
		self.meCoordinator = meCoordinator
        self.musterDrillCoordinator = musterDrillCoordinator
        self.notificationsCoordinator = notificationsCoordinator
        self.fullScreenOverlayRouter = fullScreenOverlayRouter
        self.shakeForChampagneCoordinator = shakeForChampagneCoordinator
        self.isTabBarHidden = isTabBarHidden
    }
}

extension HomeTabBarCoordinator {
    
    struct OpenHomeDashboardScreenCommand: NavigationCommandProtocol {
        func execute(on coordinator: AppCoordinator) {
            coordinator.homeTabBarCoordinator.selectedTab = .dashboard
            coordinator.homeTabBarCoordinator.homeDashboardCoordinator.navigationRouter.goToRoot()
        }
    }
    
    struct OpenMessengerScreenCommand: NavigationCommandProtocol {
        func execute(on coordinator: AppCoordinator) {
            coordinator.homeTabBarCoordinator.selectedTab = .messenger
            coordinator.homeTabBarCoordinator.messengerCoordinator.navigationRouter.goToRoot()
        }
    }
    
    struct OpenMeScreenCommand: NavigationCommandProtocol {
        func execute(on coordinator: AppCoordinator) {
            coordinator.homeTabBarCoordinator.selectedTab = .me(section: .agenda)
            coordinator.homeTabBarCoordinator.meCoordinator.navigationRouter.goToRoot()
        }
    }

	struct OpenMeAddonsScreenCommand: NavigationCommandProtocol {
		func execute(on coordinator: AppCoordinator) {
			coordinator.homeTabBarCoordinator.selectedTab = .me(section: .addOns)
		}
	}

    struct OpenMessengerContactsScreenCommand: NavigationCommandProtocol {
        let deepLink: String?
        func execute(on coordinator: AppCoordinator) {
            coordinator.homeTabBarCoordinator.selectedTab = .messenger
            coordinator.homeTabBarCoordinator.messengerCoordinator.navigationRouter.navigateTo(.contacts(link: deepLink))
        }
    }

	struct OpenMessengerContactsScreenDeepLinkCommand: NavigationCommandProtocol {
		let contact: AddContactData
		func execute(on coordinator: AppCoordinator) {
			let path = coordinator.homeTabBarCoordinator.messengerCoordinator.navigationRouter.getCurrentRoute()
			if path == .contactList || path == .contacts(link: nil) {
				coordinator.homeTabBarCoordinator.messengerCoordinator.sheetRouter.present(sheet: .addAFriendFromDeepLink(contact: contact))
			}else {
				coordinator.homeTabBarCoordinator.selectedTab = .messenger
				coordinator.homeTabBarCoordinator.messengerCoordinator.navigationRouter.navigateTo(.contactList)
				coordinator.homeTabBarCoordinator.messengerCoordinator.sheetRouter.present(sheet: .addAFriendFromDeepLink(contact: contact))
			}
		}
	}


    struct OpenAddAFriendSheetCommand: NavigationCommandProtocol {
        func execute(on coordinator: AppCoordinator) {
            coordinator.homeTabBarCoordinator.sheetRouter.present(sheet: .addAFriend)
        }
    }
    
    struct DismissAnySheetCommand: NavigationCommandProtocol {
        func execute(on coordinator: AppCoordinator) {
            coordinator.homeTabBarCoordinator.sheetRouter.dismiss()
        }
    }

	struct OpenVipBenefitsCommand: NavigationCommandProtocol {
		func execute(on coordinator: AppCoordinator) {
			coordinator.homeTabBarCoordinator.meCoordinator.navigationRouter.navigateTo(.vipBenefits)
		}
	}

    struct OpenWalletFromMeCommand: NavigationCommandProtocol {
        func execute(on coordinator: AppCoordinator) {
            if coordinator.homeTabBarCoordinator.selectedTab != .me(section: .agenda) ||
                coordinator.homeTabBarCoordinator.selectedTab != .me(section: .addOns) {
                coordinator.homeTabBarCoordinator.selectedTab = .me(section: .agenda)
            }
            coordinator.homeTabBarCoordinator.meCoordinator.navigationRouter.navigateTo(.wallet)
        }
    }

	struct OpenUserProfileCommand: NavigationCommandProtocol {
		func execute(on coordinator: AppCoordinator) {
			coordinator.homeTabBarCoordinator.meCoordinator.navigationRouter.navigateTo(.settings)
		}
	}
    
    struct OpenEateryReceipeCommand: NavigationCommandProtocol {
        let appointmentId: String
        func execute(on coordinator: AppCoordinator) {
            coordinator.homeTabBarCoordinator.meCoordinator.navigationRouter.navigateTo(.eateryReceipt(appointmentId: appointmentId))
        }
    }
	
	struct OpenHomeEateryReceipeCommand: NavigationCommandProtocol {
		let appointmentId: String
		func execute(on coordinator: AppCoordinator) {
			coordinator.homeTabBarCoordinator.homeDashboardCoordinator.navigationRouter.navigateTo(.diningReceipt(appointmentId: appointmentId))
		}
	}
    
    struct OpenShoreExcursionReceipeCommand: NavigationCommandProtocol {
        let appointmentId: String
        func execute(on coordinator: AppCoordinator) {
            coordinator.homeTabBarCoordinator.selectedTab = .me(section: .agenda)
            coordinator.homeTabBarCoordinator.meCoordinator.navigationRouter.navigateTo(.shoreExcursionReceipt(appointmentId: appointmentId))
        }
    }
    
    struct OpenTreatmentReceipeCommand: NavigationCommandProtocol {
        let appointmentId: String
        func execute(on coordinator: AppCoordinator) {
            coordinator.homeTabBarCoordinator.selectedTab = .me(section: .agenda)
            coordinator.homeTabBarCoordinator.meCoordinator.navigationRouter.navigateTo(.treatmentReceipt(appointmentId: appointmentId))
        }
    }
    
    struct OpenEntertainmentReceipeCommand: NavigationCommandProtocol {
        let appointmentId: String
        func execute(on coordinator: AppCoordinator) {
            coordinator.homeTabBarCoordinator.selectedTab = .me(section: .agenda)
            coordinator.homeTabBarCoordinator.meCoordinator.navigationRouter.navigateTo(.entertainmentReceipt(appointmentId: appointmentId))
        }
    }

	struct OpenAddonsListCommand: NavigationCommandProtocol {
		func execute(on coordinator: AppCoordinator) {
			coordinator.homeTabBarCoordinator.selectedTab = .discover(section: .addonList())
		}
	}
    
    struct OpenAddonListWithSelectedAddonCode: NavigationCommandProtocol {
        let addonCode: String
        func execute(on coordinator: AppCoordinator) {
            // Select Discover with the Add-ons List section and pass the code.
            // DiscoverView will handle navigation to the list on appear.
            coordinator.homeTabBarCoordinator.selectedTab = .discover(section: .addonList(selectedAddOnCode: addonCode))
        }
    }

    struct OpenAddonDetailsCommand: NavigationCommandProtocol {
        let addOn: AddOn
        func execute(on coordinator: AppCoordinator) {
            coordinator.discoverCoordinator.navigationRouter.navigateTo(.addOnDetails(addOn: addOn))
        }
    }

    // Open Discover tab and push Add-on Details directly
    struct OpenDiscoverAddonDetailsCommand: NavigationCommandProtocol {
        let addOn: AddOn
        func execute(on coordinator: AppCoordinator) {
            if case .discover = coordinator.homeTabBarCoordinator.selectedTab {
                coordinator.discoverCoordinator.navigationRouter.navigateTo(.addOnDetails(addOn: addOn))
            } else {
                coordinator.homeTabBarCoordinator.selectedTab = .discover(section: .addonList())
                coordinator.discoverCoordinator.navigationRouter.navigateTo(.addOnDetails(addOn: addOn))
            }
        }
    }

    // Open Discover and navigate directly to Add-on Details by code
    struct OpenDiscoverAddonDetailsByCodeCommand: NavigationCommandProtocol {
        let addonCode: String
        func execute(on coordinator: AppCoordinator) {
            // Switch to Discover first; allow its view to mount and run its own
            // navigationHandler (which clears the router to root on appear).
			coordinator.discoverCoordinator.navigationRouter.goToRoot(animation: false)
            coordinator.homeTabBarCoordinator.selectedTab = .discover(section: .home)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.18) {
                DispatchQueue.main.async {
                    coordinator.discoverCoordinator.navigationRouter.navigateTo(.addOnDetailsByCode(code: addonCode))
                }
            }
        }
    }
    
	struct OpenAddonReceipeCommand: NavigationCommandProtocol {
		let addonCode: String
		func execute(on coordinator: AppCoordinator) {
			coordinator.homeTabBarCoordinator.meCoordinator.navigationRouter.navigateTo(.addons(addonCode: addonCode))
		}
	}
    
    struct OpenDiscoverLineUpEventsCommand: NavigationCommandProtocol {
        func execute(on coordinator: AppCoordinator) {
			if coordinator.homeTabBarCoordinator.selectedTab != .discover(section: .events) {
				coordinator.homeTabBarCoordinator.selectedTab = .discover(section: .events)
			} else {
				coordinator.discoverCoordinator.navigationRouter.goToRoot()
				coordinator.discoverCoordinator.navigationRouter.navigateTo(.eventLandingView)
			}
        }
    }
    
    struct ShowMusterDrillFullScreenCommand: NavigationCommandProtocol{
        let shouldRemainOpenAfterUserHasWatchedSafteyVideo: Bool
        func execute(on coordinator: AppCoordinator) {
            if let currentRouter = coordinator.homeTabBarCoordinator.fullScreenRouter {
                if currentRouter !=  .musterDrill(shouldRemainOpenAfterUserHasWatchedSafteyVideo: true) {
                    // Present/update muster drill if muster drill is not presented with shouldRemainOpenAfterUserHasWatchedSafteyVideo set to true.
                    coordinator.homeTabBarCoordinator.fullScreenRouter = .musterDrill(shouldRemainOpenAfterUserHasWatchedSafteyVideo: shouldRemainOpenAfterUserHasWatchedSafteyVideo)
                }
                // This prevents muster screen to change from screen takeover state to top sticky info banner.
            } else {
                // Present muster drill if muster drill is not presented.
                coordinator.homeTabBarCoordinator.fullScreenRouter = .musterDrill(shouldRemainOpenAfterUserHasWatchedSafteyVideo: shouldRemainOpenAfterUserHasWatchedSafteyVideo)
            }
            
        }
    }

    struct DismissMusterDrillFullScreenCommand: NavigationCommandProtocol{
        func execute(on coordinator: AppCoordinator) {
            switch coordinator.homeTabBarCoordinator.fullScreenRouter {
            case .musterDrill(shouldRemainOpenAfterUserHasWatchedSafteyVideo: _):
                coordinator.homeTabBarCoordinator.fullScreenRouter = nil
            case .none:
                break
            }
        }
    }
    
    struct ShowShakeForChampagneAnimationFullScreenCommand: NavigationCommandProtocol {
        
        let orderId: String?
        
        func execute(on coordinator: AppCoordinator) {
            coordinator.homeTabBarCoordinator.fullScreenOverlayRouter = .shakeForChampagneLanding(orderId: orderId)
        }
        
    }
    
    struct ShowAddToPlannerAnimationFullScreenCommand: NavigationCommandProtocol {
                
        func execute(on coordinator: AppCoordinator) {
            coordinator.homeTabBarCoordinator.fullScreenOverlayRouter = .addToPlanner
        }
        
    }

    struct DismissAnyFullScreenCommand: NavigationCommandProtocol{
        func execute(on coordinator: AppCoordinator) {
            coordinator.homeTabBarCoordinator.fullScreenRouter = nil
        }
    }
    
    struct DismissFullScreenCommand: NavigationCommandProtocol{
        let path: HomeTabBarFullScreenRoute
        func execute(on coordinator: AppCoordinator) {
            if coordinator.homeTabBarCoordinator.fullScreenRouter == path {
                coordinator.homeTabBarCoordinator.fullScreenRouter = nil
            }
        }
    }
    
    struct ShowNotificationMessagesFullScreenCoverCommand: NavigationCommandProtocol {
        func execute(on coordinator: AppCoordinator) {
            coordinator.homeTabBarCoordinator.fullScreenOverlayRouter = .notifications
        }
    }

    struct DismissFullScreenOverlayCommand: NavigationCommandProtocol {
        let pathToDismiss: TabBarFullScreenOverlayRoute
        
        func execute(on coordinator: AppCoordinator) {
            if coordinator.homeTabBarCoordinator.fullScreenOverlayRouter == pathToDismiss {
                coordinator.homeTabBarCoordinator.fullScreenOverlayRouter = nil
            }
        }
    }
	
	struct OpenDiscoverEateriesListCommand: NavigationCommandProtocol {
		func execute(on coordinator: AppCoordinator) {
			if coordinator.homeTabBarCoordinator.selectedTab != .discover(section: .eateries) {
				coordinator.homeTabBarCoordinator.selectedTab = .discover(section: .eateries)
			} else {
				coordinator.discoverCoordinator.navigationRouter.goToRoot()
				coordinator.discoverCoordinator.navigationRouter.navigateTo(.diningView)
			}
		}
	}

	struct OpenDiscoverShorexListCommand: NavigationCommandProtocol {
		func execute(on coordinator: AppCoordinator) {
			if coordinator.homeTabBarCoordinator.selectedTab != .discover(section: .shoreThings) {
				coordinator.homeTabBarCoordinator.selectedTab = .discover(section: .shoreThings)
			} else {
				coordinator.discoverCoordinator.navigationRouter.goToRoot()
				coordinator.discoverCoordinator.navigationRouter.navigateTo(.shoreThings)
			}
		}
	}
    
    struct OpenMeAgendaSpecificDateCommand: NavigationCommandProtocol {
        let date: Date
        
        func execute(on coordinator: AppCoordinator) {
            if coordinator.homeTabBarCoordinator.selectedTab != .me(section: .agendaOnSpecificDate(date: date)) {
                coordinator.homeTabBarCoordinator.selectedTab = .me(section: .agendaOnSpecificDate(date: date))
                coordinator.homeTabBarCoordinator.meCoordinator.navigationRouter.goToRoot()
            } else {
                coordinator.homeTabBarCoordinator.meCoordinator.navigationRouter.goToRoot()
            }
        }
    }
    
	struct OpenDiscoverTreatmentsListCommand: NavigationCommandProtocol {
		func execute(on coordinator: AppCoordinator) {
			if coordinator.homeTabBarCoordinator.selectedTab != .discover(section: .shipSpaceCategoryView(shipSpace: "Beauty---Body")) {
				coordinator.homeTabBarCoordinator.selectedTab = .discover(section: .shipSpaceCategoryView(shipSpace: "Beauty---Body"))
			} else {
				coordinator.discoverCoordinator.navigationRouter.goToRoot()
				coordinator.discoverCoordinator.navigationRouter.navigateTo(.shipSpaceCategoryView(categoryCode: "Beauty---Body"))
			}
		}
	}
    
    struct RemoveReceipScreenCommand: NavigationCommandProtocol {
        func execute(on coordinator: AppCoordinator) {
            switch coordinator.homeTabBarCoordinator.selectedTab {
            case .discover(section: _):
                coordinator.discoverCoordinator.navigationRouter.navigateBack()
            case .me(section: _):
                coordinator.homeTabBarCoordinator.meCoordinator.navigationRouter.navigateBack()
            case .dashboard:
                coordinator.homeTabBarCoordinator.homeDashboardCoordinator.navigationRouter.navigateBack()
            default: break
            }
            
        }
    }

	struct OpenSetPinCommand: NavigationCommandProtocol {
		func execute(on coordinator: AppCoordinator) {
			coordinator.homeTabBarCoordinator.meCoordinator.navigationRouter.navigateTo(.setPin)
		}
	}
}


enum HomeSheetRoute: BaseSheetRouter {
    case addAFriend

    var id: String {
        switch self {
        case .addAFriend:
            return "addAFriend"
        }
    }
}
