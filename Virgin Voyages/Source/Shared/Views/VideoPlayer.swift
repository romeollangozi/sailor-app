//
//  VideoPlayer.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 6/26/25.
//

import SwiftUI
import AVKit

// MARK: - Audio Session Manager
class AudioSessionManager {
    static let shared = AudioSessionManager()
    
    private init() {}
    
    func configureForVideoPlayback() {
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(.playback, mode: .moviePlayback, options: [])
            try audioSession.setActive(true)
            print("Audio session configured for video playback")
        } catch {
            print("Failed to configure audio session: \(error)")
        }
    }
}

// MARK: - VideoPlayerLayer
class VideoPlayerLayer: UIView {
    private let playerLayer: AVPlayerLayer
    
    init(playerLayer: AVPlayerLayer) {
        self.playerLayer = playerLayer
        super.init(frame: .zero)
        configurePlayerLayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updatePlayerLayerFrame()
    }
    
    private func configurePlayerLayer() {
        layer.addSublayer(playerLayer)
    }
    
    private func updatePlayerLayerFrame() {
        playerLayer.frame = bounds
    }
}

// MARK: - VideoPlayerView
struct VideoPlayerView: UIViewRepresentable {
    let player: VideoPlayer
    
    func makeUIView(context: Context) -> VideoPlayerLayer {
        return VideoPlayerLayer(playerLayer: player.playerLayer)
    }
    
    func updateUIView(_ uiView: VideoPlayerLayer, context: Context) {
        // Update UI if needed
    }
}

// MARK: - Single-Play Video Player
class VVVideoPlayerWithSound {
    private let playerItem: AVPlayerItem
    let player: AVPlayer
    
    init(asset: AVAsset) {
        self.playerItem = AVPlayerItem(asset: asset)
        self.player = AVPlayer(playerItem: playerItem)
        
        // Set player properties for better video playback
        player.allowsExternalPlayback = true
        player.appliesMediaSelectionCriteriaAutomatically = true
        
        // Setup audio session notifications for interruptions
        setupAudioSessionNotifications()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func startPlayback() {
        // Configure audio session each time we start playback
        AudioSessionManager.shared.configureForVideoPlayback()
        
        // Ensure we're starting from a clean state
        player.pause()
        
        // Start from beginning and play
        player.seek(to: .zero) { [weak self] completed in
            if completed {
                self?.player.play()
            }
        }
    }
    
    var currentItem: AVPlayerItem {
        return player.currentItem ?? playerItem
    }
    
    private func setupAudioSessionNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleAudioSessionInterruption),
            name: AVAudioSession.interruptionNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleAudioSessionRouteChange),
            name: AVAudioSession.routeChangeNotification,
            object: nil
        )
    }
    
    @objc private func handleAudioSessionInterruption(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
              let type = AVAudioSession.InterruptionType(rawValue: typeValue) else {
            return
        }
        
        switch type {
        case .began:
            // Video will pause automatically
            break
        case .ended:
            if let optionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt {
                let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
                if options.contains(.shouldResume) {
                    AudioSessionManager.shared.configureForVideoPlayback()
                    player.play()
                }
            }
        @unknown default:
            break
        }
    }
    
    @objc private func handleAudioSessionRouteChange(_ notification: Notification) {
        // Reconfigure audio session on route changes (e.g., headphones plugged/unplugged)
        AudioSessionManager.shared.configureForVideoPlayback()
    }
}

// MARK: - Single Play Video Observer
class SinglePlayVideoObserver: NSObject {
    private var statusObserver: NSKeyValueObservation?
    private var player: VVVideoPlayerWithSound
    private let onVideoEnded: (() -> Void)?
    
    init(player: VVVideoPlayerWithSound, onVideoEnded: (() -> Void)? = nil) {
        self.player = player
        self.onVideoEnded = onVideoEnded
        super.init()
        addObservers()
    }
    
    private func addObservers() {
        // Observer for player status - start playback when ready
        statusObserver = player.currentItem.observe(\.status, options: [.old, .new]) { [weak self] item, change in
            guard let self = self else { return }
            if item.status == .readyToPlay {
                self.player.startPlayback()
            }
        }
        
        // Observer for video completion
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(playerDidReachEnd(_:)),
            name: .AVPlayerItemDidPlayToEndTime,
            object: player.currentItem
        )
        
        // Observer for app lifecycle - handle background/foreground
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appDidEnterBackground),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appWillEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
    }
    
    deinit {
        statusObserver?.invalidate()
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func playerDidReachEnd(_ notification: Notification) {
        onVideoEnded?()
    }
    
    @objc private func appDidEnterBackground() {
        // Video will pause automatically when app goes to background
    }
    
    @objc private func appWillEnterForeground() {
        // Only resume if video hasn't ended yet
        if let currentTime = player.player.currentItem?.currentTime(),
           let duration = player.player.currentItem?.duration,
           CMTimeCompare(currentTime, duration) < 0 {
            AudioSessionManager.shared.configureForVideoPlayback()
            player.player.play()
        }
    }
}

// MARK: - Single Play Layer Manager
class SinglePlayLayerManager {
    private let playerLayer: AVPlayerLayer
    
    init(player: VVVideoPlayerWithSound) {
        self.playerLayer = AVPlayerLayer(player: player.player)
        configurePlayerLayer()
    }
    
    private func configurePlayerLayer() {
        playerLayer.videoGravity = .resizeAspectFill
    }
    
    var layer: AVPlayerLayer {
        return playerLayer
    }
}

// MARK: - Video Player
class VideoPlayer: NSObject {
    var name: String
    private let videoPlayer: VVVideoPlayerWithSound
    private var observerManager: SinglePlayVideoObserver?
    private let layerManager: SinglePlayLayerManager
    
    var onVideoEnded: (() -> Void)?
    
    init(url: URL, onVideoEnded: (() -> Void)? = nil) {
        self.name = ""
        self.videoPlayer = VVVideoPlayerWithSound(asset: AVAsset(url: url))
        self.layerManager = SinglePlayLayerManager(player: videoPlayer)
        self.onVideoEnded = onVideoEnded
        
        super.init()
        
        self.observerManager = SinglePlayVideoObserver(player: videoPlayer) { [weak self] in
            DispatchQueue.main.async {
                self?.onVideoEnded?()
            }
        }
    }
    
    var playerLayer: AVPlayerLayer {
        return layerManager.layer
    }
    
    // This method is called to restart the video from the beginning
    func restart() {
        // First, reset the player to ensure clean state
        videoPlayer.player.pause()
        videoPlayer.startPlayback()
    }
}
