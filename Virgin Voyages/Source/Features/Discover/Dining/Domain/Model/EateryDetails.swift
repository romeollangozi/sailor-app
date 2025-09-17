//
//  EateryDetails.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 30.11.24.
//

struct EateryDetails {
    let name: String
    let deckLocation: String
    let portraitHeroURL: String
    let externalId: String
    let introduction: String
    let longDescription: String
    let dividerColor: String
    let needToKnowsColor: String
    let needToKnows: [String]
    let editorialBlocks: [String]
    let featuredEventsCategoryCode: String
    let virtualQueuesBackgroundImage: String
    let bannerBgColor: String
    let bannerTextColor: String
    let categoryCode: String
    let isFavourite: Bool
    let spaceCurrentStatus: SpaceCurrentStatus
    let operationalHours: [OperationalHour]
    let openingTimes: [OpeningTime]
    let menuData: MenuData

    struct MenuData: Codable {
        let menuFooterColor: String
        let description: String
        let menuTextColor: String
        let coverDescription: String
        let pageBackground: String
        let coverImage: String
        let name: String
        let header: String
        let logo: String
        let id: String
        let menuPdf: String
    }

    struct SpaceCurrentStatus {
        let label: String
    }

    struct OperationalHour {
        let fromDate: String
        let toDate: String
        let fromTime: String
        let toTime: String
    }

    struct OpeningTime {
        let label: String
        let text: String
    }

}

extension EateryDetails {
    static func map(from response: GetEateriesDetailsResponse) -> EateryDetails {
        return EateryDetails(
            name: response.name.value,
            deckLocation: response.deckLocation.value,
            portraitHeroURL: response.portraitHeroURL.value,
            externalId: response.externalId.value,
            introduction: response.introduction.value,
            longDescription: response.longDescription.value,
            dividerColor: response.dividerColor.value,
            needToKnowsColor: response.needToKnowsColor.value,
            needToKnows: response.needToKnows ?? [],
            editorialBlocks: response.editorialBlocks ?? [],
            featuredEventsCategoryCode: response.featuredEventsCategoryCode.value,
            virtualQueuesBackgroundImage: response.virtualQueuesBackgroundImage.value,
            bannerBgColor: response.bannerBgColor.value,
            bannerTextColor: response.bannerTextColor.value,
            categoryCode: response.categoryCode.value,
            isFavourite: response.isFavourite ?? false,
            spaceCurrentStatus: SpaceCurrentStatus(label: response.spaceCurrentStatus?.label ?? ""),
            operationalHours: (response.operationalHours ?? []).map {
                OperationalHour(
                    fromDate: $0.fromDate.value,
                    toDate: $0.toDate .value,
                    fromTime: $0.fromTime.value,
                    toTime: $0.toTime.value
                )
            },
            openingTimes: (response.openingTimes ?? []).map {
                OpeningTime(
                    label: $0.label.value,
                    text: $0.text.value
                )
            },
            menuData: MenuData(menuFooterColor: response.menuData?.menuFooterColor ?? "", description: response.menuData?.description ?? "", menuTextColor: response.menuData?.menuTextColor ?? "", coverDescription: response.menuData?.coverDescription ?? "", pageBackground: response.menuData?.pageBackground ?? "", coverImage: response.menuData?.coverImage ?? "", name: response.menuData?.name ?? "", header: response.menuData?.header ?? "", logo: response.menuData?.logo ?? "", id: response.menuData?.id ?? "", menuPdf: response.menuData?.menuPdf ?? "")
        )
    }
}
