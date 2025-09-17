//
//  VideoLoop.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 6/1/23.
//

import SwiftUI
import AVKit

class LoopingVideoPlayerLayer: UIView {
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

struct LoopingVideoPlayerView: UIViewRepresentable {
	let player: LoopingVideoPlayer

	func makeUIView(context: Context) -> LoopingVideoPlayerLayer {
		return LoopingVideoPlayerLayer(playerLayer: player.playerLayer)
	}

	func updateUIView(_ uiView: LoopingVideoPlayerLayer, context: Context) {
	}
}

class VVVideoPlayer {
	private let playerItem: AVPlayerItem
	let player: AVPlayer

	init(asset: AVAsset) {
		self.playerItem = AVPlayerItem(asset: asset)
		self.player = AVPlayer(playerItem: playerItem)
		configureAudioSession()
	}

	func play() {
		player.seek(to: .zero)
		player.play()
	}

	func stop() {
		player.pause()
		player.seek(to: .zero)
	}

	var currentItem: AVPlayerItem {
		return player.currentItem ?? playerItem
	}

	private func configureAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.ambient, mode: .default, options: [.mixWithOthers])
            try audioSession.setActive(true)
        } catch {
            print("Failed to configure AVAudioSession: \(error)")
        }
	}
}

class VideoPlayerObserverManager: NSObject {
	private var statusObserver: NSKeyValueObservation?
	private var player: VVVideoPlayer

	init(player: VVVideoPlayer) {
		self.player = player
		super.init()
		addObservers()
	}

	private func addObservers() {
		statusObserver = player.currentItem.observe(\.status, options: [.old, .new]) { [weak self] item, change in
			guard let self = self else { return }
			if item.status == .readyToPlay {
				self.player.play()
			}
		}

		NotificationCenter.default.addObserver(self, selector: #selector(playerDidReachEnd(_:)), name: .AVPlayerItemDidPlayToEndTime, object: player.currentItem)
		NotificationCenter.default.addObserver(self, selector: #selector(pausePlayer), name: UIApplication.didEnterBackgroundNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(playPlayer), name: UIApplication.willEnterForegroundNotification, object: nil)
	}

	deinit {
		NotificationCenter.default.removeObserver(self)
	}

	@objc private func playerDidReachEnd(_ notification: Notification) {
		player.play()
	}

	@objc private func pausePlayer() {
		player.stop()
	}

	@objc private func playPlayer() {
		player.play()
	}
}

class VideoPlayerLayerManager {
	private let playerLayer: AVPlayerLayer

	init(player: VVVideoPlayer) {
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

class LoopingVideoPlayer: NSObject {
	var name: String
	private let videoPlayer: VVVideoPlayer
	private let observerManager: VideoPlayerObserverManager
	private let layerManager: VideoPlayerLayerManager

	init(asset: AVAsset, autoPlay: Bool = true) {
		self.name = ""
		self.videoPlayer = VVVideoPlayer(asset: asset)
		self.observerManager = VideoPlayerObserverManager(player: videoPlayer)
		self.layerManager = VideoPlayerLayerManager(player: videoPlayer)

		if autoPlay {
			videoPlayer.play()
		}
	}

	var playerLayer: AVPlayerLayer {
		return layerManager.layer
	}

	func play() {
		videoPlayer.play()
	}

	func stop() {
		videoPlayer.stop()
	}
}
