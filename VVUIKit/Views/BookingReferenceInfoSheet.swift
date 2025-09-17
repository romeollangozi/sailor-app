//
//  BookingReferenceInfoSheet.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 9/25/24.
//

import SwiftUI
import VVUIKit

struct BookingReferenceInfoSheet: View {
    let close: () -> Void
    
    var body: some View {
        toolbar()
        VStack(alignment: .leading, spacing: Spacing.space24) {
                VStack(alignment: .leading, spacing: Spacing.space16) {
                    Text("Booking reference")
                        .font(.vvHeading3Bold)
                        .multilineTextAlignment(.leading)

                    Text("You’ll find this number on your booking confirmation.")
                        .font(.vvHeading5)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(Color.vvGray)
                }

            Button("Got it") {
                close()
            }
            .buttonStyle(SecondaryButtonStyle())
            .padding(.top, Spacing.space16)
        }
        .padding(.horizontal, Spacing.space24)
    }

    func toolbar() -> some View {
        Toolbar(buttonStyle: .closeButton) {
            close()
        }
    }
}

#Preview {
    Color.clear
        .sheet(isPresented: .constant(true)) {
            BookingReferenceInfoSheet(close: { })
                .presentationDetents([.height(300)])
        }
}
