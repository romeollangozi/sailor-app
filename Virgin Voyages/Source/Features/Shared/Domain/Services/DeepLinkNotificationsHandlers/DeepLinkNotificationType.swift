//
//  DeepLinkNotificationType.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 5/8/25.
//

import Foundation

enum DeepLinkNotificationType: String {
    
    // MARK: - S4C
    case s4cChampagneOrdered = "s4c.champagneOrdered"
    case s4cChampagneDelivered = "s4c.champagneDelivered"
    case s4cChampagneCancelled = "s4c.champagneCancelled"
    
    // MARK: - Message
    case notificationManagement = "notification.management"
    
    // MARK: - Sailor
    case sailorReviewAsk = "sailor.review.ask"
    
    // MARK: - Eateries
    case remindDinningStartHalf = "remind.dinning.start.half"
    case travelpartyDinningCancelled = "travelparty.dinning.cancelled"
    case travelpartyDinningBooked = "travelparty.dinning.booked"
    case travelpartyDinningEdit = "travelparty.dinning.edit"
    case voyagesDinningEdit = "voyages.dinning.edit"
    case voyagesDinningCancelled = "voyages.dinning.cancelled"
    case voyagesDinningBooked = "voyages.dinning.booked"
    
    // MARK: - Embarkation
    case guestTrackablePickup = "guest.trackable.pickup"
    case rtsCompleteSailingday = "rts.complete.sailingday"
    case rtsIncompleteHealthQuizSailingDay = "rts.incomplete.healthquiz.sailingday"
    case rtsIncompleteSailingday = "rts.incomplete.sailingday"
    case sailorMusterVideoNotWatched = "sailor.muster-video.not-watched"
    case guestPostembarkationSafetyInstructions = "guest.postembarkation.safety.instructions"
    case aciActiveboardingroupEmbarkday = "aci.activeboardingroup.embarkday"
    case acisupervisorActiveboardingroupEmbarkday = "acisupervisor.activeboardingroup.embarkday"

    // MARK: - Entertainment
    case travelPartyPaidEventCancelled = "travelparty.paidevent.cancelled"
    case travelPartyPaidEventBooked = "travelparty.paidevent.booked"
    case travelPartyUnpaidEventIetBooked = "travelparty.unpaidevent.iet.booked"
    case remindInventoryPaidEventsBeforeHalfHour = "remind.inventory.paid.events.before.half.hour"
    case remindInventoryUnpaidEventsBeforeHalfHour = "remind.inventory.unpaid.events.before.half.hour"
    case remindNonInventoryEventsBeforeHalfHour = "remind.non.inventory.events.before.half.hour"
    case remindSpaBeforeHalfHour = "remind.spa.before.half.hour"
    case voyagesSpaCancelled = "voyages.spa.cancelled"
    case voyagesSpaBooked = "voyages.spa.booked"
    case travelPartyUnpaidEventNetBooked = "travelparty.unpaidevent.net.booked"

    // MARK: - RTS
    case rtsFourDaysAfterLogin = "rts.fourdays.afterlogin"
    case rtsSevenDaysBeforeVoyage = "rts.sevendays.beforevoyage"
    case rtsOneDayAfterTask = "rts.onedays.aftertask"

    // MARK: - Shore Ex
    case voyagesPaExperienceUpdateMeetingLocation = "voyages.pa.experience.update.meeting.location"
    case arsCrewBookings = "ars.crew.bookings"
    case travelpartyExcursionCancelled = "travelparty.excursion.cancelled"
    case voyagesExcursionCancelled = "voyages.excursion.cancelled"
    case voyagesExcursionBooked = "voyages.excursion.booked"
    case travelpartyExcursionEdit = "travelparty.excursion.edit"
    case portopenBookingAvailable = "portopen.booking.available"
    case remindActivityStartQuarterly = "remind.activity.start.quarterly"
    case travelpartyExcursionBooked = "travelparty.excursion.booked"
    case remindActivityStartHourly = "remind.activity.start.hourly"
    case voyagesPaExperienceUpdateMeetingTimelocation = "voyages.pa.experience.update.meeting.timelocation"
    case voyagesExperienceUpdateMeetingTimelocation = "voyages.experience.update.meeting.timelocation"
    case voyagesRtExperienceUpdateMeetingTimelocation = "voyages.rt.experience.update.meeting.timelocation"
    case voyagesIetExperienceUpdateMeetingTimelocation = "voyages.iet.experience.update.meeting.timelocation"
    case voyagesNetExperienceUpdateMeetingTimelocation = "voyages.net.experience.update.meeting.timelocation"
    case voyagesPaidHardClash = "voyages.paid.hard.clash"

    // MARK: - Finance
    case folioSailorPayer = "Folio.Sailor.Payer"
    case folioSailorCash = "Folio.Sailor.Cash"

	// MARK: - AddContacts
	case addContacts = "add.contact"
}
