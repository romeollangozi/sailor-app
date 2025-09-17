//
//  GetMusterDrillResponse+mapping.swift
//  Virgin Voyages
//
//  Created by TX on 7.4.25.
//

import Foundation

extension GetMusterDrillResponse {
    func toDomain() -> MusterDrillContent {
        return MusterDrillContent(
            assemblyStation: MusterDrillContent.AssemblyStation(
                station: (assemblyStation?.station).value,
                place: (assemblyStation?.place).value,
                deck: (assemblyStation?.deck).value
            ),
            mode: MusterDrillContent.MusterDrillMode(rawValue: mode ?? "None") ?? .none,
            video: MusterDrillContent.VideoContent(
                url: (video?.url).value,
                title: (video?.title).value,
                guest: MusterDrillContent.GuestContent(
                    photoUrl: (video?.guest?.photoUrl).value,
                    name: (video?.guest?.name).value,
                    status: (video?.guest?.status).value
                ),
                stillImageUrl: (video?.stillImageUrl).value
            ),
            message: MusterDrillContent.MessageContent(
                title: (message?.title).value,
                description: (message?.description).value
            ),
            languages: (languages ?? []).map {
                MusterDrillContent.Language(
                    id: $0.id.value,
                    name: $0.name.value,
                    localName: $0.localName.value
                )
            },
            emergency: emergency != nil ? MusterDrillContent.EmergencyContent(
                title: (emergency?.title).value,
                description: (emergency?.description).value
            ) : nil
        )
    }
}

