//
//  GetShakeForChampagneLandingResponse+Mapping.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 7/15/25.
//

import Foundation

extension GetShakeForChampagneLandingResponse {
    
    func toDomain() -> ShakeForChampagne {
        
        return ShakeForChampagne(title: self.title.value,
                                 description: self.description.value,
                                 champagne: self.champagne?.toDomain() ?? .empty(),
                                 champagneState: self.champagneState?.toDomain() ?? .empty(),
                                 taxExplanationText: self.taxExplanationText.value,
                                 confirmationTitle: self.confirmationTitle.value,
                                 confirmationDescription: self.confirmationDescription.value,
                                 confirmationDeliveryDescription: self.confirmationDeliveryDescription.value,
                                 confirmationHeaderText: self.confirmationHeaderText.value,
                                 quote: self.quote?.toDomain() ?? .empty(),
                                 cancellation: self.cancellation?.toDomain() ?? .empty(),
                                 cancellationActionText: self.cancellationActionText.value,
                                 permission: self.permission?.toDomain() ?? .empty())
    }
    
}

extension GetShakeForChampagneLandingResponse.Champagne {
    
    func toDomain() -> ShakeForChampagne.Champagne {
        
        return ShakeForChampagne.Champagne(name: self.name.value,
                                           price: self.price.value,
                                           currency: self.currency.value,
                                           minQuantity: self.minQuantity.value,
                                           maxQuantity: self.maxQuantity.value)
    }
    
}

extension GetShakeForChampagneLandingResponse.ChampagneState {
    
    func toDomain() -> ShakeForChampagne.ChampagneState {
        
        return ShakeForChampagne.ChampagneState(state: ShakeForChampagne.Status(rawValue: self.state.value) ?? .available,
                                                message: self.message.value,
                                                actionText: self.actionText.value)
    }
}

extension GetShakeForChampagneLandingResponse.Quote {
    
    func toDomain() -> ShakeForChampagne.Quote {
        
        return ShakeForChampagne.Quote(author: self.author.value,
                                       text: self.text.value)
    }
}

extension GetShakeForChampagneLandingResponse.Cancellation {
    
    func toDomain() -> ShakeForChampagne.Cancellation {
        
        return ShakeForChampagne.Cancellation(title: self.title.value,
                                              description: self.description.value,
                                              cancelButton: self.cancelButton.value,
                                              continueButton: self.continueButton.value,
                                              successMessage: self.successMessage.value,
                                              successHeader: self.successHeader.value,
                                              successActionText: self.successActionText.value)
    }
}

extension GetShakeForChampagneLandingResponse.Permission {
    
    func toDomain() -> ShakeForChampagne.Permission {
        
        return ShakeForChampagne.Permission(description: self.description.value)
    }
}

// MARK: - Empty objects

extension ShakeForChampagne.Champagne {
    
    static func empty() -> ShakeForChampagne.Champagne {
        
        ShakeForChampagne.Champagne(name: "",
                                    price: 0,
                                    currency: "",
                                    minQuantity: 0,
                                    maxQuantity: 0)
    }
    
}

extension ShakeForChampagne.ChampagneState {
    
    static func empty() -> ShakeForChampagne.ChampagneState {
        
        ShakeForChampagne.ChampagneState(state: .unavailable,
                                         message: "",
                                         actionText: "")
    }
}

extension ShakeForChampagne.Quote {
    
    static func empty() -> ShakeForChampagne.Quote {
        
        ShakeForChampagne.Quote(author: "",
                                text: "")
    }
}

extension ShakeForChampagne.Cancellation {
    
    static func empty() -> ShakeForChampagne.Cancellation {
        
        ShakeForChampagne.Cancellation(title: "",
                                       description: "",
                                       cancelButton: "",
                                       continueButton: "",
                                       successMessage: "",
                                       successHeader: "",
                                       successActionText: "")
    }
}

extension ShakeForChampagne.Permission {
    
    static func empty() -> ShakeForChampagne.Permission {
        
        ShakeForChampagne.Permission(description: "")
    }
}
