//
//  RoundedCorners.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 16.1.25.
//

import SwiftUI

public struct RoundedCorners: Shape {
    var topLeft: CGFloat = 0.0
    var topRight: CGFloat = 0.0
    var bottomLeft: CGFloat = 0.0
    var bottomRight: CGFloat = 0.0
    
    public init(topLeft: CGFloat = 0, topRight: CGFloat = 0, bottomLeft: CGFloat = 0, bottomRight: CGFloat = 0) {
        self.topLeft = topLeft
        self.topRight = topRight
        self.bottomLeft = bottomLeft
        self.bottomRight = bottomRight
    }
    
    public func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let width = rect.size.width
        let height = rect.size.height
        
        path.move(to: CGPoint(x: rect.minX, y: rect.minY + topLeft))
        path.addArc(
            center: CGPoint(x: rect.minX + topLeft, y: rect.minY + topLeft),
            radius: topLeft,
            startAngle: Angle(degrees: 180),
            endAngle: Angle(degrees: 270),
            clockwise: false
        )
        
        path.addLine(to: CGPoint(x: rect.maxX - topRight, y: rect.minY))
        path.addArc(
            center: CGPoint(x: rect.maxX - topRight, y: rect.minY + topRight),
            radius: topRight,
            startAngle: Angle(degrees: 270),
            endAngle: Angle(degrees: 360),
            clockwise: false
        )
        
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - bottomRight))
        path.addArc(
            center: CGPoint(x: rect.maxX - bottomRight, y: rect.maxY - bottomRight),
            radius: bottomRight,
            startAngle: Angle(degrees: 0),
            endAngle: Angle(degrees: 90),
            clockwise: false
        )
        
        path.addLine(to: CGPoint(x: rect.minX + bottomLeft, y: rect.maxY))
        path.addArc(
            center: CGPoint(x: rect.minX + bottomLeft, y: rect.maxY - bottomLeft),
            radius: bottomLeft,
            startAngle: Angle(degrees: 90),
            endAngle: Angle(degrees: 180),
            clockwise: false
        )
        
        path.closeSubpath()
        return path
    }
}


struct RoundedCorners_Preview: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Top Left & Bottom Left")
                .frame(width: 200, height: 100)
                .background(Color.blue)
                .clipShape(
                    RoundedCorners(topLeft: 20, topRight: 0, bottomLeft: 20, bottomRight: 0)
                )
            
            Text("Top Right & Bottom Right")
                .frame(width: 200, height: 100)
                .background(Color.green)
                .clipShape(
                    RoundedCorners(topLeft: 0, topRight: 20, bottomLeft: 0, bottomRight: 20)
                )
            
            Text("All Corners")
                .frame(width: 200, height: 100)
                .background(Color.orange)
                .clipShape(
                    RoundedCorners(topLeft: 20, topRight: 20, bottomLeft: 20, bottomRight: 20)
                )
            
            Text("Top Only")
                .frame(width: 200, height: 100)
                .background(Color.purple)
                .clipShape(
                    RoundedCorners(topLeft: 20, topRight: 20, bottomLeft: 0, bottomRight: 0)
                )
            
            Text("Bottom Only")
                .frame(width: 200, height: 100)
                .background(Color.red)
                .clipShape(
                    RoundedCorners(topLeft: 0, topRight: 0, bottomLeft: 20, bottomRight: 20)
                )
        }
        .padding()
    }
}

#Preview {
    RoundedCorners_Preview()
}
