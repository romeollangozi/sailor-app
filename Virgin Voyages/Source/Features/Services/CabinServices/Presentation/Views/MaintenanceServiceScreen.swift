//
//  MaintenanceServiceScreen.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 4/29/25.
//

import SwiftUI
import VVUIKit

protocol MaintenanceServiceViewModelProtocol {
    
    var screenState: ScreenState { get set }
    var cabinServiceItem: CabinService.CabinServiceItem { get set }
    
    var didFailToActivateService: Bool { get set }
    var errorMessage: String? { get set }
    
    func onAppear()
    func onRefresh()
    func onBackTapped()
    
    func onCabinConfirmationTapped(item: CabinService.CabinServiceItem,
                                   isMaintenance: Bool,
                                   optionId: String?)
    func createMaintenanceService(item: CabinService.CabinServiceItem, optionId: String)
}

struct MaintenanceServiceScreen: View {
    
    @State var viewModel: MaintenanceServiceViewModelProtocol
    
    init(cabinServiceItem: CabinService.CabinServiceItem) {
        self.init(viewModel: MaintenanceServiceViewModel(cabinServiceItem: cabinServiceItem))
    }
    
    init(viewModel: MaintenanceServiceViewModelProtocol) {
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
                                  subTitle: viewModel.cabinServiceItem.optionsDescription,
                                  isSmallTitleWithBigSubtitleHeaderText: true)
                    .padding(.top, Spacing.space24)
                    
                    Spacer()
                    
                    HFlowStack(alignment: .leading) {
                        
                        ForEach(viewModel.cabinServiceItem.options, id: \.id) { option in
                            
                            Button(option.name) {
                                
                                if option.status == .active {
                                    viewModel.onCabinConfirmationTapped(item: viewModel.cabinServiceItem, isMaintenance: true, optionId: option.id)
                                } else {
                                    viewModel.createMaintenanceService(item: viewModel.cabinServiceItem,
                                                                       optionId: option.id)
                                }
                                

                            }
                            .buttonStyle(PrimaryServiceButtonStyle(statusType: option.status,
                                                                   iconURL: option.icon))
                            
                        }
                        
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
        .onChange(of: viewModel.cabinServiceItem, { _, newValue in
            viewModel.cabinServiceItem = newValue
        })
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
    MaintenanceServiceScreen(viewModel: MaintenanceServicePreviewViewModel())
}


struct MaintenanceServicePreviewViewModel: MaintenanceServiceViewModelProtocol {
    
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
    
    func createMaintenanceService(item: CabinService.CabinServiceItem, optionId: String) {
        
    }
    
    func onCabinConfirmationTapped(item: CabinService.CabinServiceItem,
                                   isMaintenance: Bool,
                                   optionId: String?) {
        
    }
    
}
