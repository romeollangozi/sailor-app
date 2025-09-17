//
//  AddedToAgendaView.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 11/13/24.
//

import SwiftUI

public struct AddedToAgendaView: View {
    public var body: some View {
        HStack {
            Text("Added to your agenda")
                .font(.subheadline)
                .padding(8)
                .padding(.leading, 10)
            Spacer()
        }
        .background(Color.tropicalBlue)
        .cornerRadius(8)
    }
    
    public init() {
    }
}

struct AddedToAgendaView_Previews: PreviewProvider {
    static var previews: some View {
        AddedToAgendaView()
            .previewLayout(.sizeThatFits)
            .padding()
            .background(Color.gray.opacity(0.2))
    }
}

