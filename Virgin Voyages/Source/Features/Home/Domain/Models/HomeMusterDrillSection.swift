//
//  HomeMusterDrillSection.swift
//  Virgin Voyages
//
//  Created by TX on 7.4.25.
//

import Foundation

struct HomeMusterDrillSection: HomeSection {
    var id: String = UUID().uuidString
    var key: SectionKey = .musterDrill
    let title: String
    let description: String
    let backgroundImageUrl: String
}

extension HomeMusterDrillSection {
    static func empty() -> Self {
        return HomeMusterDrillSection(
            title: "",
            description: "",
            backgroundImageUrl: ""
        )
    }

    static func sample() -> Self {
        return HomeMusterDrillSection(
            id: UUID().uuidString,
            title: "There’s a safety video we need you to watch ",
            description: "Watch the safety video",
            backgroundImageUrl: "https://s3-alpha-sig.figma.com/img/767c/ebad/afcd12c8d51c5ec53344c180811a5282?Expires=1744588800&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=AuwovOC-Do-0OXz5JshCXfKCJzIEhiF1IKp9eRsNymz91LSt166d05TeLh3~JSEZjCNAx~KTmPSGUhfecKyF-9kcegd74hwIxSwNKXHEX3JgNleeogWR98bv0wBsaPSlSuUkZpxC7Ic5osh8evvXmSqD5kJ62uotNsb2c3jiHIdtiE4gdvG94NH7eIzBYfC15ykKls6Z9mbn7pPojow6m01I9m2bidvJejW8dXxBf7I~1U7Xd-XybJiUme6AUrk8oAHydWT06GRirrvmW0lPioBGn37n7NPWitf9u1KE-wkG7CSTR7bnOpJdMUqrkMycMkJX4WnVKcja5kJswa3byQ__"
        )
    }
}
