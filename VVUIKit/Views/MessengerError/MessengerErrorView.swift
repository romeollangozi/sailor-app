//
//  MessengerErrorView.swift
//  Virgin Voyages
//
//  Created by TX on 20.8.25.
//

import SwiftUI

public struct MessengerErrorView: View {
    @State private var viewModel: MessengerErrorRetryViewModelProtocol
    private let onTryAgain: () -> Void

    public init(
        viewModel: MessengerErrorRetryViewModelProtocol,
        onTryAgain: @escaping () -> Void
    ) {
        self._viewModel = .init(wrappedValue: viewModel)
        self.onTryAgain = onTryAgain
    }

    public var body: some View {
        VStack(spacing: Spacing.space16) {
            VStack {
                ErrorBoxView(state: viewModel.state)

                if viewModel.shouldShowRetryButton {
                    LinkButton("Try again", color: .gray) {
                        onTryAgain()
                    }
                }
            }
            .padding(.vertical, Spacing.space24)
        }
    }
}
