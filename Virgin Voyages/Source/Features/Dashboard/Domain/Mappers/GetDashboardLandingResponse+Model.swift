//
//  GetDashboardLandingResponse+Model.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 10/24/24.
//

extension GetDashboardLandingResponse {
	func toModel() -> DashboardLanding {
		return DashboardLanding(heroSection: heroSection?.toModel(),
								voyageTicket: voyageTicket?.toModel(),
								musterDrill: musterDrill?.toModel(),
								taskList: taskList?.toModel(),
								articles: articles?.toModel(),
								fact: fact?.toModel(),
								isGuestOnBoard: isGuestOnBoard,
								isVIP: isVIP,
								firstBoardingStartTime: firstBoardingStartTime,
								isGuestCheckedIn: isGuestCheckedIn,
								isGuestCheckedOut: isGuestCheckedOut,
								externalRefId: externalRefId,
								nextDaySection: nextDaySection?.toModel(),
								disembarkationHomecoming: disembarkationHomecoming?.toModel(),
								crewTask: crewTask?.toModel())
	}
}

extension GetDashboardLandingResponse.HeroSection {
	func toModel() -> HeroSection {
		return HeroSection(headline: headline,
						   title: title,
						   description: description,
						   imageURL: imageURL,
						   videoURL: videoURL,
						   dividerImageURL: dividerImageURL)
	}
}

extension GetDashboardLandingResponse.VoyageTicket {
	func toModel() -> VoyageTicket {
		return VoyageTicket(date: date,
							voyageName: voyageName,
							portsName: portsName,
							cabinType: cabinType,
							cabinNumber: cabinNumber,
							deck: deck,
							embarkationDetail: embarkationDetail?.toModel(),
							cabinSide: cabinSide)
	}
}

extension GetDashboardLandingResponse.VoyageTicket.Embarkation {
	func toModel() -> Embarkation {
		return Embarkation(title: title,
						   timeLabel: timeLabel,
						   time: time,
						   locationLabel: locationLabel,
						   location: location,
						   buttonText: buttonText,
						   moduleKey: moduleKey,
						   coordinate: coordinate,
						   vipLabel: vipLabel,
						   placeId: placeId)
	}
}

extension GetDashboardLandingResponse.MusterDrill {
	func toModel() -> MusterDrill {
		return MusterDrill(linkText: linkText,
						   subheader: subheader,
						   imageURL: imageURL,
						   header: header,
						   eyebrow: eyebrow)
	}
}

extension GetDashboardLandingResponse.TaskList {
	func toModel() -> TaskList {
		return TaskList(headerImageUrl: headerImageUrl,
						title: title,
						description: description,
						navIconImageUrl: navIconImageUrl,
						tasksDetail: tasksDetail?.toModel(),
						errorImageUrl: errorImageUrl)
	}
}

extension Array where Element == GetDashboardLandingResponse.TaskList.TaskDetail {
	func toModel() -> [TaskDetail] {
		return self.map({ $0.toModel() })
	}
}

extension GetDashboardLandingResponse.TaskList.TaskDetail {
	func toModel() -> TaskDetail {
		return TaskDetail(thumbnailImageUrl: thumbnailImageUrl,
						  title: title,
						  description: description,
						  moduleKey: moduleKey,
						  sequence: sequence,
						  isEnabled: isEnabled,
						  isHealthCheckComplete: isHealthCheckComplete,
						  isError: isError,
						  isFitToTravel: isFitToTravel,
						  isCompleted: isCompleted)
	}
}

extension GetDashboardLandingResponse.Articles {
	func toModel() -> Articles {
		return Articles(dividerImageUrl: dividerImageUrl,
						headerImageUrl: headerImageUrl,
						title: title,
						description: description,
						cards: cards?.toModel())
	}
}

extension Array where Element == GetDashboardLandingResponse.Articles.Card {
	func toModel() -> [ArticleCard] {
		return self.map({ $0.toModel() })
	}
}

extension GetDashboardLandingResponse.Articles.Card {
	func toModel() -> ArticleCard {
		return ArticleCard(backgroundImageUrl: backgroundImageUrl,
						   headline: headline,
						   title: title,
						   description: description,
						   actionURL: actionURL,
						   cardType: cardType,
						   sequence: sequence)
	}
}

extension GetDashboardLandingResponse.Fact {
	func toModel() -> Fact {
		return Fact(pictogramImageUrl: pictogramImageUrl,
					title: title,
					description: description,
					footerImageURL: footerImageURL)
	}
}

extension GetDashboardLandingResponse.NextDaySection {
	func toModel() -> NextDaySection {
		return NextDaySection()
	}
}

extension GetDashboardLandingResponse.DisembarkationHomecoming {
	func toModel() -> DisembarkationHomecoming {
		return DisembarkationHomecoming(nextIconURL: nextIconURL,
										header: header,
										description: description,
										thumbnailURL: thumbnailURL,
										actionURL: actionURL)
	}
}

extension GetDashboardLandingResponse.CrewTask {
	func toModel() -> CrewTask {
		return CrewTask(isEnabled: isEnabled,
						isError: isError,
						errorImageUrl: errorImageUrl,
						moduleKey: moduleKey,
						title: title,
						description: description,
						travelPartyImageUrls: travelPartyImageUrls,
						navigationLinkText: navigationLinkText)
	}
}
