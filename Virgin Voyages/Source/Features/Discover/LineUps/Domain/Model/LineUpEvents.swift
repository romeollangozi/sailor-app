//
//  LineUpEvents.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 15.1.25.
//

import Foundation

struct LineUpEvents : Equatable, Hashable  {
	let sequence: Int
    let time: String
    let items: [EventItem]
    let uuid: String = UUID().uuidString
    let date: Date

    static func == (lhs: LineUpEvents, rhs: LineUpEvents) -> Bool {
        return lhs.time == rhs.time
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(time)
    }

    struct EventItem : Equatable, Hashable {
        let id: UUID = UUID()
        let eventID: String
		let categoryCode: String
        let name: String
        let imageUrl: String?
        let location: String
        let timePeriod: String
        let type: LineUpType
        let bookingType: BookingType
        let introduction: String?
        let longDescription: String?
        let price: Double
        let priceFormatted: String?
		let currencyCode: String
        let needToKnows: [String]
        let editorialBlocks: [String]
        let isBooked: Bool
        let bookedText: String
        let isPreVoyageBookingStopped: Bool
        let isBookingEnabled: Bool
        let bookButtonText: String?
        let selectedSlot: Slot?
        let appointments: Appointments?
        let inventoryState: InventoryState
        let slots: [Slot]
        var editorialBlocksWithContent: [EditorialBlock]?

        static func == (lhs: EventItem, rhs: EventItem) -> Bool {
            return lhs.eventID == rhs.eventID
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(eventID)
        }

		var isMultiDayEvent: Bool {
			return bookingType == .multiDaySingleInstance || bookingType == .multiDayMultiInstance
		}

		var eventDays: [Date] {
			let dates = slots.compactMap { $0.startDateTime }
			let uniqueDates = Set(dates.map { Calendar.current.startOfDay(for: $0) })
			return uniqueDates.sorted()
		}

        var selectedSlotStatusText: String? {
            switch selectedSlot?.status {
            case .soldOut:
                return "Sold out"
            case .notAvailable:
                return "Not available"
            case .closed:
                return "BOOKING CLOSED"
            case .passed:
                return nil
            case .available:
                return "Available"
            default:
                return nil
            }
        }

        var otherTimes: [Slot] {
            return slots.filter { $0 != selectedSlot }
        }

		func slotsForDate(date: Date) -> [Slot] {
			return slots.filter { Calendar.current.isDate($0.startDateTime, inSameDayAs: date) }
		}
    }

    enum LineUpType: String {
        case bookable = "Bookable"
        case informative = "Informative"
    }
}

extension LineUpEvents {
    static func sample() -> [LineUpEvents] {
        return [
            LineUpEvents(
				sequence: 0,
				time: "1pm",
                items: [
                    EventItem(
                        eventID: "616856c570fae55c2756c869",
						categoryCode: "ENT",
                        name: "The Charmer's Lounge",
                        imageUrl: "https://cert.gcpshore.virginvoyages.com/dam/jcr:54d66526-e3b5-4adb-bf6f-271178c541c9/IMG-ENT-The-Charmers-Lounge-1200x800.jpg",
                        location: "The Dock House, Deck 7",
						timePeriod: "1-1:30pm",
                        type: .bookable,
                        bookingType: .multiDayMultiInstance,
                        introduction: "Optical illusion or just good old-fashioned magic show will be sure to keep you spellbound by The Charmer.",
						longDescription: "The Charmer is not only our lady ship's resident magician, but also the consummate host. You may be charmed by impromptu illusions, or perhaps it’s The Charmer’s mystifying personality that draws you to the show.",
                        price: 0,
                        priceFormatted: nil,
						currencyCode: "USD",
                        needToKnows: [
                            "This event is on a first-come, first-served basis.",
                            "We will be using a virtual queue to manage the entrance."
                        ],
                        editorialBlocks: [],
                        isBooked: false,
                        bookedText: "",
                        isPreVoyageBookingStopped: false,
                        isBookingEnabled: true,
                        bookButtonText: "Add to agenda",
                        selectedSlot: Slot(
                            id: "6775114c260a140dc4e34d50",
                            startDateTime: Date(),
                            endDateTime: Date(),
                            status: .passed,
                            isBooked: false,
							inventoryCount: 10
                        ),
                        appointments: nil,
                        inventoryState: .nonInventoried,
                        slots: []
                    ),
                    EventItem(
                        eventID: "645163d33cc012e8a86d33df",
						categoryCode: "ENT",
                        name: "Hot in — So Hot in Heels",
                        imageUrl: "https://cert.gcpshore.virginvoyages.com/dam/jcr:54d66526-e3b5-4adb-bf6f-271178c541c9/IMG-ENT-The-Charmers-Lounge-1200x800.jpg",
                        location: "The Dock House, Deck 7",
						timePeriod: "1-2pm",
                        type: .bookable,
                        bookingType: .multiDayMultiInstance,
                        introduction: "Let your hair down, practice self-love, and have fun moving your body to the music — with heels (or not).",
						longDescription: "Come build your confidence, embrace who you are, and (bonus) get in a workout.",
                        price: 0,
                        priceFormatted: nil,
						currencyCode: "USD",
                        needToKnows: [],
                        editorialBlocks: [],
                        isBooked: true,
                        bookedText: "Added",
                        isPreVoyageBookingStopped: false,
                        isBookingEnabled: false,
                        bookButtonText: "Add to agenda",
                        selectedSlot: Slot(
                            id: "6775114c260a140dc4e34d51",
                            startDateTime: Date(),
                            endDateTime: Date(),
                            status: .available,
                            isBooked: true,
							inventoryCount: 10
                        ),
                        appointments: Appointments(
                            bannerText: "Added to agenda, 11 Jan, 1:00pm",
                            items: [
								AppointmentItem.sample()
                            ]
                        ),
                        inventoryState: .nonInventoried,
                        slots: []
                    )
                ], date: Date()
            ),
            LineUpEvents(
				sequence: 1,
				time: "2pm",
                items: [
                    EventItem(
                        eventID: "613caa4191456539eecb4b1d",
						categoryCode: "ENT",
                        name: "Shot for Shot: A Cocktail and Photography Workshop $50 - Book On Board!",
                        imageUrl: nil,
                        location: "The Test Kitchen, Deck 6",
						timePeriod: "2-2:30am",
                        type: .informative,
                        bookingType: .multiDayMultiInstance,
                        introduction: nil,
						longDescription: nil,
                        price: 0,
						priceFormatted: nil,
						currencyCode: "USD",
                        needToKnows: [],
                        editorialBlocks: [],
                        isBooked: false,
                        bookedText: "",
                        isPreVoyageBookingStopped: false,
                        isBookingEnabled: false,
                        bookButtonText: nil,
                        selectedSlot: nil,
                        appointments: nil,
                        inventoryState: .nonInventoried,
                        slots: []
                    )
                ], date: Date()
            ),
            LineUpEvents(
				sequence: 2,
				time: "4pm",
                items: [
                    EventItem(
                        eventID: "5b202642a94f130c85ea22ca",
						categoryCode: "ENT",
                        name: "Salty Trivia",
                        imageUrl: "https://cert.gcpshore.virginvoyages.com/dam/jcr:7c494ed9-12fa-4b67-acff-8664d0d5e872/ILL-ENT-8BIT-SaltyTrivia-1200x800.png",
                        location: "The Loose Cannon, Deck 7 FWD",
						timePeriod: "4:30-5:30pm",
                        type: .bookable,
                        bookingType: .multiDayMultiInstance,
                        introduction: "Optical illusion or just good old-fashioned magic show will be sure to keep you spellbound by The Charmer.",
						longDescription: "The Happenings Cast compiles the best of pop culture, history, current events and beyond in a uniquely multi-round trivia event created for your voyage.",
                        price: 10,
                        priceFormatted: "$10",
						currencyCode: "USD",
                        needToKnows: [
                            "Please keep in mind this is a first come, first served event. The venue will open 15 minutes prior to the event, and space is limited.",
                            "By selecting 'book', it does not guarantee admission to the event, so try to arrive when the venue opens to ensure a spot."
                        ],
                        editorialBlocks: [],
                        isBooked: false,
                        bookedText: "",
                        isPreVoyageBookingStopped: false,
                        isBookingEnabled: true,
                        bookButtonText: "Book other times",
                        selectedSlot: Slot(
                            id: "6775114c260a140dc4e34d50",
                            startDateTime: Date(),
                            endDateTime: Date(),
                            status: .soldOut,
                            isBooked: false,
							inventoryCount: 10
                        ),
                        appointments: nil,
                        inventoryState: .paidInventoried,
                        slots: []
                    )
                ], date: Date()
            ),
            LineUpEvents(
				sequence: 3,
				time: "5pm",
                items: [
                    EventItem(
                        eventID: "57e6c90ab2614f8689392a22f4b0241f",
						categoryCode: "ENT",
                        name: "Afternoon Tea at SIP",
                        imageUrl: "https://cert.gcpshore.virginvoyages.com/dam/jcr:7c494ed9-12fa-4b67-acff-8664d0d5e872/ILL-ENT-8BIT-SaltyTrivia-1200x800.png",
                        location: "Sip Lounge, Deck 7",
						timePeriod: "5:30-6:00pm",
                        type: .bookable,
                        bookingType: .multiDayMultiInstance,
                        introduction: "Optical illusion or just good old-fashioned magic show will be sure to keep you spellbound by The Charmer.",
						longDescription: "The Happenings Cast compiles the best of pop culture, history, current events and beyond in a uniquely multi-round trivia event created for your voyage.",
                        price: 0,
                        priceFormatted: "$10",
						currencyCode: "USD",
                        needToKnows: [
                            "Please keep in mind this is a first come, first served event. The venue will open 15 minutes prior to the event, and space is limited.",
                            "By selecting 'book', it does not guarantee admission to the event, so try to arrive when the venue opens to ensure a spot."
                        ],
                        editorialBlocks: [],
                        isBooked: true,
                        bookedText: "Booked",
                        isPreVoyageBookingStopped: false,
                        isBookingEnabled: true,
                        bookButtonText: "Book other times",
                        selectedSlot: Slot(
                            id: "6775114c260a140dc4e34d50",
                            startDateTime: Date(),
                            endDateTime: Date(),
                            status: .available,
                            isBooked: false,
							inventoryCount: 10
                        ),
                        appointments: Appointments(
                            bannerText: "Booked, 11 Jan, 1:00pm",
                            items: [
								AppointmentItem.sample()
                            ]
                        ),
                        inventoryState: .paidInventoried,
                        slots: []
                    )
                ], date: Date()
            ),
            LineUpEvents(
				sequence: 4,
				time: "6pm",
                items: [
                    EventItem(
                        eventID: "57e6c90ab2614f8689392a22f4b0241f",
						categoryCode: "ENT",
                        name: "Shot for Shot",
                        imageUrl: "https://cert.gcpshore.virginvoyages.com/dam/jcr:7c494ed9-12fa-4b67-acff-8664d0d5e872/ILL-ENT-8BIT-SaltyTrivia-1200x800.png",
                        location: "The Test Kitchen, Deck 7",
						timePeriod: "6:00-6:30pm",
                        type: .bookable,
                        bookingType: .multiDayMultiInstance,
                        introduction: "Optical illusion or just good old-fashioned magic show will be sure to keep you spellbound by The Charmer.",
						longDescription: "The Happenings Cast compiles the best of pop culture, history, current events and beyond in a uniquely multi-round trivia event created for your voyage.",
                        price: 10,
                        priceFormatted: "$10",
						currencyCode: "USD",
                        needToKnows: [
                            "Please keep in mind this is a first come, first served event. The venue will open 15 minutes prior to the event, and space is limited.",
                            "By selecting 'book', it does not guarantee admission to the event, so try to arrive when the venue opens to ensure a spot."
                        ],
                        editorialBlocks: [],
                        isBooked: true,
                        bookedText: "Booked",
                        isPreVoyageBookingStopped: false,
                        isBookingEnabled: true,
                        bookButtonText: "Book other times",
                        selectedSlot: Slot(
                            id: "6775114c260a140dc4e34d50",
                            startDateTime: Date(),
                            endDateTime: Date(),
                            status: .soldOut,
                            isBooked: false,
							inventoryCount: 10
                        ),
                        appointments: Appointments(
                            bannerText: "Booked, 11 Jan, 1:00pm",
                            items: [
								AppointmentItem.sample()
                            ]
                        ),
                        inventoryState: .paidInventoried,
                        slots: []
                    )
                ], date: Date()
            )
        ]
    }
}

struct EditorialBlock: Hashable {
    let url: String
    var html: String?
}

extension LineUpEvents.EventItem {
    static func sample() -> LineUpEvents.EventItem {
        return  LineUpEvents.EventItem(
            eventID: "616856c570fae55c2756c869",
			categoryCode: "ENT",
            name: "The Charmer's Lounge",
            imageUrl: "https://cert.gcpshore.virginvoyages.com/dam/jcr:54d66526-e3b5-4adb-bf6f-271178c541c9/IMG-ENT-The-Charmers-Lounge-1200x800.jpg",
            location: "The Dock House, Deck 7",
			timePeriod: "1-1:30pm",
            type: .bookable,
            bookingType: .multiDayMultiInstance,
            introduction: "Optical illusion or just good old-fashioned magic show will be sure to keep you spellbound by The Charmer.",
			longDescription: "The Charmer is not only our lady ship's resident magician, but also the consummate host. You may be charmed by impromptu illusions, or perhaps it’s The Charmer’s mystifying personality that draws you to the show.",
            price: 0,
            priceFormatted: nil,
			currencyCode: "USD",
            needToKnows: [
                "This event is on a first-come, first-served basis.",
                "We will be using a virtual queue to manage the entrance."
            ],
            editorialBlocks: [],
            isBooked: false,
            bookedText: "",
            isPreVoyageBookingStopped: false,
            isBookingEnabled: true,
            bookButtonText: "Add to agenda",
            selectedSlot: Slot(
                id: "6775114c260a140dc4e34d50",
                startDateTime: Date(),
                endDateTime: Date(),
                status: .available,
                isBooked: false,
				inventoryCount: 10
            ),
            appointments: nil,
            inventoryState: .nonInventoried,
            slots: []
        )
    }
	
	static func empty() -> LineUpEvents.EventItem {
		return  LineUpEvents.EventItem(
            eventID: "",
			categoryCode: "",
			name: "T",
			imageUrl: "",
			location: "",
			timePeriod: "",
			type: .bookable,
			bookingType: .multiDayMultiInstance,
			introduction: "",
			longDescription: "",
			price: 0,
			priceFormatted: nil,
			currencyCode: "USD",
			needToKnows: [],
			editorialBlocks: [],
			isBooked: false,
			bookedText: "",
			isPreVoyageBookingStopped: false,
			isBookingEnabled: true,
			bookButtonText: "",
			selectedSlot: Slot(
				id: "",
				startDateTime: Date(),
				endDateTime: Date(),
				status: .available,
				isBooked: false,
				inventoryCount: 10
			),
			appointments: nil,
			inventoryState: .nonInventoried,
			slots: []
		)
	}
}

extension LineUpEvents.EventItem {
    func copy(
        id: String? = nil,
        name: String? = nil,
        imageUrl: String? = nil,
        location: String? = nil,
        timePeriod: String? = nil,
        type: LineUpEvents.LineUpType? = nil,
        bookingType: BookingType? = nil,
        introduction: String? = nil,
		longDescription: String? = nil,
        price: Double = 0,
        priceFormatted: String? = nil,
        needToKnows: [String]? = nil,
        editorialBlocks: [String]? = nil,
        isBooked: Bool? = nil,
        bookedText: String? = nil,
        isPreVoyageBookingStopped: Bool? = nil,
        isBookingEnabled: Bool? = nil,
        bookButtonText: String? = nil,
        selectedSlot: Slot? = nil,
        appointments: Appointments? = nil,
        inventoryState: InventoryState? = nil,
        slots: [Slot]? = nil
    ) -> LineUpEvents.EventItem {
        return LineUpEvents.EventItem(
            eventID: id ?? self.eventID,
			categoryCode: categoryCode,
            name: name ?? self.name,
            imageUrl: imageUrl ?? self.imageUrl,
            location: location ?? self.location,
			timePeriod: timePeriod ?? self.timePeriod,
            type: type ?? self.type,
            bookingType: bookingType ?? self.bookingType,
            introduction: introduction ?? self.introduction,
			longDescription: longDescription ?? self.longDescription,
            price: price,
            priceFormatted: priceFormatted ?? self.priceFormatted,
			currencyCode: currencyCode,
            needToKnows: needToKnows ?? self.needToKnows,
            editorialBlocks: editorialBlocks ?? self.editorialBlocks,
            isBooked: isBooked ?? self.isBooked,
            bookedText: bookedText ?? self.bookedText,
            isPreVoyageBookingStopped: isPreVoyageBookingStopped ?? self.isPreVoyageBookingStopped,
            isBookingEnabled: isBookingEnabled ?? self.isBookingEnabled,
            bookButtonText: bookButtonText ?? self.bookButtonText,
            selectedSlot: selectedSlot ?? self.selectedSlot,
            appointments: appointments ?? self.appointments,
            inventoryState: inventoryState ?? self.inventoryState,
            slots: slots ?? self.slots
        )
    }
}

extension LineUpEvents {
	static func map(from serverResponse: GetLineUpRequestResponse) -> [LineUpEvents] {
		guard let events = serverResponse.events else {
			return []
		}

		return events.enumerated().compactMap { index, response -> LineUpEvents? in
			guard let time = response.time else { return nil }
			let sequence = response.sequence ?? index

			let items: [LineUpEvents.EventItem] = response.items?.compactMap { item -> LineUpEvents.EventItem? in
				return LineUpEvents.EventItem(
                    eventID: item.id.value,
					categoryCode: item.categoryCode.value,
					name: item.name.value,
					imageUrl: item.imageUrl,
					location: item.location.value,
					timePeriod: item.timePeriod.value,
					type: item.type != nil ? .init(rawValue: item.type!)! : .bookable,
					bookingType: BookingType(rawValue: item.bookingType.value) ?? .other,
					introduction: item.introduction,
					longDescription: item.longDescription,
					price: item.price.value,
					priceFormatted: item.priceFormatted.value,
					currencyCode: item.currencyCode.value,
					needToKnows: item.needToKnows ?? [],
					editorialBlocks: item.editorialBlocks ?? [],
					isBooked: item.isBooked.value,
					bookedText: item.bookedText.value,
					isPreVoyageBookingStopped: item.isPreVoyageBookingStopped.value,
					isBookingEnabled: item.isBookingEnabled.value,
					bookButtonText: item.bookButtonText.value,
					selectedSlot: item.selectedSlot?.toDomain(),
					appointments: item.appointments?.toDomain(),
					inventoryState: item.inventoryState != nil ? .init(rawValue: item.inventoryState!)! : .nonInventoried,
					slots: item.slots?.compactMap { $0.toDomain() } ?? []
				)
			} ?? []

			return LineUpEvents(
				sequence: sequence,
				time: time,
				items: items,
				date: Date.fromISOString(string: response.date)
			)
		}
	}
}

extension LineUpEvents {
    static func mapMustSeeEvents(from serverResponse: GetLineUpRequestResponse) -> [LineUpEvents] {
        guard let events = serverResponse.mustSeeEvents else {
            return []
        }

        return events.enumerated().compactMap { index, response -> LineUpEvents? in
            let sequence = response.sequence ?? index

            let items: [LineUpEvents.EventItem] = response.items?.compactMap { item -> LineUpEvents.EventItem? in
                return LineUpEvents.EventItem(
                    eventID: item.id.value,
                    categoryCode: item.categoryCode.value,
                    name: item.name.value,
                    imageUrl: item.imageUrl,
                    location: item.location.value,
                    timePeriod: item.timePeriod.value,
                    type: item.type != nil ? .init(rawValue: item.type!)! : .bookable,
                    bookingType: BookingType(rawValue: item.bookingType.value) ?? .other,
                    introduction: item.introduction,
                    longDescription: item.longDescription,
                    price: item.price.value,
                    priceFormatted: item.priceFormatted.value,
                    currencyCode: item.currencyCode.value,
                    needToKnows: item.needToKnows ?? [],
                    editorialBlocks: item.editorialBlocks ?? [],
                    isBooked: item.isBooked.value,
                    bookedText: item.bookedText.value,
                    isPreVoyageBookingStopped: item.isPreVoyageBookingStopped.value,
                    isBookingEnabled: item.isBookingEnabled.value,
                    bookButtonText: item.bookButtonText.value,
                    selectedSlot: item.selectedSlot?.toDomain(),
                    appointments: item.appointments?.toDomain(),
                    inventoryState: item.inventoryState != nil ? .init(rawValue: item.inventoryState!)! : .nonInventoried,
                    slots: item.slots?.compactMap { $0.toDomain() } ?? []
                )
            } ?? []

            return LineUpEvents(
                sequence: sequence,
                time: response.time.value,
                items: items,
                date: Date.fromISOString(string: response.date)
            )
        }
    }
}



