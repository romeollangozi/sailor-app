//
//  GetBoardingPassResponse+Mapping.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 4/2/25.
//

import Foundation

extension GetBoardingPassResponse {
    
    func toDomain() -> SailorBoardingPass {
        
        var boardingPassItems: [SailorBoardingPass.BoardingPassItem] = []
        
        if let responseBoardingPassItems = self.boardingPass {
            responseBoardingPassItems.forEach {
                boardingPassItems.append($0.toDomain())
            }
        }
        
        return SailorBoardingPass(items: boardingPassItems)
    }
    
}

extension GetBoardingPassResponse.BoardingPassItem {
    
    func toDomain() -> SailorBoardingPass.BoardingPassItem {
        
        return SailorBoardingPass.BoardingPassItem(shipName: self.shipName ?? "",
                                                   voyageName: self.voyageName ?? "",
                                                   depart: self.depart ?? "",
                                                   arrive: self.arrive ?? "",
                                                   sailor: self.sailor ?? "",
                                                   bookingRef: self.bookingRef ?? "",
                                                   arrivalTime: self.arrivalTime ?? "",
                                                   cabinNumber: self.cabinNumber ?? "",
                                                   embarkation: self.embarkation ?? "",
                                                   portLocation: self.portLocation ?? "",
                                                   sailTime: self.sailTime ?? "",
                                                   cabin: self.cabin ?? "",
                                                   musterStation: self.musterStation ?? "",
                                                   notes: self.notes ?? "",
                                                   imageUrl: self.imageUrl ?? "",
                                                   sailorTitle: self.sailorTitle ?? "",
                                                   reservationGuestId: self.reservationGuestId ?? "",
                                                   firstName: self.firstName ?? "",
                                                   lastName: self.lastName ?? "",
                                                   coordinates: self.coordinates ?? "",
                                                   placeId: self.placeId ?? "",
                                                   sailorType: SailorType(from: self.sailorType ?? ""))
    }
}
