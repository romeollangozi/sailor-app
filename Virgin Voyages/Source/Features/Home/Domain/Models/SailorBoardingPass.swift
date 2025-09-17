//
//  SailorBoardingPass.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 4/2/25.
//

import Foundation

struct SailorBoardingPass {
    
    let items: [BoardingPassItem]
    
    struct BoardingPassItem: Identifiable {
        var id = UUID().uuidString
        
        let shipName: String
        let voyageName: String
        let depart: String
        let arrive: String
        let sailor: String
        let bookingRef: String
        let arrivalTime: String
        let cabinNumber: String
        let embarkation: String
        let portLocation: String
        let sailTime: String
        let cabin: String
        let musterStation: String
        let notes: String
        let imageUrl: String
        let sailorTitle: String
        let reservationGuestId: String
        let firstName: String
        let lastName: String
        let coordinates: String
        let placeId: String
        let sailorType: SailorType?
    }
    
}

extension SailorBoardingPass {
    
    static func empty() -> SailorBoardingPass {
        return SailorBoardingPass(items: [])
    }
    
    static func sample() -> SailorBoardingPass {
        return SailorBoardingPass(items: [
            
            BoardingPassItem(shipName: "Valiant Lady",
                             voyageName: "The Irresistible Med",
                             depart: "Jun 1",
                             arrive: "Jun 5",
                             sailor: "Samuel Hails",
                             bookingRef: "252877",
                             arrivalTime: "3:00pm",
                             cabinNumber: "12158A",
                             embarkation: "Sailor",
                             portLocation: "Port of Miami",
                             sailTime: "Departs at 6:00pm, local time. Sailors must be embarked 60 minutes prior.",
                             cabin: "Sea Terrace",
                             musterStation: "The Manor, Deck 6 Aft",
                             notes: "Wheelchair service",
                             imageUrl: "",
                             sailorTitle: "Sailor 1 Title",
                             reservationGuestId: "123455",
                             firstName: "John",
                             lastName: "Smith",
                             coordinates: "25.78011907532392, -80.1798794875817",
                             placeId: "ChIJFfjVPFKipBIRHSOvLv8cReQ",
                             sailorType: .standard),
            
            BoardingPassItem(shipName: "Valiant Lady",
                             voyageName: "The Irresistible Med",
                             depart: "Jun 1",
                             arrive: "Jun 5",
                             sailor: "Anna Hails",
                             bookingRef: "252877",
                             arrivalTime: "3:00pm",
                             cabinNumber: "12158A",
                             embarkation: "Sailor",
                             portLocation: "Port of Miami",
                             sailTime: "Departs at 6:00pm, local time. Sailors must be embarked 60 minutes prior.",
                             cabin: "Sea Terrace",
                             musterStation: "The Manor, Deck 6 Aft",
                             notes: "Wheelchair service",
                             imageUrl: "",
                             sailorTitle: "Sailor 2 Title",
                             reservationGuestId: "123455",
                             firstName: "Anna",
                             lastName: "Smith",
                             coordinates: "25.78011907532392, -80.1798794875817",
                             placeId: "ChIJFfjVPFKipBIRHSOvLv8cReQ",
                             sailorType: .priority),
            
            BoardingPassItem(shipName: "Valiant Lady",
                             voyageName: "The Irresistible Med",
                             depart: "Jun 1",
                             arrive: "Jun 5",
                             sailor: "Anna Hails",
                             bookingRef: "252877",
                             arrivalTime: "3:00pm",
                             cabinNumber: "12158A",
                             embarkation: "Sailor",
                             portLocation: "Port of Miami",
                             sailTime: "Departs at 6:00pm, local time. Sailors must be embarked 60 minutes prior.",
                             cabin: "Sea Terrace",
                             musterStation: "The Manor, Deck 6 Aft",
                             notes: "Wheelchair service",
                             imageUrl: "",
                             sailorTitle: "Sailor 2 Title",
                             reservationGuestId: "123455",
                             firstName: "Mi",
                             lastName: "Smith",
                             coordinates: "25.78011907532392, -80.1798794875817",
                             placeId: "ChIJFfjVPFKipBIRHSOvLv8cReQ",
                             sailorType: .rockStar),
            
        ])
    }
    
}

extension SailorBoardingPass {
    func prioritized(by reservationGuestId: String) -> SailorBoardingPass {
        let prioritized = self.items.filter { $0.reservationGuestId == reservationGuestId }
        let others = self.items.filter { $0.reservationGuestId != reservationGuestId }
        return SailorBoardingPass(items: prioritized + others)
    }
}

extension SailorBoardingPass {
	func copy(items: [BoardingPassItem]? = nil) -> SailorBoardingPass {
		return SailorBoardingPass(items: items ?? self.items)
	}
}

extension SailorBoardingPass.BoardingPassItem {
	func copy(
		id: String? = nil,
		shipName: String? = nil,
		voyageName: String? = nil,
		depart: String? = nil,
		arrive: String? = nil,
		sailor: String? = nil,
		bookingRef: String? = nil,
		arrivalTime: String? = nil,
		cabinNumber: String? = nil,
		embarkation: String? = nil,
		portLocation: String? = nil,
		sailTime: String? = nil,
		cabin: String? = nil,
		musterStation: String? = nil,
		notes: String? = nil,
		imageUrl: String? = nil,
		sailorTitle: String? = nil,
		reservationGuestId: String? = nil,
		firstName: String? = nil,
		lastName: String? = nil,
		coordinates: String? = nil,
        placeId: String? = nil,
		sailorType: SailorType? = nil
	) -> SailorBoardingPass.BoardingPassItem {
		return SailorBoardingPass.BoardingPassItem(
			id: id ?? self.id,
			shipName: shipName ?? self.shipName,
			voyageName: voyageName ?? self.voyageName,
			depart: depart ?? self.depart,
			arrive: arrive ?? self.arrive,
			sailor: sailor ?? self.sailor,
			bookingRef: bookingRef ?? self.bookingRef,
			arrivalTime: arrivalTime ?? self.arrivalTime,
			cabinNumber: cabinNumber ?? self.cabinNumber,
			embarkation: embarkation ?? self.embarkation,
			portLocation: portLocation ?? self.portLocation,
			sailTime: sailTime ?? self.sailTime,
			cabin: cabin ?? self.cabin,
			musterStation: musterStation ?? self.musterStation,
			notes: notes ?? self.notes,
			imageUrl: imageUrl ?? self.imageUrl,
			sailorTitle: sailorTitle ?? self.sailorTitle,
			reservationGuestId: reservationGuestId ?? self.reservationGuestId,
			firstName: firstName ?? self.firstName,
			lastName: lastName ?? self.lastName,
            coordinates: coordinates ?? self.coordinates,
            placeId: placeId ?? self.placeId,
			sailorType: sailorType ?? self.sailorType
		)
	}
}

extension SailorBoardingPass.BoardingPassItem {
	static func sample() -> SailorBoardingPass.BoardingPassItem {
		return SailorBoardingPass.BoardingPassItem(
			id: "12345",
			shipName: "Scarlet Lady",
			voyageName: "Caribbean Getaway",
			depart: "JUN 1",
			arrive: "JUN 5",
			sailor: "John Doe",
			bookingRef: "ABCD1234",
			arrivalTime: "12:00 PM",
			cabinNumber: "101",
			embarkation: "Miami",
			portLocation: "PortMiami",
			sailTime: "5:00 PM",
			cabin: "Sea Terrace",
			musterStation: "A1",
			notes: "Welcome aboard!",
			imageUrl: "https://example.com/image.jpg",
			sailorTitle: "Mr.",
			reservationGuestId: "67890",
			firstName: "John",
			lastName: "Doe",
            coordinates: "25.7617° N, 80.1918° W",
            placeId: "ChIJFfjVPFKipBIRHSOvLv8cReQ",
			sailorType: .standard
		)
	}
}
