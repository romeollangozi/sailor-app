//
//  ConfirmationContactUseCase.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 2.11.24.
//


protocol ConfirmationContactUseCaseProtocol {
    var confirmationContactModel: ConfirmationContactModel { get set }
    func getViewData(qrCodeLink: String) -> ConfirmationContactModel
}

class ConfirmationContactUseCase: ConfirmationContactUseCaseProtocol {
    
    // MARK: - Localization manager
    private let localizationManager: LocalizationManagerProtocol
    
    // MARK: - Properties
    var confirmationContactModel: ConfirmationContactModel
    var confirmationContactRepository: ConfirmationContactRepositoryProtocol
    
    init(confirmationContactRepository: ConfirmationContactRepositoryProtocol = ConfirmationContactRepository(qrCodeLink: ""), confirmationContactModel: ConfirmationContactModel = ConfirmationContactModel(), localizationManager: LocalizationManager = LocalizationManager.shared) {
        self.confirmationContactRepository = confirmationContactRepository
        self.confirmationContactModel = confirmationContactModel
        self.localizationManager = localizationManager
    }
    
    func getViewData(qrCodeLink: String) -> ConfirmationContactModel {
        let qrCodeData = confirmationContactRepository.parseQRCode(qrCodeLink: qrCodeLink)
        confirmationContactModel = .init(name: qrCodeData.name,
                                         reservationId: qrCodeData.reservationId,
                                         reservationGuestId: qrCodeData.reservationGuestId, connectedSailorText: localizationManager.getString(for: .messengerConnectedSailorText),
                                         allowAttendingText: localizationManager.getString(for: .messengerAllowAttendingText),
                                         doneText: localizationManager.getString(for: .messengerDoneText),
                                         deleteSailorMateButtonText: localizationManager.getString(for: .messengerContactDeleteText)
        )
        return confirmationContactModel
    }
}

struct ConfirmationContactModel {
    
    let name: String
    let reservationId: String
    let reservationGuestId: String
    let connectedSailorText: String
    let allowAttendingText: String
    let doneText: String
    let deleteSailorMateButtonText: String

    init(name: String = "", reservationId: String = "", reservationGuestId: String = "", connectedSailorText: String = "", allowAttendingText: String = "", doneText: String = "", deleteSailorMateButtonText: String = "") {
        self.name = name
        self.reservationId = reservationId
        self.reservationGuestId = reservationGuestId
        self.connectedSailorText = connectedSailorText
        self.allowAttendingText = allowAttendingText
        self.doneText = doneText
        self.deleteSailorMateButtonText = deleteSailorMateButtonText
    }
    
}
