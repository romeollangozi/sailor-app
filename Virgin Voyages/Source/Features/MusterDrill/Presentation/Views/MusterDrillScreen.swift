//
//  MusterDrillScreen.swift
//  Virgin Voyages
//
//  Created by TX on 7.4.25.
//

import SwiftUI
import VVUIKit

struct MusterDrillScreen: View {
    
    let shouldRemainOpenAfterUserHasWatchedSafteyVideo: Bool
    @Binding var isExpanded: Bool
    @State private var musterDrillHeight: CGFloat = 0.0
    @State private var viewModel: MusterDrillScreenViewModelProtocol

    init(shouldRemainOpenAfterUserHasWatchedSafteyVideo: Bool, isExpanded: Binding<Bool>, viewModel: MusterDrillScreenViewModelProtocol = MusterDrillScreenViewModel()) {
        _viewModel = .init(wrappedValue: viewModel)
        self._isExpanded = isExpanded
        self.shouldRemainOpenAfterUserHasWatchedSafteyVideo = shouldRemainOpenAfterUserHasWatchedSafteyVideo
    }

    var body: some View {
        VirginScreenView(state: $viewModel.screenState) {
            MusterDrillView(shouldRemainOpenAfterUserHasWatchedSafteyVideo: self.shouldRemainOpenAfterUserHasWatchedSafteyVideo, isExpanded: $isExpanded, viewHeight: $musterDrillHeight, viewModel: viewModel, imageDownloadViewModel: DownloadImageViewModel(fileURL: viewModel.guestPhotoURL?.absoluteString ?? ""))
                .padding(.zero)
                .fullScreenCover(item: $viewModel.appCoordinator.homeTabBarCoordinator.musterDrillCoordinator.fullScreenRouter, content: { path in
                    self.viewModel.destinationView(for: path)
                })
                .sheet(item: $viewModel.appCoordinator.homeTabBarCoordinator.musterDrillCoordinator.sheetRouter.currentSheet, content: { path in
                    viewModel.destinationView(for: path)
                })
        } loadingView: {
            VStack {
                ProgressView("Loading Muster Drill...")
                    .font(.headline)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.white)

        } errorView: {
            NoDataView {
                viewModel.onAppear()
            }
        }
        .onAppear {
            viewModel.onAppear()
        }
        .onDisappear {
            viewModel.onDisappear()
        }
        .frame(height: (viewModel.screenState == .loading || viewModel.screenState == .error) ? UIScreen.main.bounds.height : musterDrillHeight)
    }
}


class MusterDrillScreenPreviewViewModel: MusterDrillScreenViewModelProtocol {
    var shouldShowInfoState: Bool = false
    
    var shouldShowEmergencyContent: Bool = false
    
    var emergencyTitle: String = ""
    
    var emergencyDescription: String = ""
    
    
    var appCoordinator: CoordinatorProtocol = AppCoordinator.init()
    
    var screenState: ScreenState = .content
    
    func onAppear() { }
    
    func onDisappear() { }
        
    var assemblyStationTitle: String = ""
    
    var stationName: String = ""
    
    var stationPlace: String = ""
    
    var stationDeck: String = ""
    
    var videoTitle: String = ""
    
    var videoThumbnailURL: URL? = nil
    
    var guestName: String = ""
    
    var guestComplementaryText: String = ""
    
    var guestPhotoURL: URL? = nil
    
    var guestHasWatched: Bool = false
    
    var messageTitle: String = ""
    
    var messageDescription: String = ""
    
    func dismissView() { }
    
    func changeLanguageButtonDidTap() {
        
    }
    
    func shouldDismissPresentingSheet() {
        
    }
    
    func videoPlayButtonTapped() {
        
    }
    
    func destinationView(for sheetRoute: any BaseSheetRouter) -> AnyView {
        AnyView(Text("Destination view"))
    }
    
    func destinationView(for fullScreenRoute: any BaseFullScreenRoute) -> AnyView {
        AnyView(Text("Destination view"))
    }
    
    var hasUserManuallyExpandedContent: Bool = false
    var isMusterDrillContentExpanded: Bool = true
    var isMusterDrillOngoing: Bool = true
    
    func onChevronButtonTapped() { }
    func toggleMusterDrillContent() { }
}

#Preview {
    MusterDrillScreen(shouldRemainOpenAfterUserHasWatchedSafteyVideo: false, isExpanded: .constant(true), viewModel: MusterDrillScreenPreviewViewModel())
}
