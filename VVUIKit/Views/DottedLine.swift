//
//  DottedLine.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 15.1.25.
//

import SwiftUI

public struct DottedLine: Shape {
    public init() {}
    
    public func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: 0))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        return path
    }
}

#Preview {
    VStack {
        DottedLine()
            .stroke(Color.blue, lineWidth: 1)
        
        DottedLine()
            .stroke(Color.red, lineWidth: 1)
    }
}
