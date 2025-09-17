//
//  VVToggle.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 1.11.24.
//

import SwiftUI
import VVUIKit

struct VVToggle: View {
    
    @Binding var isOn: Bool
    var onToggle: ((Bool) -> Void)?

    var body: some View {
        ZStack(alignment: isOn ? .trailing : .leading) {
            RoundedRectangle(cornerRadius: 16)
                .fill(isOn ? Color.vvBooked.opacity(0.3) : Color.gray.opacity(0.3))
                .frame(width: 50, height: 20)
            
            Circle()
                .fill(isOn ? Color.vvBooked : Color.gray)
                .frame(width: 25, height: 25)
                .padding(1)
                .shadow(radius: 2)
        }
        .animation(.easeInOut(duration: 0.2), value: isOn)
        .onTapGesture {
            isOn.toggle()
            onToggle?(isOn)
        }
    }
}

struct VVToggleView: View {
    @State private var isOn = false

    var body: some View {
        VStack {
            Text("VV Toggle")
                .padding(.bottom, 20)
            
            VVToggle(isOn: $isOn) { newState in
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        VVToggleView()
    }
}
