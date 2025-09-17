//
//  FolioLandingView.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 25.7.25.
//

import SwiftUI

public protocol FolioLandingViewModelProtocol {
    var sailor: FolioDependentSailor { get }
}

public struct FolioLandingView: View {
    @State private var viewModel: FolioLandingViewModelProtocol
    
    public init(viewModel: FolioLandingViewModelProtocol) {
        _viewModel = .init(wrappedValue: viewModel)
    }
    
    public var body: some View {
        VStack(spacing: .zero) {
            
            profileView()
            
            VStack(spacing: Spacing.space16) {
                Text(viewModel.sailor.name)
                    .font(.vvHeading1Bold)
                    .foregroundColor(.vvBlack)
                    .multilineTextAlignment(.center)
                
                Text(viewModel.sailor.status.uppercased())
                    .font(.vvCaptionBold)
                    .foregroundColor(.vvBlack)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, Spacing.space16)
            .padding(.vertical, Spacing.space16)
            
            Text(viewModel.sailor.description)
                .font(.vvHeading5)
                .foregroundColor(.blackText)
                .multilineTextAlignment(.center)
                .kerning(1.2)
                .padding(.horizontal, Spacing.space24)
                .padding(.vertical, Spacing.space8)
            
            Text(viewModel.sailor.instructions)
                .font(.vvBody)
                .foregroundColor(.slateGray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, Spacing.space24)
                .padding(.top, Spacing.space16)
                .padding(.bottom, Spacing.space8)
            
            Spacer()
        }
        .padding(.vertical, Spacing.space32)
    }
    
    private func profileView() -> some View {
        ZStack {
            Circle()
                .stroke(Color.lightPink, lineWidth: 3)
                .frame(width: Spacing.space150, height: Spacing.space150)
            
            AsyncImage(url: viewModel.sailor.imageURL) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Image("Profile")
            }
            .frame(width: Spacing.space150 - Spacing.space8, height: Spacing.space150 - Spacing.space8)
            .clipShape(Circle())
            
        }
        .padding(.top, Spacing.space80)
        .padding(.bottom, Spacing.space28)
    }
}

final class FolioLandingPreviewViewModel: FolioLandingViewModelProtocol {
    var sailor: FolioDependentSailor = .init(name: "Liam Doe", status: "Has it covered", description: "Your folio has been set up", instructions: "To request a list of transactions")
}

#Preview {
    FolioLandingView(viewModel: FolioLandingPreviewViewModel())
}
