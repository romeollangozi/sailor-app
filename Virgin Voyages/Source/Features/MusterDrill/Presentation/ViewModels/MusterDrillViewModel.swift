//
//  MusterDrillViewModel.swift
//  Virgin Voyages
//
//  Created by TX on 7.4.25.
//

import Foundation
import SwiftUI
import VVUIKit

protocol MusterDrillScreenViewModelProtocol: MusterDrillViewModelProtocol, CoordinatorSheetViewProvider, CoordinatorFullScreenViewProvider {
    var appCoordinator: CoordinatorProtocol { get set }
    var screenState: ScreenState { get set }
    
    func onAppear()
    func onDisappear()
}
    
@Observable
final class MusterDrillScreenViewModel: BaseViewModel, MusterDrillScreenViewModelProtocol {
    
    
    var appCoordinator: CoordinatorProtocol
    var screenState: ScreenState = .loading
    
    private let useCase: GetMusterDrillContentUseCaseProtocol
    private let musterDrillEventsNotificationService: MusterDrillEventsNotificationService
    
    private var content: MusterDrillContent = .empty()
    private var listenerKey = "MusterDrillScreenViewModel"

    init(appCoordinator: CoordinatorProtocol = AppCoordinator.shared,
         useCase: GetMusterDrillContentUseCaseProtocol = GetMusterDrillContentUseCase(),
         musterDrillEventsNotificationService: MusterDrillEventsNotificationService = .shared) {
        
        self.appCoordinator = appCoordinator
        self.useCase = useCase
        self.musterDrillEventsNotificationService = musterDrillEventsNotificationService

        super.init()
        self.startObservingEvents()
    }
    
    func onAppear() {
        Task { [weak self] in
            guard let self else { return }
            await self.fetchData()
        }
    }
    
    func onDisappear() {
        appCoordinator.executeCommand(HomeTabBarCoordinator.DismissMusterDrillFullScreenCommand())
        self.musterDrillEventsNotificationService.publish(.userDidFinishWatchingMusterDrill)
    }
    
    func fetchData() async {
        if let result = await executeUseCase({ try await self.useCase.execute() }) {
            await executeOnMain { [weak self] in
                guard let self else { return }
                self.content = result
                self.screenState = .content
            }
        } else {
            await executeOnMain { [weak self] in
                guard let self else { return }
                self.screenState = .error
            }
        }
    }

    func startObservingEvents() {
        musterDrillEventsNotificationService.listen(key: listenerKey) { [weak self] in
            guard let self else { return }
            self.handleEvent($0)
        }
    }

    func handleEvent(_ event: MusterDrillNotification) {
        switch event {
        case .shouldRefreshMusterDrill:
            Task {
                await self.fetchData()
            }
        default: break
        }
    }

    deinit {
        stopObservingEvents()
    }

    func stopObservingEvents() {
        musterDrillEventsNotificationService.stopListening(key: listenerKey)
    }

    func dismissView() {
        appCoordinator.executeCommand(HomeTabBarCoordinator.DismissAnyFullScreenCommand())
    }
    
    func shouldDismissPresentingSheet() {
        appCoordinator.executeCommand(MusterDrillCoordinator.DismissAnySheetCommand())
    }
    
    func changeLanguageButtonDidTap() {
        appCoordinator.executeCommand(MusterDrillCoordinator.ShowLanguagesSheetCommand())
    }
    
    func videoPlayButtonTapped() {
        appCoordinator.executeCommand(MusterDrillCoordinator.ShowMusterDrillVideoFullScreenCommand())
    }
    
    func onChevronButtonTapped() {
        toggleMusterDrillContent()
    }
    
    func toggleMusterDrillContent() {
        hasUserManuallyExpandedContent.toggle()
    }
    
    var hasUserManuallyExpandedContent: Bool = false
    
    // MARK: - Computed properties for View
    var shouldShowEmergencyContent: Bool {
        content.mode == .important && content.emergency != nil
    }
    
    var shouldShowInfoState: Bool {
        content.mode == .info
    }
    
    var emergencyTitle: String {
        (content.emergency?.title).value
    }
    
    var emergencyDescription: String {
        (content.emergency?.description).value
    }
    
    var isMusterDrillOngoing: Bool {
        content.mode == .important
    }
    
    var isMusterDrillContentExpanded: Bool {
        return (!guestHasWatched || hasUserManuallyExpandedContent) || isMusterDrillOngoing
    }

    var assemblyStationTitle: String { "YOUR ASSEMBLY STATION" }

    var stationName: String {
        content.assemblyStation.station
    }

    var stationPlace: String {
        content.assemblyStation.place
    }

    var stationDeck: String {
        content.assemblyStation.deck
    }

    var videoTitle: String {
        content.video.title
    }

    var videoThumbnailURL: URL? {
        return URL(string: content.video.stillImageUrl)
    }

    var guestName: String {
        content.video.guest.name
    }

    var guestPhotoURL: URL? {
        return URL(string: content.video.guest.photoUrl)
    }

    var guestHasWatched: Bool {
        content.video.guest.status
    }
    
    var guestComplementaryText: String {
        guestHasWatched ? " has watched this video" : " needs to watch this video"
    }

    var messageTitle: String {
        content.message.title
    }

    var messageDescription: String {
        content.message.description
    }
}

extension MusterDrillScreenViewModel {
    func destinationView(for sheetRoute: any BaseSheetRouter) -> AnyView {
        guard let path = sheetRoute as? MusterDrillSheetRoute else { return AnyView(Text("View for path not provided")) }
        switch path {
        case .languages:
            return AnyView (
                VStack {
                    Text("TBD - Languages View")
                }
            )
        }
    }
    
    func destinationView(for fullScreenRoute: any BaseFullScreenRoute) -> AnyView {
        guard let path = fullScreenRoute as? MusterDrillFullScreenRoute else { return AnyView(Text("View for path not provided")) }
        
        switch path {
        case .video:
            return AnyView(
                MusterDrillVideoView(
                    viewModel: MusterDrillVideoViewModel(
                        videoURL: URL(string: content.video.url),
                        hasWatched: content.video.guest.status,
                        didCompleteWatchingVideo: { [weak self] in
                            guard let self = self else { return }
                            // Reload muster drill screen after didCompleteWatchingVideo
                            self.onAppear()
                        },
                        viewDidDismiss: { [weak self] in
                            guard let self = self else { return }
                            self.appCoordinator.executeCommand(MusterDrillCoordinator.DismissMusterDrillVideoFullScreenCommand())

                        }
                    )
                )
                .presentationBackground(.clear)
                .ignoresSafeArea()
                .onAppear {
                    if let delegate = UIApplication.shared.delegate as? AppDelegate {
                        delegate.orientationLock = .all
                    }
                }
                .onDisappear {
                    if let delegate = UIApplication.shared.delegate as? AppDelegate {
                        delegate.orientationLock = .portrait
                    }
                }
            )
        }
    }
}
