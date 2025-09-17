//
//  GetHomeCheckInResponse+Mapping.swift
//  Virgin Voyages
//
//  Created by TX on 18.3.25.
//

import Foundation

extension GetHomeCheckInTaskResponse {
    func toDomain() -> HomeCheckInSection {
		HomeCheckInSection(
            id: UUID().uuidString,
            title: "checkin",
            rts: .init(
                title: (self.rts?.title).value,
                imageUrl: (self.rts?.imageUrl).value,
                description: (self.rts?.description).value,
                status: .init(rawValue: self.rts?.status ?? "") ?? .undefined,
                buttonLabel: (self.rts?.buttonLabel).value,
                paymentNavigationUrl: (self.rts?.paymentNavigationUrl).value,
                cabinMate: self.rts?.cabinMate?.toDomain()
            ),
            embarkation: HomeCheckInSection.EmbarkationSection(
                imageUrl: self.embarkation?.imageUrl ?? "",
                title: self.embarkation?.title ?? "",
                description: self.embarkation?.description ?? "",
                status: HomeCheckInSection.EmbarkationSection.EmbarkationTaskStatus(rawValue: self.embarkation?.status ?? ""),
                details: self.embarkation?.details?.toDomain(),
                guide: self.embarkation?.guide?.toDomain()
            ),
            healthCheck: .init(
                imageUrl: self.healthCheck?.imageUrl ?? "",
                title: self.healthCheck?.title ?? "",
                description: self.healthCheck?.description ?? "",
                status: HealthCheckTaskStatus(rawValue: self.healthCheck?.status ?? "")
            ),
			serviceGratuitiesSection: .init(
				title: self.serviceGratuities?.title,
				description: self.serviceGratuities?.description,
				imageUrl: self.serviceGratuities?.imageUrl,
				status: ServiceGratuitiesStatus(rawValue: self.serviceGratuities?.status ?? "")
			)
        )
    }
}

extension GetHomeCheckInTaskResponse.CabinMate {
    func toDomain() -> HomeCabinMateSection {
        return HomeCabinMateSection(
            imageUrl: self.imageUrl ?? "",
            title: self.title ?? "",
            description: self.description ?? ""
        )
    }
}

extension GetHomeCheckInTaskResponse.Embarkation.Details {
    func toDomain() -> HomeCheckInSection.EmbarkationSection.EmbarkationDetailsSection {
        
        return HomeCheckInSection.EmbarkationSection.EmbarkationDetailsSection(sailorType: SailorType(from: self.sailorType ?? ""),
                                                                               title: self.title ?? "",
                                                                               imageUrl: self.imageUrl ?? "",
                                                                               arrivalSlot: self.arrivalSlot ?? "",
                                                                               location: self.location ?? "",
                                                                               coordinates: self.coordinates ?? "",
                                                                               placeId: self.placeId ?? "",
                                                                               cabinType: self.cabinType ?? "",
                                                                               cabinDetails: self.cabinDetails ?? "")
    }
}

extension GetHomeCheckInTaskResponse.Embarkation.Guide {
    
    func toDomain() -> HomeCheckInSection.EmbarkationSection.EmbarkationGuideSection {
        
        return HomeCheckInSection.EmbarkationSection.EmbarkationGuideSection(title: self.title ?? "",
                                                                             description: self.description ?? "",
                                                                             navigationUrl: self.navigationUrl ?? "")
    }
}
