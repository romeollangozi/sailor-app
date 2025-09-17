//
//  MessengerButtonView.swift
//  Virgin Voyages
//
//  Created by TX on 12.3.25.
//

import SwiftUI
import VVUIKit

enum MessengerButtonState: Equatable {
    case empty
    case newMessages(Int)
}

protocol MessengerButtonViewModelProtocol: AnyObject {
    var unreadMessagesCount: Int { get }
    func onAppear()
}

struct MessengerButtonView: View {
    
    // MARK: - Properties
    @State private var viewModel: MessengerButtonViewModelProtocol
    @State private var textWidth: CGFloat = 0
    
    private let size: CGFloat = 40

    // MARK: - Action
    let buttonAction: (() -> Void)?

    // MARK: - Init
    init(buttonAction: (() -> Void)? = nil, viewModel: MessengerButtonViewModelProtocol = MessengerButtonViewModel()) {
        self.buttonAction = buttonAction
        _viewModel = State(wrappedValue: viewModel)
    }
    
    // MARK: - Computed properties
    private var buttonState: MessengerButtonState {
        viewModel.unreadMessagesCount > 0 ? .newMessages(viewModel.unreadMessagesCount) : .empty
    }

    var body: some View {
        
        Button(action: { buttonAction?() }) {
            messageButtonContent()
        }
        .overlay(hiddenTextForMeasurement)
        .onAppear {
            viewModel.onAppear()
        }
        
    }
    
    private func messageButtonContent() -> some View {
        HStack(spacing: 8) {
            Image(buttonState == .empty ? "chatBubbleIcon" : "chatBubbleUnreadIcon")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: size / 2, height: size / 2)

            if case .newMessages(let count) = buttonState {
                Text("\(count) new message\(count == 1 ? "" : "s")")
                    .font(.vvSmall)
                    .foregroundColor(.black)
                    .lineLimit(1)
                    .fixedSize(horizontal: true, vertical: false)
                    .frame(width: textWidth)
                    .transition(.opacity.combined(with: .move(edge: .trailing)))
            }
        }
        .padding(.horizontal, buttonState == .empty ? 0 : size * 0.25)
        .frame(width: calculatedWidth, height: size)
        .background(buttonState == .empty ? Color.white.opacity(0.5) : Color.white)
        .clipShape(Capsule())
        .animation(.spring(), value: viewModel.unreadMessagesCount)
    }
    
}

// MARK: - Private Computed Properties
private extension MessengerButtonView {

    var calculatedWidth: CGFloat {
        buttonState == .empty ? size : size + textWidth + size * 0.25
    }

    var hiddenTextForMeasurement: some View {
        Text("\(viewModel.unreadMessagesCount) new message\(viewModel.unreadMessagesCount == 1 ? "" : "s")")
            .font(.vvSmall)
            .lineLimit(1)
            .fixedSize(horizontal: true, vertical: false)
            .background(GeometryReader { proxy in
                Color.clear
                    .onAppear {
                        DispatchQueue.main.async {
                            textWidth = proxy.size.width
                        }
                    }
            })
            .hidden()
    }
}


//MARK: - Preview

struct MessengerButtonPreview: View {
    
    var body: some View {
        VStack(spacing: 20) {
            
            MessengerButtonView(
                buttonAction: {},
                viewModel: MessengerButtonMockViewModel(unreadMessagesCount: 0)
            )
            
            MessengerButtonView(
                buttonAction: {},
                viewModel: MessengerButtonMockViewModel(unreadMessagesCount: 3)
            )
            
        }
        .padding()
        .background(.black.opacity(0.5))
    }
}


#Preview {
    MessengerButtonPreview()
}
