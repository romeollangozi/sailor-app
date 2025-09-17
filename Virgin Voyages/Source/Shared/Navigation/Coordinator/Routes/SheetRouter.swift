//
//  SheetRouter.swift
//  Virgin Voyages
//
//  Created by TX on 15.1.25.
//

import Foundation
import SwiftUI

@Observable
class SheetRouter<SheetRoute: Hashable> {
    var currentSheet: SheetRoute?
    
    func present(sheet: SheetRoute) {
        currentSheet = sheet
    }
    
    func dismiss() {
        currentSheet = nil
    }
}


protocol BaseSheetRouter: Hashable, Equatable, Identifiable {}

