//
//  MyNextVirginVoyageViewModel.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 3/18/25.
//

import Foundation
import UIKit

@Observable class MyNextVirginVoyageViewModel: BaseViewModel, MyNextVirginVoyageViewModelProtocol {
    
    var myNextVoyageSection: MyNextVoyageSection
    var sailingMode: SailingMode
    
    init(myNextVoyageSection: MyNextVoyageSection = MyNextVoyageSection.sample(),
         sailingMode: SailingMode) {
        self.myNextVoyageSection = myNextVoyageSection
        self.sailingMode = sailingMode
    }
    
    // MARK: - Sailing Mode Control
    var shouldShowDaysRemaining: Bool {
        self.sailingMode == .postCruise
    }
    
    // MARK: - Navigation
    func didTapMyNextVirginVoyage() {
        if let url = URL(string: myNextVoyageSection.navigationUrl) {
            UIApplication.shared.open(url)
        }
    }
}
