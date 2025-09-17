//
//  ErrorBoxView.swift
//  Virgin Voyages
//
//  Created by TX on 15.8.25.
//

import SwiftUI

public struct ErrorBoxView: View {
    let state: ErrorBoxErrorStateProtocol
    
    public init(state: ErrorBoxErrorStateProtocol) {
        self.state = state
    }
    
    public var body: some View {
        HStack(alignment: .top, spacing: Spacing.space12) {
            ZStack {
                Circle()
                    .fill(Color(hex: "#C25B28"))
                    .frame(width: 24, height: 24)
                Text("!")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: Spacing.space12) {
                Text(state.title)
                    .font(.vvSmallBold)
                    .foregroundColor(Color(hex: "#C25B28"))
                Text(state.description)
                    .font(.vvSmall)
                    .foregroundColor(Color(hex: "#C25B28"))
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer()
        }
        .padding(Spacing.space16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(hex: "#C25B28").opacity(0.5), lineWidth: 2)
                .background(RoundedRectangle(cornerRadius: 12).fill(Color(hex: "#FFFAF1")))
        )
    }
}

enum PreviewErrorBoxState: ErrorBoxErrorStateProtocol {
    case previewState
    
    var title: String { "Preview error title" }
    var description: String { "Preview error description" }
}

#Preview {
    VStack {
        let previewState =
        ErrorBoxView(state: PreviewErrorBoxState.previewState)
            .padding()
        
    }
}
