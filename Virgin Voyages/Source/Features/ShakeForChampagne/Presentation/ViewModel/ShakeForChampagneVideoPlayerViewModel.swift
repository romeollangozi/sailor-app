//
//  ShakeForChampagneVideoPlayerViewModel.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 7/10/25.
//

import Foundation

@Observable class ShakeForChampagneVideoPlayerViewModel: BaseViewModel, ShakeForChampagneVideoPlayerViewModelProtocol {
    
    var onVideoFinished: VoidCallback?
    
    init(onVideoFinished: VoidCallback? = nil) {
        self.onVideoFinished = onVideoFinished
    }
    
    // MARK: - Properties
    @ObservationIgnored
    private(set) lazy var champagneAnimationVideoPlayer: VideoPlayer = {
        guard let url = Bundle.main.url(forResource: "ChampagneAnimation", withExtension: "mp4") else {
            fatalError("ChampagneAnimation.mp4 not found in bundle")
        }
        
        let player = VideoPlayer(url: url) { [weak self] in
            self?.onVideoFinished?()
        }
        
        player.name = "ChampagneAnimation"
        return player
    }()
    
    // MARK: - Public Interface
    
    func onAppear() {
        // Force lazy initialization if needed
        _ = champagneAnimationVideoPlayer
        
        // Add a small delay to ensure the view is fully loaded
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.champagneAnimationVideoPlayer.restart()
        }
    }
}
