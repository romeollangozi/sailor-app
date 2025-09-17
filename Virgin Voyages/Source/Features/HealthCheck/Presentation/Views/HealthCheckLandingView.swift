//
//  HealthCheckLandingView.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 6/3/25.
//

import SwiftUI
import VVUIKit

struct HealthCheckLandingView: View {
    
    var viewModel: HealthCheckEntryPointViewModelProtocol
    
    var body: some View {
        
        ZStack(alignment: .top) {
            
            self.backgroundImage(imageUrlString: viewModel.homeHealthCheckDetail.landingPage.imageURL)
            
            VStack {
                
                xButton()
                
                landingTitleAndDescription()
                
                Spacer()
                
                PrimaryButton("Get Started", action:{
                    viewModel.goToHealthCheckQuestions()
                })
                .padding(.bottom, Spacing.space40)
                .padding(.horizontal, Spacing.space8)
            }
            .padding(.top, Spacing.space24)
            
        }
        
    }
    
    private func backgroundImage(imageUrlString: String) -> some View {
        
        if let imageURL = URL(string: imageUrlString) {
            AnyView(
                FlexibleProgressImage(url: imageURL)
            )
            
        } else {
            AnyView(
                Color.gray
                    .frame(maxWidth: .infinity)
            )
        }
        
    }
    
    private func xButton() -> some View {
        
        HStack {
            Spacer()
                
                BackButton({
                    viewModel.dismissHealthCheck()
                },
                           isCircleButton: true,
                           buttonIconName: "xmark.circle.fill")
                .frame(width: 32, height: 32)
                .opacity(0.8)
                .background(.clear)
        }
        .padding(.trailing, Spacing.space16)
        .padding(.top, Spacing.space48)
        
    }
    
    private func landingTitleAndDescription() -> some View {
        
        VStack(spacing: Spacing.space24) {
            
            Text(viewModel.homeHealthCheckDetail.landingPage.title)
                .foregroundStyle(Color.vvBlack)
                .font(.vvHeading1Bold)
            
            HTMLText(htmlString: viewModel.homeHealthCheckDetail.landingPage.description,
                     fontType: .normal,
                     fontSize: .size18,
                     color: .darkGray)
        }
        .multilineTextAlignment(.center)
        .padding(.top, Spacing.space32)
        .padding(.horizontal, Spacing.space24)
        
    }
    
}

#Preview {
    HealthCheckLandingView(viewModel: HealthCheckLandingPreviewViewModel())
}

struct HealthCheckLandingPreviewViewModel: HealthCheckEntryPointViewModelProtocol {
    
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
