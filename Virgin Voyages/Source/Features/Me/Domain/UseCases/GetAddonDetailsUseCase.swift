//
//  GetAddonDetailsUseCase.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 22.10.24.
//

import Foundation

protocol GetAddonDetailsUseCaseProtocol {
    func execute(addonCode: String) async throws -> AddonDetailsModel
}

class GetAddonDetailsUseCase: GetAddonDetailsUseCaseProtocol {
    
    // MARK: - Properties
    private let guestRepository: ActivitiesGuestRepositoryProtocol
    private let addOnDetailsRepository: AddOnRepositoryProtocol

    // MARK: - Init
    init(guestRepository: ActivitiesGuestRepositoryProtocol = ActivitiesGuestRepository(),
		 addOnDetailsRepository: AddOnRepositoryProtocol = AddOnRepository()) {
        self.guestRepository = guestRepository
        self.addOnDetailsRepository = addOnDetailsRepository
    }
    
    func execute(addonCode: String) async throws -> AddonDetailsModel {
        
        //combine guest activities & addon details in single model
        var guestActivitiesGuestList: [ActivitiesGuest] = []
        
        let addonDetailsResponse = try await addOnDetailsRepository.getAddOnDetails(code: addonCode)
        let guestActivitiesResponse = await guestRepository.fetchActivitiesGuestList()
        
        //guest activities results
        switch guestActivitiesResponse {
        case .success(let guests):
            guestActivitiesGuestList = guests
        case .failure:
            guestActivitiesGuestList = []
        }
        
        //addon details results
        if let addon = addonDetailsResponse?.addOns?.first, let cms = addonDetailsResponse?.cmsContent {
            let addon = GetAddonsDetailsResponse.mapFrom(input: addon)
            let cms = GetAddonsDetailsResponse.mapFrom(input: cms)
            //Filter guest's ids
            let addonGuestIdsSet = Set(addon.guests)
            let filteredGuests = guestActivitiesGuestList.filter { addonGuestIdsSet.contains($0.guestId) }
            let guestProfileImageURLs = filteredGuests.map({$0.profileImageUrl})
            return AddonDetailsModel(addon: addon, cms: cms, guestURL: guestProfileImageURLs)
        } else {
            return AddonDetailsModel()
        }
    }
}
