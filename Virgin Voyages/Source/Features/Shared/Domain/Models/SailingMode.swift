//
//  SailingMode.swift
//  Virgin Voyages
//
//  Created by TX on 13.3.25.
//

import Foundation

enum SailingMode: String {
    case undefined, preCruise, preCruiseEmbarkationDay, shipBoardEmbarkationDay
    case shipBoardPortDay, shipBoardSeaDay, shipBoardDebarkationDay, postCruise
    
    var stringValue: String {
        switch self {
        case .undefined:
            ""
        case .preCruise:
            "preCruise"
        case .preCruiseEmbarkationDay:
            "preCruiseEmbarkationDay"
        case .shipBoardEmbarkationDay:
            "shipBoardEmbarkationDay"
        case .shipBoardPortDay:
            "shipBoardPortDay"
        case .shipBoardSeaDay:
            "shipBoardSeaDay"
        case .shipBoardDebarkationDay:
            "shipBoardDebarkationDay"
        case .postCruise:
            "postCruise"
        }
    }
}
