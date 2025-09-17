//
//  GetHomeComingGuide+Mapping.swift
//  Virgin Voyages
//
//  Created by Pajtim on 2.4.25.
//

import Foundation

extension GetHomeComingGuideResponse {
    func toDomain() -> HomeComingGuide {
        return HomeComingGuide(
            header: HomeComingGuide.HomeComingGuideHeader(
                title: header?.title.value ?? "",
                description: header?.description.value ?? "",
                bannerImageUrl: header?.bannerImageUrl.value ?? "",
                deck: header?.deck.value ?? "",
                time: header?.time.value ?? "",
                queueDescription: header?.queueDescription.value ?? ""
            ),
            sections: self.sections?.map { section in
                HomeComingGuide.HomeComingGuideSection(
                    title: section.title.value,
                    subtitle: section.subtitle.value,
                    description: section.description.value,
                    bannerImageUrl: section.bannerImageUrl.value
                )
            } ?? []
        )
    }
}
