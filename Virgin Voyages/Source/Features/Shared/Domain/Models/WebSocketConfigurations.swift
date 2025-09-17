//
//  WebSocketConfigurations.swift
//  Virgin Voyages
//
//  Created by Pajtim on 20.5.25.
//

import Foundation

struct WebSocketConfigurations: Codable {
    let topics: [String]
    let filters: [WebSocketConfigFilter]
    var token: String = TokenManager().token?.accessToken ?? ""
}

enum WebSocketOperator: String, Codable {
    case eq = "eq"
    case includedIn = "in"
}

struct WebSocketConfigFilter: Codable {
    let topic: String
    let field: String
    let op: WebSocketOperator
    let value: [String]

    enum CodingKeys: String, CodingKey {
        case topic
        case field
        case op = "operator"
        case value
    }

    static var musterDrillEvents: [String] {
        MusterDrillWSEvent.allCases.map { $0.rawValue }
    }

    static var staticConfig: WebSocketConfigFilter {
        WebSocketConfigFilter(
            topic: WebSocketConstants.topic,
            field: "n",
            op: .includedIn,
            value: musterDrillEvents
        )
    }
}

extension WebSocketConfigFilter {
    func withTopic(_ newTopic: String) -> WebSocketConfigFilter {
        WebSocketConfigFilter(topic: newTopic, field: field, op: op, value: value)
    }
}

extension WebSocketConfigurations {
    static func fromComponentSettings(_ settings: [ComponentSettings]?) -> WebSocketConfigurations {
        let topicValue = settings?
            .first { $0.name == WebSocketConstants.kafkaTopicRoomcontrol }?
            .value ?? WebSocketConstants.topic

        let filter = WebSocketConfigFilter.staticConfig.withTopic(topicValue)

        return WebSocketConfigurations(
            topics: [topicValue],
            filters: [filter]
        )
    }
}
