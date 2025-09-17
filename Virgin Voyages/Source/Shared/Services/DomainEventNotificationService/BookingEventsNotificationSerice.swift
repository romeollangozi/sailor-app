//
//  bookingEventsNotificationService.swift
//  Virgin Voyages
//
//  Created by TX on 25.4.25.
//


enum BookingEventNotification: Hashable {
	case userDidMakeABooking(activityCode: String, activitySlotCode: String)
    case userDidUpdateABooking(activityCode: String, activitySlotCode: String, appointmentId: String)
    case userDidCancelABooking(appointmentLinkId: String)
}

class BookingEventsNotificationService: DomainNotificationService<BookingEventNotification> {
    static let shared = BookingEventsNotificationService()
}
