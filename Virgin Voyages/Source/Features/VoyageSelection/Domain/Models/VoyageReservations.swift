//
//  VoyageReservations.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 1.6.25.
//

struct VoyageReservations {
    var profilePhotoURL: String
    var pageDetails: PageDetails
    var guestBookings: [GuestBooking]
    
    struct PageDetails: Codable {
        var buttons: Buttons
        var imageURL: String
        var description: String
        var title: String
        var labels: Labels
        
        struct Buttons: Codable {
            var bookVoyage: String
            var connectBooking: String
        }

        struct Labels: Codable {
            var date: String
            var archived: String
        }
    }

    struct GuestBooking {
        var guestName: String
        var voyageDate: String
        var voyageName: String
        var ports: [String]
        var reservationNumber: String
        var guestId: String
        var reservationGuestId: String
        var reservationId: String
        var portNames: [String?]
        var voyageNumber: String
        var status: String
        var isPastBooking: Bool
        var isActiveBooking: Bool
        var imageUrl: String
        var embarkDate: String
        var shipCode: String
        var shipName: String
        var isArchivedBooking: Bool
        var portsMapping: [PortMapping]
        var bookedDate: String
        
        struct PortMapping {
            var name: String
            var externalId: String
        }
    }
}

// MARK: Extensions

extension VoyageReservations {
    func sortedBookings() -> [GuestBooking] {
        var array: [GuestBooking] = []
        for booking in guestBookings {
            if !array.contains(where: { $0.reservationId == booking.reservationId }) {
                array += [booking]
            }
        }
        
        return array.filter {
            $0.isActiveBooking || !$0.isArchivedBooking
        }.sorted {
            let date1 = $0.embarkDate.iso8601 ?? .now
            let date2 = $1.embarkDate.iso8601 ?? .now
            return date1 < date2
        }
    }
}

extension VoyageReservations {

    static func empty() -> VoyageReservations {
        return VoyageReservations(
            profilePhotoURL: "",
            pageDetails: PageDetails(
                buttons: PageDetails.Buttons(
                    bookVoyage: "",
                    connectBooking: ""
                ),
                imageURL: "",
                description: "",
                title: "",
                labels: PageDetails.Labels(
                    date: "",
                    archived: ""
                )
            ),
            guestBookings: []
        )
    }
}

extension VoyageReservations {

    static func sample() -> VoyageReservations {
        return VoyageReservations(
            profilePhotoURL: "",
            pageDetails: PageDetails(
                buttons: PageDetails.Buttons(
                    bookVoyage: "Book another voyage",
                    connectBooking: "Connect a booking"
                ),
                imageURL: "https://int.virginvoyages.com/svc/dxpcore/mediaitems/e8b87907-d25e-4d02-8428-0a0005e50bfe",
                description: "You've got some sweet sails coming up — so choose which specific voyage you'd like to view below.",
                title: "Voyage Selection",
                labels: PageDetails.Labels(
                    date: "DATE",
                    archived: "ARCHIVED"
                )
            ),
            guestBookings: [
                GuestBooking(
                    guestName: "Anika Dillon",
                    voyageDate: "July 27-August 1 2025",
                    voyageName: "Riviera Maya",
                    ports: ["MIA", "CZM", "BIM", "MIA"],
                    reservationNumber: "1517294",
                    guestId: "38ca11c9-0ef8-45e6-8b73-536f491ad03c",
                    reservationGuestId: "b1a9ddda-90c2-4c22-b759-f7ca0f7e9b44",
                    reservationId: "2f1d7810-bb62-40c2-af21-9dffe8727644",
                    portNames: ["Miami", "Florida", "Key West", "Florida", "Beach Club at Bimini", "Miami", "Florida"],
                    voyageNumber: "VL2507275NCZ",
                    status: "Booked - PIF",
                    isPastBooking: false,
                    isActiveBooking: false,
                    imageUrl: "https://cert.gcpshore.virginvoyages.com/dam/jcr:738a7567-2275-466f-b88d-2f72cbc1a2a5/Booking%20Flow-Riviera%20Maya-356x356.png",
                    embarkDate: "2025-07-27",
                    shipCode: "VL",
                    shipName: "Valiant Lady",
                    isArchivedBooking: false,
                    portsMapping: [
                        GuestBooking.PortMapping(name: "Miami", externalId: "MIA"),
                        GuestBooking.PortMapping(name: "Cozumel (Playa del Carmen)", externalId: "CZM"),
                        GuestBooking.PortMapping(name: "Beach Club at Bimini", externalId: "BIM")
                    ],
                    bookedDate: "2025-04-17T00:00:00"
                ),
                GuestBooking(
                    guestName: "Anika Dillon",
                    voyageDate: "July 27-August 2 2025",
                    voyageName: "Porto Plata",
                    ports: ["MIA", "CZM", "BIM", "MIA"],
                    reservationNumber: "1524755",
                    guestId: "38ca11c9-0ef8-45e6-8b73-536f491ad03c",
                    reservationGuestId: "b1a9ddda-90c2-4c22-b759-f7ca0f7e9b45",
                    reservationId: "2f1d7810-bb62-40c2-af21-9dffe8727645",
                    portNames: ["Miami", "Florida", "Key West", "Florida", "Beach Club at Bimini", "Miami", "Florida"],
                    voyageNumber: "VL2507275NCZ",
                    status: "Booked - PIF",
                    isPastBooking: false,
                    isActiveBooking: true,
                    imageUrl: "https://cert.gcpshore.virginvoyages.com/dam/jcr:738a7567-2275-466f-b88d-2f72cbc1a2a5/Booking%20Flow-Riviera%20Maya-356x356.png",
                    embarkDate: "2025-07-27",
                    shipCode: "VL",
                    shipName: "Valiant Lady",
                    isArchivedBooking: false,
                    portsMapping: [
                        GuestBooking.PortMapping(name: "Miami", externalId: "MIA"),
                        GuestBooking.PortMapping(name: "Cozumel (Playa del Carmen)", externalId: "CZM"),
                        GuestBooking.PortMapping(name: "Beach Club at Bimini", externalId: "BIM")
                    ],
                    bookedDate: "2025-04-17T00:00:00"
                ),
                GuestBooking(
                    guestName: "John Dillon",
                    voyageDate: "July 22-August 3 2025",
                    voyageName: "Virgin",
                    ports: ["MIA", "CZM", "BIM", "MIA"],
                    reservationNumber: "1524756",
                    guestId: "38ca11c9-0ef8-45e6-8b73-536f491ad03c",
                    reservationGuestId: "b1a9ddda-90c2-4c22-b759-f7ca0f7e9b44",
                    reservationId: "2f1d7810-bb62-40c2-af21-9dffe8727646",
                    portNames: ["Miami", "Florida", "Key West", "Florida", "Beach Club at Bimini", "Miami", "Florida"],
                    voyageNumber: "VL2507275NCZ",
                    status: "Booked - PIF",
                    isPastBooking: false,
                    isActiveBooking: false,
                    imageUrl: "https://cert.gcpshore.virginvoyages.com/dam/jcr:738a7567-2275-466f-b88d-2f72cbc1a2a5/Booking%20Flow-Riviera%20Maya-356x356.png",
                    embarkDate: "2025-07-27",
                    shipCode: "VL",
                    shipName: "Valiant Valiant Lady",
                    isArchivedBooking: true,
                    portsMapping: [
                        GuestBooking.PortMapping(name: "Miami", externalId: "MIA"),
                        GuestBooking.PortMapping(name: "Cozumel (Playa del Carmen)", externalId: "CZM"),
                        GuestBooking.PortMapping(name: "Beach Club at Bimini", externalId: "BIM")
                    ],
                    bookedDate: "2025-04-17T00:00:00"
                )
            ]
        )
    }
}


