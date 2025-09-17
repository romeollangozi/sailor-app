//
//  HomeEmbarkationView.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 3/25/25.
//

import SwiftUI
import VVUIKit

struct HomeEmbarkationView: View {
    
    @State var viewModel: HomeCheckInViewModelProtocol
    
    init(viewModel: HomeCheckInViewModelProtocol) {
        _viewModel = .init(wrappedValue: viewModel)
    }
    
    
    @State private var isExpanded = false
    
    var body: some View {
        
        VStack() {
            
            HStack(spacing: Spacing.space16) {
                
                AuthURLImageView(imageUrl: viewModel.section.embarkation.imageUrl,
                                 size: 64,
                                 clipShape: .circle,
                                 defaultImage: "embarkationPlaceHolder")
                
                VStack(alignment: .leading,
                       spacing: Spacing.space8) {
                    
                    Text(viewModel.section.embarkation.title)
                        .font(.vvBodyBold)
                        .foregroundStyle(Color.charcoalBlack)
                    
                    Text(viewModel.section.embarkation.description)
                        .font(.vvSmall)
                        .foregroundStyle(Color.coolGray)
                }
                
                       .frame(maxWidth: .infinity, alignment: .leading)
                
                
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.9)) {
                        isExpanded.toggle()
                    }
                } label: {
                    
                    Image(systemName: "chevron.down")
                        .foregroundStyle(Color.darkRed)
                        .symbolEffect(.bounce, value: isExpanded)
                        .rotationEffect(.degrees(isExpanded ? -180 : 0))
                        .frame(width: 24, height: 24)
                        .background {
                            Circle()
                                .fill(Color.softGray)
                        }
                }

            }
            
            if isExpanded {
                
                VStack(alignment: .leading, spacing: Spacing.space12) {
                    
                    HomeEmbarkationReceiptView(viewModel: viewModel)
                        .padding(.top, Spacing.space16)
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                    
                    if let embarkationGuide = viewModel.section.embarkation.guide {
                        
                        Button {
                            viewModel.didTapEmbarcationGuide()
                        } label: {
                            VStack(alignment: .leading, spacing: Spacing.space4) {
                                
                                HStack(spacing: Spacing.space4) {
                                    
                                    Text(embarkationGuide.title)
                                        .font(.vvBodyBold)
                                        .foregroundStyle(Color.charcoalBlack)
                                    
                                    Image("Chevron-Right")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 16, height: 16)
                                        .padding(.top, Spacing.space4)
                                }
                                
                                Text(embarkationGuide.description)
                                    .font(.vvSmall)
                                    .foregroundStyle(Color.slateGray)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .multilineTextAlignment(.leading)
                            }
                        }
                        
                    }
                   
                }
            }
                
        }
        .padding(Spacing.space16)
        .background(.white)
        .cornerRadius(8)
        .shadow(color: .black.opacity(0.07), radius: 24, x: 0, y: 8)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 1)
        
    }
}

#Preview {
    HomeEmbarkationView(viewModel: HomeCheckInViewModel.mockViewModel(healthCheckStatus: .closed))
        .padding(.horizontal, 16)
}
