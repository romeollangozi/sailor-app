//
//  ScanCodeUseCase.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 31.10.24.
//

import Foundation

protocol ScanCodeUseCaseProtocol {
    func execute() -> Result<ScannerViewModel, Error>
}

class ScanCodeUseCase: ScanCodeUseCaseProtocol {
    
    // MARK: - Localization manager
    private let localizationManager: LocalizationManagerProtocol
    
    // MARK: - Init
    init(localizationManager: LocalizationManagerProtocol = LocalizationManager.shared) {
        self.localizationManager = localizationManager
    }
    
    // MARK: - Execute
    func execute() -> Result<ScannerViewModel, Error> {
        let result = ScannerViewModel(
            helpMeText: localizationManager.getString(for: .messengerScaneHelpMeText),
            positionSailorCodeText: localizationManager.getString(for: .messengerPositionCameraText),
            helpTitle: localizationManager.getString(for: .messengerScaneHelpTitle), helpDescription: localizationManager.getString(for: .messengerScanHelpDescriptionText), scanCodeText: localizationManager.getString(for: .messengerScanCodeText), yourCode: localizationManager.getString(for: .messengerYourCodeText),
            tryAgainText: localizationManager.getString(for: .messengerTryAgainText),
            pleaseScanText: localizationManager.getString(for: .messengerPleaseScanText),
            okText: localizationManager.getString(for: .messengerOkText),
            doneText: localizationManager.getString(for: .messengerDoneText)
        )
        return .success(result)
    }
    
}

struct ScannerViewModel {
    
    // MARK: - Model properties
    let helpMeText: String
    let positionSailorCodeText: String
    let helpTitle: String
    let helpDescription: String
    let scanCodeText: String
    let yourCodeText: String

    let tryAgainText: String
    let pleaseScanText: String
    let okText: String
    let doneText: String

    
    // MARK: - Model init
    init(helpMeText: String = "", positionSailorCodeText: String = "", helpTitle: String = "", helpDescription: String = "", scanCodeText: String = "", yourCode: String = "", tryAgainText: String = "", pleaseScanText: String = "", okText: String = "", doneText: String = "") {
        self.helpMeText = helpMeText
        self.positionSailorCodeText = positionSailorCodeText
        self.helpDescription = helpDescription
        self.helpTitle = helpTitle
        self.scanCodeText = scanCodeText
        self.yourCodeText = yourCode
        self.tryAgainText = tryAgainText
        self.pleaseScanText = pleaseScanText
        self.okText = okText
        self.doneText = doneText
    }
}
