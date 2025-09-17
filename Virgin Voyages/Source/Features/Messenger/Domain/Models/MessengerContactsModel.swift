//
//  MessengerContactsModel.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 13.11.24.
//

struct MessengerContactsModel {
    let user: UserModel
    let cabinMates: [ContactItemModel]
    let salorMates: [ContactItemModel]
    let directory: [ContactItemModel]
    let content: ContentModel
    let deepLink: String
    let shareText: String
    
    struct UserModel {
        let reservationGuestId: String
        let reservationId: String
        let voyageNumber: String
        let reservationNumber: String
        let preferredName: String
        let profileImageUrl: String
        
        static func empty() -> UserModel {
            return UserModel(
                reservationGuestId: "",
                reservationId: "",
                voyageNumber: "",
                reservationNumber: "",
                preferredName: "",
                profileImageUrl: ""
            )
        }
    }
    
    struct ContactItemModel: Equatable, Hashable {
        let name: String
        let photoUrl: String
        let personId: String
        let reservationId: String
        let isEventVisible: Bool

        static func empty() -> ContactItemModel {
            return ContactItemModel(name: "", photoUrl: "", personId: "", reservationId: "", isEventVisible: false)
        }
    }
    
    struct ContentModel {
        let noSailorsText: String
        let contactListText: String
        let yourCodeText: String
        let scanCodeText: String
        let sailorMatesText: String
        let directoryText: String
        let cabinmatesText: String
        let loadingText: String
        
        static func empty() -> ContentModel {
            return ContentModel(
                noSailorsText: "",
                contactListText: "",
                yourCodeText: "",
                scanCodeText: "",
                sailorMatesText: "",
                directoryText: "",
                cabinmatesText: "",
                loadingText: ""
            )
        }
    }
    
    static func empty() -> MessengerContactsModel {
        return MessengerContactsModel(
            user: UserModel.empty(),
            cabinMates: [],
            salorMates: [],
            directory: [],
            content: ContentModel.empty(),
            deepLink: "",
            shareText: ""
            
        )
    }
}

extension MessengerContactsModel {
    static func map(messengerContacts response: MessengerContacts, user: UserProfile, currentSailor: CurrentSailor, localization: LocalizationManagerProtocol, deepLink: String, shareText: String) -> MessengerContactsModel {
        return MessengerContactsModel(
            user: .init(reservationGuestId: currentSailor.reservationGuestId, reservationId: currentSailor.reservationId, voyageNumber: "", reservationNumber: user.bookingInfo.reservationNumber, preferredName: user.firstName, profileImageUrl: user.photoUrl),
            cabinMates: response.cabinMates.map { contact in
                ContactItemModel(
                    name: contact.name,
                    photoUrl: contact.photoUrl,
                    personId: contact.personId,
                    reservationId: contact.reservationId,
                    isEventVisible: contact.isEventVisible
                )
            },
            salorMates: response.sailorMates.map { contact in
                ContactItemModel(
                    name: contact.name,
                    photoUrl: contact.photoUrl,
                    personId: contact.personId,
                    reservationId: contact.reservationId,
                    isEventVisible: contact.isEventVisible
                )
            },
            directory: [],
            content: .init(noSailorsText: localization.getString(for: .messengerContactsEmptyState), contactListText: localization.getString(for: .messengerContactListText), yourCodeText: localization.getString(for: .messengerYourCodeText), scanCodeText: localization.getString(for: .messengerScanCodeText), sailorMatesText: localization.getString(for: .messengerSailorMatesText), directoryText: localization.getString(for: .messengerDirectoryText), cabinmatesText: localization.getString(for: .messengerCabinmatesText), loadingText: localization.getString(for: .messengerLoadingText)), deepLink: deepLink, shareText: shareText
        )
    }
}
