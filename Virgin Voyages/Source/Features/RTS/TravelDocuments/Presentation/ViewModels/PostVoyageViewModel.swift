//
//  PostVoyageViewModel.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 25.3.25.
//

import SwiftUI
import Foundation
import VVUIKit

@Observable
class PostVoyageViewModel: BaseViewModel, PostVoyagePlansScreenViewModelProtocol {

    private var coordinator: TravelDocumentsCoordinator
    private let getPostVoyagePlansUseCase: GetPostVoyagePlansUseCaseProtocol
    private let getLookupUseCase: GetLookupUseCaseProtocol
    private let savePostVoyagePlansUseCase: SavePostVoyagePlansUseCaseProtocol

    var postVoyagePlans: PostVoyagePlans = .empty()
    var inputPostVoyagePlans: PostVoyagePlansInput = .empty()
    var screenState: ScreenState = .loading
    var lookupOptions: [String: [Option]] = [:]
    var shouldValidate: Bool = false
    var title = "Post voyage plans"
    
    var usStatesOptions: [Option]{
        return lookupOptions["states"]?.filter {
            $0.key.split(separator: "|").last == "US"
        } ?? []
    }
    
    var description = "We need to inform border control of you plans post-voyage. This will help us make sure debarkation is silky smooth and effortless for you."
    
    var isStayingIn: Bool {
        inputPostVoyagePlans.isStayingIn
    }
    
    var voyagePlanLabel: String {
            "What are your post voyage plans?"
        }

    var voyagePlanOptions: [Option] {
        [
            .init(key: "true", value: "I will be remaining in the United States after ending the voyage"),
            .init(key: "false", value: "I will be leaving the United States on the same day after ending the voyage")
        ]
    }

    var stayTypeLabel: String {
        "Where will you be staying?"
    }

    var transportationLabel: String {
        "Please give details of how you will be departing"
    }

    var transportationOptions: [Option] {
        TransportationTypeCode.allCases.map { .init(key: $0.rawValue, value: $0.label) }
    }

    var shouldShowHotelNameField: Bool {
        inputPostVoyagePlans.stayTypeCode == StayTypeCode.hotel.rawValue
    }

    var shouldShowFlightFields: Bool {
        inputPostVoyagePlans.transportationTypeCode == TransportationTypeCode.air.rawValue
    }
    
    init(
        coordinator: TravelDocumentsCoordinator = AppCoordinator.shared.homeTabBarCoordinator.travelDocumentsCoordinator,
        getPostVoyagePlansUseCase: GetPostVoyagePlansUseCaseProtocol = GetPostVoyagePlansUseCase(),
        getLookupUseCase: GetLookupUseCaseProtocol = GetLookupUseCase(),
        savePostVoyagePlansUseCase: SavePostVoyagePlansUseCaseProtocol = SavePostVoyagePlansUseCase()
    ) {
        self.coordinator = coordinator
        self.getPostVoyagePlansUseCase = getPostVoyagePlansUseCase
        self.getLookupUseCase = getLookupUseCase
        self.savePostVoyagePlansUseCase = savePostVoyagePlansUseCase
        super.init()
    }

    func onAppear() async {
        await executeOnMain({
            screenState = .loading
        })
        async let plansResult = executeUseCase {
            try await self.getPostVoyagePlansUseCase.execute()
        }

        async let lookupResult = executeUseCase {
            try await self.getLookupUseCase.execute()
        }

        if let plans = await plansResult {
            self.postVoyagePlans = plans
            self.inputPostVoyagePlans = plans.toInputModel()
        }

        if let lookup = await lookupResult {
            self.lookupOptions = lookup.toLookupOptionsDictionary()
        }

        await executeOnMain({
            screenState = .content
        })
    }

    func onRefresh() async {
        await onAppear()
    }

    func save() async {
        shouldValidate = true
        if !isInputValid { return }
        if inputPostVoyagePlans.isStayingIn{
            inputPostVoyagePlans.flightDetails = nil
            let addressTypeCode = inputPostVoyagePlans.stayTypeCode
            inputPostVoyagePlans.addressInfo?.addressTypeCode = addressTypeCode
        }else if inputPostVoyagePlans.transportationTypeCode != TransportationTypeCode.air.rawValue {
            inputPostVoyagePlans.addressInfo = nil
            inputPostVoyagePlans.flightDetails = nil
        }
        await executeOnMain({
            screenState = .loading
        })
        if (await executeUseCase({
            try await self.savePostVoyagePlansUseCase.execute(input: self.inputPostVoyagePlans)
        })) != nil {
            await executeOnMain({
                screenState = .content
                coordinator.navigationRouter.navigateTo(.documentReview)
            })
        }
        await executeOnMain({
            screenState = .content
        })
    }

    func navigateBack() {
        coordinator.navigationRouter.goToRoot()
        coordinator.navigationRouter.navigateTo(.documentReview)

    }

    var isInputValid: Bool {
        if inputPostVoyagePlans.isStayingIn {
            guard !inputPostVoyagePlans.stayTypeCode.isEmpty else { return false }

            guard let address = inputPostVoyagePlans.addressInfo else { return false }

            let requiredFields = [
                address.line1,
                address.line2,
                address.city,
                address.countryCode,
                address.zipCode,
                address.stateCode,
            ]

            if requiredFields.contains(where: { ($0 ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }) {
                return false
            }

            return true
        } else {
            guard !inputPostVoyagePlans.transportationTypeCode.isEmpty else { return false }

            if inputPostVoyagePlans.transportationTypeCode == TransportationTypeCode.air.rawValue {
                guard let flight = inputPostVoyagePlans.flightDetails else { return false }

                let requiredFlightFields = [
                    flight.airlineCode,
                    flight.departureAirportCode,
                    flight.number
                ]

                if requiredFlightFields.contains(where: { ($0 ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }) {
                    return false
                }
            }

            return true
        }
    }
}
