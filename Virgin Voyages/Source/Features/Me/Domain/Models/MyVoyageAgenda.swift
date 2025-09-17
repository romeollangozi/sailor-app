//
//  MyVoyageAgenda.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 6.3.25.
//

import Foundation

struct MyVoyageAgenda {
    let title: String
    let appointments: [Appointment]
    let emptyStateText: String
    let emptyStatePictogramUrl: String
    
    struct Appointment: Equatable, Hashable {
		let uuid: UUID = UUID()
        let id: String
        let location: String
        let inventoryState: InventoryState
        let imageUrl: String
        let timePeriod: String
		let date: Date
        let bookableType: BookableType
        let name: String
    }
}

extension MyVoyageAgenda {
	func filterByDate(_ date: Date) -> [Appointment] {
		return self.appointments.filter { isSameDay(date1: $0.date, date2: date) }
	}
}


extension MyVoyageAgenda.Appointment {
    func toModel() -> MyVoyageAgenda.Appointment {
        return MyVoyageAgenda.Appointment(
            id: self.id,
            location: self.location,
            inventoryState: self.inventoryState,
            imageUrl: self.imageUrl,
            timePeriod: self.timePeriod,
			date: self.date,
            bookableType: self.bookableType,
            name: self.name
        )
    }
}

extension MyVoyageAgenda {
    static func empty() -> MyVoyageAgenda {
        return MyVoyageAgenda(
            title: "",
            appointments: [],
            emptyStateText: "",
            emptyStatePictogramUrl: ""
        )
    }

    static func sample() -> MyVoyageAgenda {
        return MyVoyageAgenda(
            title: "Keep track of everything you’ve booked right here.",
            appointments: [
                .init(
                    id: "1",
                    location: "Cork's Crew, Deck 3",
                    inventoryState: .nonInventoried,
                    imageUrl: "",
					timePeriod: "8-9:00pm",
					date: Date(),
                    bookableType: .eatery,
                    name: "Let's Set Sail from the Dock"
                ),
                .init(
                    id: "2",
                    location: "Pink Agave, Deck 5",
                    inventoryState: .paidInventoried,
                    imageUrl: "https://cert.gcpshore.virginvoyages.com/dam/jcr:5f4e1e68-303c-48a8-9874-02ae316f2fae/IMG-Salvation-Swedish-Massage-iStock-1096645432-1200x800.jpg",
					timePeriod: "7:45-9:00pm",
					date: Date(),
                    bookableType: .treatment,
                    name: "Salvation Swedish Massage"
                ),
                .init(
                    id: "3",
                    location: "Puerto-Plata",
                    inventoryState: .nonInventoried,
                    imageUrl: "https://cert.gcpshore.virginvoyages.com/dam/jcr:68b44a33-56bd-4989-a58d-74d1e8017706/ILL-ENT-UK-Summer-Series-Entertainment-PJ-Party-Under-Stars-120x120.jpg",
					timePeriod: "5-6:00pm",
					date: Date(),
                    bookableType: .entertainment,
                    name: "PJ Party"
                )
            ],
            emptyStateText: "It’s the last day, but don’t be sad! There’s still a loads going on. Squeeze the last drops out of your voyage.",
            emptyStatePictogramUrl: "https://cert.gcpshore.virginvoyages.com/dam/jcr:7691d154-8668-4043-a123-99b76b4e03bf/emptylist_myagenda_128x128.png"
        )
    }

    static func noAppointments() -> MyVoyageAgenda {
        return MyVoyageAgenda(
            title: "Keep track of everything you’ve booked right here.",
            appointments: [],
            emptyStateText: "It’s the last day, but don’t be sad! There’s still a loads going on. Squeeze the last drops out of your voyage.",
            emptyStatePictogramUrl: "https://cert.gcpshore.virginvoyages.com/dam/jcr:7691d154-8668-4043-a123-99b76b4e03bf/emptylist_myagenda_128x128.png"
        )
    }

}

extension MyVoyageAgenda {
	func copy(
		title: String? = nil,
		appointments: [Appointment]? = nil,
		emptyStateText: String? = nil,
		emptyStatePictogramUrl: String? = nil
	) -> MyVoyageAgenda {
		return MyVoyageAgenda(
			title: title ?? self.title,
			appointments: appointments ?? self.appointments,
			emptyStateText: emptyStateText ?? self.emptyStateText,
			emptyStatePictogramUrl: emptyStatePictogramUrl ?? self.emptyStatePictogramUrl
		)
	}
}

extension MyVoyageAgenda.Appointment {
	func copy(
		id: String? = nil,
		location: String? = nil,
		inventoryState: InventoryState? = nil,
		imageUrl: String? = nil,
		timePeriod: String? = nil,
		date: Date? = nil,
		bookableType: BookableType? = nil,
		name: String? = nil
	) -> MyVoyageAgenda.Appointment {
		return MyVoyageAgenda.Appointment(
			id: id ?? self.id,
			location: location ?? self.location,
			inventoryState: inventoryState ?? self.inventoryState,
			imageUrl: imageUrl ?? self.imageUrl,
			timePeriod: timePeriod ?? self.timePeriod,
			date: date ?? self.date,
			bookableType: bookableType ?? self.bookableType,
			name: name ?? self.name
		)
	}
}
