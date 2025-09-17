//
//  ActivityAppointmentDetails.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 22.11.24.
//

import Foundation

struct ShoreThingsAppointmentDetails {
    
    struct Reminder {
        let iconUrl: String
        let name: String
    }
    
    struct ActivitySlot {
        struct ActivitySellingPrice {
            struct AgeGroup {
                let maxRange: Int
                let minRange: Int
            }
            let ageGroup: AgeGroup
            let amount: Int
            let levelType: String
            let levelValue: String
            let personType: String
        }
        
        let activitySlotCode: String
        let activitySellingPrices: [ActivitySellingPrice]
        let duration: Int
        let endDate: String
        let isEnabled: Bool
        let isInventoryAvailable: Bool
        let inventoryCount: Int
        let meetingTime: String
        let startDate: String
        let meetingLocation: String
        let deckLocation: String
        let isBookingClosed: Bool
        let isHideEndTime: Bool
    }
    
    struct AppointmentDetail{
        struct GuestDetail{
            let guestId: String
            let reservationGuestId: String
            let reservationNumber: String
            let profilePhotoMediaItemUrl: String?
        }
        
        let appointmentId: String
        let bookedAmount: Int
        let refundAmount: Int
        let guestDetails: [GuestDetail]
        let appointmentLinkId: String
        let currencyCode: String
    }
    
    struct DiningEditContent {
        let cancel: CancelContent
        let edit: EditContent
        
        struct CancelContent {
            let secondaryDescription: String
            let header: String
            let wholeGroupText: String
            let primaryDescription: String
            let confirmation: ConfirmationContent
            
            struct ConfirmationContent: Codable {
                let header: String
                let description: String
            }
        }
        
        struct EditContent {
            let backIconUrl: String
            let lockIconUrl: String
            let title: String
            let selfBooking: BookingContent
            let otherBooking: BookingContent
            
            struct BookingContent {
                let header: String
                let description: String
            }
        }
    }
    
    let displayName: String
    let imageUrl: String
    let duration: Int
    let currencyCode: String
    let activityCode: String
    let activitySlotCode: String
    let meetingPlaceName: String
    let portCode: String
    let portName: String
    let startTime: Date?
    let instructionDetails: [String]
    let isWaiverSigned: Bool
    let activitySlots: [ActivitySlot]
    let isMultipleBookingAllowed: Bool
    let isNotifyEnabled: Bool
    let longDescription: String
    let categoryCode: String
    let cancelConfirmationImage: String
    let activityPictogram: String
    let appointmentDetails: [AppointmentDetail]
    let reminders: [Reminder]
    let waiverCode: String
    let waiverOpeningDuration: Int
    let activityLocation: String
    let confirmationImage: String
    let disclaimers: [String]
    let isPreVoyageEditingStopped: Bool
    let activityTypes: [String]
    let extraGuestCount: Int
    let highlightDetails: [String]
    let actionUrl: String
    let isWithinCancellationWindow: Bool
    let differenceInMinutes: Int
    let activityTime: Int
    let activityLocalTime: Int
    let isPrecruise: Bool
    let isSocialGroupBooking: Bool
    let isSlotsFromSw: Bool
    let activityLevel: String?
    let diningEditContent: DiningEditContent?
}

extension ShoreThingsAppointmentDetails {
    static func map(from response: GetActivityAppointmentDetailsResponse) -> ShoreThingsAppointmentDetails {
        return ShoreThingsAppointmentDetails(
            displayName: response.displayName.value,
            imageUrl: response.imageUrl.value,
            duration: response.duration.value,
            currencyCode: response.currencyCode.value,
            activityCode: response.activityCode.value,
            activitySlotCode: response.activitySlotCode.value,
            meetingPlaceName: response.meetingPlaceName.value,
            portCode: response.portCode.value,
            portName: response.portName.value,
			startTime: Date.fromISOString(string: response.startTime),
            instructionDetails: response.instructionDetails ?? [],
            isWaiverSigned: response.isWaiverSigned.value,
            activitySlots: (response.activitySlots ?? []).map { slot in
                ShoreThingsAppointmentDetails.ActivitySlot(
                    activitySlotCode: slot.activitySlotCode.value,
                    activitySellingPrices: (slot.activitySellingPrices ?? []).map { price in
                        ShoreThingsAppointmentDetails.ActivitySlot.ActivitySellingPrice(
                            ageGroup: ActivitySlot.ActivitySellingPrice.AgeGroup(
                                maxRange: price.ageGroup?.maxRange ?? 0,
                                minRange: price.ageGroup?.minRange ?? 0
                            ),
                            amount: price.amount.value,
                            levelType: price.levelType.value,
                            levelValue: price.levelValue.value,
                            personType: price.personType.value
                        )
                    },
                    duration: slot.duration.value,
                    endDate: slot.endDate.value,
                    isEnabled: slot.isEnabled.value,
                    isInventoryAvailable: slot.isInventoryAvailable.value,
                    inventoryCount: slot.inventoryCount.value,
                    meetingTime: slot.meetingTime.value,
                    startDate: slot.startDate.value,
                    meetingLocation: slot.meetingLocation.value,
                    deckLocation: slot.deckLocation.value,
                    isBookingClosed: slot.isBookingClosed.value,
                    isHideEndTime: slot.isHideEndTime.value
                )
            },
            isMultipleBookingAllowed: response.isMultipleBookingAllowed.value,
            isNotifyEnabled: response.isNotifyEnabled.value,
            longDescription: response.longDescription.value,
            categoryCode: response.categoryCode.value,
            cancelConfirmationImage: response.cancelConfirmationImage.value,
            activityPictogram: response.activityPictogram.value,
            appointmentDetails: (response.appointmentDetails ?? []).map { detail in
                ShoreThingsAppointmentDetails.AppointmentDetail(
                    appointmentId: detail.appointmentId.value,
                    bookedAmount: detail.bookedAmount.value,
                    refundAmount: detail.refundAmount.value,
                    guestDetails: (detail.guestDetails ?? []).map { guest in
                        AppointmentDetail.GuestDetail(
                            guestId: guest.guestId.value,
                            reservationGuestId: guest.reservationGuestId.value,
                            reservationNumber: guest.reservationNumber.value,
                            profilePhotoMediaItemUrl: guest.profilePhotoMediaItemUrl
                        )
                    },
                    appointmentLinkId: detail.appointmentLinkId.value,
                    currencyCode: detail.currencyCode.value
                )
            },
            reminders: (response.reminders ?? []).map { reminder in
                ShoreThingsAppointmentDetails.Reminder(
                    iconUrl: reminder.iconUrl.value,
                    name: reminder.name.value
                )
            },
            waiverCode: response.waiverCode.value,
            waiverOpeningDuration: response.waiverOpeningDuration.value,
            activityLocation: response.activityLocation.value,
            confirmationImage: response.confirmationImage.value,
            disclaimers: response.disclaimers ?? [],
            isPreVoyageEditingStopped: response.isPreVoyageEditingStopped.value,
            activityTypes: response.activityTypes ?? [],
            extraGuestCount: response.extraGuestCount.value,
            highlightDetails: response.highlightDetails ?? [],
            actionUrl: response.actionUrl.value,
            isWithinCancellationWindow: response.isWithinCancellationWindow.value,
            differenceInMinutes: response.differenceInMinutes.value,
            activityTime: response.activityTime.value,
            activityLocalTime: response.activityLocalTime.value,
            isPrecruise: response.isPrecruise.value,
            isSocialGroupBooking: response.isSocialGroupBooking.value,
            isSlotsFromSw: response.isSlotsFromSw.value,
            activityLevel: response.activityLevel,
            diningEditContent: response.diningEditContent != nil
            ? ShoreThingsAppointmentDetails.DiningEditContent(
                cancel: response.diningEditContent?.cancel != nil
                ? ShoreThingsAppointmentDetails.DiningEditContent.CancelContent(
                    secondaryDescription: response.diningEditContent?.cancel?.secondaryDescription ?? "",
                    header: response.diningEditContent?.cancel?.header ?? "",
                    wholeGroupText: response.diningEditContent?.cancel?.wholeGroupText ?? "",
                    primaryDescription: response.diningEditContent?.cancel?.primaryDescription ?? "",
                    confirmation: response.diningEditContent?.cancel?.confirmation != nil
                    ? ShoreThingsAppointmentDetails.DiningEditContent.CancelContent.ConfirmationContent(
                        header: response.diningEditContent?.cancel?.confirmation?.header ?? "",
                        description: response.diningEditContent?.cancel?.confirmation?.description ?? ""
                    )
                    : ShoreThingsAppointmentDetails.DiningEditContent.CancelContent.ConfirmationContent(
                        header: "",
                        description: ""
                    )
                )
                : ShoreThingsAppointmentDetails.DiningEditContent.CancelContent(
                    secondaryDescription: "",
                    header: "",
                    wholeGroupText: "",
                    primaryDescription: "",
                    confirmation: ShoreThingsAppointmentDetails.DiningEditContent.CancelContent.ConfirmationContent(
                        header: "",
                        description: ""
                    )
                ),
                edit: response.diningEditContent?.edit != nil
                ? ShoreThingsAppointmentDetails.DiningEditContent.EditContent(
                    backIconUrl: response.diningEditContent?.edit?.backIconUrl ?? "",
                    lockIconUrl: response.diningEditContent?.edit?.lockIconUrl ?? "",
                    title: response.diningEditContent?.edit?.title ?? "",
                    selfBooking: response.diningEditContent?.edit?.selfBooking != nil
                    ? ShoreThingsAppointmentDetails.DiningEditContent.EditContent.BookingContent(
                        header: response.diningEditContent?.edit?.selfBooking?.header ?? "",
                        description: response.diningEditContent?.edit?.selfBooking?.description ?? ""
                    )
                    : ShoreThingsAppointmentDetails.DiningEditContent.EditContent.BookingContent(
                        header: "",
                        description: ""
                    ),
                    otherBooking: response.diningEditContent?.edit?.otherBooking != nil
                    ? ShoreThingsAppointmentDetails.DiningEditContent.EditContent.BookingContent(
                        header: response.diningEditContent?.edit?.otherBooking?.header ?? "",
                        description: response.diningEditContent?.edit?.otherBooking?.description ?? ""
                    )
                    : ShoreThingsAppointmentDetails.DiningEditContent.EditContent.BookingContent(
                        header: "",
                        description: ""
                    )
                )
                : ShoreThingsAppointmentDetails.DiningEditContent.EditContent(
                    backIconUrl: "",
                    lockIconUrl: "",
                    title: "",
                    selfBooking: ShoreThingsAppointmentDetails.DiningEditContent.EditContent.BookingContent(
                        header: "",
                        description: ""
                    ),
                    otherBooking: ShoreThingsAppointmentDetails.DiningEditContent.EditContent.BookingContent(
                        header: "",
                        description: ""
                    )
                )
            )
            : nil
        )
    }
    
    static func sample() -> ShoreThingsAppointmentDetails {
        return ShoreThingsAppointmentDetails(
            displayName: "Snorkeling Adventure",
            imageUrl: "https://example.com/snorkeling.jpg",
            duration: 180,
            currencyCode: "USD",
            activityCode: "SNORK001",
            activitySlotCode: "SNORK-SLOT-001",
            meetingPlaceName: "Dock A",
            portCode: "MIA",
            portName: "Miami",
            startTime: ISO8601DateFormatter().date(from: "2024-11-27T08:00:00"),
            instructionDetails: [
                "Please bring a towel and sunscreen",
                "Wear comfortable clothes and swimwear"
            ],
            isWaiverSigned: false,
            activitySlots: [
                ShoreThingsAppointmentDetails.ActivitySlot(
                    activitySlotCode: "SNORK-SLOT-001",
                    activitySellingPrices: [
                        ShoreThingsAppointmentDetails.ActivitySlot.ActivitySellingPrice(
                            ageGroup: ShoreThingsAppointmentDetails.ActivitySlot.ActivitySellingPrice.AgeGroup(
                                maxRange: 65,
                                minRange: 18
                            ),
                            amount: 120,
                            levelType: "Standard",
                            levelValue: "Standard",
                            personType: "Adult"
                        )
                    ],
                    duration: 180,
                    endDate: "2024-11-27T11:00:00",
                    isEnabled: true,
                    isInventoryAvailable: true,
                    inventoryCount: 20,
                    meetingTime: "08:00",
                    startDate: "2024-11-27T08:00:00",
                    meetingLocation: "Dock A",
                    deckLocation: "Deck 5",
                    isBookingClosed: false,
                    isHideEndTime: false
                )
            ],
            isMultipleBookingAllowed: true,
            isNotifyEnabled: true,
            longDescription: "Enjoy a snorkeling adventure in crystal-clear waters with vibrant marine life.",
            categoryCode: "ADVENTURE",
            cancelConfirmationImage: "https://example.com/cancel.jpg",
            activityPictogram: "https://example.com/pictogram.png",
            appointmentDetails: [
                ShoreThingsAppointmentDetails.AppointmentDetail(
                    appointmentId: "APP001",
                    bookedAmount: 240,
                    refundAmount: 0,
                    guestDetails: [
                        ShoreThingsAppointmentDetails.AppointmentDetail.GuestDetail(
                            guestId: "GUEST001",
                            reservationGuestId: "RESG001",
                            reservationNumber: "RES12345",
                            profilePhotoMediaItemUrl: "https://example.com/guest1.jpg"
                        )
                    ],
                    appointmentLinkId: "LINK001",
                    currencyCode: "USD"
                )
            ],
            reminders: [
                ShoreThingsAppointmentDetails.Reminder(
                    iconUrl: "https://example.com/reminder1.png",
                    name: "Bring a towel"
                ),
                ShoreThingsAppointmentDetails.Reminder(
                    iconUrl: "https://example.com/reminder2.png",
                    name: "Wear sunscreen"
                )
            ],
            waiverCode: "WAIVER001",
            waiverOpeningDuration: 60,
            activityLocation: "Key Largo",
            confirmationImage: "https://example.com/confirmation.jpg",
            disclaimers: [
                "Weather conditions may affect the activity",
                "Participants must be in good health"
            ],
            isPreVoyageEditingStopped: false,
            activityTypes: ["Adventure", "Water Sports"],
            extraGuestCount: 1,
            highlightDetails: [
                "Explore vibrant coral reefs",
                "Spot tropical fish and marine life"
            ],
            actionUrl: "https://example.com/action",
            isWithinCancellationWindow: true,
            differenceInMinutes: 720,
            activityTime: 1700000000,
            activityLocalTime: 1700000000,
            isPrecruise: false,
            isSocialGroupBooking: false,
            isSlotsFromSw: true,
            activityLevel: nil,
            diningEditContent: nil
        )
    }
    
    func copy(
        displayName: String? = nil,
        imageUrl: String? = nil,
        duration: Int? = nil,
        currencyCode: String? = nil,
        activityCode: String? = nil,
        activitySlotCode: String? = nil,
        meetingPlaceName: String? = nil,
        portCode: String? = nil,
        portName: String? = nil,
        startTime: Date? = nil,
        instructionDetails: [String]? = nil,
        isWaiverSigned: Bool? = nil,
        activitySlots: [ActivitySlot]? = nil,
        isMultipleBookingAllowed: Bool? = nil,
        isNotifyEnabled: Bool? = nil,
        longDescription: String? = nil,
        categoryCode: String? = nil,
        cancelConfirmationImage: String? = nil,
        activityPictogram: String? = nil,
        appointmentDetails: [AppointmentDetail]? = nil,
        reminders: [Reminder]? = nil,
        waiverCode: String? = nil,
        waiverOpeningDuration: Int? = nil,
        activityLocation: String? = nil,
        confirmationImage: String? = nil,
        disclaimers: [String]? = nil,
        isPreVoyageEditingStopped: Bool? = nil,
        activityTypes: [String]? = nil,
        extraGuestCount: Int? = nil,
        highlightDetails: [String]? = nil,
        actionUrl: String? = nil,
        isWithinCancellationWindow: Bool? = nil,
        differenceInMinutes: Int? = nil,
        activityTime: Int? = nil,
        activityLocalTime: Int? = nil,
        isPrecruise: Bool? = nil,
        isSocialGroupBooking: Bool? = nil,
        isSlotsFromSw: Bool? = nil,
        activityLevel: String? = nil,
        diningEditContent: DiningEditContent? = nil
    ) -> ShoreThingsAppointmentDetails {
        return ShoreThingsAppointmentDetails(
            displayName: displayName ?? self.displayName,
            imageUrl: imageUrl ?? self.imageUrl,
            duration: duration ?? self.duration,
            currencyCode: currencyCode ?? self.currencyCode,
            activityCode: activityCode ?? self.activityCode,
            activitySlotCode: activitySlotCode ?? self.activitySlotCode,
            meetingPlaceName: meetingPlaceName ?? self.meetingPlaceName,
            portCode: portCode ?? self.portCode,
            portName: portName ?? self.portName,
            startTime: startTime ?? self.startTime,
            instructionDetails: instructionDetails ?? self.instructionDetails,
            isWaiverSigned: isWaiverSigned ?? self.isWaiverSigned,
            activitySlots: activitySlots ?? self.activitySlots,
            isMultipleBookingAllowed: isMultipleBookingAllowed ?? self.isMultipleBookingAllowed,
            isNotifyEnabled: isNotifyEnabled ?? self.isNotifyEnabled,
            longDescription: longDescription ?? self.longDescription,
            categoryCode: categoryCode ?? self.categoryCode,
            cancelConfirmationImage: cancelConfirmationImage ?? self.cancelConfirmationImage,
            activityPictogram: activityPictogram ?? self.activityPictogram,
            appointmentDetails: appointmentDetails ?? self.appointmentDetails,
            reminders: reminders ?? self.reminders,
            waiverCode: waiverCode ?? self.waiverCode,
            waiverOpeningDuration: waiverOpeningDuration ?? self.waiverOpeningDuration,
            activityLocation: activityLocation ?? self.activityLocation,
            confirmationImage: confirmationImage ?? self.confirmationImage,
            disclaimers: disclaimers ?? self.disclaimers,
            isPreVoyageEditingStopped: isPreVoyageEditingStopped ?? self.isPreVoyageEditingStopped,
            activityTypes: activityTypes ?? self.activityTypes,
            extraGuestCount: extraGuestCount ?? self.extraGuestCount,
            highlightDetails: highlightDetails ?? self.highlightDetails,
            actionUrl: actionUrl ?? self.actionUrl,
            isWithinCancellationWindow: isWithinCancellationWindow ?? self.isWithinCancellationWindow,
            differenceInMinutes: differenceInMinutes ?? self.differenceInMinutes,
            activityTime: activityTime ?? self.activityTime,
            activityLocalTime: activityLocalTime ?? self.activityLocalTime,
            isPrecruise: isPrecruise ?? self.isPrecruise,
            isSocialGroupBooking: isSocialGroupBooking ?? self.isSocialGroupBooking,
            isSlotsFromSw: isSlotsFromSw ?? self.isSlotsFromSw,
            activityLevel: activityLevel ?? self.activityLevel,
            diningEditContent: diningEditContent ?? self.diningEditContent
        )
    }
}
