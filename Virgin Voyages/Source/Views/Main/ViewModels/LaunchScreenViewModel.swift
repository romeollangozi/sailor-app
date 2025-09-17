//
//  LaunchScreenViewModel.swift
//  Virgin Voyages
//
//  Created by TX on 23.7.25.
//

import SwiftUI

protocol LaunchScreenViewModelProtocol {
    func onAppear()
}

@Observable
class LaunchScreenViewModel: LaunchScreenViewModelProtocol {
    func onAppear() {
        // Optional - Do some work before we let user continue the application flow.
    }
}
