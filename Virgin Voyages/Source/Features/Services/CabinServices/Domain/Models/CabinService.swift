//
//  CabinService.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 4/22/25.
//

import Foundation

struct CabinService: Equatable, Identifiable {
    
    var id = UUID().uuidString
    let items: [CabinServiceItem]
    let title: String
    let subTitle: String
    let backgroundImageURL: String
    let leadTime: LeadTime?
    
    static func == (lhs: CabinService, rhs: CabinService) -> Bool {
        return lhs.id == rhs.id
    }
    
    struct CabinServiceItem: Hashable, Identifiable {
        
        let id: String
        let name: String
        let status: StatusType
        let requestId: String
        let imageUrl: String
        let designStyle: DesignStyleType
        let options: [OptionItem]
        let optionsTitle: String
        let optionsDescription: String
        let confirmationCta: String
        let confirmationTitle: String
        let confirmationDescription: String
        
        static func == (lhs: CabinService.CabinServiceItem, rhs: CabinService.CabinServiceItem) -> Bool {
            return lhs.id == rhs.id
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
        
        struct OptionItem: Hashable, Identifiable {
            let id: String
            let name: String
            let icon: String
            let status: StatusType
            let requestId: String
            
            static func == (lhs: CabinService.CabinServiceItem.OptionItem, rhs: CabinService.CabinServiceItem.OptionItem) -> Bool {
                return lhs.id == rhs.id
            }
            
            func hash(into hasher: inout Hasher) {
                hasher.combine(id)
            }
        }
    }
    
    struct LeadTime {
        let title: String
        let imageUrl: String
        let description: String
    }
    
}

enum StatusType: String {
    case `default` = "Default"
    case active = "Active"
    case closed = "Closed"
}

enum DesignStyleType: String {
    case normal = "Normal"
    case outline = "Outline"
}


extension CabinService {
    
    static func sample() -> CabinService {
        
        let cabinServiceItems = [CabinServiceItem(id: "freshTowels",
                                                  name: "Fresh Towels",
                                                  status: .default,
                                                  requestId: "185e8d03-8bbd-47fd-9ed8-c2fb7f455a6e",
                                                  imageUrl: "https://cms-cert.ship.virginvoyages.com/dam/jcr:46f24f04-5e00-4cf3-ad04-d2fa2264e019/C4D-Sailor-App-Services-Towels-800x1280.jpg",
                                                  designStyle: .normal,
                                                  options: [CabinServiceItem.OptionItem(id: "bathTowelsReq",
                                                                                        name: "Bath towels",
                                                                                        icon: "",
                                                                                        status: StatusType.default,
                                                                                        requestId: ""),
                                                            CabinServiceItem.OptionItem(id: "fullSetReq",
                                                                                        name: "Bath towels",
                                                                                        icon: "",
                                                                                        status: StatusType.default,
                                                                                        requestId: "")
                                                  ],
                                                  optionsTitle: "Fresh towels",
                                                  optionsDescription: "You have choices",
                                                  confirmationCta: "Thanks",
                                                  confirmationTitle: "Fresh towels are on their way.",
                                                  confirmationDescription: "Sit back, shake for champagne, or just wait patiently at the door if you prefer."),
                                 CabinServiceItem(id: "cabinClean",
                                                  name: "Cabin cleaned",
                                                  status: .default,
                                                  requestId: "185e8d03-8bbd-47fd-9ed8-c2fb7f455a6e",
                                                  imageUrl: "https://cms-cert.ship.virginvoyages.com/dam/jcr:c119b166-40dd-4859-b930-22a1f24c0534/C4D-Sailor-App-Services-Cabin-Cleanning-800x1280.jpg",
                                                  designStyle: .normal,
                                                  options: [CabinServiceItem.OptionItem(id: "fullClean",
                                                                                        name: "Full clean",
                                                                                        icon: "",
                                                                                        status: StatusType.default,
                                                                                        requestId: ""),
                                                            CabinServiceItem.OptionItem(id: "spillCleanUp",
                                                                                        name: "Spill cleanup",
                                                                                        icon: "",
                                                                                        status: StatusType.default,
                                                                                        requestId: "")
                                                  ],
                                                  optionsTitle: "Cabin in need of a touch-up?",
                                                  optionsDescription: "We can send someone to clean your cabin right away.",
                                                  confirmationCta: "Thanks",
                                                  confirmationTitle: "We're on our way.",
                                                  confirmationDescription: "Someone from our Crew will be there shortly to help clean your space right up.")
        ]
        
        let staticModel =  CabinService(items: cabinServiceItems,
                                        title: "Hey Sailor, tell us how we can help you.",
                                        subTitle: "Cabin Services",
                                        backgroundImageURL: "https://cms-cert.ship.virginvoyages.com/dam/jcr:24afc9f5-9271-40c4-b233-3c804060c1ac/C4D-Sailor-App-Services-Landing-800x1280.jpg",
                                        leadTime: CabinService.LeadTime(title: "Making your cabin...",
                                                                        imageUrl: "https://cms-cert.ship.virginvoyages.com/dam/jcr:0079cb42-cb31-4677-985c-1d401e2f206d/Cabin_Services_464x464.jpg",
                                                                        description: "Once you're on board, come back here for all your cabin wants and needs.")
        )
        
        return staticModel
    }
    
    static func empty() -> CabinService {
        return CabinService(items: [], title: "", subTitle: "", backgroundImageURL: "", leadTime: nil)
    }
}

extension CabinService.CabinServiceItem {
    
    static func sample() -> CabinService.CabinServiceItem {
        return CabinService.CabinServiceItem(id: "freshTowels",
                                             name: "Fresh Towels",
                                             status: .default,
                                             requestId: "",
                                             imageUrl: "https://cms-cert.ship.virginvoyages.com/dam/jcr:46f24f04-5e00-4cf3-ad04-d2fa2264e019/C4D-Sailor-App-Services-Towels-800x1280.jpg",
                                             designStyle: .normal,
                                             options: [CabinService.CabinServiceItem.OptionItem(id: "bathTowelsReq",
                                                                                                name: "Bath towels",
                                                                                                icon: "",
                                                                                                status: StatusType.default,
                                                                                                requestId: ""),
                                                       CabinService.CabinServiceItem.OptionItem(id: "fullSetReq",
                                                                                                name: "Bath towels",
                                                                                                icon: "",
                                                                                                status: StatusType.default,
                                                                                                requestId: "")
                                             ],
                                             optionsTitle: "Fresh towels",
                                             optionsDescription: "You have choices",
                                             confirmationCta: "Thanks",
                                             confirmationTitle: "Fresh towels are on their way.",
                                             confirmationDescription: "Sit back, shake for champagne, or just wait patiently at the door if you prefer.")
    }
    
    static func empty() -> CabinService.CabinServiceItem {
        return CabinService.CabinServiceItem(id: "",
                                             name: "",
                                             status: .default,
                                             requestId: "",
                                             imageUrl: "",
                                             designStyle: .normal,
                                             options: [],
                                             optionsTitle: "",
                                             optionsDescription: "",
                                             confirmationCta: "",
                                             confirmationTitle: "",
                                             confirmationDescription: "")
    }
    
}
