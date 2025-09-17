//
//  ErrorChampagneScreen.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 3.7.25.
//

import SwiftUI
import VVUIKit

protocol ErrorChampagneViewModelProtocol {
    var screenState: ScreenState { get set }
    var headerText: String { get }
    var messageText: String { get }
    var buttonText: String { get }
    func onButtonTap()
    func onAppear()
    func onRefresh()
    func onClose()
}

struct ErrorChampagneScreen: View {
    @State var viewModel: ErrorChampagneViewModelProtocol
    @State private var animate = false
    let topOffset: CGFloat = -50
    let bottomOffset: CGFloat = 50

    init(viewModel: ErrorChampagneViewModelProtocol) {
        _viewModel = State(wrappedValue: viewModel)
    }

    var body: some View {
        DefaultScreenView(state: $viewModel.screenState) {
            VStack(spacing: Spacing.space24) {
                toolbar
                    .padding(.horizontal, Spacing.space16)
                Spacer()

                VStack(spacing: Spacing.space16) {
                    Text(viewModel.headerText.uppercased())
                        .font(.vvSmallBold)
                        .foregroundStyle(Color.mediumGray)
                        .multilineTextAlignment(.center)

                    Rectangle()
                        .frame(width: 64, height: 2)
                        .foregroundColor(.red)

                    Text(viewModel.messageText)
                        .font(.vvVesterbroHeading3Bold)
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                        .lineSpacing(10)
                        .padding(.horizontal, Spacing.space32)
                }
                .padding(.top, -Spacing.space32)
                .padding(.horizontal, Spacing.space24)
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
                    Text(viewModel.buttonText)
                        .foregroundColor(.white)
                        .font(.vvBodyMedium)
                        .underline()
                }
                .padding(.bottom, Spacing.space40)
                .opacity(animate ? 1 : 0)
                .offset(y: animate ? 0 : bottomOffset)
                .animation(.easeInOut(duration: 0.8).delay(0.3), value: animate)
            }
            .padding(.vertical, Spacing.space16)
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
    }
}

struct ErrorChampagneScreen_Previews: PreviewProvider {
    static var previews: some View {
        ErrorChampagneScreen(viewModel: ErrorChampagneViewModel(shakeForChampagne: ShakeForChampagne.sample(), onCloseAction: nil))
    }
}
