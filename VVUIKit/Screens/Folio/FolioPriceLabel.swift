//
//  FolioPriceLabel.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 12.6.25.
//

import SwiftUI

public struct FolioPrice: Equatable, Hashable {
    public let integerPart: String
    public let decimalPart: String
    public let isNegative: Bool
    
    public init(integerPart: String, decimalPart: String, isNegative: Bool = false) {
        self.integerPart = integerPart
        self.decimalPart = decimalPart
        self.isNegative = isNegative
    }
}

struct FolioPriceLabel: View {
    let price: FolioPrice
    
    var body: some View {
        HStack(spacing: .zero) {
            if price.isNegative {
                Text("-")
                    .font(.vvHeading4Bold)
                    .foregroundColor(.darkPurple)
                    .padding(.trailing, Spacing.space4)
            }
            Text("$")
                .font(.vvHeading4Bold)
                .foregroundColor(.darkPurple)
                .padding(.trailing, Spacing.space4)
            
            HStack(spacing: .zero) {
                Text("\(price.integerPart).")
                    .font(.vvHeading4Bold)
                    .foregroundColor(.darkPurple)
                
                Text(price.decimalPart)
                    .font(.vvHeading4)
                    .foregroundColor(.darkPurple)
            }
        }
    }
}

#Preview {
    FolioPriceLabel(price: FolioPrice(integerPart: "123", decimalPart: "45"))
}

