//
//  CabinServicesScreen.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 4/24/25.
//

import SwiftUI
import VVUIKit

protocol CabinServicesScreenViewModelProtocol {
    
    var screenState: ScreenState { get set }
    var cabinService: CabinService { get set }
    var didFailToActivateService: Bool { get set }
    var errorMessage: String? { get set }
    
    func onAppear()
    func onRefresh()
    func onBackTapped()
    func onCabinOptionTapped(item: CabinService.CabinServiceItem)
    func onCabinConfirmationTapped(item: CabinService.CabinServiceItem,
                                   isMaintenance: Bool,
                                   optionId: String?)
    func createCabinService(item: CabinService.CabinServiceItem)
    func onMaintenanceServiceTapped(item:  CabinService.CabinServiceItem)
    
}

struct CabinServicesScreen: View {
    
    @State var viewModel: CabinServicesScreenViewModelProtocol
    
    init(viewModel: CabinServicesScreenViewModelProtocol = CabinServicesScreenViewModel()) {
        _viewModel = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        
        DefaultScreenView(state: $viewModel.screenState) {
            
            ZStack(alignment: .top) {
                
                ServiceBackgroundImage(imageUrlString: viewModel.cabinService.backgroundImageURL)
                
                VStack(alignment: .leading, spacing: Spacing.space0) {
                    
                    ServiceHeader(spacing: 80,
                                  backButtonAction: {
                                    viewModel.onBackTapped()
                                  },
                                  title: viewModel.cabinService.title,
                                  subTitle: viewModel.cabinService.subTitle,
                                  isSmallTitleWithBigSubtitleHeaderText: true)
                        .padding(.top, Spacing.space24)
                    
                    Spacer()
                    
                    HFlowStack(alignment: .leading) {
                        ForEach(viewModel.cabinService.items, id: \.id) { item in
                            
                            if item.designStyle == .normal {
                                Button(item.name) {
                                    
                                    if item.status == .active {
                                        viewModel.onCabinConfirmationTapped(item: item,
                                                                            isMaintenance: false,
                                                                            optionId: nil)
                                    } else if item.options.isEmpty {
                                        viewModel.createCabinService(item: item)
                                    } else {
                                        viewModel.onCabinOptionTapped(item: item)
                                    }
                                    
                                }
                                .buttonStyle(PrimaryServiceButtonStyle(statusType: item.status))
                                .disabled(item.status == .closed)
                            }
                            
                            if item.designStyle == .outline {
                                Button(item.name) {
                                    
                                    if !item.options.isEmpty {
                                        viewModel.onMaintenanceServiceTapped(item: item)
                                    }
                                    
                                }
                                .buttonStyle(SecondaryServiceButtonStyle())
                            }
                            
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
        .onChange(of: viewModel.cabinService, { _, newValue in
            viewModel.cabinService = newValue
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
    CabinServicesScreen(viewModel: CabinServicesScreenPreviewViewModel())
}

struct CabinServicesScreenPreviewViewModel: CabinServicesScreenViewModelProtocol {
    
    var screenState: ScreenState = .content
    var cabinService: CabinService = .sample()
    
    var didFailToActivateService: Bool = false
    var errorMessage: String?
    
    func onAppear() {
        
    }
    
    func onRefresh() {
        
    }
    
    func onBackTapped() {
        
    }
    
    func onCabinOptionTapped(item: CabinService.CabinServiceItem) { }
    
    func onCabinConfirmationTapped(item: CabinService.CabinServiceItem,
                                   isMaintenance: Bool,
                                   optionId: String?) {
        
    }
    
    func onMaintenanceServiceTapped(item: CabinService.CabinServiceItem) {
        
    }
    
    func createCabinService(item: CabinService.CabinServiceItem) {
        
    }
}
