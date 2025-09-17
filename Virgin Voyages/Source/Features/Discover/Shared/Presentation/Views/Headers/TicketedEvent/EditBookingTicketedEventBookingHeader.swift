//
//  EditBookingTicketedEventBookingHeader.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 10/8/24.
//

import SwiftUI

struct EditBookingTicketedEventBookingHeader: View {
    
    let heading: String?
    let description: String?
    let price: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16.0) {
            Text("Edit Booking")
                .fontStyle(.title)
            BookingHeader(heading: heading,
                                       description: description,
                                       price: price)
        }
        .padding(EdgeInsets(top: 0.0,
                            leading: 24.0,
                            bottom: 24.0,
                            trailing: 24.0))
    }
}

struct EditBookingTicketedEventBookingHeader_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 0) {
            EditBookingTicketedEventBookingHeader(heading: "[Heading]",
                                                  description: "[Dynamic booking description]",
                                                  price: "[Price]")
            Spacer()
        }
        .previewLayout(.sizeThatFits)
    }
}
