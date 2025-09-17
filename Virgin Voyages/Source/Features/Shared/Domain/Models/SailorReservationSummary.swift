//
//  SailorReservationSummary.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 14.11.24.
//

import Foundation

struct SailorReservationSummary {
    let voyageDetails: VoyageDetails
    let reservationId: String
    let reservationNumber: String
    let paymentStatusCode: String
    let reservationStatusCode: String
    let stateroomsDetail: [StateroomDetail]
    let guestCount: Int
    let guestsSummary: [GuestSummary]
    let links: Links
    
    struct VoyageDetails {
        let startDate: String
        let endDate: String
        let shipCode: String
        let shipName: String
        let voyageItinerary: VoyageItinerary
        let startDateTime: String
        let endDateTime: String
        let region: String?
        
        struct VoyageItinerary {
            let voyageName: String
            let voyageNumber: String
            let voyageId: String
            let packageCode: String
            let packageName: String
            let embarkDate: String
            let debarkDate: String
            let itineraryList: [ItineraryItem]
            
            struct ItineraryItem {
                let itineraryDay: Int
                let isSeaDay: Bool
                let portCode: String
            }
        }
    }
    
    struct StateroomDetail {
        let stateroom: String
        let deck: String
        let stateroomCategory: String
        let stateroomCategoryCode: String
        let additionalAttributeCodes: [String]
    }
    
    struct GuestSummary {
        let firstName: String
        let lastName: String
        let genderCode: String
        let birthDate: String
        let email: String
        let reservationGuestId: String
        let guestId: String
        let isPrimaryGuest: Bool
        let isVIP: Bool
        let totalPercentageCheckinStatus: Double
        let isGuestOnBoard: Bool
        let isResident: Bool
        let isValidated: Bool
        let stateroom: String
        let embarkDate: String
        let debarkDate: String
        let embarkPortCode: String
        let debarkPortCode: String
    }
    
    struct Links {
        let detailInfo: LinkDetail
        let selfLink: LinkDetail
        
        struct LinkDetail {
            let href: String
        }
    }
}

extension SailorReservationSummary {
    static func map(from response: GetSailorReservationSummaryResponse) -> SailorReservationSummary {
        return SailorReservationSummary(
            voyageDetails: VoyageDetails(
                startDate: response.voyageDetails?.startDate.value ?? "",
                endDate: response.voyageDetails?.endDate.value ?? "",
                shipCode: response.voyageDetails?.shipCode.value ?? "",
                shipName: response.voyageDetails?.shipName.value ?? "",
                voyageItinerary: VoyageDetails.VoyageItinerary(
                    voyageName: response.voyageDetails?.voyageItinerary?.voyageName.value ?? "",
                    voyageNumber: response.voyageDetails?.voyageItinerary?.voyageNumber.value ?? "",
                    voyageId: response.voyageDetails?.voyageItinerary?.voyageId.value ?? "",
                    packageCode: response.voyageDetails?.voyageItinerary?.packageCode.value ?? "",
                    packageName: response.voyageDetails?.voyageItinerary?.packageName.value ?? "",
                    embarkDate: response.voyageDetails?.voyageItinerary?.embarkDate.value ?? "",
                    debarkDate: response.voyageDetails?.voyageItinerary?.debarkDate.value ?? "",
                    itineraryList: response.voyageDetails?.voyageItinerary?.itineraryList?.map {
                        VoyageDetails.VoyageItinerary.ItineraryItem(
                            itineraryDay: $0.itineraryDay.value,
                            isSeaDay: $0.isSeaDay.value,
                            portCode: $0.portCode.value
                        )
                    } ?? []
                ),
                startDateTime: response.voyageDetails?.startDateTime.value ?? "",
                endDateTime: response.voyageDetails?.endDateTime.value ?? "",
                region: response.voyageDetails?.region.value ?? ""
            ),
            reservationId: response.reservationId.value,
            reservationNumber: response.reservationNumber.value,
            paymentStatusCode: response.paymentStatusCode.value,
            reservationStatusCode: response.reservationStatusCode.value,
            stateroomsDetail: response.stateroomsDetail?.map {
                StateroomDetail(
                    stateroom: $0.stateroom.value,
                    deck: $0.deck.value,
                    stateroomCategory: $0.stateroomCategory.value,
                    stateroomCategoryCode: $0.stateroomCategoryCode.value,
                    additionalAttributeCodes: $0.additionalAttributeCodes?.compactMap { $0 } ?? []
                )
            } ?? [],
            guestCount: response.guestCount ?? 0,
            guestsSummary: response.guestsSummary?.map {
                GuestSummary(
                    firstName: $0.firstName.value,
                    lastName: $0.lastName.value,
                    genderCode: $0.genderCode.value,
                    birthDate: $0.birthDate.value,
                    email: $0.email.value,
                    reservationGuestId: $0.reservationGuestId.value,
                    guestId: $0.guestId.value,
                    isPrimaryGuest: $0.isPrimaryGuest.value,
                    isVIP: $0.isVIP.value,
                    totalPercentageCheckinStatus: $0.totalPercentageCheckinStatus ?? 0.0,
                    isGuestOnBoard: $0.isGuestOnBoard.value,
                    isResident: $0.isResident.value,
                    isValidated: $0.isValidated.value,
                    stateroom: $0.stateroom.value,
                    embarkDate: $0.embarkDate.value,
                    debarkDate: $0.debarkDate.value,
                    embarkPortCode: $0.embarkPortCode.value,
                    debarkPortCode: $0.debarkPortCode.value
                )
            } ?? [],
            links: Links(
                detailInfo: Links.LinkDetail(
                    href: response._links?.detailInfo?.href.value ?? ""
                ),
                selfLink: Links.LinkDetail(
                    href: response._links?.selfLink?.href.value ?? ""
                )
            )
        )
    }
    
    static func empty() -> SailorReservationSummary {
        return SailorReservationSummary(
            voyageDetails: VoyageDetails(
                startDate: "",
                endDate: "",
                shipCode: "",
                shipName: "",
                voyageItinerary: VoyageDetails.VoyageItinerary(
                    voyageName: "",
                    voyageNumber: "",
                    voyageId: "",
                    packageCode: "",
                    packageName: "",
                    embarkDate: "",
                    debarkDate: "",
                    itineraryList: [
                        VoyageDetails.VoyageItinerary.ItineraryItem(
                            itineraryDay: 0,
                            isSeaDay: false,
                            portCode: ""
                        )
                    ]
                ),
                startDateTime: "",
                endDateTime: "",
                region: ""
            ),
            reservationId: "",
            reservationNumber: "",
            paymentStatusCode: "",
            reservationStatusCode: "",
            stateroomsDetail: [
                StateroomDetail(
                    stateroom: "",
                    deck: "",
                    stateroomCategory: "",
                    stateroomCategoryCode: "",
                    additionalAttributeCodes: []
                )
            ],
            guestCount: 0,
            guestsSummary: [
                GuestSummary(
                    firstName: "",
                    lastName: "",
                    genderCode: "",
                    birthDate: "",
                    email: "",
                    reservationGuestId: "",
                    guestId: "",
                    isPrimaryGuest: false,
                    isVIP: false,
                    totalPercentageCheckinStatus: 0.0,
                    isGuestOnBoard: false,
                    isResident: false,
                    isValidated: false,
                    stateroom: "",
                    embarkDate: "",
                    debarkDate: "",
                    embarkPortCode: "",
                    debarkPortCode: ""
                )
            ],
            links: Links(
                detailInfo: Links.LinkDetail(
                    href: ""
                ),
                selfLink: Links.LinkDetail(
                    href: ""
                )
            )
        )
    }
}
