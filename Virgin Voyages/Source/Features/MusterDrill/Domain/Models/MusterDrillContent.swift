//
//  MusterDrillContent.swift
//  Virgin Voyages
//
//  Created by TX on 7.4.25.
//

import Foundation

struct MusterDrillContent {
    let assemblyStation: AssemblyStation
    let mode: MusterDrillMode
    let video: VideoContent
    let message: MessageContent
    let languages: [Language]
    let emergency: EmergencyContent?

    struct AssemblyStation {
        let station: String
        let place: String
        let deck: String
    }

    struct VideoContent {
        let url: String
        let title: String
        let guest: GuestContent
        let stillImageUrl: String
    }

    struct GuestContent {
        let photoUrl: String
        let name: String
        let status: Bool
    }

    struct MessageContent {
        let title: String
        let description: String
    }

    struct EmergencyContent {
        let title: String
        let description: String
    }

    struct Language {
        let id: String
        let name: String
        let localName: String
    }
}


extension MusterDrillContent {
    enum MusterDrillMode: String {
        case none = "None"
        case info = "Info"
        case important = "Important"
        case hidden = "Hidden"
    }
}


extension MusterDrillContent {
    static func empty() -> MusterDrillContent {
        return .init(assemblyStation: .init(station: "", place: "", deck: ""), mode: .none, video: .init(url: "", title: "", guest: .init(photoUrl: "", name: "", status: false), stillImageUrl: ""), message: .init(title: "", description: ""), languages: [], emergency: .init(title: "", description: ""))
    }
}
