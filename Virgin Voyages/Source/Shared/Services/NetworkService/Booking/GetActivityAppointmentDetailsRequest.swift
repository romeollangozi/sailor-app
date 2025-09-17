//
//  GetActivityAppointmentDetailsRequest.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 22.11.24.
//

struct GetActivityAppointmentDetailsRequest: AuthenticatedHTTPRequestProtocol {
    let appointmentId: String
    
    var path: String {
        return NetworkServiceEndpoint.activityAppointmentDetails + "/\(appointmentId)"
    }
    var method: HTTPMethod {
        return .GET
    }
    var headers: (any HTTPHeadersProtocol)? {
        return JSONContentTypeHeader()
    }
}

struct GetActivityAppointmentDetailsResponse: Codable {

    struct Reminder: Codable {
        let iconUrl: String?
        let name: String?
    }
    
    struct ActivitySlot: Codable {
        struct ActivitySellingPrice: Codable {
            struct AgeGroup: Codable {
                let maxRange: Int?
                let minRange: Int?
            }
            let ageGroup: AgeGroup?
            let amount: Int?
            let levelType: String?
            let levelValue: String?
            let personType: String?
        }
        
        let activitySlotCode: String?
        let activitySellingPrices: [ActivitySellingPrice]?
        let duration: Int?
        let endDate: String?
        let isEnabled: Bool?
        let isInventoryAvailable: Bool?
        let inventoryCount: Int?
        let meetingTime: String?
        let startDate: String?
        let meetingLocation: String?
        let deckLocation: String?
        let isBookingClosed: Bool?
        let isHideEndTime: Bool?
    }
    
    struct AppointmentDetail: Codable {
        struct GuestDetail: Codable {
            let guestId: String?
            let reservationGuestId: String?
            let reservationNumber: String?
            let profilePhotoMediaItemUrl: String?
        }
        
        let appointmentId: String?
        let bookedAmount: Int?
        let refundAmount: Int?
        let guestDetails: [GuestDetail]?
        let appointmentLinkId: String?
        let currencyCode: String?
    }
    
    struct DiningEditContent: Codable {
        let cancel: CancelContent?
        let edit: EditContent?
        
        struct CancelContent: Codable {
            let secondaryDescription: String?
            let header: String?
            let wholeGroupText: String?
            let primaryDescription: String?
            let confirmation: ConfirmationContent?
            
            struct ConfirmationContent: Codable {
                let header: String?
                let description: String?
            }
        }
        
        struct EditContent: Codable {
            let backIconUrl: String?
            let lockIconUrl: String?
            let title: String?
            let selfBooking: BookingContent?
            let otherBooking: BookingContent?
            
            struct BookingContent: Codable {
                let header: String?
                let description: String?
            }
        }
    }
    
    let displayName: String?
    let imageUrl: String?
    let duration: Int?
    let currencyCode: String?
    let activityCode: String?
    let activitySlotCode: String?
    let meetingPlaceName: String?
    let portCode: String?
    let portName: String?
    let startTime: String?
    let instructionDetails: [String]?
    let isWaiverSigned: Bool?
    let activitySlots: [ActivitySlot]?
    let isMultipleBookingAllowed: Bool?
    let isNotifyEnabled: Bool?
    let longDescription: String?
    let categoryCode: String?
    let cancelConfirmationImage: String?
    let activityPictogram: String?
    let appointmentDetails: [AppointmentDetail]?
    let reminders: [Reminder]?
    let waiverCode: String?
    let waiverOpeningDuration: Int?
    let activityLocation: String?
    let confirmationImage: String?
    let disclaimers: [String]?
    let isPreVoyageEditingStopped: Bool?
    let activityTypes: [String]?
    let extraGuestCount: Int?
    let highlightDetails: [String]?
    let actionUrl: String?
    let isWithinCancellationWindow: Bool?
    let differenceInMinutes: Int?
    let activityTime: Int?
    let activityLocalTime: Int?
    let isPrecruise: Bool?
    let isSocialGroupBooking: Bool?
    let isSlotsFromSw: Bool?
    let activityLevel: String?
    let diningEditContent: DiningEditContent?
}


extension NetworkServiceProtocol {
    func getGetActivityAppointmentDetails(appointmentId: String) async throws -> GetActivityAppointmentDetailsResponse? {
        let request = GetActivityAppointmentDetailsRequest(appointmentId: appointmentId)
        return try await self.requestV2(request, responseModel: GetActivityAppointmentDetailsResponse.self)
    }
}
