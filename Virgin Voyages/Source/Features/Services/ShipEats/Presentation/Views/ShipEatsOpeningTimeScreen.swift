//
//  ShipEatsOpeningTimeScreen.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 7.5.25.
//

import SwiftUI
import VVUIKit

protocol ShipEatsOpeningTimeScreenViewModelProtocol {
    var screenState: ScreenState { get set }
    var shipEatsOpeninTime: ShipEatsOpeninTime { get }
    
    func onAppear()
    func onRefresh()
    func onBackTapped()
}

struct ShipEatsOpeningTimeScreen : View {
    @State var viewModel: ShipEatsOpeningTimeScreenViewModelProtocol
    
    init(viewModel: ShipEatsOpeningTimeScreenViewModelProtocol = ShipEatsOpeningTimeScreenViewModel()) {
        _viewModel = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        DefaultScreenView(state: $viewModel.screenState) {
            VVUIKit.ContentView {
                VStack(spacing: Spacing.space40) {
                    toolbar()
                    
                    OpeningTimeView(imageURL: viewModel.shipEatsOpeninTime.imageURL,
                                    title: viewModel.shipEatsOpeninTime.title,
                                    subtitle: viewModel.shipEatsOpeninTime.subtitle)
                }
                
            }
        } onRefresh: {
            viewModel.onRefresh()
        }
        .onAppear {
            viewModel.onAppear()
        }
        .ignoresSafeArea(edges: [.top])
        .navigationTitle("")
        .navigationBarBackButtonHidden()
    }
    
    func toolbar() -> some View {
        HStack {
            BackButton {
                viewModel.onBackTapped()
            }
            .padding(.leading, Spacing.space16)
            .padding(.top, Spacing.space48)
            
            Spacer()
        }
    }
}

#Preview {
    ShipEatsOpeningTimeScreen(viewModel: ShipEatsOpeningTimeScreenPreviewViewModel(shipEatsOpeninTime: .sample()))
}


struct ShipEatsOpeningTimeScreenPreviewViewModel: ShipEatsOpeningTimeScreenViewModelProtocol {
    var screenState: ScreenState = .content
    var shipEatsOpeninTime: ShipEatsOpeninTime
    
    init(shipEatsOpeninTime: ShipEatsOpeninTime) {
        self.shipEatsOpeninTime = shipEatsOpeninTime
    }
    
    func onAppear() {
        
    }
    
    func onRefresh() {
        
    }
    
    func onBackTapped() {
        
    }
}
