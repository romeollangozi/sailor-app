//
//  OrderChampagneScreen.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 24.6.25.
//

import SwiftUI
import VVUIKit

protocol OrderChampagneViewModelProtocol {
    var screenState: ScreenState { get set }
    var totalPriceText: String { get }
    var quantity: Int { get }
    var title: String { get }
    var description: String { get }
    var champagneInfo: String { get }
    var isMinusDisabled: Bool { get }
    var isPlusDisabled: Bool { get }
    var taxExplanationText: String { get }
    func increaseQuantity()
    func decreaseQuantity()
    func onClose()
    func onAppear()
    func onRefresh()
}

struct OrderChampagneScreen: View {
    @State var viewModel: OrderChampagneViewModelProtocol
    @State private var animate = false
    @State private var isPressed = false
    let topTextOffset: CGFloat = -50
    let bottomTextOffest: CGFloat = 50
    
    var onConfirmOrder: ((Int) -> Void)?
    
    init(viewModel: OrderChampagneViewModelProtocol,
         onConfirmOrder: ((Int) -> Void)? = nil) {
        
        _viewModel = State(wrappedValue: viewModel)
        self.onConfirmOrder = onConfirmOrder
    }

    var body: some View {
        DefaultScreenView(state: $viewModel.screenState) {
            
            VStack(spacing: Spacing.space24) {
                toolbar
                    .padding(.trailing, Spacing.space16)
                    .padding(.top, Spacing.space24)

                VStack(spacing: Spacing.space16) {
                    VStack{
                        Text(viewModel.title)
                            .font(.vvHeading1Bold)
                            .foregroundStyle(Color.vvRed)
                            .multilineTextAlignment(.center)
                        
                        Text(viewModel.description)
                            .font(.vvHeading1Bold)
                            .foregroundStyle(Color.white)
                            .multilineTextAlignment(.center)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.leading, Spacing.space32)
                            .padding(.trailing, Spacing.space32)

                    }
                    .offset(y: animate ? 0 : topTextOffset)
                    .opacity(animate ? 1 : 0)
                    .animation(.easeInOut(duration: 1), value: animate)
                    .onAppear {
                        animate = true
                    }
                    Button {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.4)) {
                            isPressed = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                                isPressed = false
                            }
                        }
                        
                        self.onConfirmOrder?(viewModel.quantity)
                        
                    } label: {
                        Image("order_champagne_button")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 200)
                            .scaleEffect(isPressed ? 0.9 : 1.0)
                            .padding(.top, Spacing.space32)
                    }
                    .buttonStyle(.plain)
                    VStack{
                        Image("order_champagne_image")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 60)
                            .padding(.top, Spacing.space48)
                        
                        Text(viewModel.champagneInfo.uppercased())
                            .font(.vvSmallBold)
                            .foregroundStyle(Color.secondaryRockstar)
                            .multilineTextAlignment(.center)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(maxWidth: 120)
                            .padding(.top, Spacing.space16)
                        
                        Rectangle()
                            .frame(width: 64, height: 2)
                            .foregroundColor(.secondaryRockstar)
                            .padding(.top, -Spacing.space8)
                        
                        HStack(spacing: Spacing.space16) {
                            Button(action: viewModel.decreaseQuantity) {
                                Image(viewModel.isMinusDisabled ? "order_champagne_minus_dissabled" :"order_champagne_minus")
                                    .font(.largeTitle)
                            }
                            .disabled(viewModel.isMinusDisabled)
                            
                            Text("\(viewModel.quantity)")
                                .font(.vvHeading3Bold)
                                .frame(width: 40)
                                .foregroundStyle(Color.white)
                            
                            Button(action: viewModel.increaseQuantity) {
                                Image(viewModel.isPlusDisabled ? "order_champagne_plus_disabled" :"order_champagne_plus")
                                    .font(.largeTitle)
                            }
                            .disabled(viewModel.isPlusDisabled)
                        }
                        
                        Text(viewModel.totalPriceText.uppercased())
                            .font(.vvSmallBold)
                            .foregroundStyle(.white)
                            .padding(.top, Spacing.space8)
                        
                        Text(viewModel.taxExplanationText.uppercased())
                            .font(.vvTiny)
                            .foregroundStyle(.white)
                            .padding(.top, Spacing.space8)
                            .padding(.bottom, Spacing.space40)
                        
                    }
                    .offset(y: animate ? 0 : bottomTextOffest)
                    .opacity(animate ? 1 : 0)
                    .animation(.easeInOut(duration: 1), value: animate)
                    .onAppear {
                        animate = true
                    }
                    
                }
                .padding(.horizontal, Spacing.space24)
                .padding(.top, Spacing.space32)

                Spacer()
            }
            .background(Color.black)
        } onRefresh: {
            viewModel.onRefresh()
        }
        .onAppear {
            viewModel.onAppear()
        }
    }

    private var toolbar: some View {
        HStack {
            Spacer()
            ClosableButton(action: viewModel.onClose)
        }
        .padding(.top, Spacing.space48)
    }
}

struct OrderChampagneScreen_Previews: PreviewProvider {
    static var previews: some View {
        
        OrderChampagneScreen(viewModel: OrderChampagneViewModel(shakeForChampagne: ShakeForChampagne.sample(), onCancelAction: {}))
        
    }
}
