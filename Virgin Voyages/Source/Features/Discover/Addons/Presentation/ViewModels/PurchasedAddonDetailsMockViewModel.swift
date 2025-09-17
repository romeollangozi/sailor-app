//
//  PurchasedAddonDetailsMockViewModel.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 25.10.24.
//

class PurchasedAddonDetailsMockViewModel: PurchasedAddonDetailsViewModelProtocol {

    // MARK: - Properties
    var addonDetailsUseCase: GetAddonDetailsUseCaseProtocol
    var cancelAddonUseCase: CancelAddonUseCaseProtocol
    var addonDetailsModel: AddonDetailsModel
    var screenState: ScreenState = .content
    var showCancelationRefuse: Bool = false
    var showCancelationOptions: Bool = false
    var showConfirmCancelation: ConfirmCancelationType = (false, false, 0)
    var showCanceledPurchase: Bool = false
    var addonCode: String = "MOCK_ADDON_CODE"
    var isRunningCanceling: Bool = false
    
    // MARK: - Init
    init() {
        self.addonDetailsUseCase = MockGetAddonDetailsUseCase()
        self.cancelAddonUseCase = MockCancelAddonUseCase()
        self.addonDetailsModel = AddonDetailsModel.previewData()
    }
    
    // MARK: - Cancel addOn purchase
    func cancelAddon(singleGuest: Bool) async -> Result<Bool, VVDomainError> {
        return .success(true)
    }
    
    // MARK: - OnAppear
    func onAppear() async {}
    func onAppearV2() async {}
    
    var confirmCancellationHeading: String {
        return "Cancel your purchase"
    }
    
    func prepearForCancellation(confirmation: Bool, forSingleGuest: Bool) {}
	func didCancelAddon() {}
}

// MARK: - Mock Use Cases
class MockGetAddonDetailsUseCase: GetAddonDetailsUseCaseProtocol {
    func execute(addonCode: String) async throws -> AddonDetailsModel {
        return AddonDetailsModel()
    }
    
    func execute(addonCode: String) async -> Result<AddonDetailsModel, VVDomainError> {
        let mockAddonDetails = AddonDetailsModel(
            addon: AddOnModel(),
            cms: AddonCMSModel(),
            guestURL: []
        )
        return .success(mockAddonDetails)
    }
}

class MockCancelAddonUseCase: CancelAddonUseCaseProtocol {
    func cancelAddon(guests: [String], code: String, quantity: Int) async -> Result<Bool, VVDomainError> {
        return .success(true)
    }
}
