//
//  ServicesScreen.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 4/22/25.
//

import SwiftUI
import VVUIKit

protocol ServicesScreenViewModelProtocol {
    
    var screenState: ScreenState {get set}
    
    func onAppear()
    func onRefresh()
    func onCabinServiceTapped()
    func onHelpAndSupportTapped()
    func onShipEatsDeliveryTapped()
}

struct ServicesScreen: View {
    
    @State private var viewModel: ServicesScreenViewModelProtocol
    
    init(viewModel: ServicesScreenViewModelProtocol = ServicesScreenViewModel()) {
        _viewModel = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        
        DefaultScreenView(state: $viewModel.screenState) {
            
            ZStack(alignment: .top) {
                Image("Cabin1")
                    .resizable()
                    .overlay {
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.black.opacity(0.4),
                                Color.black.opacity(0.4)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    }
                    .ignoresSafeArea(edges: [.top])
                
                VStack(alignment: .leading, spacing: Spacing.space8) {
                    
                    VSpacer(80)
                    
                    Text("Services")
                        .foregroundStyle(Color.vvWhite)
                        .font(.vvSmallBold)
                    
                    Text("Hey Sailor, \ntell us your needs.")
                        .foregroundStyle(Color.vvWhite)
                        .font(.vvHeading1Bold)
                    
                    Spacer()
                    
                    HFlowStack(alignment: .leading) {
                        
                        Button("ShipEats Delivery") {
                            viewModel.onShipEatsDeliveryTapped()
                        }
                        .buttonStyle(PrimaryServiceButtonStyle(statusType: .default))
                        
                        Button("Cabin Services") {
                            viewModel.onCabinServiceTapped()
                        }
                        .buttonStyle(PrimaryServiceButtonStyle(statusType: .default))
                        
                        Button("Help & Support") {
                            viewModel.onHelpAndSupportTapped()
                        }
                        .buttonStyle(SecondaryServiceButtonStyle())
                    }
                    .padding(.bottom, Spacing.space48)
                                        
                }
                .padding(.horizontal, Spacing.space24)
                
            }
            
        } onRefresh: {
            viewModel.onRefresh()
        }
        .onAppear {
            viewModel.onAppear()
        }
        
    }
}

#Preview {
    ServicesScreen()
}
