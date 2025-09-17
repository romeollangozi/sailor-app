//
//  HomeHealthCheckView.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 3/20/25.
//

import SwiftUI
import VVUIKit

struct HomeHealthCheckView: View {
    
    @State var viewModel: HomeCheckInViewModelProtocol
    
    init(viewModel: HomeCheckInViewModelProtocol) {
        _viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
        
        ZStack {

            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 1)
                .shadow(color: .black.opacity(0.07), radius: 24, x: 0, y: 8)
            
            HStack(spacing: Spacing.space16) {
                
                Image(viewModel.getHealthCheckIconName)
                
                VStack(alignment: .leading, spacing: Spacing.space8) {
                    
                    Text(viewModel.section.healthCheck.title)
                        .font(.vvBodyBold)
                        .foregroundStyle(Color.charcoalBlack)
                    
                    Text(viewModel.section.healthCheck.description)
                        .font(.vvSmall)
                        .foregroundStyle(Color.coolGray)
                        .fixedSize(horizontal: false, vertical: true)
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                if viewModel.isHealthCheckAvailable {
                    Image("ForwardRed")
                }
                
            }
            .padding(Spacing.space16)
        }
        .frame(minHeight: 96)
        .padding(.horizontal, Spacing.space16)
        
    }
}

#Preview {
    
    VStack(spacing: 20){
        HomeHealthCheckView(viewModel: HomeCheckInViewModel.mockViewModel(healthCheckStatus: .closed))
        
        HomeHealthCheckView(viewModel: HomeCheckInViewModel.mockViewModel(healthCheckStatus: .opened))
        
        HomeHealthCheckView(viewModel: HomeCheckInViewModel.mockViewModel(healthCheckStatus: .completed))
        
        HomeHealthCheckView(viewModel: HomeCheckInViewModel.mockViewModel(healthCheckStatus: .moderationIssue))
    }
}
