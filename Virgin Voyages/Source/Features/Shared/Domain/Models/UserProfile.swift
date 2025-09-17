//
//  UserProfile.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 13.11.24.
//

struct UserProfile: Equatable {
    
    let firstName: String
    let lastName: String
    let photoUrl: String
    let bookingInfo: BookingInfo
    let birthDate: String
    let phoneCountryCode: String
    let userNotifications: [UserNotification]
    let email: String
    let isPasswordExist: Bool
    let personId: String
    let personTypeCode: String
    let hasLinkedReservations: Bool
    let emailVerificationStatus: String?
    let citizenshipCountryCode: String
    let preferredName: String
    
    static func == (lhs: UserProfile, rhs: UserProfile) -> Bool {
        return lhs.personId == rhs.personId
    }
    
    struct BookingInfo  {
        let embarkDate: String
        let reservationNumber: String
        let guestId: String
        let reservationGuestId: String
        let status: String
        let isVIP: Bool
        let guestTypeCode: String
    }
    
    struct UserNotification  {
        let userNotificationId: String
        let userGUID: String
        let userId: String
        let notificationTypeCode: String
        let isOptInForSMS: Bool
        let isOptInForCall: Bool
        let isOptInForEmail: Bool
        let isDeleted: Bool
    }
}

extension UserProfile {
    static func map(from source: GetUserProfileResponse) -> UserProfile {
        return UserProfile(
            firstName: source.firstName.value,
            lastName: source.lastName.value,
            photoUrl: source.photoUrl.value,
            bookingInfo: BookingInfo(
                embarkDate: source.bookingInfo?.embarkDate ?? "",
                reservationNumber: source.bookingInfo?.reservationNumber ?? "",
                guestId: source.bookingInfo?.guestId ?? "",
                reservationGuestId: source.bookingInfo?.reservationGuestId ?? "",
                status: source.bookingInfo?.status ?? "",
                isVIP: source.bookingInfo?.isVIP ?? false,
                guestTypeCode: source.bookingInfo?.guestTypeCode ?? ""
            ),
            birthDate: source.birthDate.value,
            phoneCountryCode: source.phoneCountryCode.value,
            userNotifications: (source.userNotifications ?? []).map { notification in
                UserNotification(
                    userNotificationId: notification.userNotificationId.value,
                    userGUID: notification.userGUID.value,
                    userId: notification.userId.value,
                    notificationTypeCode: notification.notificationTypeCode.value,
                    isOptInForSMS: notification.isOptInForSMS.value,
                    isOptInForCall: notification.isOptInForCall.value,
                    isOptInForEmail: notification.isOptInForEmail.value,
                    isDeleted: notification.isDeleted.value
                )
            },
            email: source.email.value,
            isPasswordExist: source.isPasswordExist.value,
            personId: source.personId.value,
            personTypeCode: source.personTypeCode.value,
            hasLinkedReservations: source.hasLinkedReservations.value,
            emailVerificationStatus: source.emailVerificationStatus.value,
            citizenshipCountryCode: source.citizenshipCountryCode.value,
            preferredName: source.preferredName.value
        )
    }
    
    static func empty() -> UserProfile {
        return UserProfile(
            firstName: "",
            lastName: "",
            photoUrl: "",
            bookingInfo: BookingInfo(
                embarkDate: "",
                reservationNumber: "",
                guestId: "",
                reservationGuestId: "",
                status: "",
                isVIP: false,
                guestTypeCode: ""
            ),
            birthDate: "",
            phoneCountryCode: "",
            userNotifications: [
                UserNotification(
                    userNotificationId: "",
                    userGUID: "",
                    userId: "",
                    notificationTypeCode: "",
                    isOptInForSMS: false,
                    isOptInForCall: false,
                    isOptInForEmail: false,
                    isDeleted: false
                )
            ],
            email: "",
            isPasswordExist: false,
            personId: "",
            personTypeCode: "",
            hasLinkedReservations: false,
            emailVerificationStatus: "",
            citizenshipCountryCode: "",
            preferredName: ""
        )
    }
}
