//
//  ProfileSettingsLanding.swift
//  Virgin Voyages
//
//  Created by Timur Xhabiri on 30.10.24.
//

import Foundation

struct GetProfileSettingsLandingScreenRequest: AuthenticatedHTTPRequestProtocol {

    var reservationID: String
    var reservationNumber: String
    var reservationGuestID: String
    
    var path: String {
        return NetworkServiceEndpoint.getSettingsProfileScreen
    }

    var method: HTTPMethod {
        return .GET
    }

    var headers: (any HTTPHeadersProtocol)? {
        return JSONContentTypeHeader()
    }

    init(reservationID: String, reservationNumber: String, reservationGuestID: String) {
        self.reservationID = reservationID
        self.reservationNumber = reservationNumber
        self.reservationGuestID = reservationGuestID
    }

    
    var queryItems: [URLQueryItem]? {
        let reservationId: URLQueryItem = .init(name: "reservation-id", value: reservationID)
        let reservationNumber: URLQueryItem = .init(name: "reservation-number", value: reservationNumber)
        let reservationGuestId: URLQueryItem = .init(name: "reservation-guest-id", value: reservationGuestID)
        
        return [reservationId, reservationNumber, reservationGuestId]
    }
}

struct GetProfileSettingsLandingScreenResponse: Decodable {
    let profilePhotoURL: String?
    let voyageSettings: VoyageSettings?
    let accountSettings: AccountSettings?
    let profilePhotoUploadURL: String?
    
    struct VoyageSettings: Decodable {
        let header: String?
        let description: String?
        let emergencyContact: SettingDetail?
        let notificationsAndPrivacy: SettingDetail?
        let sailingDocuments: SettingDetail?
        let specialAssistance: SettingDetail?
        let voyageAddOns: SettingDetail?
        let wearableAndPin: SettingDetail?
    }

    struct AccountSettings: Decodable {
        let header: String?
        let description: String?
        let personalInformation: SettingDetail?
        let contactDetails: SettingDetail?
        let accountLogin: SettingDetail?
        let paymentCard: SettingDetail?
        let switchVoyage: SettingDetail?
        let termsAndConditions: SettingDetail?
        let commsAndMarketing: SettingDetail?
        let openCameraAda: String?
    }

    struct SettingDetail: Decodable, Equatable {
        let title: String?
        let detailURL: String?
        let description: String?
        let isEnable: Bool?
        let isEditable: Bool?
        let isHidden: Bool?
        let sequence: Int?
    }
}


extension NetworkServiceProtocol {
    
    func fetchProfileSettingsLandingScreen(reservationID: String, reservationNumber: String, reservationGuestID: String) async -> ApiResponse<GetProfileSettingsLandingScreenResponse> {
        let request = GetProfileSettingsLandingScreenRequest(reservationID: reservationID, reservationNumber: reservationNumber, reservationGuestID: reservationGuestID)
        return await self.request(request, responseModel: GetProfileSettingsLandingScreenResponse.self)
    }
}
