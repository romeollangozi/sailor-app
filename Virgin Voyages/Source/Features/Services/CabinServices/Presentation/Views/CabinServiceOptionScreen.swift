//
//  CabinServiceOptionScreen.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 4/24/25.
//

import SwiftUI
import VVUIKit

protocol CabinServiceOptionViewModelProtocol {
    var screenState: ScreenState {get set}
    var cabinServiceItem: CabinService.CabinServiceItem {get}
    var createCabinServiceRequestResult: CreateCabinServiceRequestResult? { get }
    var didFailToActivateService: Bool { get set }
    var errorMessage: String? { get set }
    
    func onAppear()
    func onRefresh()
    func onBackTapped()
    func createCabinService(withRequestName name: String)
}

struct CabinServiceOptionScreen: View {
    
    @State var viewModel: CabinServiceOptionViewModelProtocol
        
    init(cabinServiceItem: CabinService.CabinServiceItem) {
        self.init(viewModel: CabinServiceOptionViewModel(cabinServiceItem: cabinServiceItem))
    }
    
    init(viewModel: CabinServiceOptionViewModelProtocol) {
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
                                  title: viewModel.cabinServiceItem.optionsTitle,
                                  subTitle: viewModel.cabinServiceItem.optionsDescription)
                    .padding(.top, Spacing.space24)
                    
                    Spacer()
                    
                    HFlowStack(alignment: .leading) {
                        
                        ForEach(viewModel.cabinServiceItem.options, id: \.id) { option in
                            
                            Button(option.name) {
                                
                                viewModel.createCabinService(withRequestName: option.id)
                                
                            }
                            .buttonStyle(PrimaryServiceButtonStyle(statusType: viewModel.cabinServiceItem.status,
                                                                   iconURL: option.icon))
                            
                        }
                        
                        Button("No thanks") {
                            viewModel.onBackTapped()
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
        .fullScreenCover(isPresented: $viewModel.didFailToActivateService) {
            
            VVSheetModal(title: viewModel.errorMessage,
                         primaryButtonText: "OK",
                         primaryButtonAction: {
                viewModel.didFailToActivateService = false
            }, dismiss: {
                viewModel.didFailToActivateService = false
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
    CabinServiceOptionScreen(viewModel: CabinServiceOptionPreviewViewModel())
}


struct CabinServiceOptionPreviewViewModel: CabinServiceOptionViewModelProtocol {
    
    var createCabinServiceRequestResult: CreateCabinServiceRequestResult?
    var screenState: ScreenState = .content
    var cabinServiceItem: CabinService.CabinServiceItem = .sample()
    
    var didFailToActivateService: Bool = false
    var errorMessage: String?
    
    func onAppear() {
        
    }
    
    func onRefresh() {
        
    }
    
    func onBackTapped() {
        
    }
    
    func createCabinService(withRequestName name: String) {
        
    }
}
