//
//  CabinServiceConfirmationViewModelProtocol.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 4/25/25.
//

import SwiftUI
import VVUIKit

protocol CabinServiceConfirmationViewModelProtocol {
    
    var screenState: ScreenState { get set }
    var cabinServiceItem: CabinService.CabinServiceItem { get }
    var isMaintenance: Bool { get }
    var optionId: String? { get }
    
    var didFailToCancelService: Bool { get set }
    var errorMessage: String? { get set }
    
    func onAppear()
    func onRefresh()
    func onBackTapped()
    func cancelCabinService(cabinServiceItem: CabinService.CabinServiceItem, isMaintenance: Bool)
}

struct CabinServiceConfirmationScreen: View {
    
    @State var viewModel: CabinServiceConfirmationViewModelProtocol
        
    init(cabinServiceItem: CabinService.CabinServiceItem,
         isMaintenance: Bool,
         optionId: String?) {
        
        self.init(viewModel: CabinServiceConfirmationViewModel(cabinServiceItem: cabinServiceItem, isMaintenance: isMaintenance, optionId: optionId))
    }
    
    init(viewModel: CabinServiceConfirmationViewModelProtocol) {
        _viewModel = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        
        DefaultScreenView(state: $viewModel.screenState) {
            
            ZStack(alignment: .top) {
                
                ServiceBackgroundImage(imageUrlString: viewModel.cabinServiceItem.imageUrl)
                
                VStack(alignment: .leading, spacing: Spacing.space0) {
                    
                    ServiceHeader(spacing: 80,
                                  backButtonAction: {
                                    viewModel.onBackTapped()
                                  },
                                  title: viewModel.cabinServiceItem.confirmationTitle,
                                  subTitle: viewModel.cabinServiceItem.confirmationDescription,
                                  isConfirmationScreen: true)
                    .padding(.top, Spacing.space24)
                    
                    Spacer()
                    
                    HFlowStack(alignment: .leading) {
                        
                        Button(viewModel.cabinServiceItem.confirmationCta) {
                            viewModel.onBackTapped()
                        }
                        .buttonStyle(PrimaryServiceButtonStyle(statusType: .default))
                        
                        Button("Cancel request") {
                            viewModel.cancelCabinService(cabinServiceItem: viewModel.cabinServiceItem,
                                                         isMaintenance: viewModel.isMaintenance)
                        }
                        .buttonStyle(DismissServiceButtonStyle())
                        
                    }
                    .padding(.horizontal, Spacing.space24)
                    
                }
                .padding(.bottom, Spacing.space48)
                
            }
            
        } onRefresh: {
            viewModel.onRefresh()
        }
        .onAppear {
            viewModel.onAppear()
        }
        .fullScreenCover(isPresented: $viewModel.didFailToCancelService) {
            
            VVSheetModal(title: viewModel.errorMessage,
                         primaryButtonText: "OK",
                         primaryButtonAction: {
                viewModel.didFailToCancelService = false
            }, dismiss: {
                viewModel.didFailToCancelService = false
            })
            .background(Color.clear)
            .transition(.opacity)
            
        }
        .ignoresSafeArea(edges: [.top])
        .navigationTitle("")
        .navigationBarBackButtonHidden()
        
    }
}

#Preview {
    CabinServiceConfirmationScreen(viewModel: CabinServiceConfirmationPreviewViewModel())
}


struct CabinServiceConfirmationPreviewViewModel: CabinServiceConfirmationViewModelProtocol {
    
    var screenState: ScreenState = .content
    var cabinServiceItem: CabinService.CabinServiceItem = .sample()
    
    var didFailToCancelService: Bool = false
    var errorMessage: String?
    var isMaintenance: Bool = false
    var optionId: String?
    
    func onAppear() {
        
    }
    
    func onRefresh() {
        
    }
    
    func onBackTapped() {
        
    }
    
    func cancelCabinService(
		cabinServiceItem: CabinService.CabinServiceItem,
		isMaintenance: Bool
	) {
    }
}
