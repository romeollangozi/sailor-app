//
//  AuthURLImageView.swift
//  Virgin Voyages
//
//  Created by TX on 12.3.25.
//

import SwiftUI
import VVUIKit

enum ClipShape {
    case circle
}

struct AuthURLImageView : View {
    
    // MARK: - Properties
    let defaultImage: String?
    let size: CGFloat?
    let height: CGFloat?
    let clipShape: ClipShape?
    let onImageTap: ((_ imageData: Data) -> Void)?
    
    @State private var viewModel: DownloadImageViewModelProtocol
    
    // MARK: - Init
    init(imageUrl: String,
         size: CGFloat? = nil,
         height: CGFloat? = nil,
         clipShape: ClipShape? = nil,
         defaultImage: String? = nil,
         viewModel: DownloadImageViewModelProtocol = DownloadImageViewModel(fileURL: ""),
         onImageTap: ((_ imageData: Data) -> Void)? = nil) {

        self.defaultImage = defaultImage
        self.size = size
        self.height = height
        self.clipShape = clipShape
        self.onImageTap = onImageTap
        _viewModel = .init(wrappedValue: DownloadImageViewModel(fileURL: imageUrl))
    }
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                if let size {
                    ProgressView().frame(width: size, height: size)
                } else if let height {
                    ProgressView().frame(maxWidth: .infinity, maxHeight: height)
                } else {
                    ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            } else {
                if let imageData = viewModel.imageData, !imageData.isEmpty {
                    if let onImageTap {
                        imageWithData(imageData)
                            .onTapGesture {
                                onImageTap(imageData)
                            }
                    } else {
                        imageWithData(imageData)
                    }
                } else {
                    // Default image
                    Image(defaultImage.value)
                        .resizable()
                        .scaledToFill()
                        .modifier(ConditionalFrame(size: size))
                        .modifier(ConditionalClipShape(shape: customClipShape))
                }
            }
        }
        .task {
            await viewModel.downloadFile()
        }
    }
    
    @ViewBuilder
    private func imageWithData(_ data: Data) -> some View {
        Image(data: data)
            .resizable()
            .scaledToFill()
            .modifier(ConditionalFrame(size: size))
            .modifier(ConditionalClipShape(shape: customClipShape))
    }
    
    private var customClipShape: CustomAnyShape? {
        switch clipShape {
        case .circle:
            CustomAnyShape(Circle())
        default:
            nil
        }
    }
}
