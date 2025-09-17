//
//  ContactsScanViewModel.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 31.10.24.
//

import CoreImage
import Foundation

protocol ContactsScanViewModelProtocol {
	var appCoordinator: AppCoordinator { get set }
	var scanCodeModel: ScannerViewModel { get }
	var selectedOption: CodeOption { get set }
	var scannedCode: String? { get set }
	var isScanning: Bool { get set }
	var showHelpMe: Bool { get set }
	var showOnboardingDialog: Bool { get set }
	var showConfirmation: Bool { get set }
	var photoTask: ScreenTask { get set }
	var qrCodeError: ScannedQRCodeErrorType? { get }
	var showInvalidQRCodeAlert: Bool { get set }
	var showScanerSegmentControl: Bool { get set }
	var contactIsAlreadyAdded: Bool { get set }
	var labels: ContactsScanView.Labels { get }
	func readQRCode(from ciImage: CIImage)
	func handleScannedCode(_ code: String)
	func onAppear() async
	func addFriend(form code: String) async
	func hideScanError()
	func showScanError(error: ScannedQRCodeErrorType)
	func hideOnboardingDialog()
	func checkQRCode(qrCode: String)
}

@Observable class ContactsScanViewModel: BaseViewModel, ContactsScanViewModelProtocol, ObservableObject {

	// MARK: - Usecase
	var appCoordinator: AppCoordinator
	private let scanCodeUseCase: ScanCodeUseCaseProtocol
	private let readQRCodeUseCase: ReadQRCodeUseCaseProtocol
	private let addFriendUseCase: AddFriendUseCaseProtocol
	private let currentSailorManager: CurrentSailorManagerProtocol
	private let localizationManager: LocalizationManagerProtocol
	private let getMySailorsUseCase: GetMySailorsUseCaseProtocol

	// MARK: - Properties

	var scanCodeModel: ScannerViewModel
	var selectedOption: CodeOption = .scanCode
	var yourCodeText: String
	var scanCodeText: String
	var scannedCode: String?
	var showHelpMe: Bool
	var showConfirmation: Bool
	var isScanning: Bool
	var photoTask: ScreenTask = .init()
	var showScanerSegmentControl: Bool
	var showInvalidQRCodeAlert: Bool = false
	var qrCodeError: ScannedQRCodeErrorType? = nil
	var showOnboardingDialog: Bool = true
	var availableSailors: [SailorModel] = []
	var contactIsAlreadyAdded: Bool = false

	// MARK: - Init

	init(appCoordinator: AppCoordinator = .shared, scanCodeModel: ScannerViewModel = ScannerViewModel(), scanCodeUseCase: ScanCodeUseCaseProtocol = ScanCodeUseCase(), selectedOption: CodeOption = .scanCode, yourCodeText: String = "", scanCodeText: String = "", scannedCode: String? = nil, showHelpMe: Bool = false, showConfirmation: Bool = false, isScanning: Bool = true, photoTask: ScreenTask = ScreenTask(), readQRCodeUseCase: ReadQRCodeUseCaseProtocol = ReadQRCodeUseCase(), addFriendUseCase: AddFriendUseCaseProtocol = AddFriendUseCase(), currentSailorManager: CurrentSailorManagerProtocol = CurrentSailorManager(), showScanerSegmentControl: Bool = true, localizationManager: LocalizationManagerProtocol = LocalizationManager.shared, getMySailorsUseCase: GetMySailorsUseCaseProtocol = GetMySailorsUseCase(), contactIsAlreadyAdded: Bool = false) {
		self.appCoordinator = appCoordinator
		self.scanCodeModel = scanCodeModel
		self.scanCodeUseCase = scanCodeUseCase
		self.selectedOption = selectedOption
		self.yourCodeText = yourCodeText
		self.scanCodeText = scanCodeText
		self.scannedCode = scannedCode
		self.showHelpMe = showHelpMe
		self.showConfirmation = showConfirmation
		self.isScanning = isScanning
		self.photoTask = photoTask
		self.readQRCodeUseCase = readQRCodeUseCase
		self.addFriendUseCase = addFriendUseCase
		self.showScanerSegmentControl = showScanerSegmentControl
		self.currentSailorManager = currentSailorManager
		self.localizationManager = localizationManager
		self.getMySailorsUseCase = getMySailorsUseCase
		self.contactIsAlreadyAdded = contactIsAlreadyAdded
	}

	// MARK: - On appear

	func onAppear() async {
		let result = scanCodeUseCase.execute()
		switch result {
		case let .success(model):
			scanCodeModel = model
		case .failure:
			break
		}

		await loadAvailableSailors(useCache: true)
	}

	func readQRCode(from ciImage: CIImage) {
		let result = readQRCodeUseCase.execute(with: ciImage)
		switch result {
		case let .success(code):
			self.handleScannedCode(code)
		case .failure:
			showInvalidQRCodeAlert = true
		}
	}

	func showScanError(error: ScannedQRCodeErrorType) {
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
			self.qrCodeError = error
			self.showInvalidQRCodeAlert = true
			self.isScanning = false
		}
	}

	func hideScanError() {
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
			self.qrCodeError = nil
			self.showInvalidQRCodeAlert = false
			self.isScanning = true
		}
	}

	func addFriend(form code: String) async {
		guard let currentSailor = currentSailorManager.getCurrentSailor() else {
			return
		}

		guard let connectionReservationId = getQueryParameter(from: code, parameterName: "reservationId") else {
			showScanError(error: .wrongQrCode)
			return
		}

		guard let connectionReservationGuestId = getQueryParameter(from: code, parameterName: "reservationGuestId") else {
			showScanError(error: .wrongQrCode)
			return
		}

		if let voyageNumberFromQR = getQueryParameter(from: code, parameterName: "voyageNumber"), !voyageNumberFromQR.isEmpty {
			if voyageNumberFromQR != currentSailor.voyageNumber {
				scannedCode = nil
				showScanError(error: .wrongVoyageNumber)
				return
			}
		}

		await executeUseCase {
			let result = try await self.addFriendUseCase.execute(connectionReservationId: connectionReservationId, connectionReservationGuestId: connectionReservationGuestId)

			await self.executeOnMain { [weak self] in
				guard let self = self else { return }
				if result {
					self.isScanning = false
					self.handleScannedCode(code)
				} else {
					self.scannedCode = nil
					self.showInvalidQRCodeAlert = true
					self.isScanning = false
				}
			}
		}
	}

	func handleScannedCode(_ code: String) {
		DispatchQueue.main.async {
			self.scannedCode = code
			self.showConfirmation = true
			self.isScanning = false
		}
	}

	func hideOnboardingDialog() {
		DispatchQueue.main.async {
			[weak self] in
			guard let self = self else { return }
			self.showOnboardingDialog = false
		}
	}

	func checkQRCode(qrCode: String) {
		guard let currentSailor = currentSailorManager.getCurrentSailor() else {
			return
		}

		guard let _ = getQueryParameter(from: qrCode, parameterName: "reservationId") else {
			showScanError(error: .wrongQrCode)
			return
		}

		guard let connectionReservationGuestId = getQueryParameter(from: qrCode, parameterName: "reservationGuestId") else {
			showScanError(error: .wrongQrCode)
			return
		}

		if let voyageNumberFromQR = getQueryParameter(from: qrCode, parameterName: "voyageNumber"), !voyageNumberFromQR.isEmpty {
			if voyageNumberFromQR != currentSailor.voyageNumber {
				scannedCode = nil
				showScanError(error: .wrongVoyageNumber)
				return
			}
		}

		if availableSailors.map({$0.reservationGuestId}).contains(connectionReservationGuestId) {
			contactIsAlreadyAdded = true
			return
		}

		showConfirmation = true
	}

	private func loadAvailableSailors(useCache: Bool = true) async {
		if let result = await executeUseCase({
			try await self.getMySailorsUseCase.execute(useCache: useCache)
		}) {
			self.availableSailors = result
		}
	}

	var labels: ContactsScanView.Labels {
		return .init(onboardTitle: localizationManager.getString(for: .contactsScanQRCodeTitle),
					 onboardDescription: localizationManager.getString(for: .contactsScanQRCodeDescription),
					 onboardButtonTitle: localizationManager.getString(for: .contactsScanQRCodeButton))
	}
}
