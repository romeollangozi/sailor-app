//
//  String+Extension.swift
//  VVUIKit
//
//  Created by Pajtim on 23.7.25.
//

import Foundation

extension String {
    func extractCurrencyComponents() -> (sign: String, amount: String) {
        let currencySymbols = CharacterSet(charactersIn: "$€£¥₹₩₽₺₴₪₫฿₦₲₵₡₢₣₤₥₧₨₩﷼ƒ")
        let sign = self.prefix { char in
            String(char).rangeOfCharacter(from: currencySymbols) != nil
        }
        let amount = self.dropFirst(sign.count)
        return (String(sign), String(amount))
    }
}
