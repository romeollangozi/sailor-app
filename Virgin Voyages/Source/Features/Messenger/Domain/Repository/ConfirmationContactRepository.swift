//
//  ConfirmationContactRepository.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 4.11.24.
//

protocol ConfirmationContactRepositoryProtocol {
    var qrCodeLink: String { get set }
    func parseQRCode(qrCodeLink: String) -> QRCodeData
}

class ConfirmationContactRepository: ConfirmationContactRepositoryProtocol {
    
    // MARK: - Input parameter
    var qrCodeLink: String
    
    // MARK: - Init
    init(qrCodeLink: String) {
        self.qrCodeLink = qrCodeLink
    }
    
    // MARK: - Parse QR
    func parseQRCode(qrCodeLink: String) -> QRCodeData {
        guard let connectionReservationId = getQueryParameter(from: qrCodeLink, parameterName: "reservationId") else {
            return QRCodeData()
        }
        
        guard let connectionReservationGuestId = getQueryParameter(from: qrCodeLink, parameterName: "reservationGuestId") else {
            return QRCodeData()
        }
        
        guard let connectionName = getQueryParameter(from: qrCodeLink, parameterName: "name") else {
            return QRCodeData()
        }
        
        return .init(name: connectionName, reservationId: connectionReservationId, reservationGuestId: connectionReservationGuestId)
    }
}


struct QRCodeData {
    let name: String
    let reservationId: String
    let reservationGuestId: String
    let connectedSailorText: String
    
    init(name: String = "", reservationId: String = "", reservationGuestId: String = "", connectedSailorText: String = "") {
        self.name = name
        self.reservationId = reservationId
        self.reservationGuestId = reservationGuestId
        self.connectedSailorText = connectedSailorText
    }
}
