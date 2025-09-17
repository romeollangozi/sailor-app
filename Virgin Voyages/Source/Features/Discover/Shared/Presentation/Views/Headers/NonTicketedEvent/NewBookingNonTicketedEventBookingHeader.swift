//
//  NewBookingNonTicketedEventBookingHeader.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 10/8/24.
//

import SwiftUI

struct NewBookingNonTicketedEventBookingHeader: View {
    
    let heading: String?
    let description: String?
    
    var body: some View {
        BookingHeader(heading: heading,
                                   description: description)
        .padding(EdgeInsets(top: 16.0, leading: 24.0, bottom: 24.0, trailing: 24.0))
    }
}

struct NewBookingNonTicketedEventBookingHeader_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 0) {
            NewBookingNonTicketedEventBookingHeader(heading: "[Heading]",
                                                  description: "[Dynamic booking description]")
            Spacer()
        }
        .previewLayout(.sizeThatFits)
    }
}
