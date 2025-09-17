//
//  MessengerContacts.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 13.11.24.
//

struct MessengerContacts: Codable {
    let cabinMates: [ContactItem]
    let sailorMates: [ContactItem]
    let directoryDetails: [DirectoryItem]
    let isDefaultContactsDelete: Bool
    
    struct ContactItem: Codable {
        let name: String
        let photoUrl: String
        let personId: String
        let reservationId: String
        let isEventVisible: Bool
    }
    
    struct DirectoryItem: Codable {
        let assetKeyName: String
        let phoneNumber: String
        let isMessenger: Bool
        let isEnable: Bool
    }
}

extension MessengerContacts {
    static func map(from response: GetMessengerContactsResponse) -> MessengerContacts {
        return MessengerContacts(
            cabinMates: (response.cabinMates ?? []).map { contact in
                ContactItem(
                    name: contact.name.value,
                    photoUrl: contact.photoUrl.value,
                    personId: contact.personId.value,
                    reservationId: contact.reservationId.value,
                    isEventVisible: contact.isEventVisible.value
                )
            },
            sailorMates: (response.sailorMates ?? []).map { contact in
                ContactItem(
                    name: contact.name.value,
                    photoUrl: contact.photoUrl.value,
                    personId: contact.personId.value,
                    reservationId: contact.reservationId.value,
                    isEventVisible: contact.isEventVisible.value
                )
            },
            directoryDetails: (response.directoryDetails ?? []).map { directory in
                DirectoryItem(
                    assetKeyName: directory.assetKeyName.value,
                    phoneNumber: directory.phoneNumber.value,
                    isMessenger: directory.isMessenger.value,
                    isEnable: directory.isEnable.value
                )
            },
            isDefaultContactsDelete: response.isDefaultContactsDelete.value
        )
    }
}
