//
//  EateryDetailsModel.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 30.11.24.
//

import Foundation

struct EateryDetailsModel: Equatable {
	let name: String
	let deckLocation: String
	let portraitHeroURL: String
	let externalId: String
	let venueId: String
	let introduction: String?
	let longDescription: String
	let needToKnows: [String]
    let editorialBlocks: [String]
	let openingTimes: [OpeningTime]
	let isBookable: Bool
	let leadTime: EateryLeadTime?
	let preVoyageBookingStoppedInfo: EateryPreVoyageBookingStoppedInfo?
    let menuData: MenuData?

	struct OpeningTime : Equatable {
		let label: String
		let text: String
		let id: String = UUID().uuidString
	}
    var resources: EateryLocalizationResources = .empty()

    var isShipBoard: Bool = false
}

extension EateryDetailsModel {
	static func sample() -> EateryDetailsModel {
		EateryDetailsModel(
			name: "Razzle Dazzle Restaurant",
			deckLocation: "Deck 5 Mid",
			portraitHeroURL: "https://cert.gcpshore.virginvoyages.com/dam/jcr:a6233f56-5316-4826-a5f8-533709598e56/IMG-FNB-razzle-dazzle-interior-bw-1200x1440.jpg",
			externalId: "5a4bf485da0c112a66ed6217",
			venueId: "5a4bf485da0c112a66ed6217",
			introduction: "The go-to option for cool and casual dining on board – serving dinner, breakfast and… *dramatic head turn*...all day boozy brunch.",
			longDescription: "So your best friend wants something healthy, and you want&hellip;sunny side hash? This is the place. Boasting a bold interior and a daring new dinner menu, this happening spot offers our creative twist on some classic American comfort go-to&rsquo;s. Razzle Dazzle strikes a culinary sweet spot between balance and decadence, with a menu that skews partly toward veggie-conscious dishes, and partly toward meats, sweets, and gluttonous treats. So whether you&rsquo;re looking for something rejuvenating and familiar or something spicy and out of left field, you&rsquo;ll leave here full of goodness.",
			needToKnows: [
				"Our dress code is pretty chill, but please no swimwear.",
				"Brunch is available daily, please book onboard."
			],
            editorialBlocks: [
                "https://cms-cert.ship.virginvoyages.com/Sailor-App/Guides/Editorial-Blocks/eatery-booking-restriction/content/0.html"
            ],
			openingTimes: [
				OpeningTime(label: "Saturday", text: "6:00am - 5:45am"),
				OpeningTime(label: "Sunday to Saturday", text: "6:00am - 1:00pm, 1:15pm - 5:45am"),
				OpeningTime(label: "Sunday", text: "6:00am - 9:30am")
			],
			isBookable: true,
			leadTime: nil,
			preVoyageBookingStoppedInfo: nil,
            menuData: MenuData(menuFooterColor: "000000", description: "From fairy toast to the Impossible burger, the menu is as diverse as it is dazzling.", menuTextColor: "ffffff", coverDescription: "Brunch and dinner", pageBackground: "https://cert.gcpshore.virginvoyages.com/dam/jcr:e176fbdf-5adb-4ce5-a5d7-8dd5f9f040bd/IMG-menu-background-razzle-dazzle-1200x1920.jpg", coverImage: "https://cert.gcpshore.virginvoyages.com/dam/jcr:8f62f9e6-978b-49ce-8679-aba4f267eedf/IMG-card-background-razzle-dazzle-600x735.jpg", name: "Razzle Dazzle Restaurant", header: "The menu", logo: "https://cert.gcpshore.virginvoyages.com/dam/jcr:dbe2424a-2bc2-400d-b844-fb3dc67157f9/IMG-logo-razzle-dazzle-256x192.png", id: "2662a1de-b554-4215-9fdd-afcdb9c9541d", menuPdf: "https://cms-cert.ship.virginvoyages.com/dam/jcr:01895a34-f73c-4a44-90c8-18de9a38ab05/RS-VL-itin-match-PDF-v2.pdf")
		)
	}
}

extension EateryDetailsModel {
	static func empty() -> EateryDetailsModel {
		EateryDetailsModel(
			name: "",
			deckLocation: "",
			portraitHeroURL: "",
			externalId: "",
			venueId: "",
			introduction: "",
			longDescription:"",
			needToKnows: [],
            editorialBlocks: [],
			openingTimes: [],
			isBookable: false,
			leadTime: nil,
			preVoyageBookingStoppedInfo: nil,
            menuData: nil
		)
	}
}

extension EateryDetailsModel {
	static func sampleWithLeadTime() -> EateryDetailsModel {
		EateryDetailsModel(
			name: "Razzle Dazzle Restaurant",
			deckLocation: "Deck 5 Mid",
			portraitHeroURL: "https://cert.gcpshore.virginvoyages.com/dam/jcr:a6233f56-5316-4826-a5f8-533709598e56/IMG-FNB-razzle-dazzle-interior-bw-1200x1440.jpg",
			externalId: "5a4bf485da0c112a66ed6217",
			venueId: "5a4bf485da0c112a66ed6217",
			introduction: "The go-to option for cool and casual dining on board – serving dinner, breakfast and… *dramatic head turn*...all day boozy brunch.",
			longDescription: "So your best friend wants something healthy, and you want&hellip;sunny side hash? This is the place. Boasting a bold interior and a daring new dinner menu, this happening spot offers our creative twist on some classic American comfort go-to&rsquo;s. Razzle Dazzle strikes a culinary sweet spot between balance and decadence, with a menu that skews partly toward veggie-conscious dishes, and partly toward meats, sweets, and gluttonous treats. So whether you&rsquo;re looking for something rejuvenating and familiar or something spicy and out of left field, you&rsquo;ll leave here full of goodness.",
			needToKnows: [
				"Our dress code is pretty chill, but please no swimwear.",
				"Brunch is available daily, please book onboard."
			],
            editorialBlocks: [
                "https://cms-cert.ship.virginvoyages.com/Sailor-App/Guides/Editorial-Blocks/eatery-booking-restriction/content/0.html"
            ],
			openingTimes: [
				OpeningTime(label: "Saturday", text: "6:00am - 5:45am"),
				OpeningTime(label: "Sunday to Saturday", text: "6:00am - 1:00pm, 1:15pm - 5:45am"),
				OpeningTime(label: "Sunday", text: "6:00am - 9:30am")
			],
			isBookable: true,
			leadTime: EateryLeadTime(title: "Booking opens:",
									 subtitle: "9am EST Feb 10th, 2024",
									 description: "Pop back then to make your reservations.",
									 date: Date(),
									 upgradeClassUrl: "",
									 isCountdownStarted: false),
            preVoyageBookingStoppedInfo: nil,
            menuData: nil
		)
	}
}

extension EateryDetailsModel {
	static func sampleWithPreVoyageBookingStoppedInfo() -> EateryDetailsModel {
		EateryDetailsModel(
			name: "Razzle Dazzle Restaurant",
			deckLocation: "Deck 5 Mid",
			portraitHeroURL: "https://cert.gcpshore.virginvoyages.com/dam/jcr:a6233f56-5316-4826-a5f8-533709598e56/IMG-FNB-razzle-dazzle-interior-bw-1200x1440.jpg",
			externalId: "5a4bf485da0c112a66ed6217",
			venueId: "5a4bf485da0c112a66ed6217",
			introduction: "The go-to option for cool and casual dining on board – serving dinner, breakfast and… *dramatic head turn*...all day boozy brunch.",
			longDescription: "So your best friend wants something healthy, and you want&hellip;sunny side hash? This is the place. Boasting a bold interior and a daring new dinner menu, this happening spot offers our creative twist on some classic American comfort go-to&rsquo;s. Razzle Dazzle strikes a culinary sweet spot between balance and decadence, with a menu that skews partly toward veggie-conscious dishes, and partly toward meats, sweets, and gluttonous treats. So whether you&rsquo;re looking for something rejuvenating and familiar or something spicy and out of left field, you&rsquo;ll leave here full of goodness.",
			needToKnows: [
				"Our dress code is pretty chill, but please no swimwear.",
				"Brunch is available daily, please book onboard."
			],
            editorialBlocks: [
                "https://cms-cert.ship.virginvoyages.com/Sailor-App/Guides/Editorial-Blocks/eatery-booking-restriction/content/0.html"
            ],
			openingTimes: [
				OpeningTime(label: "Saturday", text: "6:00am - 5:45am"),
				OpeningTime(label: "Sunday to Saturday", text: "6:00am - 1:00pm, 1:15pm - 5:45am"),
				OpeningTime(label: "Sunday", text: "6:00am - 9:30am")
			],
			isBookable: true,
			leadTime: nil,
            preVoyageBookingStoppedInfo: .init(title: "We’re moving bookings and bags", description: "Our bookings are moving onto ship and will re-open on the Sailor App once you are on board."),
            menuData: nil
		)
	}
}

extension EateryDetailsModel {
	func copy(name: String? = nil,
			  deckLocation: String?  = nil,
			  portraitHeroURL: String?  = nil,
			  externalId: String?  = nil,
			  venueId: String? = nil,
			  introduction: String? = nil,
			  longDescription: String? = nil,
			  needToKnows: [String]? = nil,
              editorialBlocks: [String]? = nil,
			  openingTimes: [OpeningTime]? = nil,
			  isBookable: Bool? = nil,
			  leadTime: EateryLeadTime? = nil,
			  preVoyageBookingStoppedInfo: EateryPreVoyageBookingStoppedInfo? = nil,
              menuData: MenuData? = nil) -> EateryDetailsModel {
		EateryDetailsModel(
			name: name ?? self.name,
			deckLocation: deckLocation ?? self.deckLocation,
			portraitHeroURL: portraitHeroURL ?? self.portraitHeroURL,
			externalId: externalId ?? self.externalId,
			venueId: venueId ?? self.venueId,
			introduction: introduction ?? self.introduction,
			longDescription: longDescription ?? self.longDescription,
			needToKnows: needToKnows ?? self.needToKnows,
            editorialBlocks: editorialBlocks ?? self.editorialBlocks,
			openingTimes: openingTimes ?? self.openingTimes,
			isBookable: isBookable != nil ? isBookable! : self.isBookable,
			leadTime: leadTime ?? self.leadTime,
			preVoyageBookingStoppedInfo: preVoyageBookingStoppedInfo ?? self.preVoyageBookingStoppedInfo,
            menuData: menuData ?? self.menuData
		)
	}
}

enum OpeningStatus: Equatable {
    case open(until: String)
    case closed
}

extension Array where Element == EateryDetailsModel.OpeningTime {

    func status(for date: Date = Date()) -> OpeningStatus {
        guard let todayOpening = openingTime(for: date), !todayOpening.text.lowercased().contains("closed") else {
            return .closed
        }

        let ranges = splitRanges(from: todayOpening.text)
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: date)
        let parser = DateFormatter.createTimeParser()

        for range in ranges {
            guard let (start, end) = parseRange(range, today: today, parser: parser, calendar: calendar) else {
                continue
            }

            if date >= start && date <= end {
                return .open(until: end.toHourMinuteDeviceTimeLowercaseMeridiem(timeZone: .current))
            }
        }

        return .closed
    }

    // MARK: - Helpers

    private func openingTime(for date: Date) -> EateryDetailsModel.OpeningTime? {
        let todayLabel = date.weekdayName()
        return first(where: { $0.label == todayLabel })
    }

    private func splitRanges(from text: String) -> [String] {
        text.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }
    }

    private func parseRange(_ range: String, today: Date, parser: DateFormatter, calendar: Calendar) -> (start: Date, end: Date)? {
        let parts = range.components(separatedBy: " - ").map { $0.trimmingCharacters(in: .whitespaces) }
        guard parts.count == 2,
              let startTime = parser.date(from: parts[0].uppercased()),
              let endTime = parser.date(from: parts[1].uppercased()) else { return nil }

        guard let start = calendar.date(
            bySettingHour: calendar.component(.hour, from: startTime),
            minute: calendar.component(.minute, from: startTime),
            second: 0,
            of: today
        ), var end = calendar.date(
            bySettingHour: calendar.component(.hour, from: endTime),
            minute: calendar.component(.minute, from: endTime),
            second: 0,
            of: today
        ) else {
            return nil
        }

        // Handle overnight ranges
        if end <= start {
            end = calendar.date(byAdding: .day, value: 1, to: end) ?? end
        }

        return (start, end)
    }
}
