//
//  VideoPlayerContianer.swift
//  VVUIKit
//
//  Created by TX on 14.4.25.
//

import Foundation
import UIKit
import SwiftUI
import AVKit

public final class MusterDrillAVPlayerViewController: AVPlayerViewController {
    private var onComplete: () -> Void
    private var onDisappear: () -> Void
    private var observerToken: Any?
    
    public init(url: URL, canSkip: Bool, onComplete: @escaping () -> Void, onDisappear: @escaping () -> Void) {
        self.onComplete = onComplete
        self.onDisappear = onDisappear
        super.init(nibName: nil, bundle: nil)
        
        let player = AVPlayer(url: url)
        self.player = player
        self.showsPlaybackControls = true
        self.requiresLinearPlayback = !canSkip
        self.modalPresentationStyle = .fullScreen
        
        observerToken = NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: player.currentItem,
            queue: .main
        ) { [weak self] _ in
            self?.onComplete()
        }
        
        player.play()
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        onDisappear()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .all
    }
    
    public override var shouldAutorotate: Bool {
        return true
    }
    
    deinit {
        if let token = observerToken {
            NotificationCenter.default.removeObserver(token)
        }
    }
}

public struct MusterDrillVideoPlayerViewControllerWrapper: UIViewControllerRepresentable {
    private var onComplete: () -> Void
    private var onDisappear: () -> Void
    private var canSkip: Bool
    private var url: URL
    
    public init(url: URL, canSkip: Bool, onComplete: @escaping () -> Void, onDisappear: @escaping () -> Void) {
        self.canSkip = canSkip
        self.url = url
        self.onComplete = onComplete
        self.onDisappear = onDisappear
    }
    
    public func makeUIViewController(context: Context) -> UIViewController {
        
        let hostVC = UIViewController()
        hostVC.view.backgroundColor = .clear
        DispatchQueue.main.async {
            let playerVC = MusterDrillAVPlayerViewController(url: url, canSkip: canSkip) {
                onComplete()
                hostVC.dismiss(animated: true)
            } onDisappear: {
                hostVC.dismiss(animated: false)
            }
            
            hostVC.present(playerVC, animated: true)
        }
        return hostVC
    }
    
    public func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
