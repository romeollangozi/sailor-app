//
//  DeepLinkNotificationDispatcher.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 5/7/25.
//

import Foundation

protocol DeepLinkNotificationDispatcherProtocol {
    func dispatch(userStatus: UserApplicationStatus, type: String, data: String)
}

struct DeepLinkNotificationDispatcher: DeepLinkNotificationDispatcherProtocol {
    private var handlers = [String: DeepLinkNotificationHandlerProtocol]()

    init() {
        registerS4C()
        registerSailor()
        registerEateries()
        registerEmbarkation()
        registerEntertainment()
        registerRTS()
        registerShoreExcursion()
        registerFolio()
		registerAddContact()
    }

    // MARK: - Dispatch
    func dispatch(userStatus: UserApplicationStatus, type: String, data: String) {
        
        if let handler = handlers[type] {
            if case UserApplicationStatus.userLoggedInWithReservation = userStatus {
                handler.handle(userStatus: userStatus,
                               type: type,
                               payload: data)
            }
        }
    }
}

extension DeepLinkNotificationDispatcher {
    // MARK: - Helpers
    private mutating func register(_ types: [DeepLinkNotificationType], handler: DeepLinkNotificationHandlerProtocol) {
        types.forEach { handlers[$0.rawValue] = handler }
    }

    // MARK: - Registrations

    private mutating func registerS4C() {
        register(
            [.s4cChampagneOrdered, .s4cChampagneDelivered, .s4cChampagneCancelled],
            handler: ShakeForChampagneDeepLinkNotificationHandler()
        )
    }

    private mutating func registerSailor() {
        register(
            [.sailorReviewAsk, .notificationManagement],
            handler: SailorDeepLinkNotificationHandler()
        )
    }

    private mutating func registerEateries() {
        register(
            [
                .remindDinningStartHalf,
                .travelpartyDinningCancelled,
                .travelpartyDinningBooked,
                .travelpartyDinningEdit,
                .voyagesDinningEdit,
                .voyagesDinningCancelled,
                .voyagesDinningBooked
            ],
            handler: EateryDeepLinkNotificationHandler()
        )
    }

    private mutating func registerEmbarkation() {
        register(
            [
                .guestTrackablePickup,
                .rtsCompleteSailingday,
                .rtsIncompleteHealthQuizSailingDay,
                .rtsIncompleteSailingday,
                .sailorMusterVideoNotWatched,
                .guestPostembarkationSafetyInstructions,
                .aciActiveboardingroupEmbarkday,
                .acisupervisorActiveboardingroupEmbarkday
            ],
            handler: EmbakationDeepLinkNotificationHandler()
        )
    }

    private mutating func registerEntertainment() {
        register(
            [
                .travelPartyPaidEventCancelled,
                .travelPartyPaidEventBooked,
                .travelPartyUnpaidEventIetBooked,
                .travelPartyUnpaidEventNetBooked,
                .remindInventoryPaidEventsBeforeHalfHour,
                .remindInventoryUnpaidEventsBeforeHalfHour,
                .remindNonInventoryEventsBeforeHalfHour,
                .remindSpaBeforeHalfHour,
                .voyagesSpaCancelled,
                .voyagesSpaBooked
            ],
            handler: EntertainmentDeepLinkNotificationHandler()
        )
    }

    private mutating func registerRTS() {
        register(
            [
                .rtsFourDaysAfterLogin,
                .rtsSevenDaysBeforeVoyage,
                .rtsOneDayAfterTask
            ],
            handler: RTSDeepLinkNotificationHandler()
        )
    }

    private mutating func registerShoreExcursion() {
        register(
            [
                .voyagesPaExperienceUpdateMeetingLocation,
                .arsCrewBookings,
                .travelpartyExcursionCancelled,
                .voyagesExcursionCancelled,
                .voyagesExcursionBooked,
                .travelpartyExcursionEdit,
                .portopenBookingAvailable,
                .remindActivityStartQuarterly,
                .travelpartyExcursionBooked,
                .remindActivityStartHourly,
                .voyagesPaExperienceUpdateMeetingTimelocation,
                .voyagesExperienceUpdateMeetingTimelocation,
                .voyagesRtExperienceUpdateMeetingTimelocation,
                .voyagesIetExperienceUpdateMeetingTimelocation,
                .voyagesNetExperienceUpdateMeetingTimelocation,
                .voyagesPaidHardClash
            ],
            handler: ShoreExcursionDeepLinkNotificationHandler()
        )
    }

    private mutating func registerFolio() {
        register(
            [.folioSailorPayer, .folioSailorCash],
            handler: FolioDeepLinkNotificationHandler()
        )
    }

	private mutating func registerAddContact() {
		register(
			[.addContacts],
			handler: AddContactDeepLinkNotificationHandler()
		)
	}
}
