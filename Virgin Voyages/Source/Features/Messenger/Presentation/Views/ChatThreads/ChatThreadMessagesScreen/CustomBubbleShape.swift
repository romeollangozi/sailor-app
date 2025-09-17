//
//  CustomBubbleShape.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 18.2.25.
//

import SwiftUI
import VVUIKit

struct CustomBubbleShape: Shape {
    var isMine: Bool
    var type: BubbleType
    var isFirst: Bool
    var isLast: Bool
    
    func path(in rect: CGRect) -> Path {
        let cornerRadius: CGFloat = Spacing.space8
        var corners: UIRectCorner = []
        
        switch type {
        case .single:
            corners = isMine ? [.topLeft, .bottomLeft, .bottomRight] : [.topRight, .bottomLeft, .bottomRight]
        case .top:
            corners = isMine ? [.topLeft] : [.topRight]
        case .middle:
            corners = []
        case .bottom:
            corners = isMine ? [.bottomLeft, .bottomRight] : [.bottomRight, .bottomLeft]
        case .topBottom:
            if isMine {
                if isFirst {
                    corners = [.topLeft]
                } else {
                    corners = [.bottomRight]
                }
            } else {
                if isFirst {
                    corners = [.topRight]
                } else {
                    corners = [.bottomRight, .bottomLeft]
                }
            }
        }
        
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        return Path(path.cgPath)
    }
}
