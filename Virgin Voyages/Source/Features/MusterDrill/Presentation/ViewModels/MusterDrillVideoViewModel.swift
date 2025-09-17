//
//  MusterDrillVideoViewModel.swift
//  VVUIKit
//
//  Created by TX on 14.4.25.
//

import Foundation
import VVUIKit

@Observable
class MusterDrillVideoViewModel: BaseViewModel, MusterDrillVideoViewModelProtocol {

    var canSkip: Bool = false
    var isDismissAllowed: Bool = false
    var currentLanguage: String = "en"

    private let markVideoAsWatchedUseCase: MarkMusterDrillVideoAsWatchedUseCaseProtocol
    private let originalVideoURL: URL?
    private let didCompleteWatchingVideo: () -> Void
    private let viewDidDismiss: () -> Void

    private var musterDrillEventsNotificationService: MusterDrillEventsNotificationService
    private var listenerKey = "MusterDrillVideoViewModel"

    init(
        musterDrillEventsNotificationService: MusterDrillEventsNotificationService = .shared,
        videoURL: URL?,
        hasWatched: Bool,
        markVideoAsWatchedUseCase: MarkMusterDrillVideoAsWatchedUseCaseProtocol = MarkMusterDrillVideoAsWatchedUseCase(),
        didCompleteWatchingVideo: @escaping () -> Void,
        viewDidDismiss: @escaping () -> Void
    ) {
        self.musterDrillEventsNotificationService = musterDrillEventsNotificationService
        self.originalVideoURL = videoURL
        self.canSkip = hasWatched
        self.markVideoAsWatchedUseCase = markVideoAsWatchedUseCase
        self.didCompleteWatchingVideo = didCompleteWatchingVideo
        self.viewDidDismiss = viewDidDismiss
        
        super.init()
        self.startObservingEvents()
    }
    
    deinit {
        stopObservingEvents()
    }
    
    var videoURL: URL? {
        self.originalVideoURL
    }

    func onCompletion() {
        Task {
            await executeUseCase { [weak self] in
                guard let self else { return }
                try await self.markVideoAsWatchedUseCase.execute()
                await self.executeOnMain {
                    self.didCompleteWatchingVideo()
                }
            }
        }
    }
    
    func onViewDismiss() {
        self.viewDidDismiss()
    }
    
    override func handleError(_ error: any VVError) {
        //TODO: Handle error if MarkVideoAsWatchedUseCase fails
    }

    // MARK: - Event Handling
    func stopObservingEvents() {
        musterDrillEventsNotificationService.stopListening(key: listenerKey)
    }
    
    func startObservingEvents() {
        musterDrillEventsNotificationService.listen(key: listenerKey) { [weak self] in
            guard let self else { return }
            self.handleEvent($0)
        }
    }

    func handleEvent(_ event: MusterDrillNotification) {
        switch event {
        case .shouldRestartMusterDrillVideo:
            if !canSkip {
                onViewDismiss()
            }
        default: break
        }
    }

}
