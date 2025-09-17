//
//  GetHomeGeneralDataRequest.swift
//  Virgin Voyages
//
//  Created by TX on 12.3.25.
//

import Foundation

struct GetHomeGeneralDataRequest: AuthenticatedHTTPRequestProtocol {
    let input: GetHomeGeneralDataInput
    
    var path: String {
        return NetworkServiceEndpoint.getHomeGeneral
    }
    
    var method: HTTPMethod {
        return .GET
    }
    
    var headers: (any HTTPHeadersProtocol)? {
        return JSONContentTypeHeader()
    }
    
    var queryItems: [URLQueryItem]? {
        return [
            .init(name: "reservationNumber", value: input.reservationNumber),
            .init(name: "reservationGuestId", value: input.reservationGuestId),
            .init(name: "sailingMode", value: input.sailingMode)
        ]
    }
}

struct GetHomeGeneralDataInput {
    let reservationNumber: String
    let reservationGuestId: String
    let sailingMode: String
}

struct GetHomeGeneralDataResponse: Codable {
    let header: Header?
    let actions: [Action]?
    let merchandiseCarousel: [MerchandiseItem]?
    let addAFriend: SectionInfo?
    let addOnsPromo: AddOnsPromo?
    let musterDrill: MusterDrill?
    let plannerPreview: PlannerPreview?
    let myNextVirginVoyage: NextVoyage?
    let footer: Footer?

    let order: [SectionKey]?
    
    struct Header: Codable {
        let topBar: TopBar?
        let headerTitle: String?
        let headerSubtitle: String?
        let backgroundImageUrl: String?
        let reservationNumber: String?
        let cabinNumber: String?
        let gangwayOpeningTime: String?
        let gangwayClosingTime: String?
        let shipTimeOffset: Int?
    }

    struct TopBar: Codable {
        let title: String?
        let subTitle: String?
    }

    struct Action: Codable {
        let type: String?
        let imageUrl: String?
        let title: String?
        let description: String?
    }

    struct MerchandiseItem: Codable {
        let title: String?
        let imageUrl: String?
        let color: String?
        let code: String?
    }

    struct SectionInfo: Codable {
        let title: String?
        let description: String?
        let thumbnailImageUrl: String?
    }
    
    struct AddOnsPromo: Codable {
        let title: String?
        let description: String?
        let imageUrl: String?
    }

    struct MusterDrill: Codable {
        let imageUrl: String?
        let title: String?
        let description: String?
    }
    
    struct PlannerPreview: Codable {
        let title: String?
        let description: String?
        let imageUrl: String?
    }
    
    struct NextVoyage: Codable {
        let dayRemaining: String?
        let title: String?
        let subTitle: String?
        let navigationUrl: String?
        let imageUrl: String?
    }

    struct Footer: Codable {
        let imageUrl: String?
        let title: String?
        let description: String?
    }
}


extension NetworkServiceProtocol {
    func getHomeGeneralContent(reservationNumber: String, reservationGuestId: String, sailingMode: String) async throws -> GetHomeGeneralDataResponse? {
        
        let request = GetHomeGeneralDataRequest(
            input: GetHomeGeneralDataInput(
                reservationNumber: reservationNumber,
                reservationGuestId: reservationGuestId,
                sailingMode: sailingMode
            )
        )
        
        return try await self.requestV2(request, responseModel: GetHomeGeneralDataResponse.self)
    }
}

// MARK: - Mock Response
extension GetHomeGeneralDataResponse {
    static func mock() -> GetHomeGeneralDataResponse {
        return GetHomeGeneralDataResponse(
            header: Header(
                topBar: TopBar(title: "Welcome Aboard", subTitle: "Your Adventure Begins"),
                headerTitle: "Virgin Voyages",
                headerSubtitle: "Set Sail for Paradise",
                backgroundImageUrl: "https://res.cloudinary.com/dtljonz0f/image/upload/c_auto,ar_4:3,w_3840,g_auto/f_auto/q_auto/v1/gc-v1/miami/miami_sunset_shutterstock_2289145067_wcmjjv?_a=BAVARSAP0",
                reservationNumber: "VV123456",
                cabinNumber: "A123",
                gangwayOpeningTime: "08:30 AM",
                gangwayClosingTime: "07:30 PM",
                shipTimeOffset: -300
            ),
            actions: [
                Action(
                    type: "Wallet",
                    imageUrl: "https://example.com/wallet.jpg",
                    title: "Your Wallet",
                    description: "View your onboard spending and balances."
                ),
                Action(
                    type: "HomeGuide",
                    imageUrl: "https://example.com/guide.jpg",
                    title: "Home Guide",
                    description: "Learn more about your voyage."
                )
            ],
            merchandiseCarousel: [
                MerchandiseItem(
                    title: "First merchandise title",
                    imageUrl: "https://example.com/icon1.png",
                    color: "#71D6E0",
                    code: "123"
                ),
                MerchandiseItem(
                    title: "Second merchandise title",
                    imageUrl: "https://example.com/icon2.png0",
                    color: "#CDB584",
                    code: "123"
                ),
                MerchandiseItem(
                    title: "Third merchandise title",
                    imageUrl: "https://example.com/icon3.png",
                    color: "#E0E0E0",
                    code: "123"
                )
            ],
            addAFriend: nil,
            addOnsPromo: AddOnsPromo(
                title: "Purchase Add-ons such as Bar Tab or WiFi upgrade",
                description: "View all Add-ons",
                imageUrl: "https://example.com/image.jpg"
            ),
            musterDrill: nil,
            plannerPreview: PlannerPreview(
                title: "Manage your bookings and view the Line-up",
                description: "Start planning",
                imageUrl: "https://example.com/line-up.jpg"
            ),
            myNextVirginVoyage: NextVoyage(dayRemaining: "10",
                                           title: "My Next Voyage",
                                           subTitle: "Exciting adventures await!!",
                                           navigationUrl: "https://example.com/next-voyage",
                                           imageUrl: "https://example.com/image.jpg"),
            footer: Footer(
                imageUrl: "https://example.com/footer-icon.png",
                title: "Bon Voyage!",
                description: "Enjoy your journey with Virgin Voyages"
            ),
            order: [.header, .actions, .notifications, .planner, .planAndBook, .merchandiseCarousel, .addAFriend, .addOnsPromo, .musterDrill, .plannerPreview, .myNextVirginVoyage, .footer]
        )
    }
}
