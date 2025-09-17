//
//  DiscoverCoordinator.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 2/4/25.
//

import SwiftUI
import Foundation

enum DiscoverNavigationRoute: BaseNavigationRoute {
	case addOnDetails(addOn: AddOn)
    case addOnDetailsByCode(code: String)
    case addOnList(code: String? = nil)
	case addOnReceipt(code: String)
	case shoreThings
	case shoreThingsList(portCode: String, arrivalDateTime: Date?, departureDateTime: Date?)
	case shoreThingItemDetails(shoreThingItem: ShoreThingItem)
    case shoreThingsReceiptView(appointmentId: String)
	case eventLandingView
	case eventDetailsView(event: LineUpEvents.EventItem)
	case eventReceiptDetailsView(id: String)
    case shipSpacesView
    case shipSpaceCategoryView(categoryCode: String)
    case shipSpaceDetailsView(shipSpace: ShipSpaceDetails)
    case diningView
    case treatmentDetails(treatmentId: String)
    case treatmentReceipt(appointmentId: String)
	case diningOpeningTimes(filter: EateriesSlotsInputModel)
	case diningDetails(slug: String, filter: EateriesSlotsInputModel? = nil)
	case diningReceipt(appointmentId: String)
}

enum DiscoverSheetRoute: BaseSheetRouter {
	case cancellationFlow(activity: any CancelBookableActivity)
    var id: String {
        switch self {
            case .cancellationFlow: "cancellationFlow"
		}
    }
}


@Observable class DiscoverCoordinator {

	var navigationRouter: NavigationRouter<DiscoverNavigationRoute>
    var sheetRouter: SheetRouter<DiscoverSheetRoute>

	init(navigationRouter: NavigationRouter<DiscoverNavigationRoute> = .init(),
         sheetRouter: SheetRouter<DiscoverSheetRoute> = .init()) {
        
		self.navigationRouter = navigationRouter
        self.sheetRouter = sheetRouter
    }
    
	func showCancellationFlow(activity: any CancelBookableActivity) {
        sheetRouter.present(sheet: .cancellationFlow(activity: activity))
    }
}


extension DiscoverSheetRoute: Hashable {
	static func == (lhs: DiscoverSheetRoute, rhs: DiscoverSheetRoute) -> Bool {
		switch (lhs, rhs) {
		case (.cancellationFlow(let a1), .cancellationFlow(let a2)):
			return a1.appointmentLinkId == a2.appointmentLinkId
		}
	}

	func hash(into hasher: inout Hasher) {
		switch self {
		case .cancellationFlow(let activity):
			hasher.combine("cancellationFlow")
			hasher.combine(activity.appointmentLinkId)
		}
	}
}
