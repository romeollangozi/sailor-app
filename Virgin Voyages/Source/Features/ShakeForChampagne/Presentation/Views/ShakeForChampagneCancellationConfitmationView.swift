//
//  ShakeForChampagneCancellationConfitmationView.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 7/9/25.
//

import SwiftUI
import VVUIKit

protocol ShakeForChampagneCancellationConfitmationViewModelProtocol {
    var screenState: ScreenState { get set }
    var shakeForChampagneCancellation: ShakeForChampagne.Cancellation { get }
    func onButtonTap()
    func onAppear()
    func onRefresh()
    func onClose()
}

struct ShakeForChampagneCancellationConfitmationView: View {
    
    @State var viewModel: ShakeForChampagneCancellationConfitmationViewModelProtocol
    @State private var animate = false
    
    let topOffset: CGFloat = -50
    let bottomOffset: CGFloat = 50
    
    init(viewModel: ShakeForChampagneCancellationConfitmationViewModelProtocol) {
        _viewModel = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        
        DefaultScreenView(state: $viewModel.screenState){
            
            VStack {
                
                toolbar
                    .padding(.top, Spacing.space24)
                    .padding(.trailing, Spacing.space16)
                
                Spacer()
                
                VStack(spacing: Spacing.space16) {
                    Text(viewModel.shakeForChampagneCancellation.successHeader.uppercased())
                        .font(.vvSmallBold)
                        .foregroundStyle(Color.mediumGray)
                        .multilineTextAlignment(.center)

                    Rectangle()
                        .frame(width: 64, height: 2)
                        .foregroundColor(.vvRed)

                    Text(viewModel.shakeForChampagneCancellation.successMessage)
                        .font(.vvVesterbroHeading3Bold)
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                        
                }
                .padding(.horizontal, Spacing.space40)
                .opacity(animate ? 1 : 0)
                .offset(y: animate ? 0 : topOffset)
                .animation(.easeInOut(duration: 0.8), value: animate)
                .onAppear {
                    animate = true
                }
                
                Spacer()
                
                Button(action: {
                    viewModel.onButtonTap()
                }) {
                    Text(viewModel.shakeForChampagneCancellation.successActionText)
                        .foregroundColor(.white)
                        .font(.vvBodyMedium)
                        .underline()
                }
                .padding(.bottom, Spacing.space40)
                .opacity(animate ? 1 : 0)
                .offset(y: animate ? 0 : bottomOffset)
                .animation(.easeInOut(duration: 0.8).delay(0.3), value: animate)
                
            }
            
        } onRefresh: {
            viewModel.onRefresh()
        }
        .onAppear {
            viewModel.onAppear()
        }
        .background(Color.black)
        
    }
    
    private var toolbar: some View {
        HStack {
            Spacer()
            ClosableButton(action: viewModel.onClose)
        }
    }
}

struct MockShakeForChampagneCancellationConfitmationViewModel: ShakeForChampagneCancellationConfitmationViewModelProtocol {
    
    var screenState: ScreenState = .content
    
    var shakeForChampagneCancellation: ShakeForChampagne.Cancellation
    
    func onButtonTap() {
        
    }
    
    func onAppear() {
        
    }
    
    func onRefresh() {
        
    }
    
    func onClose() {
        
    }
    
}

#Preview {
    ShakeForChampagneCancellationConfitmationView(viewModel: MockShakeForChampagneCancellationConfitmationViewModel(shakeForChampagneCancellation: ShakeForChampagne.sample().cancellation))
}
