//
//  VoyageActivitiesSectionModel.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 3/10/25.
//

import Foundation

struct VoyageActivitiesSection: HomeSection {
    
    var id: String = UUID().uuidString
    var key: SectionKey = .planAndBook
    var title: String = "planAndBook"
    
    let bookActivities: [VoyageActivityItem]
    let exploreActivities: [VoyageActivityItem]
    
    struct VoyageActivityItem: Identifiable {
        var id = UUID()
        let imageUrl: String
        let name: String
        let code: String
        let bookableType: BookableType?
        let layoutType: LayoutType
    }
}

extension VoyageActivitiesSection {
    
    static func empty() -> VoyageActivitiesSection {
        return VoyageActivitiesSection( bookActivities: [], exploreActivities: [])
    }
    
    static func sample() -> VoyageActivitiesSection {
        let dummyBookActivityContent = [
            VoyageActivityItem(imageUrl: "",
                                    name: "Book a Restaurant Test",
                                    code: "",
                                    bookableType: .eatery,
                                    layoutType: .square),
            VoyageActivityItem(imageUrl: "",
                                    name: "Book an Event Test",
                                    code: "",
                                    bookableType: .eatery,
                                    layoutType: .square),
            VoyageActivityItem(imageUrl: "",
                                    name: "Purchase Add-ons Test",
                                    code: "",
                                    bookableType: .eatery,
                                    layoutType: .full),
        ]
        
        let dummyExploreActivity = [
            VoyageActivityItem(imageUrl: "",
                               name: "Eateries",
                               code: "Eateries",
                               bookableType: nil,
                               layoutType: .full),
            VoyageActivityItem(imageUrl: "",
                               name: "Beauty And Body",
                               code: "Beauty--And--Body",
                               bookableType: nil,
                               layoutType: .square),
            VoyageActivityItem(imageUrl: "",
                               name: "Services",
                               code: "Services",
                               bookableType: nil,
                               layoutType: .square),
            VoyageActivityItem(imageUrl: "",
                               name: "Beauty And Body",
                               code: "Beauty--And--Body",
                               bookableType: nil,
                               layoutType: .square),
            VoyageActivityItem(imageUrl: "",
                               name: "Services",
                               code: "Services",
                               bookableType: nil,
                               layoutType: .square),
            VoyageActivityItem(imageUrl: "",
                               name: "Beauty And Body",
                               code: "Beauty--And--Body",
                               bookableType: nil,
                               layoutType: .square),
            VoyageActivityItem(imageUrl: "",
                               name: "Services",
                               code: "Services",
                               bookableType: nil,
                               layoutType: .square),
            
        ]
        
        let dummyModel = VoyageActivitiesSection(bookActivities: dummyBookActivityContent,
                                                     exploreActivities: dummyExploreActivity)
        
        return dummyModel
    }
}
