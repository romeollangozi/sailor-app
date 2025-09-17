//
//  HomeMerchandiseViewModel.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 17.3.25.
//

import Combine
import Observation
import SwiftUI

protocol HomeMerchandiseViewModelProtocol {
    var homeMerchandise: HomeMerchandise { get }
    var screenState: ScreenState { get set }
    var currentIndex: Int { get set }

    func onAppear()
    func onDragGestureEnded(value: Double)
    func startTimer()
    func restartTimer()
    func didTapMerchandise(item: HomeMerchandise.HomeMerchandiseItem)
}

@Observable
class HomeMerchandiseViewModel: BaseViewModel, HomeMerchandiseViewModelProtocol {
    
    private var appCoordinator: AppCoordinator = .shared
    private var timerCancellable: AnyCancellable?
    var homeMerchandise: HomeMerchandise
    var screenState: ScreenState = .loading
    var currentIndex: Int = 0
    
    init(homeMerchandise: HomeMerchandise = HomeMerchandise.empty()) {
        self.homeMerchandise = homeMerchandise
    }
    
    func onAppear() {
        if !homeMerchandise.items.isEmpty {
            startTimer()
        }
    }
    
    func onDragGestureEnded(value: Double) {
        let maxIndex = min(homeMerchandise.items.count, 6) - 1
        let newIndex = (currentIndex + (value < 0 ? 1 : -1))
        currentIndex = min(max(newIndex, 0), maxIndex)
        restartTimer()
    }
    
    func startTimer() {
        timerCancellable = Timer.publish(every: 5, on: .main, in: .common)
            .autoconnect()
            .sink { [self] _ in
                withAnimation {
                    currentIndex = (currentIndex + 1) % (min(homeMerchandise.items.count, 6))
                }
            }
    }

    func restartTimer() {
        timerCancellable?.cancel()
        startTimer()
    }
    
    func didTapMerchandise(item: HomeMerchandise.HomeMerchandiseItem) {
        appCoordinator.executeCommand(HomeTabBarCoordinator.OpenAddonListWithSelectedAddonCode(addonCode: item.code))
    }
}
