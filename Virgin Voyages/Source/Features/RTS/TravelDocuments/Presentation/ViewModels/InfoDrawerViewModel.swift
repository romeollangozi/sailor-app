//
//  InfoDrawerViewModel.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 11.7.25.
//

import Foundation
import UIKit

@Observable
class InfoDrawerViewModel: BaseViewModel, InfoDrawerScreenViewModelProtocol {
    
    private let travelDocuments: TravelDocuments
    private let document: TravelDocuments.Document?

    var screenState: ScreenState = .content

    //TODO: substitude static texts after the travel docs assets api integration
    var title: String {
        if let document = document, document.code == DocumentType.electronicSystemForTravelAuthorization.rawValue {
            return document.name
        }else{
            return "Entering \(travelDocuments.debarkCountryName)"
        }
    }
    var description: String {
        if let document = document, document.code == DocumentType.electronicSystemForTravelAuthorization.rawValue {
            return """
            All eligible international travelers who wish to travel to the \(travelDocuments.debarkCountryName) under the Visa Waiver Program must apply for authorization. If you haven’t done so already, please check the site below to apply.
            """
        } else {
            return """
            When you voyage with us in the \(travelDocuments.debarkCountryName), you must show valid travel documents as part of the entry process. The documents you need depend on the country you are arriving from and your citizenship or status. Please ensure that you have the correct documents or you may not be able to voyage with us.
            """
        }
    }
    
    var url: URL {
        URL(string: travelDocuments.governmentLink) ?? URL(string: "https://www.virginvoyages.com")!
    }
    
    var buttonTitle: String { "Open in Browser" }

    init(
        travelDocuments: TravelDocuments,
        document: TravelDocuments.Document?
    ) {
        self.travelDocuments = travelDocuments
        self.document = document
    }

    func onOpenURL() {
        UIApplication.shared.open(url)
    }

}
