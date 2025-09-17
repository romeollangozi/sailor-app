//
//  AddBoardingPassToWalletView.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 4/11/25.
//

import Foundation
import PassKit
import SwiftUI
import UIKit

struct AddBoardingPassToWalletView: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = PKAddPassesViewController
    
    var pass: PKPass
    
    func makeUIViewController(context: Context) -> PKAddPassesViewController {
        let addPassesViewController = PKAddPassesViewController(pass: pass)
        return addPassesViewController!
    }
    
    func updateUIViewController(_ uiViewController: PKAddPassesViewController, context: Context) {
        // not used
    }
}

