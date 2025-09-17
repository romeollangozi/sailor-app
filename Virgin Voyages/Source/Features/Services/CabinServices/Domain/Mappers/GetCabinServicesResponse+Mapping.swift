//
//  GetCabinServicesResponse+Mapping.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 4/22/25.
//

import Foundation

extension GetCabinServicesResponse {
    
    func toDomain() -> CabinService {
        
        var cabinServiceItems: [CabinService.CabinServiceItem] = []
        
        if let responseCabinServiceItems = self.items {
            responseCabinServiceItems.forEach {
                cabinServiceItems.append($0.toDomain())
            }
        }
        
        return CabinService(items: cabinServiceItems,
                            title: title ?? "",
                            subTitle: subTitle ?? "",
                            backgroundImageURL: backgroundImageURL ?? "",
                            leadTime: CabinService.LeadTime(title: leadTime?.title ?? "",
                                                            imageUrl: leadTime?.imageUrl ?? "",
                                                            description: leadTime?.description ?? ""))
        
    }
    
}


extension GetCabinServicesResponse.CabinServiceItem {
    
    func toDomain() -> CabinService.CabinServiceItem {
        
        var cabinServiceItemOptions: [CabinService.CabinServiceItem.OptionItem] = []
        
        if let options = self.options {
            options.forEach {
                cabinServiceItemOptions.append($0.toDomain())
            }
        }
        
        return CabinService.CabinServiceItem(id: id ?? "",
                                             name: name ?? "",
                                             status: StatusType(rawValue: status ?? "") ?? .default,
                                             requestId: requestId ?? "",
                                             imageUrl: imageUrl ?? "",
                                             designStyle: DesignStyleType(rawValue: designStyle ?? "") ?? .normal,
                                             options: cabinServiceItemOptions,
                                             optionsTitle: optionsTitle ?? "",
                                             optionsDescription: optionsDescription ?? "",
                                             confirmationCta: confirmationCta ?? "",
                                             confirmationTitle: confirmationTitle ?? "",
                                             confirmationDescription: confirmationDescription ?? "")
        
    }
    
}

extension GetCabinServicesResponse.CabinServiceItem.OptionItem {
    
    func toDomain() -> CabinService.CabinServiceItem.OptionItem {
        
        return CabinService.CabinServiceItem.OptionItem(id: id ?? "",
                                                        name: name ?? "",
                                                        icon: icon ?? "",
                                                        status: StatusType(rawValue: status ?? "") ?? .default,
                                                        requestId: requestId ?? "")
        
    }
    
}
