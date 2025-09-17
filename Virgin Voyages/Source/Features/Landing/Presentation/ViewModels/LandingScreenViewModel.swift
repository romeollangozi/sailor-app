//
//  LandingScreenViewModel.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 8/20/24.
//

import Foundation
import AVFoundation

protocol LandingScreenViewModelProtocol: DeepLinkPathViewModel {
    var screenState: ScreenState { get set }
    var splashBackgroundVideoPlayer: LoopingVideoPlayer { get }
    var landingBackgroundVideoPlayer: LoopingVideoPlayer { get }
    func loadLanding()
}


@Observable class LandingScreenViewModel: LandingScreenViewModelProtocol {
    var currentDeepLink: DeepLinkType?
        
    var screenState: ScreenState = .loading
    
	var splashBackgroundVideoPlayer: LoopingVideoPlayer
    var landingBackgroundVideoPlayer: LoopingVideoPlayer
    
    init(currentDeepLink: DeepLinkType? = nil) {
		let url = Bundle.main.url(forResource: "Ocean Waves", withExtension: "mp4")!
		let splashBackgroundVideoPlayer = LoopingVideoPlayer(asset: .init(url: url))
		let landingBackgroundVideoPlayer = LoopingVideoPlayer(asset: .init(url: url))
		self.splashBackgroundVideoPlayer = splashBackgroundVideoPlayer
		self.landingBackgroundVideoPlayer = landingBackgroundVideoPlayer
		self.splashBackgroundVideoPlayer.play()
		self.landingBackgroundVideoPlayer.play()
        self.currentDeepLink = currentDeepLink
    }
    
    func loadLanding() {
        screenState = .loading
        Task {
            let startTime = Date()
            
            await ensureMinimumLoadingTime(startTime: startTime, minimumTime: 3.0)
            
			DispatchQueue.main.async { [weak self] in
				self?.screenState = .content
			}
        }
    }
    
    private func ensureMinimumLoadingTime(startTime: Date, minimumTime: TimeInterval) async {
        let elapsedTime = calculateElapsedTime(from: startTime)
        let remainingTime = calculateRemainingTime(minimumTime: minimumTime, elapsedTime: elapsedTime)
        
        if remainingTime > 0 {
            try? await Task.sleep(nanoseconds: UInt64(remainingTime * 1_000_000_000))
        }
    }
    
    private func calculateElapsedTime(from startTime: Date) -> TimeInterval {
        return Date().timeIntervalSince(startTime)
    }
    
    private func calculateRemainingTime(minimumTime: TimeInterval, elapsedTime: TimeInterval) -> TimeInterval {
        return max(minimumTime - elapsedTime, 0)
    }
}
