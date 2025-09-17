//
//  ShakeForChampagne.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 24.6.25.
//

import Foundation

struct ShakeForChampagne {
    let title: String
    let description: String
    let champagne: Champagne
    let champagneState: ChampagneState
    let taxExplanationText: String
    let confirmationTitle: String
    let confirmationDescription: String
    let confirmationDeliveryDescription: String
    let confirmationHeaderText: String
    let quote: Quote
    let cancellation: Cancellation
    let cancellationActionText: String
    let permission: Permission

    struct Champagne: Equatable, Hashable {
        let name: String
        let price: Double
        let currency: String
        let minQuantity: Int
        let maxQuantity: Int
    }

    struct ChampagneState: Equatable, Hashable {
        let state: Status
        let message: String
        let actionText: String
    }

    enum Status: String, Equatable {
        case available
        case unavailable
        case restricted
        case closed
        case under21
        case locationNotFound
        case orderInProgress
        case orderDelivered
        case orderCancelled
    }

    struct Quote: Equatable, Hashable {
        let author: String
        let text: String
    }

    struct Cancellation: Equatable, Hashable {
        let title: String
        let description: String
        let cancelButton: String
        let continueButton: String
        let successMessage: String
        let successHeader: String
        let successActionText: String
    }

    struct Permission: Equatable, Hashable {
        let description: String
    }
}

extension ShakeForChampagne {
    static func sample() -> ShakeForChampagne {
        ShakeForChampagne(
            title: "FEELIN' BUBBLY?",
            description: "SUMMON CHAMPAGNE",
            champagne: Champagne(
                name: "Möet Chandon Impérial®",
                price: 100,
                currency: "$",
                minQuantity: 1,
                maxQuantity: 3
            ),
            champagneState: ChampagneState(
                state: .available,
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

    static func empty() -> ShakeForChampagne {
        ShakeForChampagne(
            title: "",
            description: "",
            champagne: Champagne(name: "", price: 0, currency: "", minQuantity: 0, maxQuantity: 0),
            champagneState: ChampagneState(state: .closed, message: "", actionText: ""),
            taxExplanationText: "",
            confirmationTitle: "",
            confirmationDescription: "",
            confirmationDeliveryDescription: "",
            confirmationHeaderText: "",
            quote: Quote(author: "", text: ""),
            cancellation: Cancellation(
                title: "", description: "", cancelButton: "", continueButton: "",
                successMessage: "", successHeader: "", successActionText: ""
            ),
            cancellationActionText: "",
            permission: Permission(description: "")
        )
    }
    
    func copy(
            title: String? = nil,
            description: String? = nil,
            champagne: Champagne? = nil,
            champagneState: ChampagneState? = nil,
            taxExplanationText: String? = nil,
            confirmationTitle: String? = nil,
            confirmationDescription: String? = nil,
            confirmationDeliveryDescription: String? = nil,
            confirmationHeaderText: String? = nil,
            quote: Quote? = nil,
            cancellation: Cancellation? = nil,
            cancellationActionText: String? = nil,
            permission: Permission? = nil
        ) -> ShakeForChampagne {
            return ShakeForChampagne(
                title: title ?? self.title,
                description: description ?? self.description,
                champagne: champagne ?? self.champagne,
                champagneState: champagneState ?? self.champagneState,
                taxExplanationText: taxExplanationText ?? self.taxExplanationText,
                confirmationTitle: confirmationTitle ?? self.confirmationTitle,
                confirmationDescription: confirmationDescription ?? self.confirmationDescription,
                confirmationDeliveryDescription: confirmationDeliveryDescription ?? self.confirmationDeliveryDescription,
                confirmationHeaderText: confirmationHeaderText ?? self.confirmationHeaderText,
                quote: quote ?? self.quote,
                cancellation: cancellation ?? self.cancellation,
                cancellationActionText: cancellationActionText ?? self.cancellationActionText,
                permission: permission ?? self.permission
            )
        }
}

extension ShakeForChampagne.ChampagneState {
    func copy(
        state: ShakeForChampagne.Status? = nil,
        message: String? = nil,
        actionText: String? = nil
    ) -> ShakeForChampagne.ChampagneState {
        return ShakeForChampagne.ChampagneState(
            state: state ?? self.state,
            message: message ?? self.message,
            actionText: actionText ?? self.actionText
        )
    }
}
