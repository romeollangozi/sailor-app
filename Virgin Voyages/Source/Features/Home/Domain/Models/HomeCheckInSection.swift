//
//  ReadyToSail.swift
//  Virgin Voyages
//
//  Created by TX on 17.3.25.
//

import Foundation

struct HomeCheckInSection: HomeSection {
    
    var id: String
    var key: SectionKey = .checkIn

    var title: String

    let rts: HomeRTSSection
    let embarkation: EmbarkationSection
    let healthCheck: HealthCheckSection
	let serviceGratuitiesSection: ServiceGratuitiesSection

    struct HomeRTSSection {
        var id: String { description + status.rawValue + imageUrl + buttonLabel }
        var title: String
        let imageUrl: String
        let description: String
        let status: HomeCheckInStatus
        let buttonLabel: String
        let paymentNavigationUrl: String
        let cabinMate: HomeCabinMateSection?
    }
    
    struct EmbarkationSection {
        let imageUrl: String
        let title: String
        let description: String
        let status: EmbarkationTaskStatus?
        let details: EmbarkationDetailsSection?
        let guide: EmbarkationGuideSection?

        enum EmbarkationTaskStatus: String {
            case inCompleted = "InCompleted"
            case completed = "Completed"
            case closed = "Closed"
        }

        struct EmbarkationDetailsSection {
            let sailorType: SailorType?
            let title: String
            let imageUrl: String
            let arrivalSlot: String
            let location: String
            let coordinates: String
            let placeId: String
            let cabinType: String
            let cabinDetails: String
        }

        struct EmbarkationGuideSection {
            let title: String
            let description: String
            let navigationUrl: String
        }
    }
    
    struct HealthCheckSection {
        let imageUrl: String
        let title: String
        let description: String
        let status: HealthCheckTaskStatus?
    }

	enum ServiceGratuitiesStatus: String {
		case Pending = "Pending"
		case opened = "Opened"
		case closed = "Closed"
	}
}

extension HomeCheckInSection {
    static func empty() -> HomeCheckInSection {
		.init(id: UUID().uuidString, title: "", rts: .init(title: "", imageUrl: "", description: "", status: .undefined, buttonLabel: "", paymentNavigationUrl: "", cabinMate: nil), embarkation: .init(imageUrl: "", title: "", description: "", status: nil, details: .init(sailorType: nil, title: "", imageUrl: "", arrivalSlot: "", location: "", coordinates: "", placeId: "", cabinType: "", cabinDetails: ""), guide: .init(title: "", description: "", navigationUrl: "")), healthCheck: .init(imageUrl: "", title: "", description: "", status: nil), serviceGratuitiesSection: .init(title: "", description: "", imageUrl: "", status: nil))
    }
    
    static func sample() -> HomeCheckInSection {
		.init(id: UUID().uuidString, title: "Home Check In", rts: .init(title: "Ready to sale", imageUrl: "", description: "Check Description", status: .InCompleted, buttonLabel: "Check in now", paymentNavigationUrl: "www.viriginvoyages.com", cabinMate: .init(imageUrl: "www.viriginvoyages.com", title: "Cabin mate title", description: "Cabinmate description")), embarkation: .init(imageUrl: "https://example.com/embarkation.jpg", title: "Embarkation Details", description: "Get ready for a smooth embarkation process.", status: .inCompleted, details: .init(sailorType: .standard, title: "Boarding Slot Confirmed", imageUrl: "https://example.com/sailor.jpg", arrivalSlot: "TBC", location: "Port Terminal 3", coordinates: "25.78011907532392, -80.1798794875817", placeId: "", cabinType: "Balcony", cabinDetails: "Deck 7 | Room 7204"), guide: .init(title: "Embarkation guide", description: "More information on your voyage embarkation", navigationUrl: "https://example.com")), healthCheck: .init(imageUrl: "https://example.com/health-check.jpg", title: "Health Check", description: "Complete your health declaration before boarding.", status: .closed), serviceGratuitiesSection: .init(title: "", description: "", imageUrl: "", status: nil))
    }
}

struct HomeCabinMateSection {
    let imageUrl: String
    let title: String
    let description: String
}

enum HomeCheckInStatus: String {
    case undefined, Pending, InCompleted, Closed, OnHold, ModerationIssue, Completed
    
    var stringValue: String {
        switch self {
        case .undefined:
            "Undefined"
        case .Pending:
            "Pending"
        case .InCompleted:
            "InCompleted"
        case .Closed:
            "Closed"
        case .OnHold:
            "OnHold"
        case .ModerationIssue:
            "ModerationIssue"
        case .Completed:
            "Completed"
        }
    }
}

enum HealthCheckTaskStatus: String {
    case closed = "Closed"
    case opened = "Opened"
    case completed = "Completed"
    case moderationIssue = "ModerationIssue"
}

struct ServiceGratuitiesSection {
	let title: String?
	let description: String?
	let imageUrl: String?
	let status: ServiceGratuitiesStatus?
}

enum ServiceGratuitiesStatus: String {
	case Pending = "Pending"
	case opened = "Opened"
	case closed = "Closed"
}
