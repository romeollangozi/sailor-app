//
//  MusterDrillView.swift
//  Virgin Voyages
//
//  Created by TX on 7.4.25.
//

import SwiftUI

public protocol MusterDrillViewModelProtocol {
    // MARK: - State flags
    var hasUserManuallyExpandedContent: Bool { get }
    var isMusterDrillOngoing: Bool { get }
    
    // MARK: - Header Info
    var assemblyStationTitle: String { get }
    var stationName: String { get }
    var stationPlace: String { get }
    var stationDeck: String { get }
    
    // MARK: - Video Info
    var videoTitle: String { get }
    var videoThumbnailURL: URL? { get }
    
    // MARK: - Guest Info
    var guestName: String { get }
    var guestComplementaryText: String { get }
    var guestPhotoURL: URL? { get }
    var guestHasWatched: Bool { get }
    
    // MARK: - Message Info
    var messageTitle: String { get }
    var messageDescription: String { get }
    
    var shouldShowInfoState: Bool { get }
    
    // MARK: - Emergency
    var shouldShowEmergencyContent: Bool { get }
    var emergencyTitle: String { get }
    var emergencyDescription: String { get }
    
    // MARK: - Header Button Display Logic
    func onChevronButtonTapped()
    
    // Content Visibility
    var isMusterDrillContentExpanded: Bool { get }
    func toggleMusterDrillContent()
    
    // MARK: - Actions
    func onAppear()
    func onDisappear()
    func dismissView()
    func changeLanguageButtonDidTap()
    func shouldDismissPresentingSheet()
    func videoPlayButtonTapped()
}

public struct MusterDrillView: View {
    
    @Binding var isExpanded: Bool
    @Binding var viewHeight: CGFloat
    
    @State private var topSafeAreaInset: CGFloat = 0
    @State private var viewModel: MusterDrillViewModelProtocol
    
    private let imageDownloadViewModel: DownloadImageViewModelProtocol
    private let shouldRemainOpenAfterUserHasWatchedSafteyVideo: Bool
    
    public init(shouldRemainOpenAfterUserHasWatchedSafteyVideo: Bool = false,
                isExpanded: Binding<Bool>,
                viewHeight: Binding<CGFloat>,
                viewModel: MusterDrillViewModelProtocol,
                imageDownloadViewModel: DownloadImageViewModelProtocol) {
        
        _viewModel = .init(wrappedValue: viewModel)
        
        self._viewHeight = viewHeight
        self._isExpanded = isExpanded
        self.imageDownloadViewModel = imageDownloadViewModel
        self.shouldRemainOpenAfterUserHasWatchedSafteyVideo = shouldRemainOpenAfterUserHasWatchedSafteyVideo
    }
    
    public var body: some View {
        ZStack {
            SafeAreaReader { insets in
                topSafeAreaInset = insets.top
            }.hidden()
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    headerSection
                    if viewModel.isMusterDrillContentExpanded || shouldRemainOpenAfterUserHasWatchedSafteyVideo {
                        if viewModel.shouldShowEmergencyContent {
                            emergencySection
                            emergencyMessageSection
                        } else {
                            languageSelector
                            videoSection
                            guestInfoSection
                            messageSection
                        }
                    }
                }
                .background(
                    GeometryReader { geo in
                        Color.clear
                            .onChange(of: geo.size.height) { _, newValue in
                                if newValue > 0 {
                                    if viewModel.shouldShowEmergencyContent || shouldRemainOpenAfterUserHasWatchedSafteyVideo || viewModel.isMusterDrillOngoing || viewModel.isMusterDrillContentExpanded {
                                        viewHeight = UIScreen.main.bounds.height
                                    } else if viewModel.shouldShowInfoState {
                                        viewHeight = newValue - topSafeAreaInset
                                    }
                                }
                            }
                    }
                )
            }
            .scrollBounceBehavior(.basedOnSize)
            .ignoresSafeArea(edges: .top)
        }
        .frame(maxHeight: .infinity)
        .background(Color.softGray)
        .onChange(of: viewModel.isMusterDrillContentExpanded) { oldValue, newValue in
            $isExpanded.wrappedValue = newValue
        }

    }
    
    private var headerSection: some View {
        MusterDrillHeaderView(
            topInset: topSafeAreaInset,
            title: viewModel.assemblyStationTitle,
            stationName: viewModel.stationName,
            stationPlace: viewModel.stationPlace,
            stationDeck: viewModel.stationDeck,
            buttonMode: resolveHeaderButtonMode()
        )
    }
    
    private func resolveHeaderButtonMode() -> MusterDrillHeaderButtonMode {
        if viewModel.isMusterDrillOngoing {
            if viewModel.shouldShowEmergencyContent {
                return .none
            }
            return viewModel.guestHasWatched
            ? viewModel.isMusterDrillContentExpanded ? .chevronUp(viewModel.toggleMusterDrillContent) : .chevronDown(viewModel.toggleMusterDrillContent)
            : .none
        } else if viewModel.shouldShowInfoState {
            if shouldRemainOpenAfterUserHasWatchedSafteyVideo {
                return .close(viewModel.dismissView)
            }
            return viewModel.isMusterDrillContentExpanded ? .chevronUp(viewModel.toggleMusterDrillContent) : .chevronDown(viewModel.toggleMusterDrillContent)
        } else {
            return .close(viewModel.dismissView)
        }
    }
    
    private var languageSelector: some View {
        HStack {
            Image(systemName: "globe")
            Text("Language: English (English)")
                .font(.vvBodyMedium)
                .foregroundStyle(Color.darkGrayText)
            
            Spacer()
//            Button {
//                viewModel.changeLanguageButtonDidTap()
//            } label: {
//                Text("Change")
//                    .font(.vvBodyMedium)
//                    .foregroundStyle(Color.darkGrayText)
//                    .underline()
//            }
        }
        .padding(.horizontal, Spacing.space24)
        .padding(.vertical, Spacing.space20)
    }
    
    private var videoSection: some View {
        VStack {
            VStack(spacing: Spacing.space8) {
                Text(viewModel.videoTitle)
                    .font(.vvHeading4Bold)
                    .multilineTextAlignment(.center)
                    .padding(Spacing.space24)
                
                ZStack {
                    
                    
                    AsyncImage(url: viewModel.videoThumbnailURL) { phase in
                        switch phase {
                        case .empty: Color.gray
                        case .success(let image): image.resizable().aspectRatio(contentMode: .fill)
                        case .failure: Color.gray
                        @unknown default: Color.gray
                        }
                    }
                    .frame(height: 180)
                    .cornerRadius(12)
                    .clipped()
                    
                    Button {
                        viewModel.videoPlayButtonTapped()
                    } label: {
                        HStack(alignment: .center) {
                            Image("playButton")
                                .frame(width: 18, height: 18)
                                .offset(x: 1)
                        }
                        .frame(width: 62, height: 62)
                        .background(.white)
                        .clipShape(Circle())
                    }
                    
                }
            }
            .padding(.horizontal, Spacing.space24)
        }
        .background(.white)
    }
    
    private var guestInfoSection: some View {
        VStack {
            HStack(alignment: .center, spacing: Spacing.space16) {
                ZStack(alignment: .bottomTrailing) {
                    AuthURLImageView(
                        size: 40,
                        clipShape: .circle,
                        defaultImage: "ProfilePlaceholder",
                        viewModel: imageDownloadViewModel
                    )
                    
                    if viewModel.guestHasWatched {
                        Circle()
                            .fill(Color.green)
                            .frame(width: 16, height: 16)
                            .overlay(
                                Image(systemName: "checkmark")
                                    .font(.caption2)
                                    .foregroundColor(.white)
                            )
                            .offset(x: 2, y: 2)
                    }
                }
                
                (
                    Text(viewModel.guestName).font(.vvSmallBold) +
                    Text(viewModel.guestComplementaryText).font(.vvSmall)
                )
                .foregroundColor(.vvBlack)
                .multilineTextAlignment(.leading)
                
                Spacer()
            }
            .padding(.vertical, Spacing.space16)
            .padding(.horizontal, Spacing.space24)
        }
        .background(.white)
        
    }
    
    private var messageSection: some View {
        VStack(alignment: .leading, spacing: Spacing.space12) {
            Text(viewModel.messageTitle)
                .font(.vvHeading4Bold)
                .foregroundColor(.vvBlack)
            Text(viewModel.messageDescription)
                .font(.vvBody)
                .foregroundColor(.darkGrayText)
                .lineSpacing(8)
            Spacer()
        }
        .padding(Spacing.space24)
        .padding(.bottom, Spacing.space48)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var emergencySection: some View {
        VStack(alignment: .center, spacing: Spacing.space12) {
            Text(viewModel.emergencyTitle)
                .font(.vvHeading4Bold)
                .foregroundColor(.vvBlack)
                .multilineTextAlignment(.center)

            Text(viewModel.emergencyDescription)
                .font(.vvBody)
                .foregroundColor(.darkGrayText)
                .lineSpacing(8)
                .multilineTextAlignment(.center)

        }
        .padding(Spacing.space24)
        .frame(maxWidth: .infinity, alignment: .center)
        .background(.white)
    }

    private var emergencyMessageSection: some View {
        VStack(alignment: .center, spacing: Spacing.space12) {
            Text(viewModel.messageTitle.uppercased())
                .font(.vvSmallBold)
                .foregroundColor(.vvBlack)
                .multilineTextAlignment(.center)

            Text(viewModel.messageDescription)
                .font(.vvBody)
                .foregroundColor(.darkGrayText)
                .lineSpacing(8)
                .multilineTextAlignment(.center)
            Spacer()
        }
        .padding(Spacing.space24)
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

final class MusterDrillPreviewViewModel: MusterDrillViewModelProtocol {
    
    var assemblyStationTitle: String { "YOUR ASSEMBLY STATION" }
    var stationName: String { "A6" }
    var stationPlace: String { "The Manor" }
    var stationDeck: String { "Deck 6 Aft" }
    
    var videoTitle: String { "Welcome to Your Muster Drill" }
    var videoThumbnailURL: URL? { URL(string: "https://cms-cert.ship.virginvoyages.com/dam/jcr:108e0bb1-a3eb-4ba4-bcb6-9b1d5056f8b6/IMG-WEL-Safety-v2-311x175.png") }
    
    var guestName: String { "John Doe" }
    var guestComplementaryText: String {
        guestHasWatched ? " has watched this video" : " has not watched this video"
    }
    var guestPhotoURL: URL? { URL(string: "https://example.com/guest.jpg") }
    
    var messageTitle: String { "Important Safety Info" }
    var messageDescription: String {
        "Please ensure you complete your muster drill before departure. This is mandatory for all guests on board."
    }
    
    var emergencyTitle: String {
        "Your Attention"
    }
    
    var emergencyDescription: String {
        "Go to your cabin if safe and collect your life jackets, warm clothing, and essential medication and proceed to your Muster Station."
    }
    
    var shouldShowEmergencyContent: Bool {
        return true
    }
    
    var shouldShowInfoState: Bool {
        return false
    }

    var hasUserManuallyExpandedContent: Bool = true
    var guestHasWatched: Bool { true }
    var isMusterDrillOngoing: Bool = true
    var isMusterDrillContentExpanded: Bool {
        return !guestHasWatched || hasUserManuallyExpandedContent
    }
    
    func onAppear() { }
    func onDisappear() {}
    func dismissView() {}
    func shouldDismissPresentingSheet() {}
    func changeLanguageButtonDidTap() {}
    func videoPlayButtonTapped() {}
    
    func toggleMusterDrillContent() {
        hasUserManuallyExpandedContent.toggle()
    }

    func onChevronButtonTapped() { }
}

final class DownloadImagePreviewViewModel: DownloadImageViewModelProtocol {
    var imageData: Data? = Data()
    
    var isLoading: Bool = false
    
    func downloadFile() async {
        
    }
}

#Preview {
    NavigationStack {
        MusterDrillView(isExpanded: .constant(true), viewHeight: .constant(460.0), viewModel: MusterDrillPreviewViewModel(), imageDownloadViewModel: DownloadImagePreviewViewModel())
    }
}
