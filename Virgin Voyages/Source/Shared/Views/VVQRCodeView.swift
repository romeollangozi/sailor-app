//
//  VVQRCodeView.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 28.10.24.
//

import SwiftUI


struct VVQRCodeView: View {
    
    // MARK: - ViewModel
    @State var viewModel: VVQRCodeViewModelProtocol
    var frameWidth: CGFloat
    var frameHeight: CGFloat
    var qrCodeImage: ((Data?, String) -> Void)
    
    // MARK: - Init
    init(viewModel: VVQRCodeViewModelProtocol = VVQRCodeViewModel(),
         frameWidth: CGFloat = 200,
         frameHeight: CGFloat = 200,
         qrCodeImage: @escaping ((Data?, String) -> Void)) {
        
        self.viewModel = viewModel
        self.frameWidth = frameWidth
        self.frameHeight = frameHeight
        self.qrCodeImage = qrCodeImage
    }
    
    var body: some View {
        ZStack {
            Image(data: viewModel.generateQRCode())
                .resizable()
                .interpolation(.none)
                .scaledToFit()
                .frame(width: frameWidth, height: frameHeight)
            if let profileImage = viewModel.profileImage {
                AuthURLImageView(imageUrl: profileImage, size: 60, clipShape: .circle, defaultImage: "")
            }
        }
        .onAppear {
            Task {
                qrCodeImage(viewModel.generateQRCode(), "")
            }
        }
    }
}

struct VVQRCodeView_Previews: PreviewProvider {
    static var previews: some View {
        VVQRCodeView(viewModel: VVQRCodeViewModel(input: "", profileImage: ""), qrCodeImage: {imageData, deepLink  in })
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
