//
//  ShakeForChampagneVideoPlayerView.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 7/10/25.
//

import SwiftUI

protocol ShakeForChampagneVideoPlayerViewModelProtocol {
    
    var champagneAnimationVideoPlayer: VideoPlayer { get }
    func onAppear()
    
}

struct ShakeForChampagneVideoPlayerView: View {
    
    // MARK: - Properties
    @State private var viewModel: ShakeForChampagneVideoPlayerViewModelProtocol
        
    // MARK: - Initialization
    init(onVideoFinished: VoidCallback? = nil) {
        _viewModel = State(wrappedValue: ShakeForChampagneVideoPlayerViewModel(onVideoFinished: onVideoFinished))
    }
    
    init(viewModel: ShakeForChampagneVideoPlayerViewModelProtocol) {
        _viewModel = State(wrappedValue: viewModel)
    }
    
    // MARK: - Body
    var body: some View {
        
        VideoPlayerView(player: viewModel.champagneAnimationVideoPlayer)
            .ignoresSafeArea()
            .onAppear {
                viewModel.onAppear()
            }
    }
    
}

// MARK: - Preview ViewModel
final class PreviewShakeForChampagneVideoPlayerView: ShakeForChampagneVideoPlayerViewModelProtocol {
    
    lazy var champagneAnimationVideoPlayer: VideoPlayer = {
        guard let url = Bundle.main.url(forResource: "ChampagneAnimation", withExtension: "mp4") else {
            return VideoPlayer(url: URL(string: "about:blank")!)
        }
        return VideoPlayer(url: url)
    }()
    
    func onAppear() {
        
    }
}

// MARK: - Preview
#Preview {
    ShakeForChampagneVideoPlayerView(viewModel: PreviewShakeForChampagneVideoPlayerView())
}
