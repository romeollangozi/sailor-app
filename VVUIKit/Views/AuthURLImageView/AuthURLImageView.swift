//
//  AuthURLImageView.swift
//  VVUIKit
//
//  Created by TX on 8.4.25.
//

import SwiftUI
import UIKit

public enum ClipShape {
    case circle
}

public protocol DownloadImageViewModelProtocol {
    var imageData: Data? { get }
    var isLoading: Bool { get }

    func downloadFile() async
}

public struct AuthURLImageView: View {
    // MARK: - Properties
    let defaultImage: String?
    let size: CGFloat?
    let height: CGFloat?
    let clipShape: ClipShape?
    let onImageTap: ((_ imageData: Data) -> Void)?

    
    @State private var viewModel: DownloadImageViewModelProtocol
    
    public init(
        size: CGFloat? = nil,
        height: CGFloat? = nil,
        clipShape: ClipShape? = nil,
        defaultImage: String? = nil,
        viewModel: DownloadImageViewModelProtocol,
        onImageTap: ((_ imageData: Data) -> Void)? = nil) {
        
        self.defaultImage = defaultImage
        self.size = size
        self.height = height
        self.clipShape = clipShape
        self.onImageTap = onImageTap
        _viewModel = .init(wrappedValue:viewModel)
    }

    public var body: some View {
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
                #if canImport(UIKit)
                if let imageData = viewModel.imageData, !imageData.isEmpty, 
                   let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .modifier(ConditionalFrame(size: size))
                        .modifier(ConditionalClipShape(shape: customClipShape))
                } else {
                    fallbackImage
                }
                #else
                fallbackImage
                #endif
            }
        }
        .task {
            await viewModel.downloadFile()
        }
    }
    
    private var fallbackImage: some View {
        Image(defaultImage ?? "")
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
