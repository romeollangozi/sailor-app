//
//  DashboardLanding.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 10/24/24.
//

struct DashboardLanding {
	var heroSection: HeroSection?
	var voyageTicket: VoyageTicket?
	var musterDrill: MusterDrill?
	var taskList: TaskList?
	var articles: Articles?
	var fact: Fact?
	var isGuestOnBoard: Bool?
	var isVIP: Bool?
	var firstBoardingStartTime: String?
	var isGuestCheckedIn: Bool?
	var isGuestCheckedOut: Bool?
	var externalRefId: String?
	var nextDaySection: NextDaySection?
	var disembarkationHomecoming: DisembarkationHomecoming?
	var crewTask: CrewTask?
}

// Crew Task Model
struct CrewTask {
	var isEnabled: Bool?
	var isError: Bool?
	var errorImageUrl: String?
	var moduleKey: String?
	var title: String?
	var description: String?
	var travelPartyImageUrls: [String]?
	var navigationLinkText: String?
}

// Hero Section Model
struct HeroSection {
	var headline: String?
	var title: String?
	var description: String?
	var imageURL: String?
	var videoURL: String?
	var dividerImageURL: String?
}

// Voyage Ticket Model
struct VoyageTicket {
	var date: String?
	var voyageName: String?
	var portsName: [String]?
	var cabinType: String?
	var cabinNumber: String?
	var deck: String?
	var embarkationDetail: Embarkation?
	var cabinSide: String?
}

// Embarkation Model
struct Embarkation {
	var title: String?
	var timeLabel: String?
	var time: String?
	var locationLabel: String?
	var location: String?
	var buttonText: String?
	var moduleKey: String?
	var coordinate: String?
	var vipLabel: String?
	var placeId: String?
}

// Task List Model
struct TaskList {
	var headerImageUrl: String?
	var title: String?
	var description: String?
	var navIconImageUrl: String?
	var tasksDetail: [TaskDetail]?
	var errorImageUrl: String?
}

// Task Detail Model
struct TaskDetail: Hashable, Equatable {
	var thumbnailImageUrl: String?
	var title: String?
	var description: String?
	var moduleKey: String?
	var sequence: Int?
	var isEnabled: Bool?
	var isHealthCheckComplete: Bool?
	var isError: Bool?
	var isFitToTravel: Bool?
	var isCompleted: Bool?
}

// Articles Model
struct Articles {
	var dividerImageUrl: String?
	var headerImageUrl: String?
	var title: String?
	var description: String?
	var cards: [ArticleCard]?
}

// Article Card Model
struct ArticleCard {
	var backgroundImageUrl: String?
	var headline: String?
	var title: String?
	var description: String?
	var actionURL: String?
	var cardType: String?
	var sequence: Int?
}

// Fact Model
struct Fact {
	var pictogramImageUrl: String?
	var title: String?
	var description: String?
	var footerImageURL: String?
}

// Muster Drill Model
struct MusterDrill {
	var linkText: String?
	var subheader: String?
	var imageURL: String?
	var header: String?
	var eyebrow: String?
}

// Next Day Section Model (if extended in future)
struct NextDaySection {
	// Currently empty but can be extended later
}

// Disembarkation Homecoming Model
struct DisembarkationHomecoming {
	var nextIconURL: String?
	var header: String?
	var description: String?
	var thumbnailURL: String?
	var actionURL: String?
}
