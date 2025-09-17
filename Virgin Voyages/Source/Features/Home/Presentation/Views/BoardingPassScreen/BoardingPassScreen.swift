//
//  BoardingPassScreen.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 4/2/25.
//

import SwiftUI
import VVUIKit

protocol BoardingPassViewModelProtocol {
    var screenState: ScreenState { get set }
    var sailorBoardingPass: SailorBoardingPass { get }
    func onApperar()
}

struct BoardingPassScreen: View {
    
    @State var viewModel: BoardingPassViewModelProtocol
    @Environment(\.dismiss) var dismiss
    
    private let cardWidth = UIScreen.main.bounds.width * 0.87
    
    init(viewModel: BoardingPassViewModelProtocol) {
        _viewModel = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        
        DefaultScreenView(state: $viewModel.screenState) {
            ScrollView(.vertical, showsIndicators: false) {
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .top, spacing: Spacing.space8) {
                        ForEach(viewModel.sailorBoardingPass.items, id: \.id) { boardingPass in
                            BoardingPassCardView(item: boardingPass)
                                .frame(width: cardWidth)
                                .fixedSize(horizontal: false, vertical: true)
                            
                        }
                    }
                    .padding(.horizontal, Spacing.space24)
                    .padding(.top, Spacing.space24)
                    .padding(.bottom, Spacing.space16)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    
                }
                
            }
            .frame(maxWidth: .infinity)
            .background(Color.white)

            
        } onRefresh: {
            viewModel.onApperar()
        }
        .onAppear {
            viewModel.onApperar()
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                VVBackButton {
                    dismiss()
                }
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .navigationBarBackButtonHidden()
    }
    
}

#Preview {
    BoardingPassScreen(viewModel: BoardingPassViewModelMock())
}
