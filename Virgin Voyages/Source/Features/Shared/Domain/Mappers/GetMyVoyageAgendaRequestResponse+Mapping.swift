//
//  GetMyVoyageAgendaRequestResponse+Mapping.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 6.3.25.
//

import Foundation

extension GetMyVoyageAgendaRequestResponse {
    func toDomain() -> MyVoyageAgenda {
        return MyVoyageAgenda(
            title: self.title.value,
            appointments: self.appointments?.map { appointment in
                MyVoyageAgenda.Appointment(
                    id: appointment.id.value,
                    location: appointment.location.value,
                    inventoryState: InventoryState(rawValue: appointment.inventoryState.value) ?? .nonInventoried,
                    imageUrl: appointment.imageUrl.value,
					timePeriod: appointment.timePeriod.value,
					date: Date.fromISOString(string: appointment.date),
                    bookableType: BookableType(rawValue: appointment.bookableType.value) ?? .eatery,
                    name: appointment.name.value
                )
            } ?? [],
            emptyStateText: self.emptyStateText.value,
            emptyStatePictogramUrl: self.emptyStatePictogramUrl.value
        )
    }
}
