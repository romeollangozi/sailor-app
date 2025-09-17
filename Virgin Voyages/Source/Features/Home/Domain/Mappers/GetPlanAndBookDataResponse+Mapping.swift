//
//  GetPlanAndBookDataResponse+Mapping.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 3/18/25.
//

import Foundation

extension GetPlanAndBookResponse {
    
    func toDomain() -> VoyageActivitiesSection {
        var bookActivities: [VoyageActivitiesSection.VoyageActivityItem] = []
        var exploreActivites: [VoyageActivitiesSection.VoyageActivityItem] = []
        
        if let responseBookActivities = self.bookActivities {
            responseBookActivities.forEach {
                bookActivities.append($0.mapBookActivity())
            }
        }
        
        if let responseExploreActivities = self.exploreActivities {
            responseExploreActivities.forEach {
                exploreActivites.append($0.mapExploreActivity())
            }
        }
        
        return VoyageActivitiesSection(bookActivities: bookActivities, exploreActivities: exploreActivites)
    }
}

extension GetPlanAndBookResponse.VoyageBookActivity {
    func mapBookActivity() -> VoyageActivitiesSection.VoyageActivityItem  {
        
        return VoyageActivitiesSection.VoyageActivityItem(imageUrl: imageUrl ?? "",
                                                          name: name ?? "",
                                                          code: "",
                                                          bookableType: BookableType(rawValue: bookableType ?? "") ?? nil,
                                                          layoutType: LayoutType(rawValue: layoutType ?? "") ?? .other)
    }
}

extension GetPlanAndBookResponse.VoyageExploreActivity {
    
    func mapExploreActivity() -> VoyageActivitiesSection.VoyageActivityItem {
        
        return VoyageActivitiesSection.VoyageActivityItem(imageUrl: imageUrl ?? "",
                                                          name: name ?? "",
                                                          code: code ?? "",
                                                          bookableType: nil,
                                                          layoutType: LayoutType(rawValue: layoutType ?? "") ?? .other)
    }
}
