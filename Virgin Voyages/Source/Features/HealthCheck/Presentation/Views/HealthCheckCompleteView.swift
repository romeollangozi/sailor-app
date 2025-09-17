//
//  HealthCheckCompleteView.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 6/12/25.
//

import SwiftUI
import VVUIKit

struct HealthCheckCompleteView: View {
    
    var viewModel: HealthCheckEntryPointViewModelProtocol
    
    var body: some View {
        
        VStack(spacing: Spacing.space0) {
            
            toolbar
            
            VStack(alignment: .leading, spacing: Spacing.space16) {
                
                Text(viewModel.homeHealthCheckDetail.healthCheckReviewPage.title)
                    .foregroundStyle(Color.blackText)
                    .font(.vvHeading1Bold)
                
                HTMLText(htmlString: viewModel.homeHealthCheckDetail.healthCheckReviewPage.description,
                         fontType: .normal,
                         fontSize: .size18,
                         color: .slateGray)
                
            }
            .padding(.top, Spacing.space32)
            .padding(.horizontal, Spacing.space24)
            
            Spacer()
            
            VStack(spacing: Spacing.space16) {
                
                PrimaryButton("Done", padding: 0, action:{
                    viewModel.dismissHealthCheck()
                })
                
                LinkButton("Changes responses", action: {
                    viewModel.goToHealthCheckQuestions()
                })
                .foregroundStyle(Color.darkGray)
                .frame(maxWidth: .infinity)
                
            }
            .padding(.bottom, Spacing.space40)
            .padding(.horizontal, Spacing.space24)
            
        }
    }
    
    var toolbar: some View {
        HStack(alignment: .top) {
            
            Spacer()
            
            ZStack {
                
                AuthURLImageView(imageUrl: viewModel.homeHealthCheckDetail.healthCheckReviewPage.imageURL,
                                 size: 144,
                                 defaultImage: "toolbar Semaphore")
                .clipShape(RoundedCorners(bottomLeft: 130))
                                 
                HStack {
                    Spacer()
                    ClosableButton(action: {
                        viewModel.dismissHealthCheck()
                    })
                    .padding(.horizontal, Spacing.space24)
                }
            }
            .frame(width: 144, height: 144, alignment: .trailing)
        }
    }
    
}

#Preview {
    HealthCheckCompleteView(viewModel: HealthCheckCompletePreviewViewModel())
        .ignoresSafeArea()
}


struct HealthCheckCompletePreviewViewModel: HealthCheckEntryPointViewModelProtocol {
    
    var screenState: ScreenState = .content
    var homeHealthCheckDetail: HealthCheckDetail = .sample()
    
    func onAppear() {
        
    }
    
    func onRefresh() {
        
    }
    
    func dismissHealthCheck() {
        
    }
    
    func goToHealthCheckQuestions() {
        
    }
}
