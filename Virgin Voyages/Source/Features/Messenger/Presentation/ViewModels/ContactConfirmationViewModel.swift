//
//  ContactConfirmationViewModel.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 1.11.24.
//

import Foundation

protocol ContactConfirmationViewModelProtocol {
    var confirmationContactUseCase: ConfirmationContactUseCaseProtocol { get set }
    var addContactUseCase: AddContactUseCaseProtocol { get set }
    var confirmationContactModel: ConfirmationContactModel { get set }
    var qrCodeInput: String { get set }
    var allowAttending: Bool { get set }
    var addFriendStatus: Result<EmptyModel, VVDomainError> { get set }
    var showErrorAlert: Bool { get set }
    var isLoadingRemoveContact: Bool { get set }
	var sailorProfileImage: String { get }
    func addContactPreferences() async
    func onAppear()
    func onRemoveContactButtonTapped()
    func executeRemoveContact(onFinished: @escaping () -> Void)
    var showRemoveContactConfirmation: Bool { get set }
    var isSailorMate: Bool { get set }
}

@Observable class ContactConfirmationViewModel: BaseViewModel, ContactConfirmationViewModelProtocol {
   
    private var appCoordinator: AppCoordinator
    private let removeFriendUseCase: RemoveFriendUseCaseProtocol

    var addContactUseCase: AddContactUseCaseProtocol
    var confirmationContactUseCase: ConfirmationContactUseCaseProtocol

    var confirmationContactModel: ConfirmationContactModel
    var qrCodeInput: String
    var addFriendStatus: Result<EmptyModel, VVDomainError>
    var allowAttending: Bool
    var showErrorAlert: Bool
    var isSailorMate: Bool
	var sailorProfileImage: String
    var isLoadingRemoveContact: Bool = false
    var showRemoveContactConfirmation: Bool = false

    init(appCoordinator: AppCoordinator = .shared,
         removeFriendUseCase: RemoveFriendUseCaseProtocol = RemoveFriendUseCase(),
         confirmationContactUseCase: ConfirmationContactUseCaseProtocol = ConfirmationContactUseCase(),
         addContactUseCase: AddContactUseCaseProtocol = AddContactUseCase(),
         confirmationContactModel: ConfirmationContactModel = ConfirmationContactModel(),
         addFriendStatus: Result<EmptyModel, VVDomainError> = .success(EmptyModel()),
         qrCodeInput: String = "",
		 sailorProfileImage: String = "",
         allowAttending: Bool = false,
         showErrorAlert: Bool = false,
         isSailorMate: Bool = false)
    {
        self.appCoordinator = appCoordinator
        self.removeFriendUseCase = removeFriendUseCase
        self.confirmationContactUseCase = confirmationContactUseCase
        self.confirmationContactModel = confirmationContactModel
        self.qrCodeInput = qrCodeInput
        self.addFriendStatus = addFriendStatus
        self.allowAttending = allowAttending
        self.addContactUseCase = addContactUseCase
        self.showErrorAlert = showErrorAlert
        self.isSailorMate = isSailorMate
		self.sailorProfileImage = sailorProfileImage
    }

    func onAppear() {
        confirmationContactModel = confirmationContactUseCase.getViewData(qrCodeLink: qrCodeInput)
    }

    func addContactPreferences() async {
        guard let personId = getQueryParameter(from: qrCodeInput, parameterName: "reservationGuestId") else {
            return
        }

        let _ = await addContactUseCase.execute(connectionPersonId: personId, isEventVisibleCabinMates: allowAttending)
    }

    func onRemoveContactButtonTapped() {
        showRemoveContactConfirmation = true
    }

    func executeRemoveContact(onFinished: @escaping VoidCallback) {
        self.isLoadingRemoveContact = true

        Task {
            await executeUseCase {  [weak self] in
                guard let self else { return }
                let success = try await self.removeFriendUseCase.execute(
                    connectionReservationId: self.confirmationContactModel.reservationId,
                    connectionReservationGuestId: self.confirmationContactModel.reservationGuestId
                )
                await self.executeOnMain { [weak self] in
                    guard let self else { return }
                    if success {
                        self.isLoadingRemoveContact = false
                        onFinished()
                    } else {
                        self.isLoadingRemoveContact = false
                        onFinished()
                        print("ContactConfirmationViewModel executeRemoveContact failed.")
                    }
                }
            }
            
        }
    }
    
}
