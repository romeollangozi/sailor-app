//
//  Color+Hexadecimal.swift
//  Virgin Voyages
//
//  Created by Timur Xhabiri on 4.11.24.
//

import SwiftUI

extension Color {
    // Method to convert Color to Hex String
    var hexadecimalString: String {
        let components = self.cgColor?.components
        let r = (components?[0] ?? 0) * 255
        let g = (components?[1] ?? 0) * 255
        let b = (components?[2] ?? 0) * 255
        
        // Ensure we format as 2-digit hex values
        return String(format: "#%02X%02X%02X", Int(r), Int(g), Int(b))
    }
}
