//
//  GetMyVoyageHeaderUseCase.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 26.2.25.
//

protocol  GetMyVoyageHeaderUseCaseProtocol {
	func execute(useCache: Bool) async throws -> MyVoyageHeaderModel
}

final class GetMyVoyageHeaderUseCase: GetMyVoyageHeaderUseCaseProtocol {
    private let myVoyageHeaderRepository: MyVoyageHeaderRepositoryProtocol
    private let currentSailorManager: CurrentSailorManagerProtocol
    
    init(myVoyageHeaderRepository: MyVoyageHeaderRepositoryProtocol = MyVoyageHeaderRepository(), currentSailorManager: CurrentSailorManagerProtocol = CurrentSailorManager()) {
        self.myVoyageHeaderRepository = myVoyageHeaderRepository
        self.currentSailorManager = currentSailorManager
    }
    
    func execute(useCache: Bool) async throws -> MyVoyageHeaderModel {
		guard let currentSailor = currentSailorManager.getCurrentSailor() else {
			throw VVDomainError.unauthorized
		}
		
		let result = try await myVoyageHeaderRepository.fetchMyVoyageHeader(reservationGuestId: currentSailor.reservationGuestId, reservationNumber: currentSailor.reservationNumber, useCache: useCache)
        
        return MyVoyageHeaderModel(
			imageUrl: result.imageUrl,
			type: result.type,
			name: result.name,
			profileImageUrl: result.profileImageUrl,
			cabinNumber: result.cabinNumber,
			lineUpOpeningDateTime: result.lineUpOpeningDateTime,
			isLineUpOpened: result.isLineUpOpened,
			buttonSettingsTitle: "Settings",
			buttonMyWalletTitle: "My Wallet",
			buttonLineUpTitle: "View the Line-Up",
			buttonAddonsTitle: "View Available Add-ons",
			emptyStateText: "Book anything that floats your boat now!",
			tabMyAgendaTitle: "My Agenda",
			tabAddOnsTitle: "Add-ons"
		)
    }
}
