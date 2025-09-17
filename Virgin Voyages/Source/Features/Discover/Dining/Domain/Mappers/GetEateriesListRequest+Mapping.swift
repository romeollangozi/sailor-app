//
//  GetEateriesListRequest+Mapping.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 10.4.25.
//


import Foundation

extension GetEateriesListRequestResponse {
	func toDomain(shipName: String) -> EateriesList {
		let defaultTitle = "We’re moving bookings and bags"
		let defaultDescription = "Our bookings are moving onto ship and will re-open on the Sailor App once you are on board."

        let partySizeInfoDrawerBody = 
        """
<p>To make a booking onboard the ship we need the actual names of all the guests, we can&rsquo;t just take a number.</p>\n\n<p>We do this so that we can alert everybody of their new reservation and add it to their voyage agenda. It also allows us to control dining inventory to ensure that all sailors have the opportunity to experience our signature restaurants!</p>\n\n<p>If you can&rsquo;t see your friends in the list you can add them and they&rsquo;ll be available for you to add to this and any other bookings until the end of your voyage.</p>\n
"""
        let partySizeInfoDrawerHeading = "Selecting your party size"
        let diningReservationsShipboardModalHeading = "Dining reservations"
        let diningReservationsShipboardModalSubHeading =
        """
"<p>If you haven&rsquo;t managed to book dining at one or more of our restaurants in the app yet, don&rsquo;t worry, we&rsquo;ve got you!<br />\n<br />\nWe hold a number of tables back for booking once you are onboard the ship.<br />\n<br />\nAfter embarkation, just connect to the ship wifi and make your dining reservations here in the app. If you want a hand, we run a dining help-desk in Razzle Dazzle on embarkation day, too.</p>\n
"""
        let diningReservationsShipboardModalSubHeading1 =
        """
<p>Sorry sailor, looks like {Restaurant} is fully booked for that day.<br />\n<br />\nHowever... it may be worth checking with the restaurant directly. Our crew are dab hands at squeezing in walk-ins and of course we also sometimes get last minute cancellations.</p>\n
"""
        let soldOutReadMore = "Read More"
        let gotItCta = "Got It"
        let selectTimeSlotSubheading = "Select a timeslot"

		let title = cmsContent?.text?.preVoyageBookingStoppedTitle ?? defaultTitle
		let description = cmsContent?.text?.preVoyageBookingStoppedDescription?.replacingPlaceholder("ShipName", with: shipName) ?? defaultDescription
		return EateriesList(
			bookable: bookable?.map { $0.toDomain(isBookable: true) } ?? [],
			walkIns: walkIns?.map { $0.toDomain(isBookable: false) } ?? [],
			guestCount: guestCount.value,
			leadTime: leadTime?.toDomain(),
			preVoyageBookingStoppedInfo: isPreVoyageBookingStopped.value
				? .init(title: title, description: description)
				: nil,
            resources: .init(partySizeInfoDrawerBody: cmsContent?.text?.partySizeInfoDrawerBody ?? partySizeInfoDrawerBody, partySizeInfoDrawerHeading: cmsContent?.text?.partySizeInfoDrawerHeading ?? partySizeInfoDrawerHeading, diningReservationsShipboardModalHeading: cmsContent?.text?.diningReservationsShipboardModalHeading ?? diningReservationsShipboardModalHeading, diningReservationsShipboardModalSubHeading: cmsContent?.text?.diningReservationsShipboardModalSubHeading ?? diningReservationsShipboardModalSubHeading, diningReservationsShipboardModalSubHeading1: cmsContent?.text?.diningReservationsShipboardModalSubHeading1 ?? diningReservationsShipboardModalSubHeading1, soldOutReadMore: cmsContent?.text?.soldOutReadMore ?? soldOutReadMore, gotItCta: cmsContent?.text?.gotItCta ?? gotItCta, selectTimeSlotSubheading: cmsContent?.text?.selectTimeSlotSubheading ?? selectTimeSlotSubheading)
		)
	}
}

extension GetEateriesListRequestResponse.Eatery {
	func toDomain(isBookable: Bool) -> EateriesList.Eatery {
		return EateriesList.Eatery(
			name: self.name.value,
			slug: self.slug.value,
			externalId: self.externalId.value,
			squareThumbnailUrl: self.squareThumbnailUrl,
			subHeading: "\(self.label.value) | \(self.deckLocation.value)",
			venueId: self.venueId.value,
			isBookable: isBookable
		)
	}
}

extension GetEateriesListRequestResponse.LeadTime {
	func toDomain() -> EateryLeadTime {
		return EateryLeadTime(
			title: self.title.value,
			subtitle: self.subtitle.value,
			description: self.description.value,
			date: self.date?.iso8601.value ?? Date(),
			upgradeClassUrl: self.upgradeClassUrl,
			isCountdownStarted: self.isCountdownStarted.value
		)
	}
}


