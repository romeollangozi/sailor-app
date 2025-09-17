//
//  GetHomeGeneralDataResponse+Mappers.swift
//  Virgin Voyages
//
//  Created by TX on 12.3.25.
//

import Foundation

extension GetHomeGeneralDataResponse {
    func toDomain() -> HomePage {
        
        var sections: [HomeSection] = []
        for sectionKey in self.order ?? [] {
            switch sectionKey {
            case .header:
                if let header = self.header {
                    sections.append(header.toDomain())
                }
            case .actions:
                if let actions = self.actions {
                    sections.append(mapToActions(from: actions))
                }
            case .checkIn:
                sections.append(HomeCheckInSection.empty())
            case .planAndBook:
                sections.append(VoyageActivitiesSection.empty())
            case .notifications:
                sections.append(HomeNotificationsSection.empty())
            case .planner:
                sections.append(HomePlannerSection.empty())
            case .merchandiseCarousel:
                if let merchandiseCarousel = self.merchandiseCarousel {
                    sections.append(mapToHomeMerchandise(from: merchandiseCarousel))
                }
            case .plannerPreview:
                if let plannerPreview = self.plannerPreview {
                    sections.append(plannerPreview.toDomain())
                }
            case .addOnsPromo:
                if let addOnsPromo = self.addOnsPromo {
                    sections.append(addOnsPromo.toDomain())
                }
            case .myNextVirginVoyage:
                if let myNextVirginVoyage = self.myNextVirginVoyage {
                    sections.append(myNextVirginVoyage.toDomain())
                }
            case .switchVoyage:
                sections.append(HomeSwitchVoyageSection.empty())
            case .footer:
                if let footer = self.footer {
                    sections.append(footer.toDomain())
                }
            case .musterDrill:
                if let musterDrill = self.musterDrill {
                    sections.append(musterDrill.toDomain())
                }
            default:
                print("GetHomeGeneralDataResponse toDomain() - Warning : Section \(sectionKey.rawValue) not implemented in home screen")
                //sections.append(EmptySection(title: sectionKey.rawValue)) // Placeholder for unmapped sections
            }
        }
        
        return HomePage(sections: sections)
    }
    
}

extension GetHomeGeneralDataResponse.Header {
    func toDomain() -> HomeHeader {
        return HomeHeader(
            id: UUID().uuidString,
            title: self.headerTitle ?? "",
            topBarTitle: self.topBar?.title ?? "",
            topBarSubtitle: self.topBar?.subTitle ?? "",
            headerTitle: self.headerTitle ?? "",
            headerSubtitle: self.headerSubtitle ?? "",
            backgroundImageUrl: self.backgroundImageUrl ?? "",
            reservationNumber: self.reservationNumber ?? "",
            cabinNumber: self.cabinNumber ?? "",
            gangwayOpeningTime: self.gangwayOpeningTime ?? "",
            gangwayClosingTime: self.gangwayClosingTime ?? "",
            shipTimeOffset: self.shipTimeOffset ?? -1
        )
    }
}

extension GetHomeGeneralDataResponse.Action {
    func toDomain() -> HomeActionsSection.Action {
        return HomeActionsSection.Action(
            type: ActionType(rawValue: self.type.value) ?? .homeGuide,
            imageUrl: self.imageUrl.value,
            title: self.title.value,
            description: self.description.value
        )
    }
}

extension GetHomeGeneralDataResponse.MerchandiseItem {
    func toDomain() -> HomeMerchandise.HomeMerchandiseItem {
        return HomeMerchandise.HomeMerchandiseItem(
            title: self.title.value,
            imageUrl: self.imageUrl.value,
            color: self.color.value,
            code: self.code.value
        )
    }
}

extension GetHomeGeneralDataResponse.NextVoyage {
    func toDomain() -> MyNextVoyageSection {
        return MyNextVoyageSection(id: UUID().uuidString,
                                   title: self.title ?? "",
                                   subTitle: self.subTitle ?? "",
                                   dayRemaining: self.dayRemaining ?? "",
                                   navigationUrl: self.navigationUrl ?? "",
                                   imageURL: self.imageUrl ?? "")
    }
}

extension GetHomeGeneralDataResponse {
    private func mapToHomeMerchandise(from: [MerchandiseItem]) -> HomeMerchandise {
        return HomeMerchandise(
            id: UUID().uuidString,
            items: merchandiseCarousel?.compactMap { $0.toDomain() } ?? []
        )
    }
}

extension GetHomeGeneralDataResponse.AddOnsPromo {
    func toDomain() -> HomeAddOnsPromoSection {
        return HomeAddOnsPromoSection(
            id: UUID().uuidString,
            title: self.title.value,
            description: self.description.value,
            imageUrl: self.imageUrl.value
        )
    }
}

extension GetHomeGeneralDataResponse.Footer {
    func toDomain() -> HomeFooterSection {
        return HomeFooterSection(
            id: UUID().uuidString,
            title: self.title.value,
            description: self.description.value,
            pictogramUrl: self.imageUrl.value
        )
    }
}

extension GetHomeGeneralDataResponse.PlannerPreview {
    func toDomain() -> HomePlannerPreviewSection {
        return HomePlannerPreviewSection(
            id: UUID().uuidString,
            title: self.title.value,
            description: self.description.value,
            thumbnailImageUrl: self.imageUrl.value
        )
    }
}

extension GetHomeGeneralDataResponse.MusterDrill {
    func toDomain() -> HomeMusterDrillSection {
        return HomeMusterDrillSection(
            title: self.title.value,
            description: self.description.value,
            backgroundImageUrl: self.imageUrl.value
        )
    }
}

extension GetHomeGeneralDataResponse {
    private func mapToActions(from: [Action]) -> HomeActionsSection {
        return HomeActionsSection(
            id: UUID().uuidString,
            key: .actions,
            items: actions?.compactMap { $0.toDomain() } ?? []
        )
    }
}
