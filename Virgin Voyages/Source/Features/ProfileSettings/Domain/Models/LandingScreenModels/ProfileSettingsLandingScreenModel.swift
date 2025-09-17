//
//  ProfileSettingsLandingScreenModel.swift
//  Virgin Voyages
//
//  Created by Timur Xhabiri on 30.10.24.
//

import Foundation

struct ProfileSettingsLandingScreenModel {
    
    var content: ProfileSettingsLandingScreenModel.ContentModel
    var menuItems: [ProfileSettingsMenuListItemModel]
    
    mutating func updateMenuItems(_ menuItems: [ProfileSettingsMenuListItemModel]) {
        self.menuItems = menuItems
    }
    
    init(content: ProfileSettingsLandingScreenModel.ContentModel, menuItems: [ProfileSettingsMenuListItemModel]){
        self.content = content
        self.menuItems = menuItems
    }
    
}

extension ProfileSettingsLandingScreenModel {
    struct ContentModel {
        let screenTitle: String?
        let screenDescription: String?
        let imageUrl: String?
        
        init(screenTitle: String?, screenDescription: String?, imageUrl: String?) {
            self.screenTitle = screenTitle
            self.screenDescription = screenDescription
            self.imageUrl = imageUrl
        }
    }
}

extension ProfileSettingsLandingScreenModel {
    static func mapProfileSettingsLandingScreenViewModel(from apiResult: GetProfileSettingsLandingScreenResponse) -> ProfileSettingsLandingScreenModel {
     
        // Page content
        let title = apiResult.accountSettings?.header
        let description = apiResult.accountSettings?.description
        let imageUrl = apiResult.profilePhotoURL
        
        // Menu items
        let settingsMenuItemsResponse = [
            apiResult.accountSettings?.personalInformation,
            apiResult.accountSettings?.contactDetails,
            apiResult.accountSettings?.accountLogin,
            apiResult.accountSettings?.paymentCard,
            apiResult.accountSettings?.switchVoyage,
            apiResult.accountSettings?.termsAndConditions,
            apiResult.accountSettings?.commsAndMarketing
        ]
        
        var menuItems: [ProfileSettingsMenuListItemModel] = []
        for (index, setting) in settingsMenuItemsResponse.enumerated() {
			if let setting {
				
				var id = ProfileSettingItemIdentifier.undefined
				
				if (setting == apiResult.accountSettings?.termsAndConditions) {
					id = ProfileSettingItemIdentifier.termsAndConditions
				} else if (setting == apiResult.accountSettings?.switchVoyage) {
					id = ProfileSettingItemIdentifier.switchVoyage
				} else if (setting == apiResult.accountSettings?.personalInformation) {
					id = ProfileSettingItemIdentifier.personalInformation
				} else if (setting == apiResult.accountSettings?.contactDetails) {
					id = ProfileSettingItemIdentifier.contactDetails
				} else if (setting == apiResult.accountSettings?.accountLogin) {
					id = ProfileSettingItemIdentifier.paymentCard
				} else if (setting == apiResult.accountSettings?.commsAndMarketing) {
					id = ProfileSettingItemIdentifier.commsAndMarketing
				} else if (setting == apiResult.accountSettings?.paymentCard) {
					id = ProfileSettingItemIdentifier.paymentCard
				}
				
                menuItems.append(.init(
                    id: id,
					title: setting.title.value,
					description: setting.description.value,
                    isEnabled: true,
                    sequence: setting.sequence.map { Int($0) }.value
                ))
            }
        }

        let contentModel: ProfileSettingsLandingScreenModel = .init(
            content: .init(screenTitle: title.value, screenDescription: description.value, imageUrl: imageUrl.value),
            menuItems: menuItems
        )

        return contentModel
    }
}


