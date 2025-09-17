//
//  BoardingPassCardViewModel.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 4/11/25.
//

import Foundation
import SwiftUI
import PassKit

protocol BoardingPassCardViewModelProtocol {
    
    var pass: PKPass? { get set }
    var isPassSheetVisible: Bool { get set }
    var didFailedGeneratingPass: Bool { get set }
    
    func isStandartSailor(item: SailorBoardingPass.BoardingPassItem) -> Bool
    func getSailorTypeBackgroundColor(item: SailorBoardingPass.BoardingPassItem) -> Color
    func getLocationURL(coordinates: String, placeId: String) -> URL?
    func generateQRBoardingPassString(item: SailorBoardingPass.BoardingPassItem) -> String
    
    func getBoardingPassAppleWalletData(reservationGuestId: String) async
    func handleWalletButtonAction()
}

@Observable class BoardingPassCardViewModel: BaseViewModel, BoardingPassCardViewModelProtocol {
    
    // MARK: - Properties
    
    var pass: PKPass?
    var didFailedGeneratingPass: Bool = false
    var isPassSheetVisible: Bool = false
    private let getBoardingPassAppleWalletUseCase: GetBoardingPassAppleWalletUseCaseProtocol
    
    // MARK: - Init
    init(getBoardingPassAppleWalletUseCase: GetBoardingPassAppleWalletUseCaseProtocol = GetBoardingPassAppleWalletUseCase()) {
        self.getBoardingPassAppleWalletUseCase = getBoardingPassAppleWalletUseCase
    }
    
    func isStandartSailor(item: SailorBoardingPass.BoardingPassItem) -> Bool {
        item.sailorType == .standard
    }
    
    func getSailorTypeBackgroundColor(item: SailorBoardingPass.BoardingPassItem) -> Color {
        switch item.sailorType {
        case .standard:
            Color.vvRed
        case .priority:
            Color.deepPurple
        case .rockStar, .megaRockStar:
            Color.darkGrayText
        case .none:
            .white
        }
    }
    
    func getLocationURL(coordinates: String, placeId: String) -> URL? {
        let coordinates = coordinates.components(separatedBy: ",")
        
        if let latitude = coordinates.first, let longitude = coordinates.last,
           let url = URL(string: MapUrls.googleMapsURL(latitude: latitude, longitude: longitude, placeId: placeId)) {
            
            return url
        } else {
            return nil
        }
    }
    
    func generateQRBoardingPassString(item: SailorBoardingPass.BoardingPassItem) -> String {
        let qrBoardingPass = QRBoardingPass(firstName: item.firstName,
                                            lastName: item.lastName,
                                            reservationGuestId: item.reservationGuestId,
                                            reservationNumber: item.bookingRef)
        
        return qrBoardingPass.toJSONString() ?? ""
    }
    
    
    func getBoardingPassAppleWalletData(reservationGuestId: String) async {
        
        if let result = await executeUseCase({
            try await self.getBoardingPassAppleWalletUseCase.execute(reservationGuestId: reservationGuestId)
        }) {
            
            await executeOnMain {
                
                do {
                    self.pass = try PKPass(data: result)
                } catch {
                    self.didFailedGeneratingPass = true
                }
                
            }
        }
    }
    
    func handleWalletButtonAction() {
        
        if let pass = pass {
            let passLibrary = PKPassLibrary()
            
            if passLibrary.containsPass(pass) {
                isPassSheetVisible = false
                openWalletApp()
            } else {
                isPassSheetVisible = true
            }
        } else {
            isPassSheetVisible = false
        }
    }
    
    private func openWalletApp() {
        if let walletURL = URL(string: "shoebox://") {
            UIApplication.shared.open(walletURL, options: [:])
        }
    }
    
}
