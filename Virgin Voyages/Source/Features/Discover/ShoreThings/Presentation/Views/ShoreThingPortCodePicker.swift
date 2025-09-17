//
//  ShoreThingPortCodePicker.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 14.5.25.
//

import SwiftUI

struct ShoreThingPortCodePicker: View {
    var ports: [ShoreThingPort]
    @Binding var selectedPort: ShoreThingPort
    var body: some View {
        HFlowStack(verticalSpacing: 5) {
            ForEach(ports) { portCode in
                Button {
                    selectedPort = portCode
                } label: {
                    HStack {
                        Text(portCode.code)
                        
                        if portCode.id != ports.last?.id {
                            Image(systemName: "arrow.forward.circle")
                        }
                    }
                }
                .foregroundStyle(portCode.id == selectedPort.id ? Color.accentColor : .white)
            }
        }
        .fontStyle(.headline)
        .foregroundStyle(.white)
    }
}
