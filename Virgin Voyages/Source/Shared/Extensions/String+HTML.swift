//
//  String+HTML.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 9.6.25.
//

import Foundation

extension String{
    func removingHTMLTags() -> String {
        var result = self
        result = result.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
        result = result.replacingOccurrences(of: "&nbsp;", with: " ")
        return result
    }
}
