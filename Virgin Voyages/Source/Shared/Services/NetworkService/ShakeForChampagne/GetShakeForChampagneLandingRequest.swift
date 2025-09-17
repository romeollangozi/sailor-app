//
//  GetShakeForChampagneLandingRequest.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 7/15/25.
//

import Foundation

struct GetShakeForChampagneLandingRequest: AuthenticatedHTTPRequestProtocol {
    
    let input: GetShakeForChampagneLandingInput
    
    var path: String {
        return NetworkServiceEndpoint.shakeForChampagneLanding
    }
    
    var method: HTTPMethod {
        return .GET
    }
    
    var headers: (any HTTPHeadersProtocol)? {
        return JSONContentTypeHeader()
    }
    
    var queryItems: [URLQueryItem]? {
        let reservationGuestIdQueryItem = URLQueryItem(name: "reservationGuestId", value: input.reservationGuestId)
        
        if let orderId = input.orderId {
            
            let orderIdURLQueryItem = URLQueryItem(name: "orderId", value: orderId)
            
            return [reservationGuestIdQueryItem, orderIdURLQueryItem]
        }
        
        return [reservationGuestIdQueryItem]
    }
}

struct GetShakeForChampagneLandingInput {
    let reservationGuestId: String
    let orderId: String?
}

struct GetShakeForChampagneLandingResponse: Decodable {
    let title: String?
    let description: String?
    let champagne: Champagne?
    let champagneState: ChampagneState?
    let taxExplanationText: String?
    let confirmationTitle: String?
    let confirmationDescription: String?
    let confirmationDeliveryDescription: String?
    let confirmationHeaderText: String?
    let quote: Quote?
    let cancellation: Cancellation?
    let cancellationActionText: String?
    let permission: Permission?

    struct Champagne: Decodable {
        let name: String?
        let price: Double?
        let currency: String?
        let minQuantity: Int?
        let maxQuantity: Int?
    }

    struct ChampagneState: Decodable {
        let state: String?
        let message: String?
        let actionText: String?
    }

    struct Quote: Decodable {
        let author: String?
        let text: String?
    }

    struct Cancellation: Decodable {
        let title: String?
        let description: String?
        let cancelButton: String?
        let continueButton: String?
        let successMessage: String?
        let successHeader: String?
        let successActionText: String?
    }

    struct Permission: Decodable {
        let description: String?
    }
}

// MARK: - NetworkServiceProtocol

extension NetworkServiceProtocol {
    
    func getShakeForChampagneLanding(reservationGuestId: String, orderId: String?) async throws -> GetShakeForChampagneLandingResponse? {
         
        let request = GetShakeForChampagneLandingRequest(input: GetShakeForChampagneLandingInput(reservationGuestId: reservationGuestId,
                                                                                                 orderId: orderId))
        
        return try await self.requestV2(request, responseModel: GetShakeForChampagneLandingResponse.self)
    }
    
}

// MARK: - Mock Response

extension GetShakeForChampagneLandingResponse {
    
    static func mock() -> GetShakeForChampagneLandingResponse {
        
        return GetShakeForChampagneLandingResponse(
            title: "FEELIN' BUBBLY?",
            description: "SUMMON CHAMPAGNE",
            champagne: Champagne(
                name: "Möet Chandon Impérial®",
                price: 100,
                currency: "$",
                minQuantity: 1,
                maxQuantity: 3
            ), champagneState: ChampagneState(
                state: "available",
                message: "Even Champagne needs a bit of downtime sometimes. Come back and shake again later.",
                actionText: "Explore bars"
            ),
            taxExplanationText: "Charges may be subject to local tax",
            confirmationTitle: "The Champagne",
            confirmationDescription: "is on its way to you",
            confirmationDeliveryDescription: "Has been delivered",
            confirmationHeaderText: "Stay Put",
            quote: Quote(
                author: "John Maynard Keynes",
                text: "My only regret in life is that I did not drink more Champagne"
            ),
            cancellation: Cancellation(
                title: "Changed your mind?",
                description: "Bubble not taking your fancy? Ordered a bottle you no longer need? No worries, you can cancel your order.",
                cancelButton: "Cancel my order",
                continueButton: "No, bring me bubbles",
                successMessage: "Your order has been cancelled. Come back and shake again later.",
                successHeader: "Hey sailor",
                successActionText: "Ok, got it"
            ),
            cancellationActionText: "I've changed my mind",
            permission: Permission(
                description: "It looks like we don't have permission to use some of your phone's functionality. We can't bring you champagne without these."
            )
        )
    }
    
}
