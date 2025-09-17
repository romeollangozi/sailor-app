//
//  DeepLinkJSONEncoderProtocol.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 8/7/25.
//

import Foundation

protocol DeepLinkJSONEncoderProtocol {
    func encodeExternalURLLink(url: String) -> (type: String, jsonString: String)
}
