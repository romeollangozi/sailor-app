//
//  ConfirmOrderChampagneScreen.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 26.6.25.
//

import SwiftUI
import VVUIKit

protocol ConfirmOrderChampagneViewModelProtocol {
    var screenState: ScreenState { get set }
    var shakeForChampagne: ShakeForChampagne { get }
    var isCancelSheetDisplayed: Bool { get set }
    func displayCancelSheet()
    func dismissCancelSheet()
    var shouldShowCancelButton: Bool { get }
    var descriptionText: String { get }
    func onClose()
    func onAppear()
    func onRefresh()
}

struct ConfirmOrderChampagneScreen: View {
    @State var viewModel: ConfirmOrderChampagneViewModelProtocol
    @State private var animate = false
    
    @Binding var isLoading: Bool
    
    var errorMessage: String?
    let topTextOffset: CGFloat = -50
    let bottomTextOffest: CGFloat = 50
    let gifOffset: CGFloat = 150
    
    var onCancelChampagne: VoidCallback?
    
    init(viewModel: ConfirmOrderChampagneViewModelProtocol,
         isLoading: Binding<Bool>,
         errorMessage: String?,
         onCancelChampagne: VoidCallback?) {
        
        _viewModel = State(wrappedValue: viewModel)
        self._isLoading = isLoading
        self.errorMessage = errorMessage
        self.onCancelChampagne = onCancelChampagne
    }

    var body: some View {
        DefaultScreenView(state: $viewModel.screenState) {
            VStack(spacing: Spacing.space24) {
                toolbar
                    .padding(.horizontal, Spacing.space16)

                VStack {
                    VStack{
                        Text(viewModel.shakeForChampagne.confirmationHeaderText.uppercased())
                            .font(.vvSmallBold)
                            .foregroundStyle(Color.mediumGray)
                            .multilineTextAlignment(.center)
                        
                        Text(viewModel.shakeForChampagne.confirmationTitle.uppercased())
                            .font(.vvHeading1Bold)
                            .foregroundStyle(Color.vvRed)
                            .multilineTextAlignment(.center)
                        
                        Text(viewModel.descriptionText)
                            .font(.vvHeading1Bold)
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.center)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.leading, Spacing.space32)
                            .padding(.trailing, Spacing.space32)
                    }
                    .offset(y: animate ? 0 : topTextOffset)
                    .opacity(animate ? 1 : 0)
                    .animation(.easeInOut(duration: 1).delay(1), value: animate)
                    .onAppear {
                        animate = true
                    }
                    ZStack{
                        VStack{
                            GIFView(gifName: "mermaid")
                                .frame(width: 230, height: 174)
                                .padding(.top, Spacing.space80)
                                .padding(.bottom, Spacing.space80)
                                .scaleEffect(animate ? 1.50 : 0.95)
                                .offset(y: animate ? 0 : gifOffset)
                                .animation(.easeInOut(duration: 1), value: animate)
                                .onAppear {
                                    animate = true
                                }
                            Spacer()
                        }
                        
                        VStack(spacing: Spacing.space8) {
                            Spacer()
                                .frame(height: 160)
                            Text(viewModel.shakeForChampagne.quote.text)
                                .font(.vvVesterbroHeading3Bold)
                                .foregroundStyle(.white)
                                .multilineTextAlignment(.center)
                                .fixedSize(horizontal: false, vertical: true)
                            Rectangle()
                                .frame(width: 64, height: 2)
                                .foregroundColor(.vvRed)
                            Text(viewModel.shakeForChampagne.quote.author.uppercased())
                            .font(.vvSmallBold)
                            .foregroundStyle(Color.mediumGray)
                        }
                        .opacity(animate ? 1 : 0)
                        .offset(y: animate ? 0 : bottomTextOffest)
                        .animation(.easeInOut(duration: 1).delay(1), value: animate)
                        .onAppear {
                            animate = true
                        }
                        .padding(.top, Spacing.space16)
                    }
                    Spacer()

                    if viewModel.shouldShowCancelButton{
                        Button(action: {
                            viewModel.displayCancelSheet()
                        }) {
                            Text(viewModel.shakeForChampagne.cancellationActionText)
                                .foregroundColor(.white)
                                .font(.vvBodyMedium)
                                .underline()
                        }
                        .opacity(animate ? 1 : 0)
                        .offset(y: animate ? 0 : bottomTextOffest)
                        .animation(.easeInOut(duration: 1).delay(1), value: animate)
                        .onAppear {
                            animate = true
                        }
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
        .sheet(isPresented: $viewModel.isCancelSheetDisplayed) {
            ShakeForChampagneCancelOrderBottomSheetView(isLoading: $isLoading,
                                                        errorMessage: errorMessage,
                                                        shakeForChampagne: viewModel.shakeForChampagne,
                                                        onCancelChampagne: onCancelChampagne,
                                                        onDismiss: viewModel.dismissCancelSheet)
                .presentationDetents([.fraction(0.7)])
                .presentationDragIndicator(.hidden)
        }
    }

    private var toolbar: some View {
        HStack {
            Spacer()
            ClosableButton(action: viewModel.onClose)
        }
    }
}

#Preview {
    
    @Previewable @State var isLoading = false
    
    ConfirmOrderChampagneScreen(viewModel: ConfirmOrderChampagneViewModel(shakeForChampagne: ShakeForChampagne.sample(),
                                                                          onCloseAction: nil),
                                isLoading: $isLoading,
                                errorMessage: "New Backend Testing",
                                onCancelChampagne: {})
    
}
