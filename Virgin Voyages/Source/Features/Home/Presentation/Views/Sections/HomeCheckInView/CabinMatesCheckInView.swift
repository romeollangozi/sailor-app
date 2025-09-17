//
//  CabinMatesCheckInView.swift
//  Virgin Voyages
//
//  Created by TX on 17.3.25.
//

import SwiftUI
import VVUIKit

struct CabinMatesCheckInView: View {
    var title: String
    var subtitle: String
    let addTopBorder: Bool
    let action: () -> Void

    
    var body: some View {
        Button(action: action) {
            HStack(alignment: .center, spacing: 8) {
                
                Image("cabinmatesCheckinIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 44, height: 44)

                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(title)
                            .font(.vvBodyBold)
                            .foregroundColor(.black)

                        Image(systemName: "chevron.right")
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundColor(Color.vvRed)
                        Spacer()
                    }

                    Text(subtitle)
                        .font(.vvSmall)
                        .foregroundColor(.gray)
						.multilineTextAlignment(.leading)
                }
            }
            .padding(.vertical, Paddings.defaultVerticalPadding16)
            .padding(.leading, Paddings.padding12)
            
        }
        .background(Color.white.cornerRadius(Sizes.defaultSize24, corners: [.bottomLeft, .bottomRight]))
        .overlay(
            addTopBorder
            ? AnyView(TopLineBorderShape().stroke(Color.borderGray.opacity(0.5), lineWidth: 1))
            : AnyView(BottomRoundedBorderShape(cornerRadius: Sizes.defaultSize24).stroke(Color.borderGray, lineWidth: 1))
        )
    }
}

struct TopLineBorderShape: Shape {

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        return path
    }
}


struct BottomRoundedBorderShape: Shape {
    var cornerRadius: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY - cornerRadius))
        path.addQuadCurve(
            to: CGPoint(x: rect.minX + cornerRadius, y: rect.maxY),
            control: CGPoint(x: rect.minX, y: rect.maxY)
        )
        path.addLine(to: CGPoint(x: rect.maxX - cornerRadius, y: rect.maxY))
        path.addQuadCurve(
            to: CGPoint(x: rect.maxX, y: rect.maxY - cornerRadius),
            control: CGPoint(x: rect.maxX, y: rect.maxY)
        )
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))

        return path
    }
}

struct CabinMatesCheckInView_Previews: PreviewProvider {
    static var previews: some View {
        let title = "Help your cabin mates"
        let subtitle = "John is behind on their check-in"
        CabinMatesCheckInView(title: title, subtitle: subtitle, addTopBorder: false) {}
            .padding()
    }
}
