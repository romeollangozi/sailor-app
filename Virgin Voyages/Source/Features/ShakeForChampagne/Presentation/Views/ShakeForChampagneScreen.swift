//
//  ShakeForChampagneAnimationView.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 6/24/25.
//

import SwiftUI
import VVUIKit

protocol ShakeForChampagneViewModelProtocol {
    
    var shakeForChampagne: ShakeForChampagne { get set }
    var isLoading: Bool { get set }
    var errorMessage: String? { get set }
    var currentScreen: ShakeForChampagneScreenType? { get }
        
    func onAppear()
    func onDisappear()
    func onVideoFinished()
    func onConfirmOrder(quantity: Int)
    func onPermissionGranted()
    func onCancelChampagne()
    func onTryAgain()
    func dismiss()
}

enum ShakeForChampagneScreenType: Equatable {
    case bubbleVideo
    case permissions
    case order
    case confirmation
    case error
    case cancelConfirmation
    case orderError
}

// MARK: - View Implementation
struct ShakeForChampagneScreen: View {
    
    // MARK: - Properties
    @State private var viewModel: ShakeForChampagneViewModelProtocol
    var isDissmissed: VoidCallback?
    var orderId: String?
    
    // MARK: - Initialization
    init(orderId: String? = nil, isDissmissed: VoidCallback? = nil) {
        _viewModel = State(wrappedValue: ShakeForChampagneViewModel(orderId: orderId))
        self.isDissmissed = isDissmissed
    }
    
    init(viewModel: ShakeForChampagneViewModelProtocol) {
        _viewModel = State(wrappedValue: viewModel)
    }
    
    // MARK: - Body
    var body: some View {
        
        ZStack {
            switch viewModel.currentScreen {
                
            case .bubbleVideo:
                ShakeForChampagneVideoPlayerView(onVideoFinished: {
                    viewModel.onVideoFinished()
                })
                
            case .permissions:
                ShakeForChampagnePermissionsView(shakeForChampagne: viewModel.shakeForChampagne,
                                                 onPermissionGranted: {
                    viewModel.onPermissionGranted()
                })
                
            case .order:
                OrderChampagneScreen(viewModel: OrderChampagneViewModel(shakeForChampagne: viewModel.shakeForChampagne, onCancelAction: {
                    viewModel.dismiss()
                })) { quantity in
                    viewModel.onConfirmOrder(quantity: quantity)
                }
                
            case .confirmation:
                ConfirmOrderChampagneScreen(viewModel: ConfirmOrderChampagneViewModel(shakeForChampagne: viewModel.shakeForChampagne,
                                                                                      onCloseAction: {
                    viewModel.dismiss()
                }),
                                            isLoading: $viewModel.isLoading,
                                            errorMessage: viewModel.errorMessage,
                                            onCancelChampagne: {
                    viewModel.onCancelChampagne()
                })
                
            case .error:
                ErrorChampagneScreen(viewModel: ErrorChampagneViewModel(shakeForChampagne: viewModel.shakeForChampagne, onCloseAction: { viewModel.dismiss() }))
                
            case .cancelConfirmation:
                ShakeForChampagneCancellationConfitmationView(viewModel: ShakeForChampagneCancellationConfitmationViewModel(shakeForChampagne: viewModel.shakeForChampagne, onCancelAction: {
                    viewModel.dismiss()
                }))
                
            case .orderError:
                ShakeForChampagneOrderErrorView(onDismiss: {
                    viewModel.dismiss()
                }, onTryAgain: {
                    viewModel.onTryAgain()
                })
                
            case .none:
                EmptyView()
            }

        }
        .background(Color.vvBlack)
        .onAppear {
            viewModel.onAppear()
        }
        .onDisappear {
            viewModel.onDisappear()
            isDissmissed?()
        }
        .animation(.easeInOut, value: viewModel.currentScreen)
    }
}

// MARK: - Preview ViewModel
final class PreviewShakeForChampagneAnimationViewModel: ShakeForChampagneViewModelProtocol {
    
    var isLoading: Bool = false
    
    var errorMessage: String?
    
    var shakeForChampagne: ShakeForChampagne = .empty()
    
    var currentScreen: ShakeForChampagneScreenType? = .bubbleVideo
    
    func onAppear() {
        
    }
    
    func onDisappear() {
        
    }
    
    func onVideoFinished() {
        
    }
    
    func onConfirmOrder(quantity: Int) {
        
    }
    
    func onPermissionGranted() {
        
    }
    
    func onCancelChampagne() {
        
    }
    
    func onTryAgain() {
        
    }
    
    func dismiss() {
        
    }
}

// MARK: - Preview
#Preview {
    ShakeForChampagneScreen(viewModel: PreviewShakeForChampagneAnimationViewModel())
}
