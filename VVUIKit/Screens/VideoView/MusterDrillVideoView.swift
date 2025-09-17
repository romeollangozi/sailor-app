//
//  MusterDrillVideoView.swift
//  VVUIKit
//
//  Created by TX on 14.4.25.
//

import SwiftUI

public protocol MusterDrillVideoViewModelProtocol {
    var videoURL: URL? { get }
    var canSkip: Bool { get }
    var isDismissAllowed: Bool { get }
    var currentLanguage: String { get set }

    func onCompletion()
    func onViewDismiss()
}

public struct MusterDrillVideoView: View {
    @State private var viewModel: MusterDrillVideoViewModelProtocol

    public init(viewModel: MusterDrillVideoViewModelProtocol) {
        _viewModel = .init(wrappedValue: viewModel)
    }

    public var body: some View {
        
        if let url = viewModel.videoURL {
            MusterDrillVideoPlayerViewControllerWrapper(
                url: url,
                canSkip: viewModel.canSkip,
                onComplete: viewModel.onCompletion,
                onDisappear: viewModel.onViewDismiss
            )
        } else {
            VStack {
                Text("Video not found")
            }
        }
    }
}

class MusterDrillVideoPreviewViewModel: MusterDrillVideoViewModelProtocol {
    
    var videoURL: URL? = URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")

    var canSkip: Bool = true
    var isDismissAllowed: Bool = true
    var currentLanguage: String = "en"

    func onCompletion() { }

    func onViewDismiss() { }
}

// MARK: - Preview

#Preview("Muster Drill Video View") {
    MusterDrillVideoView(viewModel: MusterDrillVideoPreviewViewModel())
}
