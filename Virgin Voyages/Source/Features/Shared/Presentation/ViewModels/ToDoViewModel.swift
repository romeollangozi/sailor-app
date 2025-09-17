//
//  ToDoViewModel.swift
//  Virgin Voyages
//
//  Created by TX on 11.12.24.
//

import Foundation
import UIKit

struct ToDoScreenData {
    let title: String
    let message: String
    let alternativeMessage: String
    let actionTitle: String
    let deepLink: DeepLinkType?
    
    static let defaultTemplateData = ToDoScreenData(
        title: "Comming soon",
        message: "This functionality is coming soon!",
        alternativeMessage: "In the meantime, please use the existing Sailor App to manage this data.",
        actionTitle: "Open in App",
        deepLink: nil
    )
}

@Observable class ToDoViewModel {
	let openReactNativeAppUseCase: OpenReactNativeAppUseCaseProtocol
    let data: ToDoScreenData
    
    init(data: ToDoScreenData = .defaultTemplateData,
		 openReactNativeAppUseCase: OpenReactNativeAppUseCaseProtocol = OpenReactNativeAppUseCase()) {
        self.data = data
		self.openReactNativeAppUseCase = openReactNativeAppUseCase
    }
    
	init(title: String,
		 openReactNativeAppUseCase: OpenReactNativeAppUseCaseProtocol = OpenReactNativeAppUseCase()) {
        let defaultData = ToDoScreenData.defaultTemplateData
        self.data = .init(title: title, message: defaultData.message, alternativeMessage: defaultData.alternativeMessage, actionTitle: defaultData.actionTitle, deepLink: defaultData.deepLink)
		self.openReactNativeAppUseCase = openReactNativeAppUseCase
    }
    
    init(title: String,
		 deepLink: DeepLinkType,
		 openReactNativeAppUseCase: OpenReactNativeAppUseCaseProtocol = OpenReactNativeAppUseCase()) {
        let defaultData = ToDoScreenData.defaultTemplateData
        self.data = .init(title: title, message: defaultData.message, alternativeMessage: defaultData.alternativeMessage, actionTitle: deepLink.deepLinkActionTitle, deepLink: deepLink)
		self.openReactNativeAppUseCase = openReactNativeAppUseCase
    }
    
    func handleDeepLink() {
        switch data.deepLink {
        case .reactNativeApp:
            openReactNativeApp()
        default:
            let urlString = "https://virginvoyagessailorapp.page.link"
            if let url = URL(string: urlString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    func openReactNativeApp() {
		openReactNativeAppUseCase.execute()
    }
}
